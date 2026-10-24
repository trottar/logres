#!/usr/bin/env python3
"""P0332: target harmful canonical-source correctness, guardrail and pure fallback fixtures."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
s=read('Logres/HUD/StatusAuras.lua')
legacy=read('tools/check_status_auras_contract.py')
n=read('Logres/HUD/NativeDebuffs.lua')
comp=read('Logres/HUD/AuraSourceEngine.lua')
current=read('docs/memory/CURRENT.md')
handoff=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
issues=read('docs/memory/investigations/ISSUE_REGISTER.md')
boot=read('Logres/Core/Bootstrap.lua');toc=read('Logres/Logres.toc')

def need(ok,what):
    if not ok: raise AssertionError(what)

filters=s.split('local FILTERS = {',1)[1].split('local COLORS = {',1)[0]
target=filters.split('    target = {',1)[1].split('    },',1)[0]
need(target.count('{ filter = "HARMFUL", kind = "harmful" }')==1,
     'canonical target harmful filter absent or duplicated')
need('HARMFUL|PLAYER' not in target and 'HARMFUL|CROWD_CONTROL' not in target,
     'overlapping target harmful filters reintroduced')
for f in ('HELPFUL|DISPELLABLE','HELPFUL|BIG_DEFENSIVE','HELPFUL|IMPORTANT',
          'HELPFUL'):
    need(f'filter = "{f}"' in target, 'helpful source lost '+f)
need('"HARMFUL|CROWD_CONTROL"' in filters and '"HARMFUL|RAID"' in filters,
     'player urgent filter behavior lost')
need('local TARGET_HARMFUL_SCAN = 16' in s and 'local MAX_SCAN = 6' in s,
     'canonical target scan bound or other scope altered')
reader=s.split('local function readUnit(unit)',1)[1].split('local function createLane(',1)[0]
for t in ('local canonicalTargetHarmful = unit == "target"',
          'descriptor.filter == "HARMFUL"',
          'and TARGET_HARMFUL_SCAN or MAX_SCAN',
          'if not canonicalTargetHarmful and #bucket >= MAX_ICONS then',
          'targetHarmfulCandidates[#targetHarmfulCandidates + 1] = aura',
          '(aura.fromPlayer == true) == (pass == 1)',
          'result.harmfulRows[#result.harmfulRows + 1] = aura',
          'seen[aura.instanceID] = true',
          'result.secretSkips = result.secretSkips + 1'):
    need(t in reader, 'fallback source/selection contract missing '+t)
source=s.split('local function readAura(',1)[1].split('local function readUnit(',1)[0]
need('local playerOrigin = aura.isFromPlayerOrPlayerPet' in source,
     'player-origin source missing')
need('if isSecret(playerOrigin) or type(playerOrigin) ~= "boolean" then' in source,
     'origin not independently secret checked')
need(source.index('if isSecret(aura) then') < source.index('local playerOrigin = aura.isFromPlayerOrPlayerPet')
     < source.index('if isSecret(playerOrigin) or type(playerOrigin) ~= "boolean" then'),
     'secret-first origin ordering lost')
need('fromPlayer = playerOrigin,' in source, 'sanitized origin not forwarded')
need("""'{ filter = "HARMFUL", kind = "harmful" }'""" in legacy,
     'P0175 historical contract not migrated to canonical source')
need('"HARMFUL|PLAYER"' not in legacy,
     'stale historical overlapping source requirement')
for term in ('CustomAuraContainerTemplate', 'frame:AddAuraGroup("LogresHarmful", "HARMFUL", {',
             'frame:SetUnit(unit)', 'frame:SetEnabled(false)'):
    need(term in n, 'native secured fallback changed '+term)
need('key = "targetHarmful", unit = "target", baseline = "HARMFUL"' in comp,
     'independent comparison engine changed')
for bad in ('SetScript("OnUpdate"','C_Timer.NewTicker','GetAuraSlots',
            'GetAuraDataBySlot','SetParent(', 'TargetFrame:Hide',
            'BuffFrame:Hide','DebuffFrame:Hide'):
    need(bad not in s,'unsafe status modification '+bad)
need('stockPreserved = true' in s and 'nativeActive = self.nativeDebuffs' in s,
     'stock fallback or native control removed')
v=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',boot)
need(v and b and v.group(1)==b.group(1), 'version parity')
for m in ('P0330','P0331','P0332','P0317','P0318','P0319','P0320',
          'P0321','P0326','P0327','P0328','P0329'):
    need(m in current,'CURRENT milestone continuity lost '+m)
for m in ('CURRENT.md','P0326','P0327','P0330','P0331','P0332'):
    need(m in handoff,'handoff marker missing '+m)
need('| L-028 |' in issues and 'P0332' in issues,
     'issue register not updated')
need('UNVERIFIED' in read('docs/memory/evidence/P0332_TARGET_AURAS.md'),
     'missing runtime defer evidence')

# Synthetic distinct auras, identical icons, unknown IDs, out-of-view DoTs,
# mixed-origin and >16 input. No Blizzard data and no spell-ID deduplication.
def select(candidate,limit=5):
    seen=set(); scanned=[]
    for item in candidate[:16]:
        ident=item.get('instance')
        if ident is not None and ident in seen: continue
        if ident is not None: seen.add(ident)
        scanned.append(item)
    return [x for x in scanned if x.get('own') is True][:limit]+[x for x in scanned if x.get('own') is not True][:max(0,limit-min(limit,sum(x.get('own') is True for x in scanned)))]

a=[{'instance':None,'icon':'shared','own':True},{'instance':None,'icon':'shared','own':None}]
need(len(select(a))==2,'distinct same-icon/unknown-ID auras improperly merged')
need(select([{'instance':7,'own':True},{'instance':7,'own':True}])==[{'instance':7,'own':True}],
     'proven duplicate ID not removed')
c=[{'instance':i,'own':False} for i in range(1,7)]+[{'instance':7,'own':True}]
need(select(c)[0]['instance']==7,'later player DoT not prioritized')
need(len(select([{'instance':i} for i in range(30)]))==5,
     'display or scan bounds drift')
need(len(select([{'instance':None}]*3))==3,
     'identity-unknown DoTs incorrectly collapsed')
need(select([])==[],'empty source invented rows')
print('P0332 canonical target harmful fallback source / bounded selection fixtures')
print('PASS: single harmful source, source-independent origin, identity-unknown safety, native fallback')
