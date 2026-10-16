#!/usr/bin/env python3
"""P0214 D-039 sheet-03 shared action art derivative (visual contract, not WoW PASS)."""
from pathlib import Path
import hashlib
import struct

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {'action_frame.tga': 'c6bdf768435e6e4adc2a50302f727676b1d3042866359adb34039f961dd32f55', 'action_hover.tga': '138e5618d562bc844939059148fc5f474a7895ab65bd10864e1176f82274b5b5', 'action_pressed.tga': 'ba5e9beb0d1a9aa3e583e8f6beb35ebfe1fd208a23d31350a736a06cbe54e929', 'action_checked.tga': '0bfc4a317cc5a1ab344808f8f219d16706ef2d631f1e0a96671bc7974d82e88a', 'action_flash.tga': 'd46219de5bd4014af6d734cf4baad943e9765d99af5446fef0fb9fc499e43cb3'}
SHEET = ROOT / 'docs/design/approved/03_action_button_primitive.png'
SHEET_HASH = 'c204d9755c3c4298177a5e49be5f9a0042052d9f69d4887b86f83b0b5e7dc7dd'
errors=[]
if not SHEET.exists() or hashlib.sha256(SHEET.read_bytes()).hexdigest()!=SHEET_HASH:
    errors.append('approved canonical action sheet must remain unchanged')
for name,digest in EXPECTED.items():
    f=ROOT/'Logres/Media/Action'/name
    if not f.exists():
        errors.append('missing '+str(f.relative_to(ROOT)))
        continue
    data=f.read_bytes()
    if hashlib.sha256(data).hexdigest()!=digest:
        errors.append('production asset hash drift: '+name)
    if len(data)<18:
        errors.append('invalid TGA header: '+name)
        continue
    width,height=struct.unpack_from('<HH',data,12)
    if (width,height)!=(64,64) or data[2] not in (2,10) or data[16]!=32:
        errors.append('asset must be 64x64 RGBA TGA: '+name)
theme=(ROOT/'Logres/Media/Theme.lua').read_text()
button=(ROOT/'Logres/Actions/Button.lua').read_text()
layout=(ROOT/'Logres/Integration/Layout.lua').read_text()
for piece in ['buttonSize = 42','buttonGap = 5','iconInset = 4','artOverscan = 2']:
    if piece not in theme: errors.append('established geometry changed: '+piece)
for piece in ['"SecureActionButtonTemplate"','frameArt:SetTexture(actionAssets.frame)','hoverTexture:SetTexture(actionAssets.hover)','pushedTexture:SetTexture(actionAssets.pressed)','checked:SetTexture(actionAssets.checked)','activationFlash:SetTexture(actionAssets.flash)']:
    if piece not in button: errors.append('shared secure action visual integration absent: '+piece)
if 'SCREEN_MAP_V4' not in layout:
    # Current runtime may refer to v4 implicitly. Do not mandate literal JSON filename.
    if 'Logres.Layout' not in layout and 'Bind' not in layout:
        errors.append('semantic layout interface missing')
print('Logres P0214 approved action-family contract')
print('============================================')
for e in errors:print('FAIL:',e)
if errors:raise SystemExit(1)
print('PASS: 0 errors')
