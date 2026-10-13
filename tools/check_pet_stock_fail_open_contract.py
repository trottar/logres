#!/usr/bin/env python3
"""P0208 source-policy contract: both native pet domains remain Blizzard-owned."""
from pathlib import Path
import re
root=Path(__file__).resolve().parents[1]
native=(root/'Logres/Immersion/NativeSurfaceReplacement.lua').read_text()
commands=(root/'Logres/Core/Commands.lua').read_text()
panel=(root/'Logres/Dev/Panel.lua').read_text()
checks=(root/'tools/check_dev_panel_contract.py').read_text()
errors=[]
if 'function Native:Ready(key)' not in native or 'function Native:RefreshNativeAuras()' not in native:
    errors.append('native readiness boundaries missing')
else:
    gate=native.split('function Native:Ready(key)',1)[1].split('function Native:RefreshNativeAuras()',1)[0]
    for key in ('petFrame','petActions'):
        match=re.search(r'if key == "'+key+r'" then return false end',gate)
        legacy=re.search(r'if key == "'+key+r'" then\n',gate)
        if not match:errors.append(key+' stock gate missing')
        elif legacy and match.start()>legacy.start():errors.append(key+' stock guard after legacy readiness')
if 'button:SetText("PET STOCK")' not in native:errors.append('PET dock stock label missing')
if 'self:Reconcile("pet-stock-access")' not in native:errors.append('PET stock-only reconcile missing')
if 'petPolicy=stock/stock' not in native or 'petVisual=UNVERIFIED' not in native:errors.append('native ownership/visibility qualification missing')
if 'local ORDER = {"petFrame", "petActions", "playerBuffs", "targetAuras"}' not in native:errors.append('native order changed')
for frag in ('function Native:Restore(key)','function Native:Fold(key)','function Native:RestoreTargetAuras()'):
    if frag not in native:errors.append('existing restore/aura contract missing: '+frag)
for forbidden in ('RegisterStateDriver(', 'UnregisterStateDriver(', 'SetParent(', 'SetScript("OnUpdate"', 'C_Timer.NewTicker(', 'C_Timer.After('):
    if forbidden in native:errors.append('unsafe stock override: '+forbidden)
if 'MAX_ACTIONS_PER_PHASE = BUTTON_COLUMNS * 6' not in panel or 'MAX_ACTIONS_PER_PHASE = 18' not in checks:errors.append('18-action Phase H contract regressed')
if '"nativeAccessCheck"' not in commands:errors.append('Phase H native access panel check missing')
print('Logres P0208 pet stock fail-open contract')
for e in errors:print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAIL: {len(errors)} errors')
raise SystemExit(bool(errors))
