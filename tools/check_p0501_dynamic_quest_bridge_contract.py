#!/usr/bin/env python3
"""P0501: protected, bounded rebase of native quest-stage child sets."""
from pathlib import Path
import re, shutil, subprocess
r = Path(__file__).resolve().parents[1]
d = (r/'Logres/Quest/Dialogue.lua').read_text()
c = (r/'Logres/Quest/CompletionControl.lua').read_text()
panel = (r/'Logres/Dev/Panel.lua').read_text()
errors = []
bridge = d[d.index('function Dialogue:ValidateProgressCompletionBridge(bridge)'):d.index('function Dialogue:EndProgressCompletionBridge(reason, adopted)')]
for token in (
    'local questID, idError = readQuestID()',
    'pcall(module.CanBridgeVisual, module, snapshot)',
    'pcall(module.CaptureOfferPresentation, module)',
    'current.frame ~= snapshot.frame',
    'local changed = current.frame ~= snapshot.frame',
    'pcall(module.CanBridgeVisual, module, current)',
    'local merged, seen = {}, {}',
    'if not seen[entry.frame] then',
    'if #merged > 512 then',
    'alpha = snapshot.alpha',
    'bridge.snapshot = {',
    'pcall(module.SuppressOfferPresentation, module, current)',
    '"bridge-rebase-suppress-failed"',
    'return true, "same-quest-subtree-rebased"',
):
    if token not in bridge: errors.append('missing guarded rebase: '+token)
if bridge.find('bridge.snapshot = {') > bridge.find('pcall(module.SuppressOfferPresentation, module, current)'):
    errors.append('restoration union must predate suppression')
if 'alpha = current.alpha' in bridge or 'snapshot.alpha ==' in bridge:
    errors.append('original opaque alpha must be passed through unexamined')
for token in ('"progressBridgeRebaseCount", "progressBridgeNewChildCount"',):
    if token not in panel: errors.append('incident missing bridge counters')
for token in ('local progressBridge = self.dialogue.progressCompletionBridge',
              'self:Restore("claim-invoked")',
              'pcall(_G.QuestRewardCompleteButton_OnClick)'):
    if token not in c: errors.append('claim/completion invariant missing: '+token)
if c.index('self:Restore("claim-invoked")') > c.index('pcall(_G.QuestRewardCompleteButton_OnClick)'):
    errors.append('native claim input not restored before dispatch')
boot=(r/'Logres/Core/Bootstrap.lua').read_text()
toc=(r/'Logres/Logres.toc').read_text()
b=re.search(r'^Logres.VERSION\s*=\s*"([^"\n]+)"',boot,re.M)
t=re.search(r'^## Version: ([^\r\n]+)',toc,re.M)
if not b or not t or b.group(1)!=t.group(1):errors.append('version mismatch')
lua=shutil.which('lua') or shutil.which('texlua')
if not lua: errors.append('actual-source Lua interpreter required')
elif not errors:
    p=subprocess.run([lua,str(r/'tools/test_p0498_quest_bridge.lua')],cwd=r,capture_output=True,text=True)
    if p.returncode: errors.append('actual-source bridge fixture FAIL: '+(p.stderr or p.stdout)[-400:])
print('P0501 guarded dynamic quest bridge: '+('PASS' if not errors else 'FAIL'))
for e in errors: print('ERROR:',e)
if errors:raise SystemExit(1)
