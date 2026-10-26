#!/usr/bin/env python3
"""P0344: Forever L-027 owner-family evidence; docs-only source safety contract."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
def need(ok,why):
    if not ok: raise AssertionError(why)
E=read('docs/memory/evidence/P0344_FOREVER_POPUP_FAMILIES.md')
P=read('docs/memory/patches/P0344_FOREVER_POPUP_FAMILIES.md')
C=read('docs/memory/CURRENT.md')
H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
M=read('docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md')
I=read('docs/memory/investigations/ISSUE_REGISTER.md')
N=read('Logres/Immersion/NativeAccess.lua')
G=read('Logres/Core/Commands.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
for marker in ('AutoQuestPopUpBlockTemplate','ShowQuestOffer','ShowQuestComplete',
               'ObjectiveTrackerRewardsToastTemplate','CreateFramePool',
               'UIParent','WorldQuestCompleteAlertFrameTemplate',
               'ObjectiveTrackerTopBannerFrame', 'UNVERIFIED','P0321','L-027'):
    need(marker in E, 'documented source family/safety boundary omitted '+marker)
need('USER SYMPTOM OWNER STILL UNCONFIRMED' in E and 'WoW UNVERIFIED' in E,
     'source-only audit must not assert in-game popup identity')
for f in (E,P):
    need(f.endswith('\n') and not f.endswith('\n\n') and '\r' not in f,'document EOF hygiene')
for marker in ('ObjectiveTrackerFrame','StatusTrackingBarManager','SOURCE'):
    need(marker in N or marker=='SOURCE', 'Logres native fold ownership lost '+marker)
need('ObjectiveTrackerRewardsToastTemplate' not in N and
     'WorldQuestCompleteAlertFrameTemplate' not in N,
     'Logres native fold silently claimed unmatched Blizzard toast')
for marker in ('Logres gameplaycapture NativeAccess:',
               'Logres gameplaycapture QuestXP:',
               'Logres gameplaycapture QuestObjectiveProgress:'):
    need(marker in G,'existing P0335 gameplay capture lost '+marker)
need('| L-027 |' in I and 'P0344' in I and 'OPEN' in I,
     'L-027 issue failed to preserve unresolved popup owner')
need('P0344' in M and 'L-027' in M and 'UIParent' in M and
     'interactive' in M and '/fstack' in M,
     'Nov 4 owner discrimination/interactive fallback missing')
for marker in ('P0344','P0343','P0342','P0341','P0340','P0339','P0338',
               'P0337','cfdc07af','L-031','L-022','L-027','L-019',
               'P0321','UNVERIFIED'):
    need(marker in C and marker in H,'historic CURRENT/HANDOFF continuity '+marker)
for n in range(317,345):
    need(f'P{n:04d}' in H, 'historical handoff marker P%04d'%n)
for p in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/investigations/ACTIVE.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0344' in read(p),'checkpoint not indexed '+p)
need(len(C.encode('utf-8')) < 9800,'CURRENT maintenance budget')
a=re.search(r'(?m)^## Version: (\S+)$',T)
b=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(a and b and a.group(1)==b.group(1),'runtime version parity')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'loaded Lua inventory drift')
print('P0344 Forever popup owner-family attribution: PASS (STATIC; user symptom UNVERIFIED)')
