#!/usr/bin/env python3
"""P0243: verified ordinary text rewards; no Logres claim or stock removal."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
d=(R/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(R/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
e=[]
a=d.find('local function ordinaryRewardNumber(')
b=d.find('function Dialogue:UpdatePageControls()',a)
s=d[a:b] if a>=0 and b>a else ''
for q in ('function Dialogue:ReadCompletionRewardSummary()',
'pcall(GetQuestItemInfo, "reward", 1)',
'isSecret(name) and not isSecret(quantity)',
'ordinaryRewardNumber("reward-choices", GetNumQuestChoices)',
'ordinaryRewardNumber("reward-count", GetNumQuestRewards)',
'ordinaryRewardNumber("reward-xp", GetRewardXP)',
'"Review rewards in Blizzard quest window"',
'"\\nComplete using Blizzard quest controls"',
'self:ReadCompletionRewardSummary()',
'completion.title, completion.body, rewardSummary, "QUEST_COMPLETE"',
'false, false, false'):
    if q not in s:e.append('missing reward scope '+q)
for q in ('GetQuestReward(', 'pcall(GetQuestReward', 'CompleteQuest(',
          'pcall(CompleteQuest', 'HideUIPanel(', 'QuestFrame:Hide',
          'SetScript("OnUpdate"'):
    if q in s:e.append('forbidden action in reward scope: '+q)
for q in ('self.objectiveHeader:SetText("REWARDS")',
          'self.objectiveHeader:SetText("OBJECTIVE")',
          'lastCompletionRewardReason = self.lastCompletionRewardReason',
          'lastCompletionRewardIdentified = self.lastCompletionRewardIdentified == true'):
    if q not in d:e.append('missing render/diagnostic '+q)
if 'Logres questdialogue rewards: CANDIDATE' not in c:e.append('missing diagnostic')
legacy=(R/'tools/check_p0242_quest_completion_contract.py').read_text(encoding='utf-8')
for q in ('original not in s:', 'function Dialogue:ReadCompletionRewardSummary()',
          'completion.title, completion.body, rewardSummary, "QUEST_COMPLETE",',
          'forbidden completion action'):
    if q not in legacy:e.append('missing P0242 backward-compatible gate '+q)
print('Logres P0243 reward summary contract')
print('==================================')
if e:
    for x in e:print('ERROR:',x)
    raise SystemExit(1)
print('PASS: 0 errors')
