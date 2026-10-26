#!/usr/bin/env python3
"""P0343 R1 L-022 existing-normal-preview missing-percent coverage, static only."""
from pathlib import Path
import re

R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
A=read('Logres/Quest/ActiveQuest.lua')
C=read('Logres/Core/Commands.lua')
P=read('Logres/Quest/Progress.lua')
CUR=read('docs/memory/CURRENT.md')
H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
M=read('docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md')
I=read('docs/memory/investigations/ISSUE_REGISTER.md')
E=read('docs/memory/evidence/P0343_ACTIVE_QUEST_UNKNOWN_PREVIEW.md')
REC=read('docs/memory/patches/P0343_ACTIVE_QUEST_UNKNOWN_PREVIEW.md')
T=read('Logres/Logres.toc'); B=read('Logres/Core/Bootstrap.lua')
def need(ok,msg):
    if not ok: raise AssertionError(msg)
# Zero additions to developer panel or command routes; P0256 and P0271–P0310
# maintain fixed historical registry counts.
need('activeQuestPreviewUnknown' not in C and 'activequestpreview unknown' not in C,
     'extra developer panel action / slash routing must not be introduced')
for label,command in (('Active Quest Preview','activequestpreview normal'),
                      ('Active Quest Complete','activequestpreview complete'),
                      ('Active Quest Live','activequestpreview live')):
    need('"'+label+'"' in C and '"'+command+'"' in C,'existing preview routing lost '+label)
need('  /logres activequestpreview [normal|complete|live]' in C,
     'unchanged slash help missing')
need('local PREVIEW_NORMAL = "normal"' in A and 'local PREVIEW_COMPLETE = "complete"' in A,
     'legacy fixture modes missing')
need('PREVIEW_UNKNOWN' not in A,'separate unreviewed preview mode introduced')
start=A.index('function ActiveQuest:BuildPreviewSnapshot(mode)')
end=A.index('function ActiveQuest:PercentForRow(row)',start)
s=A[start:end]
normal=s[s.rindex('    return {'):]
need('source = "preview-normal"' in normal,'normal preview fixture lost')
need(normal.count('text = "Objective progress unavailable"')==1,
     'normal fixture must contain exactly one missing-number row')
row=normal[normal.index('text = "Objective progress unavailable"'):]
need('finished = false' in row.split('},',1)[0] and
     'fulfilled' not in row.split('},',1)[0] and 'required' not in row.split('},',1)[0],
     'unknown row must not have numeric progress')
need('fulfilled = 3' in normal and 'required = 10' in normal and
     'fulfilled = 0' in normal and 'required = 4' in normal,
     'measurable control rows removed')
need('self:BuildPreviewSnapshot(self.previewMode)' in A and
     'return self:Render(\n        snapshot,' in A and
     A.count('function ActiveQuest:Render(snapshot, reason)')==1,
     'normal and live must share production renderer')
for token in ('visual.unknown:Show()', 'unknown:SetSize(122, 1)',
              'if percent ~= nil then', 'visual.bar.status:SetValue(percent)'):
    need(token in A,'production missing-percent fallback changed '+token)
need('function Progress:NormalizeObjectiveLabel(row)' in P and
     'function Progress:StableObjectiveText(row)' in P,
     'text-only label path removed')
for unsafe in ('C_QuestLog.', 'GetPoint(', 'C_Timer.', 'SetSuperTrackedQuestID'):
    need(unsafe not in normal,'fixture contains live/protected source '+unsafe)
need('P0343' in M and 'L-022' in M and 'Active Quest Preview' in M and
     '/logres activequestpreview normal' in M and 'P0321' in M,
     'matrix lacks existing preview and safety boundaries')
need('| L-022 |' in I and 'symptom OPEN' in I,'L-022 falsely accepted')
for token in ('P0343','P0342','P0341','P0339','P0338','P0321','L-022','L-027','L-019','UNVERIFIED'):
    need(token in CUR and token in H,'continuity missing '+token)
for token in ('P0337','cfdc07af','P0338','L-031','UNVERIFIED'):
    need(token in CUR and token in H,'P0338 historical continuity '+token)
for i in range(317,344):need(f'P{i:04d}' in H,'handoff milestone missing P%04d'%i)
need(len(CUR.encode('utf-8')) < 9800,'CURRENT maintenance budget exceeded')
for f in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/ROADMAP.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0343' in read(f),'patch index omitted '+f)
for doc in (E,REC):
    for token in ('P0343','R0','8/214','PREWRITE','OPEN','UNVERIFIED','P0321'):
        need(token in doc,'rejected R0/safety evidence missing '+token)
    need(doc.endswith('\n') and not doc.endswith('\n\n'),'evidence EOF hygiene')
t=re.search(r'(?m)^## Version: (\S+)$',T)
b=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(t and b and t.group(1)==b.group(1),'TOC/Bootstrap dynamic version parity')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,'TOC module inventory drift')
print('P0343 R1 existing-normal Active Quest missing-percent preview contract PASS (STATIC; WoW UNVERIFIED)')
