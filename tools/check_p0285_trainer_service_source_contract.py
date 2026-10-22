#!/usr/bin/env python3
"""P0285: trainer source probe is read-only and no live adapter is authorized."""
from pathlib import Path
import re
root=Path(__file__).resolve().parents[1]
read=lambda p:(root/p).read_text(encoding="utf-8")
probe=read('Logres/Quest/NativeTrainerServiceProbe.lua')
commands=read('Logres/Core/Commands.lua')
toc=read('Logres/Logres.toc')
bootstrap=read('Logres/Core/Bootstrap.lua')
evidence=read('docs/memory/evidence/P0285_NATIVE_TRAINER_SOURCE_FEASIBILITY.md')
errors=[]
def need(ok,reason):
    if not ok:errors.append(reason)
for token in ('function Probe.Read()', 'Logres.NPCNativeTrainerServiceProbe = Probe',
    'function Probe.Read()', 'MAX_SAMPLE = 64', 'MAX_SERVICES = 384',
    'return ok and secret == false', 'local function ordinary(value)',
    'local function snapshotRow(infoFn, costFn, iconFn, index)',
    'local state = Logres:GetState()', 'state.interactionType ~= 7',
    'read(root, "IsProtected") ~= false', 'read(root, "IsShown") ~= true',
    'local locked, lockKnown = scalar(api("InCombatLockdown"))',
    'api("GetNumTrainerServices")', 'api("GetTrainerServiceInfo")',
    'api("GetTrainerServiceCost")', 'api("GetTrainerServiceIcon")',
    'api("GetTrainerSelectionIndex")', 'api("GetMoney")',
    'api("GetTrainerServiceTypeFilter")', 'api("SetTrainerServiceTypeFilter")',
    'api("SelectTrainerService")', 'api("BuyTrainerService")',
    'math.min(total, MAX_SAMPLE)', 'not ordinary(name)',
    'mutationCalls=0, trainerPurchases=0, geometryWrites=0',
    'report.status="read-only-service-sample"'):
    need(token in probe,'missing source/gating '+token)
for bad in ('BuyTrainerService(', 'SelectTrainerService(',
    'SetTrainerServiceTypeFilter(', 'SetTrainerSkillLineFilter(',
    'SetScript("OnUpdate"', 'hooksecurefunc(', 'SetPoint(',
    'ClearAllPoints(', 'SetParent(', 'SetAlpha(', 'DynamicCam'):
    need(bad not in probe,'native write/hook forbidden '+bad)
need('Logres.NPCNativeTrainerServiceProbe.Read()' in commands,'existing H audit not extended')
need('Logres trainer service source:' in commands, 'service export log absent')
need('Quest\\NativeTrainerRegionAudit.lua\nQuest\\NativeTrainerServiceProbe.lua' in toc,
     'TOC probe must follow read-only native region audit')
ver=re.search(r'(?m)^## Version: (\S+)$',toc)
boot=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',bootstrap)
need(bool(ver and boot and ver.group(1)==boot.group(1)), 'TOC/Bootstrap version mismatch')
for word in ('ElvUI','Aurora','Class Trainer Plus','P0284','P0285',
             'read-only','DEFERRED','native', 'VISUAL PASS'):
    need(word.lower() in evidence.lower(),'missing source/evidence '+word)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff missing current authority')
for e in errors:print('ERROR:',e)
print('P0285 native trainer source feasibility contract')
if errors:raise SystemExit(1)
print('PASS: read-only gated sample and no native mutation; WoW verification pending')
