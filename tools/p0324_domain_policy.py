"""P0324 deterministic *specification fixture*; never loaded by WoW.

Not a live controller, native-frame probe, preference migration or secure-action API.
The later Forever implementation must match these pure policy observations.
"""
from __future__ import annotations
from copy import deepcopy

DOMAINS = ("NAV", "ACT", "NPC", "STATUS", "CAM")
MODES = ("blizzard", "logres")
COVERAGE = ("full", "partial", "none")


def _mapping(name, value, allowed):
    if not isinstance(value, dict) or set(value) != set(DOMAINS):
        raise ValueError(name + " requires exactly five named domains")
    if any(type(value[d]) is not str or value[d] not in allowed for d in DOMAINS):
        raise ValueError(name + " has an unsupported domain value")


def _booleans(name, value):
    if not isinstance(value, dict) or set(value) != set(DOMAINS):
        raise ValueError(name + " requires exactly five named domains")
    if any(type(value[d]) is not bool for d in DOMAINS):
        raise ValueError(name + " requires real booleans")


def from_mask(mask):
    """All 32 requested modes; mask ordering remains explicit and stable."""
    if type(mask) is not int or not 0 <= mask < (1 << len(DOMAINS)):
        raise ValueError("domain selection mask must be an integer from 0 to 31")
    return {d: "logres" if mask & (1 << i) else "blizzard"
            for i, d in enumerate(DOMAINS)}


def evaluate(requested, coverage, current=None, restored=None):
    """Pure requested/effective/fallback/pending *model*, not runtime observation.

    `coverage` is an externally verified capability assertion, not detected here.
    `restored` is the caller's externally verified restoration evidence, not a
    claim about any Blizzard frame. Missing coverage falls back to Blizzard.
    When leaving Logres but restoration is not proven, keep the existing Logres
    effective owner and report pending, never abandon the usable surface.
    """
    _mapping("requested", requested, MODES)
    _mapping("coverage", coverage, COVERAGE)
    if current is None:
        current = {d: "blizzard" for d in DOMAINS}
    if restored is None:
        restored = {d: True for d in DOMAINS}
    _mapping("current", current, MODES)
    _booleans("restored", restored)
    outcome = {}
    for d in DOMAINS:
        wish = requested[d]
        if wish == "blizzard" and current[d] == "logres" and not restored[d]:
            item = ("logres", "pending-restore", True, "native-restore-deferred")
        elif wish == "blizzard":
            item = ("blizzard", "native", False, "native-selected")
        elif coverage[d] == "none":
            item = ("blizzard", "native", False, "capability-unavailable")
        elif coverage[d] == "partial":
            item = ("logres", "native-required", False, "partial-capability")
        else:
            item = ("logres", "native-available", False, "full-capability")
        outcome[d] = dict(requested=wish, effective=item[0],
                          fallback=item[1], pending=item[2], reason=item[3])
    return outcome


def legacy_passthrough(settings):
    """No migration: preserve schema-3 data until live transition is authorized."""
    if not isinstance(settings, dict):
        raise ValueError("legacy settings must be a mapping")
    if type(settings.get("immersionEnabled")) is not bool or \
       type(settings.get("activeQuestEnabled")) is not bool:
        raise ValueError("legacy booleans must be explicit and valid")
    return {"state": "not-migrated", "requires_runtime_migration": True,
            "existing_settings": deepcopy(settings), "domain_preferences": None}
