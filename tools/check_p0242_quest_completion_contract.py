#!/usr/bin/env python3
"""P0242 additive quest completion text, without reward action ownership."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
d=(R/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(R/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
p=(R/'Logres/Quest/InteractionProbe.lua').read_text(encoding='utf-8')
errors=[]
def need(s,part):
    if part not in s:errors.append('missing '+part)
a=d.index('function Dialogue:ReadCompletion()') if 'function Dialogue:ReadCompletion()' in d else -1
b=d.index('function Dialogue:UpdatePageControls()',a) if a>=0 else -1
s=d[a:b] if a>=0 and b>a else ''
for frag in ('function Dialogue:ReadCompletion()', 'function Dialogue:HandleQuestComplete()',
             'readQuestID()', 'readString("completion-title", GetTitleText)',
             'readString("completion-text", GetRewardText)', 'if body == "" then',
             'self:ClearActiveDetail("QUEST_COMPLETE")', 'self:PresentText(',
             'false, false, false', 'self.completionActive = true'):
    need(s,frag)
# P0243 extends the narrative argument with a source-gated read-only footer.
# Keep the P0242 legacy narrative-only path valid and explicitly gate the new
# form on a bounded reward-source helper and the same stock-preserving flags.
original='completion.title, completion.body, "", "QUEST_COMPLETE",'
rewarded='completion.title, completion.body, rewardSummary, "QUEST_COMPLETE",'
if original not in s:
    for frag in ('function Dialogue:ReadCompletionRewardSummary()',
                 'self:ReadCompletionRewardSummary()', rewarded,
                 'false, false, false'):
        need(s,frag)
for frag in ('self.completionActive = false',
             'if self.progressActive or self.completionActive then',
             'self:HandleQuestComplete()', 'self.lastCompletionSecret',
             'completionSkippedCount = self.completionSkippedCount',
             'completionShownCount = self.completionShownCount',
             'self.completionActive = false', '"QUEST_PROGRESS"', '"QUEST_COMPLETE"'):
    need(d,frag)
for frag in ('"Logres questdialogue completion: %s', 'stock=retained rewards=Blizzard actions=none',
             'debugStatus.completionShownCount', 'debugStatus.completeRegistered'):
    need(c,frag)
for frag in ('"QUEST_COMPLETE"', 'function Probe:CaptureSnapshot(reason)'):
    need(p,frag)
for frag in ('CompleteQuest(', 'GetQuestReward(', 'C_GossipInfo.Select',
             'C_Timer.After(', 'SetScript("OnUpdate"', 'HideUIPanel(', 'QuestFrame:Hide'):
    if frag in s:errors.append('forbidden completion action '+frag)
if 'SetScript("OnUpdate"' in d:errors.append('no polling in dialogue')
if 'pcall(GetQuestReward)' in d or 'pcall(CompleteQuest)' in d:
    errors.append('no quest mutations in dialogue')
print('Logres P0242 additive completion narrative contract')
print('=================================================')
if errors:
    for e in errors:print('ERROR:',e)
    raise SystemExit(1)
print('PASS: 0 errors')
