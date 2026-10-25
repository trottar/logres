#!/usr/bin/env python3
"""P0289: H developer panel owns the trainer live trial controls."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding='utf-8')
cmd = read('Logres/Core/Commands.lua')
panel = read('Logres/Dev/Panel.lua')
trial = read('Logres/Quest/TrainerLiveTrial.lua')
old = read('tools/check_p0288_trainer_live_trial_contract.py')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
evidence = read('docs/memory/evidence/P0289_TRAINER_LIVE_PANEL_ROUTING.md')
errors = []
def need(condition, detail):
    if not condition: errors.append(detail)

for identity, label, action in (
    ('nativeTrainerLiveOn', 'Live Trainer ON (TEST)', 'nativetrainerlive on'),
    ('nativeTrainerLiveOff', 'Live Trainer OFF', 'nativetrainerlive off'),
):
    expected = 'Logres:RegisterDevPanelAction(\n    "' + identity + '",\n    "' + label + '",\n    "' + action + '",\n    "H"\n)'
    need(cmd.count(expected) == 1, 'H registration absent/duplicate: ' + identity)
    need(panel.count('item.id == "' + identity + '"') == 1,
         'first H page must prioritize: ' + identity)
need(cmd.index('"nativeTrainerLiveOn",') < cmd.index('"nativeTrainerLiveOff",') < cmd.index('"nativeTrainerSkinOn",'),
     'H action registration should preserve live ON/OFF then skin ON/OFF ordering')
for token in ('item.id == "nativeTrainerSkinOn"', 'item.id == "nativeTrainerSkinOff"',
              'self:UpdatePreviewPager(#visible)', 'self:RunCommand(action.command)',
              'MAX_ACTIONS_PER_PHASE', 'if self.activePhase == "H" then'):
    need(token in panel, 'preserve paginated H command runner: ' + token)
for token in ('if command == "nativetrainerlive" then',
              'Logres.NPCTrainerLiveTrial.Toggle(argument)',
              'Logres.NPCTrainerLiveTrial.GetAudit()'):
    need(token in cmd, 'do not replace existing read-only live handler: ' + token)
for token in ('function Trial.Toggle(mode)', 'function Trial.Disable(why)',
              'Logres.NPCTrainerLandscape.Render(root, model)',
              'root:EnableMouse(false)', 'purchases=0, filterWrites=0, selectionWrites=0'):
    need(token in trial, 'live render/data safety preserved: ' + token)
need('P0288' in old and 'read-only' in old, 'P0288 old contract remains installed')
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'), 'handoff must cite authority')
for token in ('P0288', 'P0289', 'slash-only', 'user', 'Blizzard', 'UNVERIFIED', 'PREWRITE'):
    need(token.lower() in evidence.lower(), 'required recorded failure/scope: ' + token)
ver = re.search(r'(?m)^## Version: (\S+)$', toc)
bootstrap = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', boot)
need(bool(ver and bootstrap and ver.group(1) == bootstrap.group(1)), 'TOC/bootstrap version mismatch')
print('P0289 R1 H live trainer developer panel and migration contract')

# R1: close the exact PREWRITE failure graph. Previously published feature
# checkers pin the now-stale 108/H20 inventory. Preserve the exact P gallery,
# while allowing H to grow through existing pagination with explicit actions.
registry = re.findall(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*"([0A-HP])"\s*\)', cmd, re.S)
need(len(registry) >= 110 and sum(phase == 'H' for _, phase in registry) >= 22
     and sum(phase == 'P' for name, phase in registry if name not in ('pvpBadgePreviewOn','pvpBadgePreviewOff')) == 36 and sum(phase == 'P' for _, phase in registry) == 38,
     'R1 action inventory must contain two additional H controls and unchanged P gallery')
need(len(registry) == len(set(id_ for id_, _ in registry)),
     'R1 action IDs must be unique')
for path, token in (
    ('tools/check_p0256_preview_hub_contract.py', 'if len(actions) < 108:'),
    ('tools/check_p0261_n1_narrative_contract.py', "'len(actions) < 108' in p"),
    ('tools/check_p0269_native_service_ownership_contract.py', "'len(actions) < 108' in h"),
    ('tools/check_p0270_native_frame_capability_contract.py', "'if len(actions) < 108:' in preview_check"),
    ('tools/check_p0271_native_placement_trial_contract.py', 'len(entries)>=108 and'),
    ('tools/check_p0272_native_auto_handoff_contract.py', 'len(reg)>=108 and'),
    ('tools/check_p0273_native_gossip_continuity_contract.py', 'len(a)>=108 and'),
    ('tools/check_p0274_native_service_accent_contract.py', 'len(reg) >= 108 and'),
    ('tools/check_p0276_r1_native_trainer_skin_contract.py', 'len(acts) >= 108 and'),
):
    need(token in read(path), 'stale historical panel count checker: ' + path)
need('P0289 R0 PREWRITE refusal' in evidence,
     'R1 must durably preserve original 6/160 failure')
for error in errors: print('ERROR:', error)
if errors: raise SystemExit(1)
print('PASS: first-page Live ON/OFF, 35 P previews, historical count migration, Blizzard unchanged')
