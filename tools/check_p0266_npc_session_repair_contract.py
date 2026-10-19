#!/usr/bin/env python3
"""P0266 combined user-reported runtime defect regression and stock safety."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
D=read('Logres/Quest/Dialogue.lua')
V=read('Logres/UI/OptionList.lua')
S=read('Logres/Quest/OptionSession.lua')
M=read('Logres/Quest/OptionModel.lua')
C=read('Logres/Core/Commands.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
E=[]
def require(v,label):
 if not v:E.append(label)
# Precise geometry: the third option row must clear pager and pager/nav
# cannot overlap; nav still ends inside the original 467-high option frame.
for pattern in ('local ROW_TOP = 233','local ROW_PITCH = 43',
                'local SLOT_HEIGHT = 34','local PAGER_TOP = 391',
                'local NAV_TOP = 423','local PANEL_HEIGHT = 467',
                'ROW_TOP + 2 * ROW_PITCH + SLOT_HEIGHT + 24 <= PAGER_TOP',
                'PAGER_TOP + 24 <= NAV_TOP',
                'NAV_TOP + 28 + 12 <= PANEL_HEIGHT'):
 require(pattern in V,'geometry invariant missing '+pattern)
values={}
for k in ('ROW_TOP','ROW_PITCH','SLOT_HEIGHT','PAGER_TOP','NAV_TOP','PANEL_HEIGHT'):
 match=re.search(r'(?m)^local '+k+r' = (\d+)$',V)
 require(match is not None,'missing coordinate '+k)
 if match:values[k]=int(match.group(1))
if len(values)==6:
 row=values['ROW_TOP']+2*values['ROW_PITCH']+values['SLOT_HEIGHT']
 require(values['PAGER_TOP']-row>=24,'third row touches pager')
 require(values['NAV_TOP']-values['PAGER_TOP']>=24,'pager touches nav')
 require(values['PANEL_HEIGHT']-(values['NAV_TOP']+28)>=12,'nav clips frame bottom')
for token in ('function Visual:SetPageVisible(show)',
              'local showChoices = show == true',
              'slot:SetShown(visible)',
              'slot:EnableMouse(visible and slot.optionEnabled == true)',
              'self.back:SetShown(self.canBack == true)',
              'self.frame:Show()',
              'self.canBack = canBack == true',
              'self.totalPages = total'):
 require(token in V,'preserve Back and isolate narrative choices: '+token)
require('self.frame:SetShown(show == true)' not in V,
        'BUG: hiding whole option frame also hides Back on long narratives')
for token in ('rootReturns = 0','goodbyes = 0','function Session:Back()',
              'table.remove(self.history)',
              'if self.nodeKey == self.model.start then',
              'self.rootReturns = self.rootReturns + 1',
              'function Session:Goodbye()',
              'self.dialogue:HidePresentation("goodbye")',
              'self.lastResult = "goodbye"',
              'nativeActions = 0'):
 require(token in S,'session navigation/exit ownership '+token)
for token in ('function Dialogue:Goodbye()',
              'self.goodbyeClicks = self.goodbyeClicks + 1',
              'self.optionSession:Goodbye()',
              'self:HidePresentation("goodbye")',
              'goodbyeButton:SetPoint("TOPRIGHT", root, "TOPRIGHT", -21, -12)',
              'goodbyeText:SetText("Goodbye")',
              'goodbyeButton:SetScript("OnClick", function()',
              'self:Goodbye()',
              'goodbyeClicks = self.goodbyeClicks,',
              'function Dialogue:ShowRewardPreview(mode)',
              'function Dialogue:ShowOptionPreview(mode)',
              'self.rewardVisual:Present(model.cards, model.footer)',
              'self:RequestStockOfferSuppression('):
 require(token in D,'shared dialogue exit/regression '+token)
require(D.count('goodbyeButton:SetScript("OnClick", function()')==1,
        'universal shared dialogue Goodbye must have precisely one handler')
# Audit + user-accessible dismissal without new phase actions or root mutation.
for token in ('Logres questdialogue goodbye: AUDIT (clicks=%s)',
              '"npcgoodbye"',
              'dialogue:Goodbye()',
              'Logres npcgoodbye: %s (state=%s)',
              'Logres questdialogue npcoptions: AUDIT ('):
 require(token in C,'goodbye command/audit '+token)
require('function Model.Preview(mode)' in M and 'function Model.FromValidated(' in M,
        'retain source-independent authored option models')
for source,name in ((S,'session'),(V,'view'),(M,'model')):
 for forbidden in ('AcceptQuest(', 'DeclineQuest(', 'GetQuestReward(',
  'CompleteQuest(', 'QuestRewardCompleteButton_OnClick',
  'C_GossipInfo.Select', 'GossipOptionOnClick(',
  'InCombatLockdown(', 'HideUIPanel(', 'SetScript("OnUpdate"',
  'C_Timer.', 'DynamicCam', 'RegisterEvent('):
  require(forbidden not in source,name+' must not own native/game/camera '+forbidden)
for p in ('Logres/Camera/WorldCombat.lua','Logres/Camera/ProfileContexts.lua',
          'Logres/Quest/CompletionControl.lua','Logres/UI/DecisionVisual.lua'):
 require((R/p).is_file(),'frozen module missing '+p)
require('UI\\NarrativePages.lua\nUI\\DecisionVisual.lua\nQuest\\ContextVisual.lua' in T,
        'preserve historical P0263 TOC adjacency')
require('Quest\\NarrativeModel.lua\nQuest\\RewardModel.lua\nQuest\\RewardVisual.lua\nQuest\\Dialogue.lua' in T,
        'preserve legacy quest model load order')
t=re.search(r'^## Version: (\S+)$',T,re.M)
b=re.search(r'^Logres\.VERSION = "([^"]+)"$',B,re.M)
require(bool(t and b and t.group(1)==b.group(1) and re.fullmatch(r'\d+\.\d+\.\d+-dev',t.group(1))),
        'TOC/Bootstrap parity without historical pins')
print('P0266 NPC option layout, root Back, shared Goodbye and stock ownership contract')
print('==========================================================================')
for e in E:print('ERROR:',e)
if E:raise SystemExit(1)
print('PASS: 0 static errors; client-specific behavior remains pending')
