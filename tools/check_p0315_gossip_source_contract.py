#!/usr/bin/env python3
"""P0315: guarded read-only live gossip into the existing option model."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding="utf-8")
source = read("Logres/Quest/NPCGossipSource.lua")
model = read("Logres/Quest/OptionModel.lua")
session = read("Logres/Quest/OptionSession.lua")
commands = read("Logres/Core/Commands.lua")
toc = read("Logres/Logres.toc")
boot = read("Logres/Core/Bootstrap.lua")
current = read("docs/memory/CURRENT.md")
evidence = read("docs/memory/evidence/P0315_GOSSIP_SOURCE_MODEL.md")
errors = []
def need(ok, msg):
    if not ok: errors.append(msg)
for token in ('Logres.NPCGossipSource = Source', 'function Source.Sample()',
              'function Source.GetAudit()', 'local MAX_OPTIONS = 24',
              'if not ordinary(value)', 'readList("GetOptions")',
              'readList("GetAvailableQuests")', 'readList("GetActiveQuests")',
              'method(C_GossipInfo, "GetText")', 'state.interacting ~= true',
              'pcall(UnitExists, "npc")', 'pcall(UnitName, "npc")',
              '"mixed-quest-gossip-stock-retained"',
              '"gossip-text-unavailable"', '"option-unvalidated"',
              'enabled = false', 'Logres.NPCOptionModel.FromValidated(',
              'nativeActions = 0', 'nativeWrites = 0'):
    need(token in source, 'source gate/model missing: '+token)
for forbidden in ('C_GossipInfo.Select', 'SelectGossipOption(', 'AcceptQuest(',
                  'CompleteQuest(', 'GetQuestReward(', 'CloseGossip(',
                  'SetPoint(', 'HideUIPanel(', 'SetAlpha(', 'C_Timer.',
                  'RegisterEvent(', 'SetScript("OnUpdate"', 'DynamicCam'):
    need(forbidden not in source, 'source must not mutate/poll/act: '+forbidden)
need('function Model.FromValidated(title, start, nodes)' in model,
     'validated common option envelope missing')
need('model.previewOnly ~= true' in session,
     'preview controller could begin live gossip')
for token in ('if command == "gossipsourcecheck" then',
              'Logres.NPCGossipSource.Sample()',
              '"gossipSourceCheck"', '"Gossip Source Check (READ-ONLY)"',
              '"gossipsourcecheck"'):
    need(token in commands, 'H command missing '+token)
need('Quest\\TrainerProfessionContext.lua\nQuest\\NPCGossipSource.lua\n' in toc,
     'gossip source must load after established source/option modules')
need(toc.index('Quest\\OptionModel.lua') < toc.index('Quest\\NPCGossipSource.lua'),
     'source before model')
a = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', boot)
need(bool(a and b and a.group(1)==b.group(1)), 'runtime version parity')
heads = ('## Active Objective', '## Current Work Item', '## Verified State',
         '## Next Action', '## Success Criteria',
         '## Do Not Reopen Without New Evidence', '## Relevant References')
need(len(current.encode())<10000 and all(current.splitlines().count(h)==1 for h in heads),
     'CURRENT required headings/size')
for word in ('P0314', 'P0315', 'UNVERIFIED', 'gossip', 'quest',
             'read-only', 'Blizzard', 'FAIL', 'camera'):
    need(word.lower() in evidence.lower(), 'evidence missing '+word)
print('P0315 guarded live gossip source model/static contract')
for issue in errors: print('ERROR:', issue)
if errors: raise SystemExit(1)
print('PASS: data-only model, H action, source caps and fail-open stock retention')
