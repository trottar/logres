#!/usr/bin/env python3
"""P0350: state/sensor diagnostic ownership seam; source-only, runtime deferred."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding="utf-8")
C = read("Logres/Core/Commands.lua")
S = read("Logres/Core/State.lua")
T = read("Logres/Logres.toc")
B = read("Logres/Core/Bootstrap.lua")
CUR = read("docs/memory/CURRENT.md")
HAND = read("docs/memory/handoffs/CURRENT_HANDOFF.md")

def need(condition, reason):
    if not condition:
        raise AssertionError(reason)

def extract(text, signature):
    need(text.count(signature) == 1, "duplicate/missing entry " + signature)
    p = text.index(signature)
    end = text.index("\nend\n", p) + len("\nend\n")
    return text[p:end]

# Command-local functions remain in place for every historical consumer.
need(extract(C, "local function runStateCheck()\n") ==
     "local function runStateCheck()\n    Logres:RunDevStateCheck(emit)\nend\n",
     "state command must forward to preloaded State with original sink")
need(extract(C, "local function runSensorCheck()\n") ==
     "local function runSensorCheck()\n    Logres:RunDevSensorCheck(emit, boolText)\nend\n",
     "sensor command must forward original sink and boolean representation")
state = extract(S, "function Logres:RunDevStateCheck(emit)\n")
sensor = extract(S, "function Logres:RunDevSensorCheck(emit, boolText)\n")
for line in (
    "Logres statecheck: PASS (snapshot isolation=true, no-op revision=%s, callbacks=0)",
    "Logres statecheck: FAIL (snapshotIsolation=%s changed=%s revisionBefore=%s revisionAfter=%s callbacks=%s)",
):
    need(state.count(line) == 1 and line not in C,
         "state report text not owned exclusively by State")
for line in (
    "Logres sensorcheck: PASS (mounted=%s resting=%s taxi=%s interact=%s/%s)",
    "Logres sensorcheck: FAIL (mounted=%s/%s resting=%s/%s taxi=%s/%s interact=%s/%s)",
):
    need(sensor.count(line) == 1 and line not in C,
         "sensor report text not owned exclusively by State")
need(state.count("emit(string.format(") == 2 and
     sensor.count("emit(string.format(") == 2,
     "original PASS/FAIL branches must each emit once")
for marker in (
    'before.context = "__consumer_mutation_test__"',
    'afterMutation.context == expectedContext',
    'Logres:SubscribeState(function()',
    'Logres:RefreshState("DEV_STATECHECK_NOOP")',
    'unsubscribe()',
    'changed == false',
    'afterRefresh.revision == revisionBefore',
    'callbackCount == 0',
):
    need(marker in state, "state test semantics lost: " + marker)
for marker in (
    'UnitOnTaxi("player") and true or false',
    'IsMounted() and not apiTaxi',
    'IsResting() and true or false',
    'state.mounted == (apiMounted and true or false)',
    'state.resting == apiResting',
    'state.onTaxi == apiTaxi',
    'state.interacting == (state.interactionType ~= 0)',
):
    need(marker in sensor, "sensor comparison semantics lost: " + marker)
for b in (state, sensor):
    for forbidden in ('C_Timer.', 'RegisterEvent(', 'SetScript(',
                      'GetAttribute(', 'IsShown(', ':Hide(', ':Show(',
                      'SetParent(', 'SetPoint(', 'hooksecurefunc('):
        need(forbidden not in b, "new protected/UI/polling operation in diagnostic: " + forbidden)
need(S.index('function Logres:RefreshState(reason)') <
     S.index('function Logres:RunDevStateCheck(emit)') <
     S.index('local function refreshFromEvent('),
     "diagnostics must be in State after normal refresh, before event dispatch")
need(S.index('function Logres:RunDevStateCheck(emit)') <
     S.index('function Logres:RunDevSensorCheck(emit, boolText)'),
     "original state/sensor order lost")
for marker in ('runStateCheck()', 'runSensorCheck()',
               'if command == "statecheck" then', 'if command == "sensorcheck" then',
               '"state",', '"sensor",'):
    need(marker in C, "slash/Run All/panel routing missing: " + marker)
need('Core\\State.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Core\\State.lua') < T.index('Core\\Commands.lua'),
     'State must be loaded before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')]) == 94,
     'Lua load inventory changed')
need(re.search(r'(?m)^## Version: (\S+)$', T).group(1) ==
     re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B).group(1),
     'TOC and Bootstrap versions diverge')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     'panel action count changed')
need('Logres:GetState()' in C, 'legacy Commands state consumer contract lost')
for marker in ('P0350', 'P0349', 'P0348', 'P0347', 'P0346', 'P0321',
               'D-048', 'L-019', 'L-022', 'L-027', 'L-028',
               'UNVERIFIED', 'L-031', 'cfdc07af'):
    need(marker in CUR and marker in HAND, 'memory continuity ' + marker)
for n in range(317, 350):
    need(f'P{n:04d}' in HAND, 'historical handoff missing P%04d' % n)
for n in range(317, 338):
    need(f'P{n:04d}' in CUR, 'historical CURRENT missing P%04d' % n)
need(len(CUR.encode('utf-8')) < 9800, 'CURRENT health budget exceeded')
for p in ('docs/ROADMAP.md', 'docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0350' in read(p), 'missing roadmap/index checkpoint ' + p)
for p in ('docs/memory/evidence/P0350_STATE_SENSOR_SEAM.md',
          'docs/memory/patches/P0350_STATE_SENSOR_SEAM.md'):
    d = read(p)
    for marker in ('P0350', 'P0349', 'P0321', '221', 'UNVERIFIED', 'OPEN'):
        need(marker in d, 'missing source/evidence provenance in ' + p + ': ' + marker)
    need(d.endswith('\n') and not d.endswith('\n\n') and '\r' not in d,
         'record EOF hygiene')
need('Logres:GetState()' in read('tools/check_state_contract.py') and
     '"statecheck"' in read('tools/check_dev_panel_contract.py'),
     'historical state/panel safety checkers must remain')
need(len(list((ROOT / 'tools').glob('check_*.py'))) >= 221,
     'P0350 checker #221 missing')
print('P0350 state/sensor seam: PASS (STATIC; WoW UNVERIFIED)')
