#!/usr/bin/env python3
"""P0316: stage-aware, source-only gossip extends to mixed quest/NPC services safely."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
get = lambda p: (R / p).read_text(encoding="utf-8")
source = get("Logres/Quest/NPCGossipSource.lua")
old = get("tools/check_p0315_gossip_source_contract.py")
model = get("Logres/Quest/OptionModel.lua")
session = get("Logres/Quest/OptionSession.lua")
commands = get("Logres/Core/Commands.lua")
toc = get("Logres/Logres.toc")
boot = get("Logres/Core/Bootstrap.lua")
current = get("docs/memory/CURRENT.md")
evidence = get("docs/memory/evidence/P0316_UNIVERSAL_GOSSIP_SCOPE.md")
errors = []
def need(cond, reason):
    if not cond: errors.append(reason)
for token in ('function Source.Sample()', 'local MAX_OPTIONS = 24',
              'readList("GetOptions")', 'readList("GetAvailableQuests")',
              'readList("GetActiveQuests")', 'method(C_GossipInfo, "GetText")',
              '"gossip-only"', '"mixed-quest-gossip"', '"quest-only-gossip"',
              '"empty-gossip"', 'model.questSummary = { available = #available, active = #active }',
              'model.gossipKind = kind', 'audit("model-ready", interaction, #choices, totalQuests',
              'gossipOptionID = identity', 'enabled = false',
              'Logres.NPCOptionModel.FromValidated(', 'nativeActions = 0',
              'nativeWrites = 0'):
    need(token in source, 'missing universal source gate or inert model: '+token)
need('"mixed-quest-gossip-stock-retained"' not in source,
     'old blanket mixed quest source rejection must be gone')
need('if totalQuests > 0 then\n        return nil' not in source,
     'quest presence alone may not reject an NPC')
need('"mixed-quest-gossip"' in old and '"mixed-quest-gossip-stock-retained"' not in old,
     'P0315 historical contract must migrate from blanket rejection')
for token in ('if not ordinary(value)', 'if not ordinary(option)',
              'if index > MAX_OPTIONS then', 'if body == nil then',
              'if not options then', 'if not available then', 'if not active then',
              'pcall(UnitExists, "npc")', 'pcall(UnitName, "npc")'):
    need(token in source, 'ordinary/required-source gate missing: '+token)
for forbidden in ('C_GossipInfo.Select', 'SelectGossipOption(', 'AcceptQuest(',
                  'CompleteQuest(', 'GetQuestReward(', 'CloseGossip(',
                  'BuyTrainerService(', 'SetPoint(', 'HideUIPanel(', 'SetAlpha(',
                  'C_Timer.', 'RegisterEvent(', 'SetScript("OnUpdate"', 'DynamicCam'):
    need(forbidden not in source, 'unauthorized native action or polling: '+forbidden)
need('function Model.FromValidated(title, start, nodes)' in model,
     'shared option model unavailable')
need('model.previewOnly ~= true' in session,
     'preview-only controller must reject all live gossip')
need('if command == "gossipsourcecheck" then' in commands
     and 'Logres.NPCGossipSource.Sample()' in commands
     and '"Gossip Source Check (READ-ONLY)"' in commands,
     'existing H developer-panel source probe lost')
need('Quest\\NPCGossipSource.lua' in toc and
     toc.index('Quest\\OptionModel.lua') < toc.index('Quest\\NPCGossipSource.lua'),
     'source-to-option dependency order broken')
a = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', boot)
need(bool(a and b and a.group(1) == b.group(1)), 'runtime version parity')
heads = ('## Active Objective', '## Current Work Item', '## Verified State',
         '## Next Action', '## Success Criteria',
         '## Do Not Reopen Without New Evidence', '## Relevant References')
need(len(current.encode()) < 10000 and
     all(current.splitlines().count(h) == 1 for h in heads), 'CURRENT health')
for word in ('P0315', 'P0316', '878235b', 'UNVERIFIED', 'mixed', 'guard',
             'trainer', 'quest', 'Blizzard', 'FAIL', 'read-only', 'no native'):
    need(word.lower() in evidence.lower(), 'evidence omits: '+word)
print('P0316 universal gossip stage/source compatibility contract')
for err in errors: print('ERROR:', err)
if errors: raise SystemExit(1)
print('PASS: mixed NPC stage supported; quest counts only; native actions zero')
