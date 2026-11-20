#!/usr/bin/env python3
"""P0500 L-058 native corpse position and L-059 bag safety contract."""
from pathlib import Path
import re,shutil,subprocess
R=Path(__file__).resolve().parents[1]
c=(R/'Logres/Navigation/Compass.lua').read_text()
p=(R/'Logres/Dev/Panel.lua').read_text()
b=(R/'Logres/Core/Bootstrap.lua').read_text()
t=(R/'Logres/Logres.toc').read_text()
assert 'C_DeathInfo.GetCorpseMapPosition, mapID' in c
assert 'UnitIsDeadOrGhost, "player"' in c
assert 'type(issecretvalue) ~= "function"' in c
assert 'local function corpseValueOrdinary(value)' in c
assert 'return ok and secret == false' in c
assert 'not corpseValueOrdinary(playerPosition)' in c
assert 'not corpseValueOrdinary(corpsePosition)' in c
assert 'not corpseValueOrdinary(component)' in c
assert 'not self.policyEligible' in c
assert 'readVectorXY, playerPosition' in c and 'readVectorXY, corpsePosition' in c
assert 'corpseDistanceYards' in c and 'C_Map.GetMapWorldSize, mapID' in c
assert 'pcall(corpseMarker.SetAtlas' in c and '"Navigation-Tombstone-Icon"' in c
assert 'self.corpseEdgeCued = clipped' in c
assert 'reserveMarkerBearing(self.corpseMarkerOffset, CORPSE_WIDTH, occupied)' in c
assert 'name = "Your body [corpse]", kind = "corpse"' in c
assert 'self:RefreshCorpseBearing("onupdate")' in c
assert 'self:RefreshCorpseBearing(reason or "policy")' in c
assert '"PLAYER_UNGHOST"' in c and '"PLAYER_DEAD"' in c
assert c.count('self.frame:SetScript("OnUpdate", self.onUpdateHandler)') == 1
assert 'incident.snapshot.compassCorpse' in p
for field in ('corpseAPIAvailable','corpseMarkerShown','corpseSourcePresent',
              'corpseDistanceYards','corpseEdgeCued','lastCorpseReason'):
    assert '"'+field+'"' in p
# Zero native waypoint, pin, input or bag-slot mutation in compass change.
for forbidden in ('SetUserWaypoint(', 'ClearUserWaypoint(', 'SetSuperTracked',
                  'PickupContainerItem(', 'EquipItemByName(', 'C_Container.Pickup',
                  'TargetUnit(', 'SetOverrideBinding(', 'C_Timer.After('):
    assert forbidden not in c, forbidden
assert re.search(r'^Logres.VERSION = "([^"\n]+)"',b,re.M).group(1)==re.search(r'^## Version: ([^\r\n]+)',t,re.M).group(1)
for f in ('docs/memory/CURRENT.md','docs/memory/investigations/ISSUE_LEDGER.md',
          'docs/memory/evidence/P0500_CORPSE_COMPASS_AND_BAG_BACKLOG.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    text=(R/f).read_text()
    assert 'L-058' in text and 'L-059' in text, f
engine=shutil.which('texlua') or shutil.which('lua')
if not engine: raise SystemExit('P0500 source Lua engine required')
subprocess.run([engine,str(R/'tools/test_p0500_corpse_compass.lua'),str(R)],cwd=R,check=True)
print('P0500 corpse compass and bag backlog contract: PASS')
