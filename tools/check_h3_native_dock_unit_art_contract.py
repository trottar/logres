#!/usr/bin/env python3
"""P0217 approved bronze dock + sparse unit appearance contract; no version freeze."""
from pathlib import Path
import hashlib
ROOT=Path(__file__).resolve().parents[1]
text=lambda p:(ROOT/p).read_text(encoding='utf-8')
t=text('Logres/Media/Theme.lua')
n=text('Logres/Immersion/NativeAccess.lua')
s=text('Logres/Immersion/NativeSurfaceReplacement.lua')
h=text('Logres/HUD/HUD.lua')
errors=[]
for file,sha,size in (
 ('Logres/Media/Dock/dock_tab.tga','474a985de5fce7a56eb0e16b6da1a433d53067294c9a591790448f8c3e3ff7b8',(96,34)),
 ('Logres/Media/Dock/dock_fallback.tga','448bebc467cc46447fc4c6ecc6861cf328885208a9f419b04c915c092453d126',(128,34)),
):
 p=ROOT/file
 if not p.is_file():errors.append('missing asset '+file);continue
 b=p.read_bytes();w=b[12]+256*b[13];height=b[14]+256*b[15]
 if (w,height)!=size or b[16]!=32 or b[2]!=2:errors.append('unexpected TGA format/size '+file)
 if hashlib.sha256(b).hexdigest()!=sha:errors.append('asset hash drift '+file)
for token in ('theme.nativeAccessDock = {','assets = {','Dock\\\\dock_tab.tga','Dock\\\\dock_fallback.tga','fallbackText =','fallbackHover =','petName =','targetAccent =','allyAccent =','petAccent ='):
 if token not in t:errors.append('missing Theme token '+token)
for token in ('Logres.Layout.Bind(dock, "nativeAccess", "TOPRIGHT", "TOPRIGHT")','local dockAssets = dockStyle.assets or {}','bronze:SetTexture(dockAssets.tab)','self:Toggle(key)','button:RegisterForClicks("LeftButtonUp")'):
 if token not in n:errors.append('dock source missing '+token)
for token in ('button:SetSize(110, 23)','button:SetPoint("TOPLEFT", row, "TOPLEFT", x, 0)', 'button:SetText("PET STOCK")','button:SetScript("OnClick", function() self:Toggle(key) end)','button:SetFontString(text)','bronze:SetTexture(dockAssets.fallback)','button:RegisterForClicks("LeftButtonUp")'):
 if token not in s:errors.append('fallback control missing '+token)
if '"UIPanelButtonTemplate"' in s:errors.append('stock red fallback template still in use')
for token in ('targetFrame:SetSize(198, 54)','targetNameText:SetWidth(190)','"LogresHUDTargetHealthBar",','"compact",','self.targetNameText:SetText(UnitName("target"))','row.nameText:SetText(UnitName(unit))','local targetAccent = targetFrame:CreateTexture(nil, "ARTWORK")','local rowAccent = rowFrame:CreateTexture(nil, "ARTWORK")','unit == "pet"'):
 if token not in h:errors.append('HUD rendering/data boundary missing '+token)
for forbidden in ('UnitLevel(', 'UnitClassification(', 'UnitHealth("player"', 'UnitHealthMax("player"'):
 if forbidden in h:errors.append('forbidden unit detail read '+forbidden)
forbidden=('RegisterStateDriver(', 'UnregisterStateDriver(', 'C_Timer.After(', 'C_Timer.NewTicker(')
if any(x in s for x in forbidden):errors.append('unsafe stock control logic introduced')
print('Logres P0217 approved native dock and sparse unit art contract')
for e in errors:print('ERROR:',e)
if errors:raise SystemExit(1)
print('PASS: 0 errors')
