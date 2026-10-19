#!/usr/bin/env python3
"""P0265: one combined, bounded NPC option interaction/view/session milestone."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
M=read('Logres/Quest/OptionModel.lua')
V=read('Logres/UI/OptionList.lua')
S=read('Logres/Quest/OptionSession.lua')
D=read('Logres/Quest/Dialogue.lua')
C=read('Logres/Core/Commands.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
E=[]
def need(ok,what):
 if not ok:E.append(what)
for x in ('Logres.NPCOptionModel = Model','function Model.Preview(mode)',
          'function Model.FromValidated(title, start, nodes)',
          'mode == "branching"','mode == "services"','mode == "overflow"',
          'mode == "locked"','previewOnly = true','enabled = enabled ~= false',
          'Requires a permit','Merchant and supplies','Flight routes','Bank storage'):
 need(x in M,'model: '+x)
for x in ('Logres.NPCOptionList = Visual','function Visual.New(root)',
          'local PAGE_SIZE = 6','function Visual:Clear()',
          'function Visual:Present(options, page, canBack, callbacks)',
          'function Visual:SetPageVisible(show)',
          'slot:SetScript("OnClick", function(button)',
          'if self.active and button.optionEnabled and self.onChoose then',
          'self.onChoose(button.optionIndex)','slot:EnableMouse(slot.optionEnabled)',
          'self.onBack and self.onBack()','self.onPage and self.onPage(1)',
          'self.onPage and self.onPage(-1)','[LOCKED]'):
 need(x in V,'view: '+x)
for x in ('Logres.NPCOptionSession = Session','function Session:Gate()',
          'd.lastPresentationReason == "npc-options-preview"',
          'function Session:Start(mode, model)','model.previewOnly ~= true',
          'function Session:Choose(index)','choice.enabled == false',
          'self.model.nodes[choice.nextNode]',
          'function Session:Back()','table.remove(self.history)',
          'function Session:MovePage(delta)','function Session:OnNarrativePageChanged()',
          'function Session:Debug()','nativeActions = 0'):
 need(x in S,'session: '+x)
for x in ('function Dialogue:ShowOptionPreview(mode)',
          'Logres.NPCOptionModel.Preview(mode)',
          'self.optionSession:Start(mode, model)',
          'self.optionView = Logres.NPCOptionList.New(root)',
          'self.optionSession = Logres.NPCOptionSession.New(self, self.optionView)',
          'self.optionSession:OnNarrativePageChanged()',
          'optionSession = self.optionSession and self.optionSession:Debug()',
          'self.optionSession:Reset()','self.optionView:Clear()'):
 need(x in D,'integration: '+x)
for mode in ('branching','services','overflow','locked'):
 need('"npcoptionpreview '+mode+'"' in C,'missing command/gallery '+mode)
 need('"npcOption'+mode.title()+'"' in C,'missing panel action '+mode)
need('Logres npcoptionpreview: %s (mode=%s state=%s)' in C,'commands result audit')
need('Logres questdialogue npcoptions: AUDIT (' in C,'diagnostic readout')
need('UI\\OptionList.lua' in T and 'Quest\\OptionModel.lua' in T and 'Quest\\OptionSession.lua' in T,'TOC load sequence')
need(T.index('UI\\OptionList.lua')<T.index('Quest\\OptionModel.lua')<T.index('Quest\\OptionSession.lua')<T.index('Quest\\Dialogue.lua'),'load dependencies')
need(T.index('Quest\\RewardVisual.lua')<T.index('Quest\\Dialogue.lua'),'reward visual stays before quest Dialogue')
for label,txt in (('model',M),('view',V),('session',S)):
 for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'AcceptQuest(', 'DeclineQuest(',
                   'QuestRewardCompleteButton_OnClick', 'C_GossipInfo.Select',
                   'GossipOptionOnClick(', 'SelectGossipOption(', 'HideUIPanel(',
                   'InCombatLockdown(', 'DynamicCam', 'RegisterEvent(',
                   'C_Timer.', 'SetScript("OnUpdate"'):
  need(forbidden not in txt,label+' may not own gameplay/native actions: '+forbidden)
need('if self.completionControl then\n        self.completionControl:Restore("new-presentation")' in D,
     'native completion restore preserved')
need('self.rewardVisual:Present(model.cards, model.footer)' in D,'reward preview retained')
need('self:RequestStockOfferSuppression(' in D,'stock offer source retained')
v=re.search(r'^## Version: ([^\r\n]+)$',T,re.M)
b=re.search(r'^Logres\.VERSION = "([^"]+)"$',B,re.M)
need(bool(v and b and v.group(1)==b.group(1) and re.fullmatch(r'\d+\.\d+\.\d+-dev',v.group(1))),
     'version format/equality; no historical pin')
print('P0265 combined NPC option session, branching, paging, service, disabled and native safety')
for e in E:print('ERROR:',e)
if E:raise SystemExit(1)
print('PASS: all static source contracts (in-game test still required)')
