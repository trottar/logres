#!/usr/bin/env python3
"""P0270: read-only, on-demand Blizzard service frame capability audit."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
source=lambda p:(R/p).read_text(encoding='utf-8')
p=source('Logres/Quest/NativeServiceCapabilities.lua')
a=source('Logres/Quest/NativeServicePolicy.lua')
c=source('Logres/Core/Commands.lua')
t=source('Logres/Logres.toc')
b=source('Logres/Core/Bootstrap.lua')
e=[]
def need(ok,why):
 if not ok:e.append(why)
for token in ('Logres.NPCNativeServiceCapabilities = Probe', 'function Probe.Read()',
 'source = "on-demand-native-metadata"','Logres:GetState()',
 'pcall(issecretvalue, value)','safeMethod(frame, "GetPoint")',
 'safeMethod(frame, "SetPoint")','safeMethod(frame, "IsProtected")',
 'placementAuthorization = "none"','stylingAuthorization = "none"',
 'serviceIdentity = "unverified"','mutationCalls = 0',
 'deferred-combat-or-api','method-present'):
 need(token in p,'missing evidence boundary '+token)
for key in ('GossipFrame','MerchantFrame','ClassTrainerFrame','FlightMapFrame',
 'BankFrame','AuctionHouseFrame','PetStableFrame','TabardFrame'):
 need(('"'+key+'"') in p,'candidate frame missing '+key)
for forbidden in ('CreateFrame(', 'SetPoint(', 'GetPoint(', 'SetParent(',
 'RegisterEvent(', 'HookScript(', 'SetScript(', 'SetAlpha(', 'Show(', 'Hide(',
 'GetWidth(', 'GetHeight(', 'IsShown(', 'GetNumChildren(', 'GetChildren(',
 'GetMerchantItemInfo(', 'GetTrainerServiceInfo(', 'UnitExists(',
 'BuyMerchantItem(', 'RepairAllItems(', 'SellCursorItem(', 'TakeTaxiNode(',
 'C_GossipInfo.', 'C_Timer.', 'DynamicCam'):
 need(forbidden not in p,'prohibited native mutation/presentation operation: '+forbidden)
need('Quest\\NativeServiceCapabilities.lua' in t,'TOC audit module')
need(t.index('Quest\\NativeServiceCapabilities.lua') < t.index('Quest\\NativeServicePolicy.lua'),
 'module must precede policy')
need('if command == "nativeframeaudit" then' in c, 'slash read-only probe')
need('"nativeServiceFrameAudit"' in c and '"Native Service Frame Audit"' in c,
 'H panel read-only probe')
need('nativeservicepolicycheck' in c and 'Logres.NPCNativeServicePolicy.GetAudit()' in c,
 'prior P0269 policy retained')
need('nativeTransactions = "Blizzard-owned"' in a,'Blizzard owns all transactions')
# P0270 adds one H diagnostic; synchronize all three historical gallery checkers.
preview_check=source('tools/check_p0256_preview_hub_contract.py')
narrative_check=source('tools/check_p0261_n1_narrative_contract.py')
service_check=source('tools/check_p0269_native_service_ownership_contract.py')
need('if len(actions) != 104:' in preview_check, 'P0256 action inventory must be 104')
need("'len(actions) != 104' in p" in narrative_check, 'P0261 historical count must be 104')
need("'len(actions) != 104' in h" in service_check and
     "'len(actions) != 104' in n" in service_check,
     'P0269 historical native ownership count must be 104')
need('if len(required) != 34:' in preview_check, 'P gallery must remain at 34 actions')
need('Logres.NPCServiceCatalogModel' not in c,'do not revive catalog model')
need('Quest\\ServiceCatalogModel.lua' not in t,'do not revive catalog TOC')
need('Logres/Quest/ServiceCatalogModel.lua' not in [str(x.relative_to(R)) for x in (R/'Logres/Quest').glob('ServiceCatalogModel.lua')],
 'do not revive catalog runtime file')
versions=[re.search(r'^## Version: (\d+\.\d+\.\d+-dev)$',t,re.M),
 re.search(r'^Logres\.VERSION = "(\d+\.\d+\.\d+-dev)"$',b,re.M)]
need(bool(all(versions) and versions[0].group(1)==versions[1].group(1)),
 'Bootstrap / TOC version parity')
print('P0270 native frame metadata audit (on demand; no styling permission)')
for error in e:print('ERROR:',error)
if e:raise SystemExit(1)
print('PASS: 0 errors (STATIC; WoW/client service capabilities still unverified)')
