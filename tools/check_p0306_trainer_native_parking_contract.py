#!/usr/bin/env python3
"""P0306: trainer-only whole-root offscreen park with opaque restore before Logres teardown."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
s=read('Logres/UI/NPCServiceNativeParking.lua')
v=read('Logres/Quest/TrainerLiveTrial.lua')
t=read('Logres/Quest/TrainerPurchaseTrial.lua')
toc=read('Logres/Logres.toc')
e=read('docs/memory/evidence/P0306_TRAINER_NATIVE_PARKING.md')
prev=read('tools/check_p0305_trainer_ready_events_contract.py')
cur=read('docs/memory/CURRENT.md')
issues=[]
def need(condition, explanation):
    if not condition: issues.append(explanation)
for token in (
    'Logres.NPCServiceNativeParking = Parking',
    'local permitted = {trainer={native="ClassTrainerFrame", interactionType=7}}',
    'function Parking.Park(key)',
    'function Parking.Restore(reason)',
    'function Parking.DeferExit()',
    'function Parking.GetAudit()',
    'read(root, "IsProtected") ~= false',
    'read(root, "IsShown") ~= true',
    'if not unlocked() then',
    'state.interactionType ~= spec.interactionType',
    'placementConflict()',
    'capture(root)',
    'pcall(getPoint, root, index)',
    'points[index] = {p, relative, rp, x, y}',
    'local token = state.points[i]',
    'state.set(state.root, token[1], token[2], token[3], token[4], token[5])',
    'parked = {key=key, root=root, points=points, clear=clear, set=set, pending=false}',
    'set(root, "TOPRIGHT", UIParent, "BOTTOMLEFT", -64, -64)',
    'pcall(hook, root, "OnHide", function()',
    'retry:RegisterEvent("PLAYER_REGEN_ENABLED")',
    'retry:UnregisterEvent("PLAYER_REGEN_ENABLED")',
    'Logres.NPCTrainerLiveTrial.Disable("deferred-stock-restored")',
    'nativeVisibilityWrites=0',
):need(token in s,'missing native parking capability / restoration: '+token)
need(s.count('set(root, "TOPRIGHT", UIParent, "BOTTOMLEFT", -64, -64)') == 1,
     'native park must have single exact bounded offscreen placement')
for banned in ('SetAlpha(', 'SetParent(', 'EnableMouse(false)',
               'HideUIPanel(', 'hooksecurefunc(', 'C_Timer.',
               'SetScript("OnUpdate"', 'BuyTrainerService(', 'CloseTrainer('):
    need(banned not in s, 'parking must not hide/mutate native interactions, transact, or poll: '+banned)
for token in (
    'function Trial.Disable(why)',
    'pcall(Logres.NPCServiceNativeParking.Restore,',
    'Logres.NPCServiceNativeParking.DeferExit()',
    'last = "stock-restore-pending"',
    'if browse and browse.searchEdit then browse.searchEdit:ClearFocus() end',
    'if active then active:Hide(); active = nil end',
    'pcall(Logres.NPCServiceNativeParking.Park, "trainer")',
    'owner:Show()',
    'if not refreshBrowse() then',
    'Logres.NPCTrainerPurchaseTrial.Attempt(',
    'Logres.NPCTrainerPurchaseTrial.AttemptAll(',
    'Logres.NPCServiceCatalogue.Filter(',
    'nativeParking=Logres.NPCServiceNativeParking.GetAudit()',
):need(token in v,'missing trainer integration / legacy behavior: '+token)
need(v.find('pcall(Logres.NPCServiceNativeParking.Restore,') <
     v.find('if browse and browse.searchEdit then browse.searchEdit:ClearFocus() end'),
     'native restore must precede removal of owned interaction')
need(v.find('owner:Show()') < v.find('pcall(Logres.NPCServiceNativeParking.Park, "trainer")'),
     'park must happen after Logres owner shown')
need('function Trial.AttemptAll(' in t and 'function Trial.Attempt(' in t,
     'single and bulk purchase guards changed')
need('Quest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua' in toc,
     'historical trainer adjacency broken')
need('Core\\Lifecycle.lua\nUI\\NPCServiceSession.lua\nUI\\NPCServiceNativeParking.lua' in toc,
     'append native parking after existing session without breaking adjacency')
need('P0305' in prev and 'TRAINER_SHOW' in prev,'historical readiness contract absent')
for x in ('P0305','P0306','PASS','UNVERIFIED','Goodbye','Blizzard','combat','stock','opaque','runtime'):
    need(x.lower() in e.lower(),'negative/runtime scope evidence missing '+x)
for heading in ('## Active Objective','## Current Work Item','## Verified State',
                '## Next Action','## Success Criteria',
                '## Do Not Reopen Without New Evidence','## Relevant References'):
    need(cur.splitlines().count(heading)==1,'CURRENT missing mandatory heading '+heading)
need(len(cur.encode())<10000,'CURRENT size gate')
ma=re.search(r'(?m)^## Version: (\S+)$',toc)
mb=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(ma and mb and ma.group(1)==mb.group(1)),'version parity')
print('P0306 trainer native whole-root parking contract')
for issue in issues:print('ERROR:',issue)
if issues:raise SystemExit(1)
print('PASS: trainer-only position gate; native shown; restore before teardown; source/transactions preserved')
