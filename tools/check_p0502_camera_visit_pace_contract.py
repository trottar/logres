#!/usr/bin/env python3
"""Static L-036 camera visit and movement-pace invariants."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
world = (root / "Logres/Camera/WorldCombat.lua").read_text()
behavior = (root / "Logres/Camera/ProfileBehavior.lua").read_text()
ledger = (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text()
boot = (root / "Logres/Core/Bootstrap.lua").read_text()
toc = (root / "Logres/Logres.toc").read_text()
assert 'local CAMERA_MOTION_DURATION_SCALE = 1 / 0.65' in world
assert 'return duration * CAMERA_MOTION_DURATION_SCALE' in world
assert 'local CAMERA_CONTINUOUS_ROTATION_SPEED_SCALE = 0.65' in behavior
assert 'rotation.speed * CAMERA_CONTINUOUS_ROTATION_SPEED_SCALE' in behavior
assert 'rotation.yaw or 0' in behavior and 'rotation.pitch or 0' in behavior
assert 'Controller.npcHandoffUntil = GetTime() + 0.45' in world
assert 'self.npcHandoffUntil ~= nil and now >= self.npcHandoffUntil' in world
assert 'self:Reconcile("npc-handoff-expired")' in world
assert 'reason == "PLAYER_REGEN_DISABLED"' not in world or 'self.npcHandoffPending = false' in world
assert 'C_Timer.After' not in world
assert 'dynamiccam-loaded' in world
assert '| L-036 |' in ledger and 'P0502 candidate' in ledger
b = re.search(r'^Logres.VERSION = "([^"]+)"$', boot, re.M)
t = re.search(r'^## Version: (\S+)$', toc, re.M)
assert b and t and b.group(1) == t.group(1)
print('P0502 camera lifecycle/pace static contract PASS')
