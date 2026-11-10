#!/usr/bin/env python3
"""P0431: on-screen debug entry and one-click world-target incident contract."""
from pathlib import Path
R = Path(__file__).resolve().parents[1]
P = (R / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
C = (R / "Logres/Core/Commands.lua").read_text(encoding="utf-8")

def need(condition, message):
    if not condition:
        raise AssertionError("P0431 " + message)

start = P.index('    incident.snapshot.worldTarget = ')
end = P.index('    incident.snapshot.questPresentation = ', start)
segment = P[start:end]
for token in ('probe:CaptureManual()', 'probe:GetDebugStatus()',
              '"anchorPresent"', '"attachmentState"', '"worldCandidate"',
              '"fallback"', '"reactionCategory"',
              '"nameplateAddedEvents"', '"nameplateRemovedEvents"',
              '"secretSkipCount"', '"failureCount"'):
    need(token in segment, 'missing diagnostic field/capture ' + token)
for forbidden in ('GetNamePlateForUnit', 'SetPoint(', 'GetPoint(',
                  'UnitHealth(', 'UnitAura(', 'SetAttribute('):
    need(forbidden not in segment, 'incident directly inspects/mutates ' + forbidden)
need('incident.snapshot.worldTarget' in P[P.index('function Logres:CaptureBugIncident()'):P.index('journal.incidents[#journal.incidents + 1] = incident')],
     'WorldTarget capture not retained in incident')
click = P.split('bugButton:SetScript("OnClick", function(_, button)', 1)[1].split('end)', 1)[0]
need('if button == "RightButton" then' in click and
     'Logres:ToggleDevPanel()' in click and
     'Logres:CaptureBugIncident()' in click,
     'left report/right panel dispatch missing')
need('bugButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")' in P,
     'debug button missing both click routes')
need('frame:Hide() -- Panel is opened explicitly' in P and
     'self.frame:Hide() -- Do not open the panel automatically on login.' in P,
     'panel not closed by default')
for anchor in ('    if command == "" then\n        printStatus()',
               '    if command == "panel" then\n        emit('):
    need(anchor in C, 'slash still opens panel: ' + anchor)
need('function Logres:ToggleDevPanel()' in P,
     'stock panel toggle primitive removed')
print('P0431 debug/worldtarget incident: PASS (STATIC ONLY)')
