#!/usr/bin/env python3
"""P0347: bounded private listener lifecycle with reentrant-safe release (STATIC)."""
from pathlib import Path
import re

R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
STATE=read('Logres/Core/State.lua')
PREF=read('Logres/Core/Preferences.lua')
MOD=read('Logres/Core/Modules.lua')
DB=read('Logres/Core/Database.lua')
P0346=read('tools/check_p0346_architecture_health_contract.py')
TOC=read('Logres/Logres.toc')
BOOT=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
E=read('docs/memory/evidence/P0347_SUBSCRIPTION_LIFECYCLE.md')
P=read('docs/memory/patches/P0347_SUBSCRIPTION_LIFECYCLE.md')

def need(ok,why):
    if not ok: raise AssertionError(why)

for src,name,event,depth,compact,announce in (
    (STATE,'state','publishStateChange','stateDispatchDepth','compactStateListeners','SubscribeState'),
    (PREF,'preference','publishPreferenceChange','preferenceDispatchDepth','compactPreferenceListeners','SubscribePreferences'),
):
    need(f'local {depth} = 0' in src and f'local {name}ListenersDirty = false' in src, name+' dispatch depth/dirty initialization')
    need(f'local function {compact}()' in src, name+' compaction missing')
    block=src[src.index(f'local function {compact}()'):src.index(f'local function {event}(')] if name=='preference' else src[src.index(f'local function {compact}()'):src.index('local function copyState(')]
    need(f'if not {name}ListenersDirty then return end' in block and
         f'{name}ListenersDirty = false' in block and
         'local write = 1' in block and 'subscription.active' in block and
         'write = write + 1' in block and '= nil' in block,
         name+' must compact only active records preserving order')
    pub=src[src.index(f'local function {event}('):src.index('function Logres:Get'+('State' if name=='state' else 'Preferences')+'()')]
    need(pub.index(f'{depth} = {depth} + 1') < pub.index('pcall(function()') <
         pub.index(f'{depth} = {depth} - 1') < pub.index(f'if {depth} == 0 then') < pub.index('if not ok then'),
         name+' nested/reentrant publish depth and error finalization missing')
    need(f'{compact}()' in pub and 'error(failure, 0)' in pub,
         name+' must collect/rethrow dispatch failure')
    need('if subscription.active then' in pub and 'subscription.handler(' in pub,
         name+' must skip unsubscribed callbacks')
    sub_start=src.index(f'function Logres:{announce}(')
    sub=src[sub_start:src.index('    return unsubscribe\nend',sub_start)+len('    return unsubscribe\nend')]
    need('if not subscription.active then' in sub and
         'subscription.active = false' in sub and 'subscription.handler = nil' in sub and
         f'{name}ListenersDirty = true' in sub and
         f'if {depth} == 0 then' in sub and f'{compact}()' in sub,
         name+' unsubscribe not idempotent/bounded')
    need('return unsubscribe' in sub, name+' returned cancellation closure removed')
    need('SetScript("OnUpdate"' not in pub and 'C_Timer' not in pub,
         name+' must not add polling')

need('return self:OwnCleanup(Logres:SubscribeState(handler))' in MOD and
     'return self:OwnCleanup(Logres:SubscribePreferences(handler))' in MOD,
     'existing module cleanup ownership altered')
need("need(len([p for p in (ROOT/'tools').glob('check_*.py')])>=217," in P0346
     and "'P0346 historical checker floor is 217'" in P0346
     and "need(len([p for p in (ROOT/'tools').glob('check_*.py')])==217," not in P0346,
     'P0346 legacy hard-coded checker ceiling must be migrated without losing inventory checks')
for marker in ('report=audit.inspect(ROOT)', 'faults=audit.verify(report)',
               'dev_panel_actions', 'bootstrap_version', 'missing_loaded_paths'):
    need(marker in P0346, 'P0346 historical audit source guard lost '+marker)
need('R0 PREWRITE shadow' in read('docs/memory/evidence/P0347_SUBSCRIPTION_LIFECYCLE.md')
     and '1/218' in read('docs/memory/evidence/P0347_SUBSCRIPTION_LIFECYCLE.md'),
     'rejected R0 candidate not documented')
need('local CURRENT_SCHEMA = 3' in DB and 'activeQuestEnabled = true' in DB,
     'persisted preference schema unexpectedly changed')
need('Core\\State.lua' in TOC and 'Core\\Preferences.lua' in TOC and
     len([l for l in TOC.splitlines() if l.endswith('.lua')])==94,
     'Lua load inventory changed')
need(re.search(r'(?m)^## Version: (\S+)$',TOC).group(1)==
     re.search(r'(?m)^Logres.VERSION = "([^\"]+)"$',BOOT).group(1),
     'TOC/Bootstrap version parity')
for marker in ('P0347','P0346','P0345','P0338','P0321','D-048','UNVERIFIED','L-022','L-027','L-028','L-019'):
    need(marker in CUR and marker in HAND,'CURRENT/HANDOFF continuity '+marker)
for marker in ('P0337','cfdc07af','P0338','L-031','UNVERIFIED'):
    need(marker in CUR and marker in HAND,'P0338 history continuity '+marker)
for n in range(317,347):need(f'P{n:04d}' in HAND,'historical handoff P%04d'%n)
for n in range(317,338):need(f'P{n:04d}' in CUR,'historical CURRENT P%04d'%n)
need(len(CUR.encode('utf-8'))<9800,'CURRENT maintenance budget')
for p in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0347' in read(p),'patch index missing '+p)
for v in (E,P):
    need(all(x in v for x in ('P0347','P0346','P0321','UNVERIFIED','218','OPEN')),
         'provenance/client deferral missing')
    need(v.endswith('\n') and not v.endswith('\n\n') and '\r' not in v,'record hygiene')
print('P0347 bounded State/Preferences listener release PASS (STATIC; WoW UNVERIFIED)')
