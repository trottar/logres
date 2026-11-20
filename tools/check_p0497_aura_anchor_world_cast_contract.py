#!/usr/bin/env python3
"""P0497 player HELPFUL first-row and selected world-cue spatial contracts."""
from pathlib import Path
import re, shutil, subprocess
R=Path(__file__).resolve().parents[1]
N=(R/'Logres/HUD/NativeDebuffs.lua').read_text()
H=(R/'Logres/HUD/PlayerHelpfulAuras.lua').read_text()
U=(R/'Logres/HUD/HUD.lua').read_text()
assert 'function Native.CreatePlayerHelpfulMirror(anchor)' in N
native=N.split('function Native.CreatePlayerHelpfulMirror(anchor)',1)[1].split('function Native.CreateWorldEnemyLanes',1)[0]
assert 'if not anchor then return nil, "player-helpful-anchor-unavailable" end' in native
assert 'frame:SetPoint("BOTTOMLEFT", anchor, "LEFT", 0, -iconSize / 2)' in native
assert 'frame:SetSize(width, 10 * iconSize + 9 * gap)' in native
assert 'frame:SetFlowLayoutAnchorPoint("BOTTOMLEFT")' in native
assert 'AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Up' in native
assert 'Logres.Layout.Bind(frame' not in native, 'must not create separate passiveStatus anchor owner'
assert 'native.CreatePlayerHelpfulMirror(self.root)' in H
assert 'Logres.Layout.Bind(root, "passiveStatus", "LEFT", "CENTER")' in H
assert 'root:SetPoint(\n        "LEFT",\n        UIParent,\n        "CENTER",' in H
assert 'self.root:SetHeight(iconSize + (rows - 1) * (iconSize + styleValue("gap")))' in H
assert 'cue:SetPoint("BOTTOM", frame, "TOP", 0, 10)' in U
assert 'targetCastCue:SetPoint("TOP", targetFrame, "BOTTOM", 0, -6)' in U, 'screen fallback unchanged'
assert 'function HUD:HideWorldNativeCastStrip()' in U and 'function HUD:RestoreWorldNativeCastStrip()' in U
assert 'function Native.CreatePlayerHelpfulMirror()' not in N
assert 'SetScript("OnUpdate"' not in N+H+U
for t in ('docs/memory/evidence/P0497_AURA_ANCHOR_WORLD_CAST_PLACEMENT.md',
          'docs/memory/investigations/ISSUE_LEDGER.md', 'docs/memory/CURRENT.md'):
    assert 'P0497' in (R/t).read_text(), t
lua=shutil.which('texlua') or shutil.which('lua')
if lua:
    subprocess.run([lua,str(R/'tools/test_p0496_native_helpful_mirror.lua')],cwd=R,check=True)
print('P0497 native-first-row placement and above-nameplate cast: PASS (STATIC)')
