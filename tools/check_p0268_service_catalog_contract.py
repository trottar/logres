#!/usr/bin/env python3
"""P0268: four shared service fixtures, preview-only confirmation and header clearance."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
M=read('Logres/Quest/ServiceCatalogModel.lua')
S=read('Logres/Quest/OptionSession.lua')
V=read('Logres/UI/OptionList.lua')
D=read('Logres/Quest/Dialogue.lua')
C=read('Logres/Core/Commands.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
P=read('tools/check_p0256_preview_hub_contract.py')
N=read('tools/check_p0261_n1_narrative_contract.py')
P66=read('tools/check_p0266_npc_session_repair_contract.py')
P67=read('tools/check_p0267_npc_navigation_exit_contract.py')
e=[]
def req(ok,why):
 if not ok:e.append(why)
for token in ('Logres.NPCServiceCatalogModel = Model',
              'local function catalog(family, title, description, rows)',
              'previewOnly = true','family = family',
              'function Model.Preview(mode)',
              '"merchant"','"trainer"','"flight"','"unavailable"',
              'Requires reputation','Sold out','Requires level 20',
              'Flight point undiscovered','Route not connected',
              'Review preview confirmation','Confirm preview (no transaction)',
              '"preview-confirm"','"goodbye"','unknown-service-catalog-preview'):
 req(token in M,'service fixture model missing '+token)
req(M.count('entry("Confirm preview (no transaction)", result,')==1,
    'one shared quote confirmation builder required')
req('CreateFrame(' not in M and 'SetScript(' not in M,
    'model must remain source-independent without its own view')
for forbidden in ('AcceptQuest(', 'DeclineQuest(', 'GetQuestReward(',
  'CompleteQuest(', 'C_GossipInfo.', 'SelectGossipOption(', 'GossipOptionOnClick(',
  'BuyMerchantItem(', 'RepairAllItems(', 'BuyTrainerService(',
  'TakeTaxiNode(', 'C_TaxiMap.', 'InCombatLockdown(',
  'C_Timer.', 'DynamicCam','RegisterEvent(', 'UnitExists('):
 for source,name in ((M,'model'),(S,'session')):
  req(forbidden not in source,name+' must not use native/camera action '+forbidden)
for token in ('self.model.family','choice.action == "preview-confirm"',
  'self.previewConfirmCount = self.previewConfirmCount + 1',
  'previewConfirmCount = self.previewConfirmCount',
  'nativeActions = 0','self.model.nodes[choice.nextNode]',
  'function Session:Back()', 'function Session:Goodbye()'):
 req(token in S,'shared gated controller missing '+token)
req(S.index('choice.action == "preview-confirm"') < S.index('self.previewConfirmCount = self.previewConfirmCount + 1'),
 'confirmation must be handled explicitly by session')
req('Logres.NPCServiceCatalogModel.Preview(mode)' in D and
    'Logres.NPCOptionModel.Preview(mode)' in D and
    'self.optionSession:Start(mode, model)' in D,
    'both fixture families must share same existing renderer/session')
for token in ('Quest\\ServiceCatalogModel.lua','Quest\\OptionSession.lua','Quest\\Dialogue.lua'):
 req(token in T,'TOC missing '+token)
req(T.index('Quest\\ServiceCatalogModel.lua') < T.index('Quest\\OptionSession.lua') < T.index('Quest\\Dialogue.lua'),
    'service fixture must load before session and dialogue')
for mode in ('merchant','trainer','flight','unavailable'):
 req('"npcoptionpreview '+mode+'"' in C,'P entry missing '+mode)
 req('argument == "'+mode+'"' in C,'slash routing missing '+mode)
req('npcservice: AUDIT' in C and 'previewConfirmCount' in C,
    'F diagnostics must expose preview confirmation count')
req('len(required) != 38' in P and 'len(actions) != 106' in P and
    'len(required) != 38' in N and 'len(actions) != 106' in N,
    'P gallery and historical inventory checker not updated together')
req('self.back:SetPoint("TOPLEFT", frame, "TOPLEFT", 45, -12)' in V,
    'Back must clear ornate corner at left')
req('goodbyeButton:SetPoint("TOPRIGHT", root, "TOPRIGHT", -45, -12)' in D,
    'Goodbye must clear ornate corner at right')
req('self.back:SetPoint("TOPLEFT", frame, "TOPLEFT", 45, -12)' in P67 and
    'inset=45' in P67 and
    'goodbyeButton:SetPoint("TOPRIGHT", root, "TOPRIGHT", -45, -12)' in P67 and
    'goodbyeButton:SetPoint("TOPRIGHT", root, "TOPRIGHT", -45, -12)' in P66,
    'old layout checkers must enforce updated matching header insets')
req(45+78 < 640-78-45, 'header click regions must be disjoint')
req('UI\\NarrativePages.lua\nUI\\DecisionVisual.lua\nQuest\\ContextVisual.lua' in T,
    'historical N3 TOC adjacency')
req('Quest\\NarrativeModel.lua\nQuest\\RewardModel.lua\nQuest\\RewardVisual.lua\nQuest\\Dialogue.lua' in T,
    'historical quest TOC adjacency')
t=re.search(r'^## Version: (\S+)$',T,re.M)
b=re.search(r'^Logres\.VERSION = "([^"]+)"$',B,re.M)
req(bool(t and b and t.group(1)==b.group(1) and
    re.fullmatch(r'\d+\.\d+\.\d+-dev',t.group(1))),
    'runtime TOC and Bootstrap parity')
print('P0268 catalogue reuse, previews, quote confirmation and ornate header clearance')
print('=============================================================================')
for issue in e: print('ERROR:',issue)
if e:raise SystemExit(1)
print('PASS: 0 errors (STATIC, WoW visual/interaction tests required)')
