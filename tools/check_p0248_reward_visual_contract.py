#!/usr/bin/env python3
"""P0248: dynamic, secret-safe quest reward portraits; read-only stock fallback."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
v=(r/'Logres/Quest/RewardVisual.lua').read_text(encoding='utf-8')
c=(r/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
t=(r/'Logres/Logres.toc').read_text(encoding='utf-8')
b=(r/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
e=[]
for token in (
    'MAX_REWARD_CARDS = 6',
    'local function completionRewardCard(kind, name, icon, quantity, itemID)',
    'if isSecret(name) or isSecret(quantity) then return nil end',
    'if not isSecret(icon) and type(icon) == "number"',
    'elseif not isSecret(icon) and type(icon) == "string"',
    'elseif not isSecret(itemID) and type(itemID) == "number"',
    'pcall(GetItemIcon, itemID)',
    'local function readCompletionRewardCard(kind, index)',
    'pcall(GetQuestItemInfo, kind, index)',
    'local ok, name, texture, quantity, _, _, itemID =',
    'pcall(GetQuestItemInfo, "reward", 1)',
    'for i = 1, math.min(rewards, MAX_REWARD_CARDS) do',
    'for i = 1, math.min(choices, MAX_REWARD_CARDS - reads) do',
    'self.completionRewardOverflow = rewards + choices > MAX_REWARD_CARDS',
    'self.rewardVisual:Present(self.completionRewardCards, rewardFooter)',
    'completionRewardCards = #self.completionRewardCards',
    'function Dialogue:ShowRewardPreview(mode)',
    'function Dialogue:HandleCompletionItemData(eventItemID, success)',
    'self.rewardVisual = Logres.QuestRewardVisual.New(root, objectiveText)',
    'if self.rewardVisual then self.rewardVisual:Reset() end',
):
    if token not in d:e.append('missing guarded reward integration: '+token)
for token in (
    'Logres.QuestRewardVisual = Visual', 'function Visual.New(root, objectiveText)',
    'local MAX_CARDS = 6', 'function Visual:Reset()',
    'function Visual:Present(cards, footer)',
    'slot.icon:SetTexture(card.icon)',
    'slot.label:SetText((card.kind == "choice"',
    'slot.count:SetText(card.quantity > 1',
    'self.root:SetHeight(349 + rows * SLOT_PITCH)',
    'slot:EnableMouse(false)',
):
    if token not in v:e.append('missing portrait visual: '+token)
for token in ('"questrewardpreview single"','"questrewardpreview multi"',
              'if command == "questrewardpreview" then',
              'Logres questdialogue rewardvisual: CANDIDATE'):
    if token not in c:e.append('missing diagnostic/preview: '+token)
if 'Quest\\RewardVisual.lua\nQuest\\Dialogue.lua' not in t:
    e.append('reward visual must load before dialogue')
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'HideUIPanel(',
    'C_GossipInfo.Select', 'SetScript("OnUpdate"',
    'RegisterStateDriver', 'SecureActionButtonTemplate'):
    if forbidden in v:e.append('reward visual must be noninteractive: '+forbidden)
s=d[d.find('local function completionRewardCard('):d.find('function Dialogue:UpdatePageControls()')]
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'HideUIPanel(',
    'C_GossipInfo.Select', 'SetScript("OnUpdate"'):
    if forbidden in s:e.append('reward read must not mutate or poll: '+forbidden)
if s.count('pcall(GetQuestItemInfo, "reward", 1)') != 1:
    e.append('single-item source read altered')
if s.count('pcall(GetItemInfo, itemID)') != 1:
    e.append('single-item name-cache read altered')
tv=re.findall(r'(?m)^## Version: (0\.0\.\d+-dev)$',t)
bv=re.findall(r'(?m)^Logres\.VERSION = "(0\.0\.\d+-dev)"$',b)
if len(tv)!=1 or len(bv)!=1 or tv[0]!=bv[0]:
    e.append('Bootstrap/TOC version mismatch')
print('Logres P0248 dynamic read-only quest reward cards')
print('================================================')
if v.count('slot:SetScript("OnClick", function(button)') != 1 or 'slot:EnableMouse(interactive)' not in v or 'self.previewChoiceHandler and button.choiceIndex' not in v:
    e.append('interactive card must be preview-gated with owner callback')
if e:
    for x in e:print('ERROR:', x)
    raise SystemExit(1)
print('PASS: 0 errors')
