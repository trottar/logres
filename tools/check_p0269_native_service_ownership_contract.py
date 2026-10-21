#!/usr/bin/env python3
"""P0269: enforce D-047 native NPC service ownership, not replacement catalogs."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
get=lambda f:(R/f).read_text(encoding='utf-8')
p=get('Logres/Quest/NativeServicePolicy.lua')
c=get('Logres/Core/Commands.lua')
s=get('Logres/Quest/OptionSession.lua')
d=get('Logres/Quest/Dialogue.lua')
t=get('Logres/Logres.toc')
b=get('Logres/Core/Bootstrap.lua')
h=get('tools/check_p0256_preview_hub_contract.py')
n=get('tools/check_p0261_n1_narrative_contract.py')
e=[]
def need(ok,message):
    if not ok: e.append(message)
for term in ('Logres.NPCNativeServicePolicy = Policy','function Policy.GetAudit()',
    'function Policy.GetFamilies()','source = "addon-owned-state"',
    'nativeTransactions = "Blizzard-owned"','visualIntegration = "deferred-capability-proof"',
    'serviceIdentity = "not-observed"','mutationCalls = 0','Logres:GetState()',
    '"merchant"','"repairs"','"sell-junk"','"trainer"','"flight"','"bank"','"auction"'):
    need(term in p,'native service policy: '+term)
for forbidden in ('CreateFrame(', 'SetPoint(', 'ClearAllPoints(', 'SetParent(',
  'HideUIPanel(', 'ShowUIPanel(', 'RegisterEvent(', 'SetScript(',
  'C_GossipInfo.', 'BuyMerchantItem(', 'SellCursorItem(', 'RepairAllItems(',
  'BuyTrainerService(', 'TakeTaxiNode(', 'GetMerchantItemInfo(',
  'GetRepairAllCost(', 'GetContainerItemInfo(', 'UnitExists(',
  'issecretvalue(', 'DynamicCam', 'GetPoint(', 'IsShown('):
    need(forbidden not in p,'policy must not access native frame or transaction: '+forbidden)
need('Quest\\NativeServicePolicy.lua' in t,'TOC native policy')
need('Quest\\ServiceCatalogModel.lua' not in t,'retired catalogue must not load')
need(not (R/'Logres/Quest/ServiceCatalogModel.lua').exists(),'remove obsolete service catalogue runtime file')
need('Logres.NPCServiceCatalogModel' not in d,'dialogue must not route service catalogue')
need('choice.action == "preview-confirm"' not in s,'session must not simulate service confirmation')
need('previewConfirmCount' not in s,'remove obsolete purchase/training confirmation counter')
need('npcservice: AUDIT' not in c,'remove obsolete simulation audit')
for mode in ('merchant','trainer','flight','unavailable'):
    need('"npcCatalog'+mode.title()+'"' not in c,'no synthetic service preview registration: '+mode)
    need('"npcoptionpreview '+mode+'"' not in c,'no synthetic service command: '+mode)
need('"nativeservicepolicycheck"' in c,'native policy command')
need('"nativeServicePolicyCheck"' in c and '"Native NPC Services Check"' in c,
     'H-tab native ownership diagnostic')
need('len(required) != 35' in h and 'len(actions) < 108' in h,
    'exact P/total inventory after removing 4 demos and adding H check')
need('len(required) != 35' in n and 'len(actions) < 108' in n,
    'N1 historical preview inventory updated')
need('self.back:SetPoint("TOPLEFT", frame, "TOPLEFT", 45, -12)' in get('Logres/UI/OptionList.lua'),
    'accepted Back art inset retained')
need('goodbyeButton:SetPoint("TOPRIGHT", root, "TOPRIGHT", -45, -12)' in d,
    'accepted Goodbye art inset retained')
toc=re.search(r'^## Version: (\d+\.\d+\.\d+-dev)$',t,re.M)
boot=re.search(r'^Logres\.VERSION = "(\d+\.\d+\.\d+-dev)"$',b,re.M)
need(bool(toc and boot and toc.group(1)==boot.group(1)),'TOC Bootstrap version parity')
for frozen in ('Logres/Camera/ProfileContexts.lua','Logres/Camera/WorldCombat.lua',
    'Logres/Quest/CompletionControl.lua','Logres/Quest/OfferStockSuppression.lua'):
    need((R/frozen).is_file(),'frozen source exists '+frozen)
print('P0269 D-047 native-service ownership restoration')
for message in e: print('ERROR:',message)
if e: raise SystemExit(1)
print('PASS: native service ownership, retired synthetic catalogs, retained quest/option UI')
