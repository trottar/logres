#!/usr/bin/env python3
"""P0276: gated, on-demand trainer region inventory with zero stock mutation."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p:(R/p).read_text(encoding='utf-8')
a = read('Logres/Quest/NativeTrainerRegionAudit.lua')
b = read('Logres/Quest/NativeServiceAccent.lua')
p = read('Logres/Quest/NativeServicePlacementTrial.lua')
c = read('Logres/Core/Commands.lua')
t = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
errors=[]
def need(ok,why):
    if not ok:errors.append(why)
for token in ('Logres.NPCNativeTrainerRegionAudit = Audit', 'function Audit.Read()',
    'type(issecretvalue)', 'pcall(issecretvalue, value)', 'ordinary(object)',
    'Logres:GetState()', 'state.interactionType ~= 7', 'InCombatLockdown',
    'read(frame, "IsProtected") ~= false', 'read(frame, "IsShown") ~= true',
    '"ClassTrainerFrame"', '"ClassTrainerTrainButton"',
    '"ClassTrainerListScrollFrame"', '"ClassTrainerDetailScrollFrame"',
    '"ClassTrainerMoneyFrame"', '"ClassTrainerFrameFilterDropDown"',
    '"ClassTrainerFrameFilterDropdown"', '"ClassTrainerSkill1"',
    '"GetNumRegions"', '"GetRegions"', '"GetTexture"', '"GetAtlas"',
    'regionToken(region)', 'ordinary(region)', 'maxRegions = 16',
    'nativeMutations = 0', 'transactionCalls = 0', 'geometryWrites = 0'):
    need(token in a,'region audit invariant: '+token)
for banned in ('CreateFrame(', ':Hide(', ':Show(', ':SetPoint(',
    ':ClearAllPoints(', ':SetSize(', ':SetTexture(', ':SetAlpha(',
    ':SetParent(', ':EnableMouse(', ':HookScript(', 'SetScript(',
    'hooksecurefunc(', 'C_Timer.', 'BuyTrainerService(', 'BuyMerchantItem(',
    'GetTrainerServiceInfo(', 'GetTrainerServiceCost(', 'DynamicCam'):
    need(banned not in a,'read-only audit must not mutate or query transactions: '+banned)
need('Quest\\NativeServicePolicy.lua\nQuest\\NativeTrainerRegionAudit.lua' in t,
     'new audit follows existing contiguous native modules')
need(t.index('Quest\\NativeTrainerRegionAudit.lua') < t.index('Quest\\OptionModel.lua'),
     'audit registered before Core Commands')
need('Logres.NPCNativeTrainerRegionAudit.Read()' in c and
     'Logres native trainer feasibility:' in c and
     'Logres trainer control:' in c and
     'Logres trainer region:' in c,
     'existing nativeframeaudit emits bounded trainer detail')
need('"Native Service Frame Audit"' in c and '"nativeframeaudit"' in c,
     'existing H button reused, no new action')
need('mode = "retired"' in b and 'CreateFrame(' not in b,
     'failed P0274/P0275 art no longer constructed')
need('function Trial.Restore(reason)' in p and
     'function Trial.AutoReconcile(reason)' in p and
     'nativeTransactions = 0' in p, 'native positioning/transaction safety remains')
need('Quest\\ServiceCatalogModel.lua' not in t,
     'no duplicated trainer transaction logic')
version = re.search(r'^## Version: (\S+)$', t, re.M)
bootVersion = re.search(r'^Logres\.VERSION = "([^"]+)"$',boot,re.M)
need(bool(version and bootVersion and version.group(1)==bootVersion.group(1)),
     'Bootstrap / TOC version parity')
for path in ('Logres/Camera/ProfileContexts.lua','Logres/Camera/WorldCombat.lua',
             'Logres/Quest/Dialogue.lua'):
    need((R/path).is_file(),'frozen module retained: '+path)
need((R/'docs/memory/evidence/P0276_NATIVE_TRAINER_FEASIBILITY.md').exists(),
     'P0276 evidence exists')
for err in errors: print('ERROR:',err)
print('P0276 native trainer region feasibility (static, read only)')
if errors:raise SystemExit(1)
print('PASS: 0 errors (in-client region identities NOT YET PROVEN)')
