#!/usr/bin/env python3
"""P0439: trial must be accessible and readable in developer panel, not chat."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
panel=read('Logres/Dev/Panel.lua'); command=read('Logres/Core/Commands.lua')
hud=read('Logres/HUD/HUD.lua')
assert 'local WORLD_TRIAL_PANEL_ACTIONS = {' in panel
for label,action in [('World Trial ON','worldtrial on'),
                     ('World Trial OFF','worldtrial off'),
                     ('World Trial Status','worldtrial status')]:
    assert f'label = "{label}", command = "{action}"' in panel
assert 'for i = 1, #WORLD_TRIAL_PANEL_ACTIONS do' in panel
assert 'visible[#visible + 1] = WORLD_TRIAL_PANEL_ACTIONS[i]' in panel
assert 'self:RunCommand(action.command)' in panel
assert 'Logres:RunDevCommand(command, function(line)' in panel
assert 'self:AddResult(line, run)' in panel
assert 'function Panel:BeginDiagnosticRun(command)' in panel
assert 'if argument == "status" then' in command
assert 'local state = hud:GetDebugStatus()' in command
assert 'state.worldTrialAttachCount' in command and 'state.worldTrialLastReason' in command
assert 'hud:SetWorldTargetTrial(argument == "on")' in command
assert 'if command == "worldtrial" then' in command
assert len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',command)) == 122
assert 'bugButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")' in panel
assert 'Logres:ToggleDevPanel()' in panel and 'Logres:CaptureBugIncident()' in panel
assert 'incident.snapshot.worldTargetTrial' in panel
assert '"[combat] hide; show"' in hud and 'enemyFallbackPreserved = true' in hud
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
for path in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
    s=read(path)
    assert '## P0439 —' in s,path
    assert '## P0438 —' in s and '## P0437 —' in s
assert '| L-047 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert '| L-011 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert len(read('docs/memory/CURRENT.md').encode('utf-8')) < 9800
print('P0439 PASS: panel-only trial input/output, saved diagnostics and protected fallback (STATIC)')
