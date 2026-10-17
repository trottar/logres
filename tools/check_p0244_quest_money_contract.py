#!/usr/bin/env python3
"""P0244: addon-owned quest money from ordinary quest-log API; no claim mutation."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(r/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
errors=[]
start=d.find('local function ordinaryRewardNumber(label, fn, ...)')
end=d.find('function Dialogue:HandleQuestComplete()',start)
s=d[start:end] if start>=0 and end>start else ''
for x in (
    'pcall(fn, ...)',
    'if isSecret(value) then return nil, label .. "-secret" end',
    'if type(value) ~= "number" or value ~= value or value == math.huge',
    'ordinaryRewardNumber("reward-xp", GetRewardXP)',
    'ordinaryRewardNumber("reward-choices", GetNumQuestChoices)',
    'ordinaryRewardNumber("reward-count", GetNumQuestRewards)',
    '"reward-money", GetQuestLogRewardMoney, self.lastQuestID',
    'if money ~= nil and money > 0 then',
    'local gold = math.floor(money / 10000)',
    'local silver = math.floor((money % 10000) / 100)',
    'local copper = money % 100',
    'label = label .. " | " .. table.concat(amounts, " ")',
    '"\\nComplete using Blizzard quest controls"',
):
    if x not in s: errors.append('missing guarded money path '+x)
for x in (
    'GetQuestReward(', 'CompleteQuest(', 'C_GossipInfo.Select',
    'QuestFrame:Hide', 'HideUIPanel(', 'SetScript("OnUpdate"',
):
    if x in s: errors.append('forbidden quest mutation/polling '+x)
for x in ('self.lastCompletionRewardMoney = rewardMoney',
          'lastCompletionRewardMoney = self.lastCompletionRewardMoney',
          'lastCompletionRewardMoneyReason = self.lastCompletionRewardMoneyReason',
          '"Logres questdialogue rewards: CANDIDATE (source=%s itemIdentified=%s moneyCopper=%s moneySource=%s stock=retained claim=Blizzard)"',
          'tostring(debugStatus.lastCompletionRewardMoney)',
          'tostring(debugStatus.lastCompletionRewardMoneyReason)'):
    if x not in (c if x.startswith('"Logres') or x.startswith('tostring(') else d):errors.append('missing money diagnostic '+x)
if 'GetQuestMoneyToGet' in s:errors.append('money required to hand in is not a reward')
print('Logres P0244 quest payout money contract')
print('========================================')
if errors:
    for e in errors:print('ERROR:',e)
    raise SystemExit(1)
print('PASS: 0 errors')
