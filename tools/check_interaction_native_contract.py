#!/usr/bin/env python3
"""P0174 interaction, cast fallback, tooltip and tracker coherence static contract."""
from pathlib import Path
import sys
root = Path(__file__).resolve().parents[1]
button = (root / 'Logres/Actions/Button.lua').read_text()
aura = (root / 'Logres/HUD/PlayerHelpfulAuras.lua').read_text()
native = (root / 'Logres/Immersion/NativeAccess.lua').read_text()
commands = (root / 'Logres/Core/Commands.lua').read_text()
audit = (root / 'Logres/Core/UIOwnershipAudit.lua').read_text()
errors = []
for token in ('button:RegisterForDrag("LeftButton", "RightButton")',
              'button:SetScript("OnDragStart", onActionDragStart)',
              'button:SetScript("OnReceiveDrag", onActionReceiveDrag)',
              'PickupAction(slot)', 'PlaceAction(slot)', 'InCombatLockdown()',
              'GameTooltip:SetAction(slot)', 'GameTooltip:SetPetAction(petSlot)',
              'actionBarsUnlocked()'):
    if token not in button: errors.append('action button missing: '+token)
for token in ('index = index,', 'slot.auraIndex = aura.index',
              'GameTooltip:SetUnitAura("player", slot.auraIndex, FILTER)',
              'slotFrame:EnableMouse(true)'):
    if token not in aura: errors.append('aura hover missing: '+token)
# P0409: CAST is the panel label now; preserve the exact stock cast
# source and event refold invariants without restoring a gameplay HUD button.
panel = (root / 'Logres/Dev/Panel.lua').read_text()
for token in ('"casts"', '"PlayerCastingBarFrame"',
              '"OverlayPlayerCastingBarFrame"', '"TargetFrameSpellBar"',
              'function NativeAccess:Refold(',
              'self:Refold("objectives", event)',
              'self:Refold("casts", event)',
              'self.refoldAttempts', 'self.refoldFailures'):
    if token not in native: errors.append('native source missing: '+token)
if '{label = "Cast", command = "nativeui casts", domain = "casts"}' not in panel or \
        'if command == "nativeui" then' not in commands:
    errors.append('native cast stock access not routed through the panel')
for token in ('expected and 5 or 0', 'refolds=%s', 'castStockOnDemand=true'):
    if token not in audit: errors.append('native check missing: '+token)
if 'MainActionBar:Hide()' in native or 'PetActionBar:Hide()' in native:
    errors.append('protected stock domain unexpectedly hidden')
print('Logres P0174 interaction / native coherence contract')
for e in errors: print('ERROR: '+e)
print(('FAIL: '+str(len(errors))+' error(s)') if errors else 'PASS: 0 errors')
sys.exit(bool(errors))
