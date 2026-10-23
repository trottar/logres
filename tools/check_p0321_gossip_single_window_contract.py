#!/usr/bin/env python3
"""P0321: fully gated native GossipFrame root parking and restoration."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
p=read('Logres/Quest/NPCGossipStockParking.lua')
l=read('Logres/Quest/NPCGossipPresentation.lua')
g=read('Logres/Quest/NPCGossipChoice.lua')
q=read('Logres/Quest/NPCGossipQuestChoice.lua')
s=read('Logres/Quest/OptionSession.lua')
d=read('Logres/Quest/Dialogue.lua')
c=read('Logres/Core/Commands.lua')
t=read('Logres/Logres.toc')
b=read('Logres/Core/Bootstrap.lua')
a=read('docs/memory/CURRENT.md')
h=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
e=read('docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md')
errors=[]
def need(ok,msg):
    if not ok:errors.append(msg)
for item in ('Logres.NPCGossipStockParking = Parking',
    'function Parking.TryPark(model)', 'function Parking.Restore(reason)',
    'function Parking.RequestExit(reason)', 'function Parking.CloseGossip()',
    'function Parking.Toggle()', 'function Parking.GetAudit()',
    'function Parking.IsParked()', 'method(C_GossipInfo, "CloseGossip")',
    'read(root, "IsProtected") ~= false', 'read(root, "IsShown") ~= true',
    'InCombatLockdown', 'UIParent, "BOTTOMLEFT", -64, -64',
    'saved.set(saved.root, token[1], token[2], token[3], token[4], token[5])',
    'retry:RegisterEvent("PLAYER_REGEN_ENABLED")',
    'retry:UnregisterEvent("PLAYER_REGEN_ENABLED")',
    'Logres.NPCGossipQuestChoice.CanSelect("available")',
    'Logres.NPCGossipChoice.CanSelect()', 'option.gossipStatus ~= 0',
    'Logres.NPCGossipPresentation.OnStockRestored()', 'pcall(close)',
    'nativeAlphaWrites = 0', 'nativeMouseWrites = 0'):
    need(item in p,'parking gate or restoration missing: '+item)
for forbidden in ('SetAlpha(', 'EnableMouse(', 'HideUIPanel(', 'GossipFrame:Hide(',
                  'GossipFrame:SetParent(', 'C_Timer.', 'SetScript("OnUpdate"',
                  'BuyTrainerService(', 'AcceptQuest(', 'CompleteQuest(',
                  'GetQuestReward(', 'C_GossipInfo.SelectOption('):
    need(forbidden not in p,'parking forbidden gameplay/native operation: '+forbidden)
need('if not unlocked() then' in p, 'lockdown protection absent')
need('if not complete(model) then' in p and 'if parked then Parking.Restore(' in p,
    'partial staged menu must restore stock')
need('Logres.NPCGossipStockParking.TryPark(model)' in l and
     'Logres.NPCGossipStockParking.RequestExit(' in l and
     'function Live.BeforeNativeChoice()' in l and
     'function Live.Goodbye()' in l and
     'function Live.OnStockRestored()' in l,
     'live lifecycle not wired to native parking')
need('Logres.NPCGossipPresentation.BeforeNativeChoice()' in g and
     'Logres.NPCGossipPresentation.BeforeNativeChoice()' in q,
     'native option/quest actions must first restore stock')
need('Logres.NPCGossipPresentation.Goodbye()' in s and
     'if self.liveReadOnly then' in s, 'live Goodbye must use native-safe exit')
need('function Dialogue:HidePresentation(reason)' in d and
     'Logres.NPCGossipStockParking.RequestExit(' in d,
     'independent immersion/dialogue exits require restoration')
for item in ('"gossipstockstatus"','"gossipstocktoggle"',
             '"Gossip Stock Status (READ-ONLY)"','"Gossip Stock Toggle"'):
    need(item in c,'H developer panel action missing: '+item)
need('Quest\\NPCGossipQuestChoice.lua\nQuest\\NPCGossipStockParking.lua\n' in t,
     'gossip module load order unsafe')
need(re.search(r'^## Version: (\S+)$',t,re.M).group(1) ==
     re.search(r'^Logres.VERSION = "([^"]+)"$',b,re.M).group(1),
     'runtime version parity')
need('CURRENT.md' in h and all(x in a for x in ('P0317','P0318','P0319','P0320','P0321')),
     'durable memory continuity missing')
for word in ('P0321','P0320','fail-open','Blizzard','UNVERIFIED','DEFERRED',
             'FAIL','GossipFrame','restore','quest','merchant','flight'):
    need(word.lower() in e.lower(),'evidence missing '+word)
print('P0321 gossip whole-root parking and restoration contract')
for x in errors:print('ERROR:',x)
if errors:raise SystemExit(1)
print('PASS: complete native gossip coverage, guarded parking, no invisible click regions, native restore')
