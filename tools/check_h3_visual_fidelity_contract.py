#!/usr/bin/env python3
"""P0200 H.3 narrow visual/secure-boundary contract; no fixed dev-version pin."""
from pathlib import Path
import re
root = Path(__file__).resolve().parents[1]
source = {key: (root/path).read_text(encoding="utf-8") for key, path in {
    'native': 'Logres/HUD/NativeDebuffs.lua',
    'theme': 'Logres/Media/Theme.lua',
    'hud': 'Logres/HUD/HUD.lua',
    'dock': 'Logres/Immersion/NativeAccess.lua',
    'button': 'Logres/Actions/Button.lua',
    'layout': 'Logres/Integration/Layout.lua',
    'helpful': 'Logres/HUD/PlayerHelpfulAuras.lua',
}.items()}
errors = []
def require(ok, msg):
    if not ok: errors.append(msg)
n=source['native']; t=source['theme']; h=source['hud']; d=source['dock']
for fragment in (
    'CustomAuraContainerTemplate', '"LogresHarmful", "HARMFUL"',
    'button:SetIcon(icon)', 'frame:SetUnit(unit)', 'frame:SetEnabled(false)',
    'InCombatLockdown()', 'return false, "combat-deferred"',
    'columns = unit == "target" and 2 or 5',
    'local width = columns * ICON + (columns - 1) * GAP',
    'math.ceil(MAX / columns)',
    'harmfulStyle.assets and harmfulStyle.assets.frame',
): require(fragment in n, 'native aura invariant missing: '+fragment)
require('border:SetTexture(' in n and 'harmfulStyle.assets and harmfulStyle.assets.frame' in n,
        'native harmful style must prefer authored frame')
require('C_UnitAuras' not in n and 'GetAuraDataByIndex' not in n,
        'restricted native harmful payload may not be read')
require('theme.nativeHarmfulAuras' in t and 'iconSize = 25' in t and 'gap = 3' in t,
        'harmful icon sizing/Theme token contract')
require('aura_frame_passive.tga' in t and 'theme.playerHelpfulAuras' in t,
        'approved authored Aura frame family must remain')
require('theme.hudTypography' in t and 'hudTypography.targetName' in h
        and 'hudTypography.allyName' in h, 'shared HUD name color tokens')
# P0409: old dock tabs are intentionally retired. Keep the approved Theme
# family on the single gameplay Report Bug button and route native access via
# the panel. Do not reintroduce invisible HUD input to satisfy old tokens.
p = (root/'Logres/Dev/Panel.lua').read_text(encoding='utf-8')
require('theme.nativeAccessDock' in t and
        'local skin = (Logres.Theme and Logres.Theme.nativeAccessDock) or {}' in p and
        'bronze:SetTexture((skin.assets or {}).fallback)' in p,
        'native stock access / Report Bug must retain approved Theme art')
require('function NativeAccess:Toggle(key)' in d and
        'self:RunCommand(entry.command)' in p and
        'if self.activePhase == "N" then' in p and
        'bugButton:RegisterForClicks("LeftButtonUp")' in p and
        'bugButton:SetScript("OnClick", function()' in p,
        'native access panel routing / Report Bug click behavior missing')
require('CreateFrame("Button", nil, dock)' not in d and
        'self.dock:Show()' not in d and 'dock:EnableMouse(false)' in d,
        'retired HUD dock must not expose click regions')
require('HOTKEY_BORDER' in source['button'] and 'HOTKEY_TEXT' in source['button'],
        'action metadata presentation')
require('Logres.Layout.Bind(root, anchorKey' in (root/'Logres/HUD/StatusAuras.lua').read_text(),
        'ordinary status lane anchors must remain')
require('Logres.Layout.Bind(frame, key, "CENTER", "CENTER")' in n,
        'native harmful semantic binds must remain')
require('SCREEN_MAP_V4' not in n, 'do not embed special-case v4 coordinates')
require('theme.playerHelpfulAuras' in source['helpful'] or 'playerHelpfulAuras' in source['helpful'],
        'restored helpful presentation must remain')
print('Logres H.3 visual fidelity contract')
print('===================================')
if errors:
    for e in errors: print('FAIL:',e)
    raise SystemExit(1)
print('PASS: 0 errors')
