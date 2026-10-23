#!/usr/bin/env python3
"""P0317: production option visual consumes guarded live gossip inertly."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
r=lambda p:(ROOT/p).read_text(encoding='utf8')
live=r('Logres/Quest/NPCGossipPresentation.lua')
session=r('Logres/Quest/OptionSession.lua')
visual=r('Logres/UI/OptionList.lua')
dialogue=r('Logres/Quest/Dialogue.lua')
commands=r('Logres/Core/Commands.lua')
toc=r('Logres/Logres.toc')
current=r('docs/memory/CURRENT.md')
legacy=r('tools/check_p0265_npc_options_contract.py')
errors=[]
def need(test, msg):
    if not test: errors.append(msg)
for token in ['Logres.NPCGossipPresentation = Live', 'Logres.NPCGossipSource.Sample()',
              'd:ShowReadOnlyGossip(model)', '"GOSSIP_SHOW"', '"GOSSIP_CLOSED"',
              '"PLAYER_INTERACTION_MANAGER_FRAME_SHOW"', '"QUEST_DETAIL"',
              '"npc-options-read-only"', 'nativeActions = actions.attempts', 'nativeWrites = 0',
              'stock = "retained"', 'function Live.Toggle()', 'function Live.GetAudit()']:
    need(token in live or token in dialogue, 'missing live guard: '+token)
for token in ['function Session:StartReadOnly(model)', 'model.previewOnly ~= false',
              'option.enabled ~= false', 'self.liveReadOnly = true',
              'if self.liveReadOnly then', '}, self.liveReadOnly)']:
    need(token in session, 'missing inert session: '+token)
for token in ['function Visual:Present(options, page, canBack, callbacks, displayOnly)',
              'self.displayOnly = displayOnly == true', 'if not slot.optionEnabled and not self.displayOnly then',
              'if button.optionEnabled or self.displayOnly then']:
    need(token in visual, 'missing shared renderer read-only variant: '+token)
for token in ['function Dialogue:ShowReadOnlyGossip(model)',
              'return self.optionSession:StartReadOnly(model)',
              'reason == "npc-options-read-only"']:
    need(token in dialogue, 'missing production Dialogue path: '+token)
for token in ['"gossiplivestatus"', '"gossiplivetoggle"',
              '"Gossip Live Status (READ-ONLY)"', '"Gossip Live Toggle"']:
    need(token in commands, 'missing H panel control: '+token)
need("'function Visual:Present(options, page, canBack, callbacks, displayOnly)'" in legacy,
     'historical P0265 preview contract must allow additive display-only renderer')
need('Quest\\NPCGossipSource.lua\nQuest\\NPCGossipPresentation.lua\n' in toc,
     'event presentation must load after the source and Dialogue')
need('P0317' in current and '187' not in current.split('## Next Action')[1].split('## Success Criteria')[0],
     'CURRENT must advance beyond P0316 static test gate')
for term in ['C_GossipInfo.SelectOption','SelectGossipOption(', 'AcceptQuest(',
             'SetAlpha(', 'HideUIPanel(', 'C_Timer.', 'SetScript("OnUpdate"',
             'DynamicCam', 'GossipFrame:Hide', 'GossipFrame.Hide']:
    need(term not in live, 'live module cannot act/modify native: '+term)
print('P0317 live additive read-only gossip contract')
for error in errors: print('ERROR:',error)
if errors: raise SystemExit(1)
print('PASS: source -> shared renderer, inert live choices, stock retained and event handoff')
