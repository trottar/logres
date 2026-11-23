#!/usr/bin/env python3
"""Historical P0509 Lunar invariants, superseded by P0510 generalized gate."""
from pathlib import Path
import subprocess, shutil, re
R=Path(__file__).resolve().parents[1]
s=(R/'Logres/Navigation/QuestieDBNearby.lua').read_text()
for token in (
 'local function calendarHolidayActive(required)',
 'type(cal.GetNumDayEvents) ~= "function"',
 'type(cal.GetDayEvent) ~= "function"',
 'read(clock.GetCurrentCalendarTime)',
 'read(cal.GetNumDayEvents, 0, day)',
 'ordinary(read(cal.GetDayEvent, 0, day, index), "table")',
 'if eventType == "HOLIDAY" then',
 'lunarfestival = "lunar-festival"',
 '[-366] = "lunar-festival"',
 'local category, categoryKnown = optionalNumber("zoneOrSort")',
 'local requiredHoliday = HOLIDAY_QUEST_SORT[category]',
 'if active ~= true then return false, reason end',
 '"CALENDAR_UPDATE_EVENT_LIST"',
 'if type(currentQuestOffers) == "table" then',
 'if type(id) == "number" and currentQuestOffers[id] == true then',
 'self:InvalidateEligibility(event)',
): assert token in s, token
for forbidden in ('C_Timer', 'SetCVar(', 'UnitPosition(', 'HideUIPanel('):
 assert forbidden not in s,forbidden
assert len(re.findall(r'zoneOrSort',s)) <= 5
assert 'holiday-inactive:' in s and 'holiday-calendar-incomplete' in s
assert (R/'docs/memory/evidence/P0509_LUNAR_QUEST_EVENT_GATE.md').exists()
assert '| L-030 |' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
engine=shutil.which('lua') or shutil.which('lua5.4') or shutil.which('texlua')
if engine:
 subprocess.run([engine,str(R/'tools/test_p0509_lunar_event_gate.lua'),str(R)],cwd=R,check=True)
else: print('P0509 Lua source fixture DEFERRED: no interpreter')
print('P0509 historical contract PASS: Lunar -366 retained under P0510 generalized calendar gate')
