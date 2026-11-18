#!/usr/bin/env python3
"""P0474 L-037 client header-zero and native ADDONS binding regression."""
from pathlib import Path
import xml.etree.ElementTree as ET
import shutil,os,subprocess
R=Path(__file__).resolve().parents[1]
source=(R/'Logres/Quest/Progress.lua').read_text()
assert 'if isSecret(questID) then return nil, "cycle-quest-secret" end' in source
assert 'if questID == 0 then' in source and 'self.cycleZeroRowsSkipped' in source
assert 'elseif questID ~= nil then' in source
assert source.index('if isSecret(questID) then',source.index('function Progress:ReadCycleQuestIDs')) < source.index('if questID == 0 then',source.index('function Progress:ReadCycleQuestIDs'))
assert 'return nil, "cycle-quest-invalid"' in source
x=ET.parse(R/'Logres/Bindings.xml').getroot(); assert x.tag=='Bindings' and len(x)==1
assert x[0].attrib=={'name':'LOGRES_NEXT_FOCUSED_QUEST','category':'ADDONS','header':'LOGRES'}
assert x[0].text.strip()=='Logres_NextFocusedQuest()'
assert 'Bindings.xml' not in (R/'Logres/Logres.toc').read_text()
a=(R/'Logres/Quest/ActiveQuest.lua').read_text()
for token in ('lastCycleListReason =','cycleZeroRowsSkipped =','self.cycleButton:Show()','self.cycleButton:Hide()'):
 assert token in a,token
assert 'L-037' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert (R/'docs/memory/handoffs/CURRENT_HANDOFF.md').read_text().startswith('# P0474:')
assert 'P0474' in (R/'docs/memory/evidence/P0474_QUEST_CYCLE_HEADER_REPAIR.md').read_text()
lua=os.environ.get('LOGRES_LUA') or shutil.which('texlua') or shutil.which('lua')
if lua:
 subprocess.run([lua,str(R/'tools/test_p0473_quest_cycle.lua'),str(R)],cwd=R,check=True)
else: print('P0474 actual-source Lua UNVERIFIED: interpreter unavailable')
print('P0474 cycle header sentinel, binding category and diagnostics PASS (STATIC; WoW UNVERIFIED)')
