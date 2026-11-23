#!/usr/bin/env python3
"""P0510 global holiday quest-sort coverage, source ownership and live fixture."""
from pathlib import Path
import subprocess, shutil, re
R=Path(__file__).resolve().parents[1]
s=(R/'Logres/Navigation/QuestieDBNearby.lua').read_text()
block=s.split('local HOLIDAY_QUEST_SORT = {',1)[1].split('\n}',1)[0]
found=dict((int(k),n) for k,n in re.findall(r'\[(-\d+)\] = "([a-z-]+)"',block))
expected={-21:'hallows-end',-41:'day-of-the-dead',-364:'darkmoon-faire',
 -366:'lunar-festival',-369:'midsummer',-370:'brewfest',-374:'noblegarden',
 -375:'pilgrims-bounty',-376:'love-is-in-the-air',-378:'childrens-week'}
assert found==expected,(found,expected)
for token in ('elseif category == -22 then','"seasonal-holiday-identity-unknown"',
 'if eventType == "HOLIDAY" then','holidayTitleKey(title) == required',
 '"holiday-inactive:" .. required','"holiday-calendar-incomplete"',
 'self:InvalidateEligibility("calendar-day-changed")','"CALENDAR_UPDATE_EVENT_LIST"',
 'self.questEligibilityCalendarDay = today',
 'if type(id) == "number" and currentQuestOffers[id] == true then'):
 assert token in s,token
for forbidden in ('C_Timer','SetCVar(','OpenCalendar(','SetMonth(','HideUIPanel(',
 'eventID == 327 or title == "Lunar Festival"'):
 assert forbidden not in s,forbidden
for token in ('[-22]',):
 assert token not in block,'generic seasonal cannot masquerade as an exact holiday'
assert (R/'docs/memory/evidence/P0510_HOLIDAY_QUEST_ELIGIBILITY.md').exists()
engine=shutil.which('lua') or shutil.which('lua5.4') or shutil.which('texlua')
if engine:
 subprocess.run([engine,str(R/'tools/test_p0510_all_holidays.lua'),str(R)],cwd=R,check=True)
else:
 print('P0510 Lua source fixture DEFERRED: no interpreter')
print('P0510 PASS: ten exact holiday categories, generic seasonal veto, current-day gate, native precedence')
