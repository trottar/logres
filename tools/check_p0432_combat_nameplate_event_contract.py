#!/usr/bin/env python3
"""P0432: retain event-time current-target world-anchor evidence in Report Bug."""
from pathlib import Path
import re

R = Path(__file__).resolve().parents[1]
P = (R / "Logres/HUD/WorldTargetProbe.lua").read_text(encoding="utf-8")
D = (R / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
T = (R / "Logres/Logres.toc").read_text(encoding="utf-8")
B = (R / "Logres/Core/Bootstrap.lua").read_text(encoding="utf-8")

def need(ok, message):
    if not ok:
        raise AssertionError("P0432: " + message)

anchor = P[P.index('function Probe:RecordEventAnchor(reason, capture)'):
           P.index('function Probe:CaptureManual()')]
for token in ('readBoolean(InCombatLockdown)', 'sanitizedBoolean(combat)',
              'active == nil', 'capture.anchor.secret ~= true',
              'targetAnchorEverSeenInCombat = true',
              'worldCandidateEverSeenOutOfCombat = true',
              'lastCombatFallback = capture.fallback',
              'lastCombatAttachmentState = attachmentState(capture.attachment)'):
    need(token in anchor, 'event-time observation/guard missing: '+token)
for forbidden in ('SetPoint(', 'ClearAllPoints(', 'GetNamePlates(',
                  'UnitThreatSituation(', 'GetNamePlateForUnit('):
    need(forbidden not in anchor, 'event sample must not call native/mutating API: '+forbidden)
need('eventFrame:SetScript("OnEvent", function(_, event)' in P and
     'self:RecordEventAnchor(event, capture)' in P and
     'self:RecordEventAnchor("enable", self.lastCapture)' in P,
     'event payload discard or event/initial capture lost')
need('local anchor, anchorFrame = readNameplate()' in P and
     'attachment = self:TestAttachment(anchorFrame)' in P and
     '"target",\n        false' in P,
     'original target-only, includeForbidden=false anchor gate changed')
need('self:Capture("enable")' in P and
     'self:Capture(event)' in P and 'probe:CaptureManual()' in D,
     'existing automatic/manual capture changed')
status = P[P.index('function Probe:GetDebugStatus()'):
           P.index('function Probe:OnInitialize()')]
trace = D[D.index('    incident.snapshot.worldTarget = '):
          D.index('    incident.snapshot.questPresentation = ')]
fields = ('combatEventSamples','outOfCombatEventSamples','combatStateUnknownSamples',
          'targetAnchorEverSeenInCombat','targetAnchorEverSeenOutOfCombat',
          'worldCandidateEverSeenOutOfCombat','lastCombatEvent',
          'lastCombatPositiveEvent','lastCombatAnchorPresent',
          'lastCombatFallback','lastCombatAttachmentState','lastOutOfCombatEvent')
for field in fields:
    need(field+' =' in status and '"'+field+'"' in trace,
         'sanitized event evidence absent from status or Report Bug: '+field)
need('"anchorPresent"' in trace and '"attachmentState"' in trace and
     '"fallback"' in trace and '"secretSkipCount"' in trace,
     'P0431 Report Bug evidence replaced')
need('targetAnchorEverSeenInCombat = false' in P and
     'targetAnchorEverSeenOutOfCombat = false' in P,
     'per-session latches not initialized')
need('"NAME_PLATE_UNIT_ADDED"' in P and
     '"NAME_PLATE_UNIT_REMOVED"' in P and
     '"PLAYER_TARGET_CHANGED"' in P,
     'existing current-target event routes altered')
need('SetCVar(' not in P and 'GetNamePlates(' not in P and
     'UnitThreatSituation(' not in P,
     'no nameplate setting/enumeration/threat-value use is authorized')
vt = re.search(r'(?m)^## Version: (\S+)$', T)
vb = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B)
need(bool(vt and vb and vt.group(1)==vb.group(1)),
     'TOC/Bootstrap dynamic version parity lost')
print('P0432: PASS (STATIC; Forever attachment/aggro UNVERIFIED)')
