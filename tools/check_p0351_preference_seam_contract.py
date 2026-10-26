#!/usr/bin/env python3
"""P0351: preference diagnostic extraction; source contracts, runtime deferred."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding="utf-8")
C = read("Logres/Core/Commands.lua")
P = read("Logres/Core/Preferences.lua")
T = read("Logres/Logres.toc")
B = read("Logres/Core/Bootstrap.lua")
CUR = read("docs/memory/CURRENT.md")
HAND = read("docs/memory/handoffs/CURRENT_HANDOFF.md")


def need(condition, reason):
    if not condition:
        raise AssertionError(reason)


def extract(source, signature):
    need(source.count(signature) == 1, "missing/nonunique function " + signature)
    a = source.index(signature)
    b = source.index("\nend\n", a) + len("\nend\n")
    return source[a:b]


wrapper = extract(C, "local function runPreferenceCheck()\n")
need(wrapper == ("local function runPreferenceCheck()\n"
                 "    Logres:RunDevPreferenceCheck(emit, boolText)\nend\n"),
     "existing command wrapper must delegate once with original emit/boolText")
need(C.count("Logres:RunDevPreferenceCheck(emit, boolText)") == 1,
     "preference delegation must not be duplicated")
report = extract(P, "function Logres:RunDevPreferenceCheck(emit, boolText)\n")
need(P.count("function Logres:RunDevPreferenceCheck(emit, boolText)") == 1,
     "Preferences must own exactly one development diagnostic")
for token in (
    "Logres preferencecheck: PASS (snapshot isolation=true, callbacks=2, revision=%s, immersionEnabled=%s)",
    "Logres preferencecheck: FAIL (snapshotIsolation=%s noopStable=%s changeSemantics=%s callbacks=%s revision=%s immersionEnabled=%s)",
):
    need(report.count(token) == 1 and token not in C,
         "PASS/FAIL report lost or duplicated/retained in Commands: " + token)
need(report.count("emit(string.format(") == 2,
     "exact original PASS and FAIL emission count required")
need(report.count("boolText(final.immersionEnabled)") == 2,
     "original boolean formatting on PASS and FAIL required")
for token in (
    "original.immersionEnabled = not originalValue",
    "afterMutation.immersionEnabled == originalValue",
    "Logres:SubscribePreferences(function()",
    '"DEV_PREFERENCECHECK_NOOP"',
    '"DEV_PREFERENCECHECK_CHANGE"',
    '"DEV_PREFERENCECHECK_RESTORE"',
    "noopChanged == false",
    "afterNoop.revision == afterMutation.revision",
    "callbackCount == 0",
    "changedAway == true",
    "changedBack == true",
    "callbackCount == 2",
    "final.immersionEnabled == originalValue",
    "final.revision == afterNoop.revision + 2",
    "unsubscribe()",
):
    need(token in report, "historical preference diagnostic semantics absent: " + token)
need(report.index('"DEV_PREFERENCECHECK_NOOP"') <
     report.index('"DEV_PREFERENCECHECK_CHANGE"') <
     report.index('"DEV_PREFERENCECHECK_RESTORE"') <
     report.index("unsubscribe()"),
     "original no-op/change/restore/unsubscribe ordering lost")
for token in ("C_Timer.", "RegisterEvent(", "SetScript(",
              "GetAttribute(", "IsShown(", ":Hide(", ":Show(",
              "SetParent(", "SetPoint(", "hooksecurefunc("):
    need(token not in report, "diagnostic gained unsafe UI/polling action: " + token)
need(P.index("function Logres:SetPreference(name, value, reason)") <
     P.index("function Logres:RunDevPreferenceCheck(emit, boolText)"),
     "existing public preference setter must remain defined before developer report")
need('Core\\Preferences.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Core\\Preferences.lua') < T.index('Core\\Commands.lua'),
     "Preferences must load before Commands")
need(len([l for l in T.splitlines() if l.endswith('.lua')]) == 94,
     "94 module TOC inventory must remain")
need(re.search(r'(?m)^## Version: (\S+)$', T).group(1) ==
     re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B).group(1),
     "TOC/Bootstrap version parity lost")
for token in ('local function runPreferenceCheck()',
              '    runPreferenceCheck()', 'if command == "preferencecheck" then',
              '"preferencecheck"', '"preference",'):
    need(token in C, "Run All/command/panel registration missing: " + token)
need(C.index('    runStateCheck()') < C.index('    runSensorCheck()') <
     C.index('    runPreferenceCheck()') < C.index('    runLifecycleCheck()'),
     "Run All order changed")
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     "120 original developer-panel registrations required")
legacy = read("tools/check_status_aura_disabled_contract.py")
need("'local function runPreferenceCheck()'" in legacy and
     "'    runPreferenceCheck()'" in legacy,
     "P0175 historical preference transition coverage weakened")
legacy_pref = read("tools/check_preference_contract.py")
need("'Logres:SetPreference('" in legacy_pref and
     '"/logres preferencecheck"' in legacy_pref,
     "A.3 historical preference contract weakened")
legacy_350 = read("tools/check_p0350_state_sensor_seam_contract.py")
need('RunDevStateCheck(emit)' in legacy_350 and
     'RunDevSensorCheck(emit, boolText)' in legacy_350,
     "P0350 state and sensor contract lost")
for token in ("P0351", "P0350", "P0349", "P0348", "P0347", "P0346",
              "P0321", "D-048", "L-019", "L-022", "L-027", "L-028",
              "UNVERIFIED", "L-031", "cfdc07af"):
    need(token in CUR and token in HAND, "CURRENT/HANDOFF continuity " + token)
for n in range(317, 351):
    need(f"P{n:04d}" in HAND, "historical handoff missing P%04d" % n)
for n in range(317, 338):
    need(f"P{n:04d}" in CUR, "historical CURRENT missing P%04d" % n)
need(len(CUR.encode("utf-8")) < 9800, "CURRENT maintenance budget exceeded")
for p in ("docs/ROADMAP.md", "docs/memory/investigations/ACTIVE.md",
          "docs/memory/roadmap/STATUS.md", "docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md",
          "docs/memory/patches/PATCH_INDEX.md"):
    need("P0351" in read(p), "missing roadmap/index checkpoint " + p)
for p in ("docs/memory/evidence/P0351_PREFERENCE_SEAM.md",
          "docs/memory/patches/P0351_PREFERENCE_SEAM.md"):
    doc = read(p)
    for token in ("P0351", "P0350", "P0321", "222", "UNVERIFIED", "OPEN"):
        need(token in doc, "missing record provenance/safety gate: " + p + " " + token)
    need(doc.endswith("\n") and not doc.endswith("\n\n") and "\r" not in doc,
         "record EOF hygiene")
need(len(list((ROOT / "tools").glob("check_*.py"))) >= 222,
     "new checker #222 missing")
print("P0351 preference diagnostic seam: PASS (STATIC; WoW UNVERIFIED)")
