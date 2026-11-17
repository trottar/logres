#!/usr/bin/env python3
"""P0473 focused-quest next-button, native keybind, source-bound safety."""
from pathlib import Path
import os,re,shutil,subprocess,xml.etree.ElementTree as ET
R=Path(__file__).resolve().parents[1]
read=lambda s:(R/s).read_text(encoding='utf-8')
A=read('Logres/Quest/ActiveQuest.lua');P=read('Logres/Quest/Progress.lua')
T=read('Logres/Logres.toc');B=read('Logres/Core/Bootstrap.lua')
X=ET.parse(R/'Logres/Bindings.xml').getroot()
assert X.tag=='Bindings' and len(X)==1
binding=X[0]
assert binding.tag=='Binding' and binding.attrib=={'name':'LOGRES_NEXT_FOCUSED_QUEST','header':'LOGRES'}
assert (binding.text or '').strip()=='Logres_NextFocusedQuest()'
assert 'Bindings.xml' not in T, 'native client loads binding XML automatically'
assert len([s for s in T.splitlines() if s.endswith('.lua')])==96
assert 'BINDING_HEADER_LOGRES = "Logres"' in A
assert 'BINDING_NAME_LOGRES_NEXT_FOCUSED_QUEST = "Next focused quest"' in A
assert 'function Logres_NextFocusedQuest()' in A and 'active:CycleFocusedQuest("binding")' in A
assert 'local cycleButton = CreateFrame("Button", nil, root)' in A
assert 'self:CycleFocusedQuest("button")' in A
assert 'self.cycleButton:Hide()' in A and 'self.cycleButton:Show()' in A
assert 'self.cycleCandidateCount >= 2' in A and 'not snapshot.preview' in A
assert 'function ActiveQuest:CycleFocusedQuest(source)' in A
assert 'self.previewMode ~= nil' in A and 'not self.immersionEnabled' in A and 'not self.activeQuestEnabled' in A
assert 'progress:AdvanceFocusedQuest()' in A
for bad in ['C_SuperTrack.Set','C_QuestLog.AddQuestWatch','C_QuestLog.RemoveQuestWatch','SetBinding(','SaveBindings(']:
 assert bad not in A,bad
D=read('Logres/Dev/Panel.lua')
assert 'incident.snapshot.activeQuest = pickTraceStatus' in D
assert '"cycleCandidateCount", "cycleAttempts"' in D
assert 'function Progress:ReadCycleQuestIDs()' in P
assert 'function Progress:AdvanceFocusedQuest()' in P
assert 'C_QuestLog.GetNumQuestLogEntries' in P and 'C_QuestLog.GetQuestIDForLogIndex' in P
assert 'MAX_CYCLE_LOG_ENTRIES = 128' in P
assert 'if isSecret(count) then' in P and 'if isSecret(questID) then' in P
assert 'if isSecret(questID) then' in P and P.index('if isSecret(questID) then', P.index('function Progress:ReadCycleQuestIDs'))<P.index('type(questID)', P.index('function Progress:ReadCycleQuestIDs'))
assert P.count('pcall(C_SuperTrack.SetSuperTrackedQuestID, nextQuestID)')==1
assert 'if currentSecret or currentError then' in P
for bad in ['C_QuestLog.AddQuestWatch','C_QuestLog.RemoveQuestWatch','C_QuestLog.SetSelectedQuest','SetBinding(','SaveBindings(']:
 assert bad not in P,bad
version=re.search(r'(?m)^## Version: (\S+)$',T)
boot=re.search(r'Logres.VERSION = "([^\"]+)"',B)
assert version and boot and version[1]==boot[1]
for doc in ('docs/memory/evidence/P0473_FOCUSED_QUEST_CYCLE.md','docs/memory/patches/P0473_FOCUSED_QUEST_CYCLE.md'):
 assert 'UNVERIFIED' in read(doc)
for f in ('docs/memory/CURRENT.md','docs/memory/handoffs/CURRENT_HANDOFF.md','docs/memory/PRE_HANDOFF_AUDIT.md','docs/memory/roadmap/STATUS.md','docs/memory/patches/PATCH_INDEX.md','docs/ROADMAP.md'):
 assert 'P0473' in read(f),f
lua=os.environ.get('LOGRES_LUA') or shutil.which('texlua') or shutil.which('lua')
if lua:subprocess.run([lua,str(R/'tools/test_p0473_quest_cycle.lua'),str(R)],cwd=R,check=True)
else:print('P0473 Lua actual-source fixture UNVERIFIED (interpreter missing)')
print('P0473 focused quest button/binding/secret/TOC contract PASS (STATIC; WoW UNVERIFIED)')
