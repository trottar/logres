#!/usr/bin/env python3
"""P0319: source-backed no-choice NPC stages use existing narrative UI safely."""
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding='utf-8')
live = read('Logres/Quest/NPCGossipPresentation.lua')
session = read('Logres/Quest/OptionSession.lua')
source = read('Logres/Quest/NPCGossipSource.lua')
visual = read('Logres/UI/OptionList.lua')
choice = read('Logres/Quest/NPCGossipChoice.lua')
current = read('docs/memory/CURRENT.md')
handoff = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
evidence = read('docs/memory/evidence/P0319_UNIVERSAL_GOSSIP_STAGES.md')
errors = []
def need(ok, why):
    if not ok: errors.append(why)
for token in ('function Live.TryShow(reason)', 'Logres.NPCGossipSource.Sample()',
              'd:ShowReadOnlyGossip(model)', 'local hasChoices = #node.options > 0',
              'local hasBody = type(node.body) == "string" and node.body ~= ""',
              'if not hasChoices and not hasBody then',
              'last = "no-displayable-gossip-stage"',
              'Logres:RegisterEvent("GOSSIP_SHOW"',
              'Logres:RegisterEvent("GOSSIP_CLOSED"',
              'function Live.OnNativeChoice()'):
    need(token in live, 'live stage handling missing: '+token)
need('if not node or not node.options or #node.options == 0 then' not in live,
     'legacy choice-count-only live presentation gate persists')
for token in ('function Session:StartReadOnly(model)',
              'if type(node.options) ~= "table" then',
              'if #node.options == 0 and (type(node.body) ~= "string" or node.body == "") then',
              'if #choices == 0 then', 'self.visual:Clear()',
              'self.visual:Present(choices, self.optionPage',
              'Logres.NPCGossipChoice.Activate(self.model, index)'):
    need(token in session, 'shared session text-only support lost: '+token)
need('type(node.options) ~= "table" or #node.options == 0' not in session,
     'legacy no-option rejection persists')
need('model.questSummary = { available = #available, active = #active }' in source,
     'native quest entries must remain count-only')
need('enabled = false' in source and 'gossipStatus = status' in source,
     'source option inertness and status metadata lost')
need('function Visual:SetLiveSelectable(enabled)' in visual,
     'actual native choice route lost')
need('C_GossipInfo.SelectOption' in choice and 'chosen.gossipStatus ~= 0' in choice,
     'separate guarded native selector lost')
for forbidden in ('C_GossipInfo.Select', 'C_GossipInfo.SelectAvailableQuest',
                  'C_GossipInfo.SelectActiveQuest', 'AcceptQuest(',
                  'SetAlpha(', 'HideUIPanel(', 'GossipFrame:Hide',
                  'C_Timer.', 'SetScript("OnUpdate"', 'DynamicCam'):
    need(forbidden not in live and forbidden not in session,
         'native action, suppression or polling in presentation: '+forbidden)
need('P0319' in current and 'P0318' in current and 'CURRENT.md' in handoff,
     'durable current/handoff authority missing')
for word in ('P0319', 'Gerrig', 'Eldrun', 'Ironforge Guard', 'Grimnur',
             'text-only', 'quest-only', 'UNVERIFIED', 'Blizzard', 'fail-open'):
    need(word.lower() in evidence.lower(), 'evidence missing: '+word)
print('P0319 universal NPC dialogue stages static contract')
for problem in errors: print('ERROR:', problem)
if errors: raise SystemExit(1)
print('PASS: empty-option body uses shared narrative, live choices and native controls retained')
