#!/usr/bin/env python3
"""P0246: event-driven, active-completion-only ordinary item resolution."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(r/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
a=d.find('function Dialogue:ReadCompletionRewardSummary()')
b=d.find('function Dialogue:UpdatePageControls()',a)
s=d[a:b] if a>=0 and b>a else ''
errors=[]
for v in (
    'if self.eventRegistration.GET_ITEM_INFO_RECEIVED == true',
    'or self.eventRegistration.ITEM_DATA_LOAD_RESULT == true',
    'self.pendingCompletionItem = {',
    'itemID = itemID,', 'quantity = math.floor(quantity)',
    'pending.generation = self.presentationGeneration',
    'pending.questID = completion.questID',
    'C_Item.RequestLoadItemDataByID, pending.itemID',
    'function Dialogue:HandleCompletionItemData(eventItemID, success)',
    'if isSecret(eventItemID) or isSecret(success) then',
    'eventItemID ~= pending.itemID',
    'self.presentationGeneration ~= pending.generation',
    'self.lastQuestID ~= pending.questID',
    'local ok, name = pcall(GetItemInfo, pending.itemID)',
    'if not ok or isSecret(name) then',
    'self.objectiveText:SetText(',
    'self.lastCompletionRewardReason = "guaranteed-item-event"',
):
    if v not in s: errors.append('missing bounded asynchronous gate '+v)
for v in (
    '"GET_ITEM_INFO_RECEIVED",', '"ITEM_DATA_LOAD_RESULT",',
    'function(_, event, ...)',
    'self:HandleCompletionItemData(select(1, ...), select(2, ...))',
    'self.pendingCompletionItem = nil',
    'lastCompletionItemCacheState = self.lastCompletionItemCacheState',
):
    if v not in d:errors.append('missing event/cleanup/diagnostic '+v)
if 'Logres questdialogue itemcache: CANDIDATE' not in c:
    errors.append('missing developer-panel cache diagnostic')
for v in ('GetQuestReward(', 'CompleteQuest(', 'C_GossipInfo.Select',
          'QuestFrame:Hide', 'HideUIPanel(', 'SetScript("OnUpdate"',
          'C_Timer.After('):
    if v in s:errors.append('forbidden mutation/polling in item event scope '+v)
print('Logres P0246 bounded event-driven quest reward cache contract')
print('==========================================================')
if errors:
    for e in errors: print('ERROR:',e)
    raise SystemExit(1)
print('PASS: 0 errors')
