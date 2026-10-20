#!/usr/bin/env python3
"""P0275: exact quest art behind native merchant/trainer with zero native mutation."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
a=read('Logres/Quest/NativeServiceAccent.lua')
p=read('Logres/Quest/NativeServicePlacementTrial.lua')
t=read('Logres/Media/Theme.lua')
c=read('Logres/Core/Commands.lua')
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')
old=read('tools/check_p0274_native_service_accent_contract.py')
errors=[]
def need(ok, label):
    if not ok:errors.append(label)
for token in ('Logres.NPCNativeServiceAccent = Accent',
 'function Accent.Show(frame, key)', 'function Accent.Hide()',
 'function Accent.GetAudit()', 'key ~= "merchant" and key ~= "trainer"',
 'CreateFrame("Frame", nil, UIParent)', 'surface:EnableMouse(false)',
 'surface:SetFrameStrata("BACKGROUND")', 'surface:SetFrameLevel(0)',
 'assets.panel', 'assets.divider', 'piece:SetTexture(assets.panel)',
 'piece:SetTexCoord(', 'divider:SetTexture(assets.divider)',
 'root:SetPoint("CENTER", frame, "CENTER", 0, 0)',
 'categoryLabel:SetText(', 'root:Hide()', 'root:ClearAllPoints()',
 'pcall(issecretvalue, frame)', 'nativeMutations = 0',
 'ownership = "addon-art-only"', 'mouse = false',
 'mode = visible and "quest-shell" or "stock"'):
    need(token in a,'missing exact quest-native-shell condition: '+token)
for forbidden in ('frame:SetPoint(', 'frame:ClearAllPoints(', 'frame:Hide(',
 'frame:Show(', 'frame:SetAlpha(', 'frame:SetParent(', 'frame:EnableMouse(',
 'frame:SetTexture(', 'SetScript("OnUpdate"', 'C_Timer.',
 'BuyMerchantItem(', 'BuyTrainerService(', 'RepairAllItems(',
 'C_GossipInfo.', 'TakeTaxiNode(', 'DynamicCam'):
    need(forbidden not in a, 'native input/safety violation: '+forbidden)
for token in ('theme.nativeServiceAccent = {','width = 640,','height = 540,',
 'corner = 40,','theme.questDialogue = {',
 'quest_narrative_panel.tga','quest_narrative_divider.tga'):
    need(token in t,'missing themed quest shell: '+token)
for token in ('Logres.NPCNativeServiceAccent.Show(frame, candidate.key)',
 'Logres.NPCNativeServiceAccent.Hide()',
 'accent = Logres.NPCNativeServiceAccent.GetAudit()',
 'scope = "opt-in-gossip-merchant-trainer-only"',
 'nativeTransactions = 0'):
    need(token in p,'preserve native placement lifecycle: '+token)
need('root:SetPoint("CENTER", frame, "CENTER", 0, 0)' in old,
 'migrate P0274 archival contract to new safe quest artwork location')
reg=re.findall(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*"([0A-HP])"\s*\)',c,re.S)
need(len(reg)==105 and sum(phase=='H' for _,phase in reg)==18 and
     sum(phase=='P' for _,phase in reg)==34,'no added panel actions 105/18/34')
need('"Native Auto Position (TEST)"' in c,'existing H action retained')
need('Quest\\ServiceCatalogModel.lua' not in toc and
     not (R/'Logres/Quest/ServiceCatalogModel.lua').exists(),
     'D-047: no native transactions rebuilt')
version=re.search(r'^## Version: (\S+)$',toc,re.M)
bootVersion=re.search(r'^Logres\.VERSION = "([^"]+)"$',boot,re.M)
need(bool(version and bootVersion and version.group(1)==bootVersion.group(1)),
     'runtime version parity, no pinned historical version')
for path in ('Logres/Camera/ProfileContexts.lua',
 'Logres/Camera/WorldCombat.lua','Logres/Quest/Dialogue.lua'):
    need((R/path).is_file(),'frozen module preserved: '+path)
for err in errors:print('ERROR:',err)
print('P0275 native quest-art shell contract')
if errors:raise SystemExit(1)
print('PASS: 0 errors (STATIC; in-client visibility and native control safety remain pending)')
