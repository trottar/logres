#!/usr/bin/env python3
"""P0345: separate cached renderer route from native activation state (STATIC)."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
S=read('Logres/HUD/StatusAuras.lua')
N=read('Logres/HUD/NativeDebuffs.lua')
C=read('Logres/Core/Commands.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md')
H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
I=read('docs/memory/investigations/ISSUE_REGISTER.md')
M=read('docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md')
E=read('docs/memory/evidence/P0345_AURA_ACTIVATION_PROVENANCE.md')
P=read('docs/memory/patches/P0345_AURA_ACTIVATION_PROVENANCE.md')
def need(ok,msg):
    if not ok:raise AssertionError(msg)
refresh=S[S.index('function StatusAuras:Refresh('):S.index('function StatusAuras:SetPreview(')]
status=S[S.index('function StatusAuras:GetDebugStatus()'):S.index('function StatusAuras:OnInitialize()')]
init=S[S.index('function StatusAuras:OnInitialize()'):S.index('function StatusAuras:OnEnable()')]
capture=C[C.index('function Logres:RunGameplayCapture()'):C.index('local function printPreferences()')]
route='Logres gameplaycapture Auras route: nativeReady=%s nativeActive=%s ordinaryFallbackShown=%s ordinaryFallbackRows=%s (cached Logres status; NOT native icon visibility proof)'
activation='Logres gameplaycapture Auras activation: nativeEnabledCached=%s routeNativeSelected=%s activationReason=%s (Logres-owned state; NOT native icon visibility proof)'
need(capture.count(route)==1, 'P0342 original aura route line must survive unmodified')
need(capture.count(activation)==1, 'exactly one additive cached activation line')
need('local nativeOK, activationReason = Logres.NativeDebuffs.SetActive(' in refresh,
    'existing native activation call must capture reason without another call')
need('self.nativeActivationReason = activationReason' in refresh,
    'activation reason must be cached as addon-owned state')
need('useNative = nativeOK and active and not self.preview' in refresh and
     'self.nativeActive = useNative' in refresh and
     'active and not useNative' in refresh,
     'renderer routing / fallback policy changed')
need('nativeEnabledCached = self.nativeDebuffs ~= nil' in status and
     'and self.nativeDebuffs.active == true' in status and
     'nativeActivationReason = self.nativeActivationReason' in status,
     'read-only state fields do not reflect addon-owned cache')
need('self.nativeActivationReason = self.nativeReason or "unavailable"' in init,
     'initialized cached activation reason absent')
need('boolText(aura.nativeEnabledCached)' in capture and
     'boolText(aura.nativeActive)' in capture and
     'tostring(aura.nativeActivationReason or "unavailable")' in capture,
     'bounded one-shot snapshot missing cached fields')
need('if state.active == active then' in N and
     'return true, "unchanged-in-combat"' in N and
     'return false, "combat-deferred"' in N and
     'state.active = active' in N,
     'native combat token contract was modified')
for forbidden in ('GetPoint(', 'IsProtected(', 'GetAuraDataByIndex(', 'UnitAura(',
                  'SetEnabled(', 'SetShown(', 'UpdateAllAuras(', 'SetScript(',
                  'RegisterEvent(', 'C_Timer.', 'hooksecurefunc('):
    need(forbidden not in capture,'snapshot must not read/mutate Blizzard native state: '+forbidden)
for forbidden in ('GetPoint(', 'SetPoint(', 'UpdateAllAuras(', 'C_Timer.',
                  'GetAuraDataByIndex(', 'UnitHealth('):
    need(forbidden not in refresh,'activation-only refresh not allowed: '+forbidden)
for token in ('L-028','P0345','nativeEnabledCached','nativeActivationReason'):
    need(token in M and token in E and token in P,'durable diagnostic evidence absent '+token)
need('| L-028 |' in I and 'P0345' in I and 'OPEN' in I,
     'L-028 cannot be closed statically')
for token in ('P0345','P0344','P0343','P0338','P0321','L-022','L-027','L-019','UNVERIFIED'):
    need(token in CUR and token in H,'current/handoff continuity lost '+token)
for token in ('P0337','cfdc07af','P0338','L-031','UNVERIFIED'):
    need(token in CUR and token in H,'P0338 historical gate lost '+token)
for i in range(317,345):need(f'P{i:04d}' in H,'historical handoff marker P%04d'%i)
for i in range(317,338):need(f'P{i:04d}' in CUR,'historical CURRENT marker P%04d'%i)
need(len(CUR.encode('utf-8')) < 9800,'CURRENT health budget exceeded')
for p in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0345' in read(p),'patch index missing: '+p)
for doc in (E,P):need(doc.endswith('\n') and not doc.endswith('\n\n'),'evidence EOF hygiene')
t=re.search(r'(?m)^## Version: (\S+)$',T)
b=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(t and b and t.group(1)==b.group(1),'TOC/Bootstrap version parity')
need(len([l for l in T.splitlines() if l.endswith('.lua')])==94,'loaded Lua inventory drift')
# Pure state-route negative case; not a WoW simulation.
def decide(cached, requested, in_combat):
    if in_combat and cached!=requested:return (False,cached,'combat-deferred')
    return (True,requested,'native-active' if requested else 'native-disabled')
assert decide(True,False,True)==(False,True,'combat-deferred')
assert decide(False,True,True)==(False,False,'combat-deferred')
assert decide(True,True,True)==(True,True,'native-active')
print('P0345 native activation cache versus rendering-route provenance PASS (STATIC; WoW UNVERIFIED)')
