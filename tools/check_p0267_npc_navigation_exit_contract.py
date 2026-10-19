#!/usr/bin/env python3
"""P0267: header rail no longer collides with narrative pagination; exits are one step."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
V=read('Logres/UI/OptionList.lua')
M=read('Logres/Quest/OptionModel.lua')
S=read('Logres/Quest/OptionSession.lua')
D=read('Logres/Quest/Dialogue.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
E=[]
def req(cond,msg):
 if not cond:E.append(msg)
for fragment in (
 'self.back:ClearAllPoints()',
 'self.back:SetSize(78, 24)',
 'self.back:SetPoint("TOPLEFT", frame, "TOPLEFT", 21, -12)',
 'self.back:SetShown(self.canBack == true)',
 'self.back:SetScript("OnEnter", function()',
 'self.back:SetScript("OnLeave", function()',
 'backRule:SetPoint("BOTTOMLEFT", self.back, "BOTTOMLEFT", 5, 0)',
 'backRule:SetPoint("BOTTOMRIGHT", self.back, "BOTTOMRIGHT", -5, 0)',
 'self.previous = navigation("< Previous", -170',
 'self.next = navigation("Next >", 170',
 'local NAV_TOP = 423',
 'local PAGER_TOP = 391',
 'local PANEL_HEIGHT = 467',
 'slot:SetPoint("TOPLEFT", frame, "TOPLEFT",',
):req(fragment in V,'view required '+fragment)
req(V.count('self.back:SetPoint("TOPLEFT", frame, "TOPLEFT", 21, -12)')==1,
    'exactly one header Back anchor')
# The former bottom-center Back sat on top of the NarrativePages central 1 / N
# indicator. The new Back and Goodbye are mutually non-overlapping, each at
# its own header edge (640px-wide panel, both 78px-wide, 21px inset).
width=640;size=78;inset=21
req((inset+size) < (width-size-inset), 'header buttons collide')
req('goodbyeButton:SetSize(78, 24)' in D and
    'goodbyeButton:SetPoint("TOPRIGHT", root, "TOPRIGHT", -21, -12)' in D,
    'universal Goodbye remains at matching right-header anchor')
req('Logres.NPCNarrativePages.Paint(' in D and
    'function Dialogue:UpdatePageControls()' in D,
    'narrative paginator remains native shared painter')
for fragment in (
 'local function entry(label, nextNode, enabled, reason, action)',
 'entry("Farewell", nil, true, nil, "goodbye")',
 'entry("Leave the watch", nil, true, nil, "goodbye")',
 'enabled = enabled ~= false',
 'function Model.FromValidated(title, start, nodes)',
):req(fragment in M,'authored model '+fragment)
req('farewell = { title = "Safe Travels"' not in M,
    'obsolete Farewell response forces a second click')
req('["end"] = { title = "Watch Post"' not in M,
    'obsolete watch-leave response forces a second click')
for fragment in (
 'if choice.action == "goodbye" then',
 'self.clicks = self.clicks + 1',
 'return self.dialogue:Goodbye()',
 'function Session:Goodbye()',
 'self.dialogue:HidePresentation("goodbye")',
 'self.lastResult = "goodbye"',
 'function Session:Back()',
 'self.rootReturns = self.rootReturns + 1',
 'nativeActions = 0',
):req(fragment in S,'session exit and history '+fragment)
req(S.index('if choice.action == "goodbye" then') < S.index('if type(choice.nextNode) ~= "string"'),
    'Farewell must be dispatched before nextNode validation')
for fragment in ('function Dialogue:Goodbye()',
                 'self.optionSession:Goodbye()',
                 'self:HidePresentation("goodbye")',
                 'self:RequestStockOfferSuppression(',
                 'self.completionControl:Restore(reason or "hide-presentation")'):
 req(fragment in D,'unchanged native restoring Goodbye '+fragment)
for source,name in ((V,'view'),(M,'model'),(S,'session')):
 for forbidden in ('C_GossipInfo.Select','SelectGossipOption(',
                   'AcceptQuest(', 'DeclineQuest(', 'GetQuestReward(',
                   'CompleteQuest(', 'QuestRewardCompleteButton_OnClick',
                   'HideUIPanel(', 'InCombatLockdown(', 'SetScript("OnUpdate"',
                   'DynamicCam', 'RegisterEvent('):
  req(forbidden not in source,name+' may not mutate protected/native state: '+forbidden)
for fragment in ('UI\\NarrativePages.lua\nUI\\DecisionVisual.lua\nQuest\\ContextVisual.lua',
                 'Quest\\NarrativeModel.lua\nQuest\\RewardModel.lua\nQuest\\RewardVisual.lua\nQuest\\Dialogue.lua'):
 req(fragment in T,'legacy TOC adjacency '+fragment)
t=re.search(r'^## Version: (\d+\.\d+\.\d+-dev)$',T,re.M)
b=re.search(r'^Logres\.VERSION = "(\d+\.\d+\.\d+-dev)"$',B,re.M)
req(bool(t and b and t.group(1)==b.group(1)),'TOC/Bootstrap version parity')
print('P0267 fixed NPC header Back/Goodbye and one-step semantic exit')
print('==========================================================')
for issue in E:print('ERROR:',issue)
if E:raise SystemExit(1)
print('PASS: static geometry, action dispatch, native safety and regression contract')
