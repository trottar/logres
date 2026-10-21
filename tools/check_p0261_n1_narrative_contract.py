#!/usr/bin/env python3
"""P0261 N1: one quest offer/narrative view from live or preview models."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
m=(r/'Logres/Quest/NarrativeModel.lua').read_text(encoding='utf-8')
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(r/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
p=(r/'tools/check_p0256_preview_hub_contract.py').read_text(encoding='utf-8')
t=(r/'Logres/Logres.toc').read_text(encoding='utf-8')
err=[]
def need(cond,message):
    if not cond: err.append(message)
need('Logres.NPCNarrativeModel = Model' in m,'source-independent model registration')
need('function Model.FromLive(title, body, objective, reason, action)' in m,'guarded live adapter contract')
need('function Model.Preview(mode)' in m,'deterministic preview fixtures')
for mode in ('long','short','generic'):
    need('mode == "'+mode+'"' in m,'missing narrative fixture '+mode)
need('action = "none"' in m and 'action = "offer"' in m,'visual-only action classification')
need('return nil, "unknown-narrative-preview"' in m,'unknown fixture rejection')
for forbidden in ('CreateFrame(', 'RegisterEvent(', 'GetQuestID(', 'GetQuestText(',
                  'AcceptQuest(', 'DeclineQuest(', 'CompleteQuest(', 'GetQuestReward(',
                  'C_GossipInfo.', 'QuestRewardCompleteButton_OnClick(', 'SetScript(',
                  'InCombatLockdown(', 'UnitExists(', 'C_Timer.After('):
    need(forbidden not in m,'pure model contains native/interaction API '+forbidden)
need(d.count('function Dialogue:PresentNarrativeModel(model)')==1,'single model-to-view adapter')
view=d.split('function Dialogue:PresentNarrativeModel(model)',1)[-1].split('function Dialogue:HandleQuestDetail()',1)[0]
need('return self:PresentText(' in view,'production renderer must serve both models')
need('model.action == "offer"' in view and 'model.previewOnly' in view,'model action and preview-only routing')
need('Logres.NPCNarrativeModel.FromLive(' in d,'live guarded quest data flows into same model')
live=d.split('function Dialogue:HandleQuestDetail()',1)[-1].split('function Dialogue:RestoreCompletionAfterImmersion()',1)[0]
need('local model = Logres.NPCNarrativeModel.FromLive(' in live and
     'self:PresentNarrativeModel(model)' in live,'production offer must use the shared renderer')
need('self:ReadDetail()' in live,'guarded native source retained')
need('function Dialogue:ShowPreview()' in d and
     'return self:ShowNarrativePreview("long")' in d,'legacy approved long preview preserved')
preview=d.split('function Dialogue:ShowNarrativePreview(mode)',1)[-1].split('function Dialogue:ShowPreview()',1)[0]
need('Logres.NPCNarrativeModel.Preview(mode)' in preview and
     'self:PresentNarrativeModel(model)' in preview,'fixture must use identical live renderer')
need('self.previewCount = self.previewCount + 1' in preview,'preview diagnostics retained')
for forbidden in ('AcceptQuest(', 'DeclineQuest(', 'CompleteQuest(', 'GetQuestReward(',
                  'C_GossipInfo.Select', 'QuestRewardCompleteButton_OnClick('):
    need(forbidden not in preview,'preview must not mutate game state: '+forbidden)
need('if owner.offerActionPreview then' in d,'preview button input must stay intercepted')
for fragment in ('"questnarrativepreview"', 'dialogue:ShowNarrativePreview(mode)',
                 '"questNarrativePreviewShort"','"questNarrativePreviewGeneric"',
                 '"questnarrativepreview short"','"questnarrativepreview generic"'):
    need(fragment in c,'missing preview command/gallery registration '+fragment)
pattern=re.compile(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([0A-HP])"\s*\)',re.S)
a={x[0]:x for x in pattern.findall(c)}
for key,cmd in [('questNarrativePreviewShort','questnarrativepreview short'),
                ('questNarrativePreviewGeneric','questnarrativepreview generic')]:
    need(key in a and a[key][2]==cmd and a[key][3]=='P',key+' must be on P tab')
need('len(required) != 35' in p and 'len(actions) < 108' in p,
     'P-tab inventory contract must reflect two additional real previews')
need('Quest\\NarrativeModel.lua\nQuest\\RewardModel.lua' in t,'model must load before existing quest dialogue')
need('Quest\\RewardModel.lua\nQuest\\RewardVisual.lua\nQuest\\Dialogue.lua' in t,'preserve reward model/view/dialogue load order')
need('Quest\\Dialogue.lua' in t,'existing renderer must remain loaded')
for path in ['Logres/Camera/WorldCombat.lua','Logres/Camera/ProfileContexts.lua']:
    need((r/path).exists(),'camera baseline file absent '+path)
print('P0261 N1 shared narrative/live/preview presentation contract')
print('==========================================================')
for e in err: print('ERROR:',e)
if err: raise SystemExit(1)
print('PASS: 0 errors (STATIC; camera and live NPC runtime unmodified)')
