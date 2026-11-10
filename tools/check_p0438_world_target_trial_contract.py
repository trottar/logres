#!/usr/bin/env python3
"""P0438 source gate: explicit out-of-combat world target trial; no production attachment."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
read=lambda path:(ROOT/path).read_text(encoding='utf-8')
hud=read('Logres/HUD/HUD.lua')
probe=read('Logres/HUD/WorldTargetProbe.lua')
status=read('Logres/HUD/StatusAuras.lua')
cmd=read('Logres/Core/Commands.lua')
dev=read('Logres/Dev/Panel.lua')
assert 'function Probe:AcquireWorldTrialAnchor()' in probe
assert 'if worldCandidate == true' in probe
assert 'anchorFrame.IsForbidden' in probe
assert 'forbidden.value ~= false' in probe
assert 'function HUD:BuildWorldTargetTrial()' in hud
assert 'function HUD:RefreshWorldTargetTrial(reason)' in hud
assert 'function HUD:SetWorldTargetTrial(enabled)' in hud
assert 'if not ordinaryOutOfCombat() then' in hud
assert '"[combat] hide; show"' in hud
assert 'pcall(RegisterStateDriver, shell,' in hud
assert 'frame:SetPoint("TOP", aggroSlot, "TOP"' not in hud
assert 'worldTrialRequested = false' in hud
assert 'worldTrialVisible = false' in hud
assert 'enemyWorldAttachmentEnabled = false' in hud
assert 'enemyFallbackPreserved = true' in hud
assert 'Logres.Layout.Bind(targetFrame, "targetFallback"' in hud
assert 'frame.enemyNameText:SetText(UnitName("target"))' in hud
assert 'frame.enemyHealthBar.status:SetValue(percent)' in hud
assert 'frame.enemyHealthText:SetFormattedText("%.0f%%", percent)' in hud
assert 'function StatusAuras:CreateWorldTrialLanes(parent)' in status
assert 'function StatusAuras:RefreshWorldTrialLanes()' in status
assert 'if not ok or isSecret(lockdown) or lockdown ~= false then return end' in status
assert 'root:SetPoint("RIGHT", previewParent, "LEFT", -25, 0)' in status
assert 'root:SetPoint("LEFT", previewParent, "RIGHT", 25, 0)' in status
assert 'if command == "worldtrial"' in cmd
assert 'hud:SetWorldTargetTrial(argument == "on")' in cmd
assert 'incident.snapshot.worldTargetTrial' in dev
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
for forbidden in ('SetCVar(', 'C_NamePlate.GetNamePlates(', 'SetParent(anchor', 'anchor:SetPoint('):
    assert forbidden not in hud
for path in ('docs/ROADMAP.md', 'docs/memory/investigations/ACTIVE.md',
    'docs/memory/roadmap/STATUS.md', 'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
    s=read(path)
    assert s.startswith('## P0438 —'), path
    assert '## P0437 —' in s and '## P0436 —' in s
assert 'P0425 visual PASS' in read('docs/memory/CURRENT.md')
assert len(read('docs/memory/CURRENT.md').encode()) < 9800
assert '| L-011 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert '| L-046 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0438' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
print('P0438 PASS: live OOC trial only after hidden proof, state driver, preserved native fallback (STATIC)')
