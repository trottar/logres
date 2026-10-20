#!/usr/bin/env python3
"""P0274 archival contract, migrated for P0275 quest-art shell; D-047 stock controls."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
a=read('Logres/Quest/NativeServiceAccent.lua')
p=read('Logres/Quest/NativeServicePlacementTrial.lua')
c=read('Logres/Core/Commands.lua')
t=read('Logres/Logres.toc')
b=read('Logres/Core/Bootstrap.lua')
style=read('Logres/Media/Theme.lua')
history=read('tools/check_p0271_native_placement_trial_contract.py')
errors=[]
def need(cond,what):
 if not cond: errors.append(what)
for token in ('Logres.NPCNativeServiceAccent = Accent',
 'function Accent.Show(frame, key)','function Accent.Hide()',
 'function Accent.GetAudit()', 'key ~= "merchant" and key ~= "trainer"',
 'CreateFrame("Frame", nil, UIParent)','surface:EnableMouse(false)',
 'root:SetPoint("CENTER", frame, "CENTER", 0, 0)',
 'surface:Hide()','root:Hide()','root:ClearAllPoints()',
 'pcall(issecretvalue, frame)','nativeMutations = 0',
 'ownership = "addon-art-only"','mouse = false',
 'mode = visible and "quest-shell" or "stock"'):
 need(token in a, 'missing noninteractive additive art invariant: '+token)
for forbidden in ('frame:SetPoint(', 'frame:ClearAllPoints(', 'frame:Hide(',
 'frame:Show(', 'frame:SetAlpha(', 'frame:SetParent(', 'frame:EnableMouse(',
 'SetScript("OnUpdate"', 'C_Timer.', 'BuyMerchantItem(',
 'BuyTrainerService(', 'RepairAllItems(', 'SellCursorItem(',
 'C_GossipInfo.', 'TakeTaxiNode(', 'DynamicCam'):
 need(forbidden not in a, 'native styling must not act on Blizzard UI: '+forbidden)
need('theme.nativeServiceAccent = {' in style, 'central theme controls appearance')
need('Quest\\NativeServiceCapabilities.lua\nQuest\\NativeServiceAccent.lua\nQuest\\NativeServicePlacementTrial.lua\nQuest\\NativeServicePolicy.lua' in t,
 'load addon-owned accent before existing controller')
need("'Quest\\\\NativeServiceAccent.lua'" not in t, 'no mistaken doubled escaping')
need(r'Quest\\NativeServiceAccent.lua' in history, 'migrated P0271 TOC contract')
for token in ('Logres.NPCNativeServiceAccent.Show(frame, candidate.key)',
 'Logres.NPCNativeServiceAccent.Hide()',
 'accent = Logres.NPCNativeServiceAccent.GetAudit()',
 'styling = "unchanged"',
 'scope = "opt-in-gossip-merchant-trainer-only"',
 'nativeTransactions = 0',
 'Trial.Restore("native-hide")',
 '[3] = { key = "gossip", name = "GossipFrame" }',
 '[5] = { key = "merchant", name = "MerchantFrame" }',
 '[7] = { key = "trainer", name = "ClassTrainerFrame" }'):
 need(token in p, 'existing controller invariant: '+token)
need('gossipRestores=%s accent=%s accentShows=%s accentHides=%s accentFailures=%s' in c,
 'H diagnostic reports accessory results separately from positioning')
need('tostring(report.accent.mode)' in c and
 'tostring(report.accent.failures)' in c, 'H diagnostic binds addon-owned accent audit')
rg=re.compile(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*"([0A-HP])"\s*\)',re.S)
reg=rg.findall(c)
need(len(reg)==105 and sum(ph=='H' for _,ph in reg)==18 and
 sum(ph=='P' for _,ph in reg)==34,'no new panel buttons: 105/18/34')
need('"Native Auto Position (TEST)"' in c,'keep existing panel button')
need('Quest\\ServiceCatalogModel.lua' not in t and not (R/'Logres/Quest/ServiceCatalogModel.lua').exists(),
 'D-047: no custom service transaction catalogue')
need(bool(re.search(r'^## Version: (\S+)$',t,re.M)) and
 re.search(r'^## Version: (\S+)$',t,re.M).group(1)==
 (re.search(r'^Logres\.VERSION = "([^"]+)"$',b,re.M) or [None,None])[1],
 'TOC/Bootstrap runtime version parity')
need((R/'docs/memory/evidence/P0274_NATIVE_SERVICE_ACCENT.md').is_file(),
 'preserve runtime acceptance boundary in durable evidence')
for filename in ('Logres/Camera/ProfileContexts.lua','Logres/Camera/WorldCombat.lua',
 'Logres/Quest/Dialogue.lua'):
 need((R/filename).is_file(), 'do not remove frozen module '+filename)
print('P0274 native merchant/trainer addon-owned accent contract')
for e in errors: print('ERROR:', e)
if errors: raise SystemExit(1)
print('PASS: 0 errors (STATIC; native accent visual and restoration require WoW validation)')
