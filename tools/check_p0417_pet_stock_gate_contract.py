#!/usr/bin/env python3
"""P0417: source-backed pet stock-access readiness, not native visibility PASS."""
from pathlib import Path
import re
root=Path(__file__).resolve().parents[1]
def source(name): return (root/name).read_text(encoding="utf-8")
trial=source("Logres/Immersion/PetBarVisibilityTrial.lua")
native=source("Logres/Immersion/NativeSurfaceReplacement.lua")
access=source("Logres/Immersion/NativeAccess.lua")
panel=source("Logres/Core/Commands.lua")
assert 'local native = getNative()' in trial
assert 'or type(native.Toggle) ~= "function"' in trial
assert 'or not native.petInteraction' in trial
assert 'or not native.buttons' not in trial, 'stale dock gate remains executable'
assert 'return false, "secure-pet-unit-or-stock-access-unavailable"' in trial
assert 'function Native:Toggle(domain)' in native
assert 'if domain == "pet" then' in native
assert 'trial:ToggleNativeAccess()' in native
assert 'function Trial:ToggleNativeAccess()' in trial
assert 'self:Release(' in trial
assert 'RegisterStateDriver, bar, "visibility", NATIVE_HIDE' in trial
assert 'RegisterStateDriver, unit, "visibility", NATIVE_HIDE' in trial
assert 'UnregisterStateDriver(bar, "visibility")' in trial
assert 'UnregisterStateDriver(unit, "visibility")' in trial
assert 'if InCombatLockdown() then return false, "combat-lockdown" end' in trial
assert 'editModeActive()' in trial
assert 'if key == "petActions" then return false end' in native
assert 'if key == "petFrame" then return false end' in native
assert '"Native Pet Bar Check"' in panel
assert '"petbardriver check"' in panel
assert '"PET' in panel or '"pet' in panel
assert 'nativeAccess' in access
version = re.search(r'Logres.VERSION = \"([^\"]+)\"', source('Logres/Core/Bootstrap.lua'))
toc_version = re.search(r'## Version: ([^\n]+)', source('Logres/Logres.toc'))
assert version and toc_version and version.group(1) == toc_version.group(1)
for p in ('docs/memory/CURRENT.md','docs/memory/investigations/ACTIVE.md',
'docs/memory/investigations/ISSUE_LEDGER.md','docs/memory/patches/PATCH_INDEX.md',
'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
'docs/ROADMAP.md','docs/memory/PRE_HANDOFF_AUDIT.md',
'docs/memory/evidence/P0417_PET_STOCK_GATE_REPAIR.md',
'docs/memory/patches/P0417_PET_STOCK_GATE_REPAIR.md'):
    assert 'P0417' in source(p), f'memory missing P0417: {p}'
print('P0417 pet stock readiness contract: PASS (no WoW runtime claimed)')
