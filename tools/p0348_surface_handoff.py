"""P0348: pure D-048 surface-specific handoff contract, NEVER loaded by WoW.

This is a specification fixture. Inputs `capable`, `fallback_ready`, and
`restored` MUST come from separately validated evidence in a future runtime
controller. No observation, native ownership assertion, persistence, or IO.
"""
from __future__ import annotations

from typing import Mapping
from p0324_domain_policy import DOMAINS, MODES, from_mask


# A domain selector never implicitly claims a still-unreplaced stock control.
# `logres_candidate` is not a runtime capability assertion.
SURFACES = (
    ("NAV", "compass", "logres_candidate"),
    ("NAV", "minimap-and-tracking", "stock_required"),
    ("ACT", "primary-actions", "logres_candidate"),
    ("ACT", "secondary-utility", "logres_candidate"),
    ("ACT", "pet-controls", "stock_required"),
    ("ACT", "special-vehicle-override", "stock_required"),
    ("NPC", "quest-narrative", "logres_candidate"),
    ("NPC", "gossip-choices", "logres_candidate"),
    ("NPC", "trainer-presentation", "logres_candidate"),
    ("NPC", "quest-transactions", "stock_required"),
    ("NPC", "merchant-transactions", "stock_required"),
    ("NPC", "flight-transactions", "stock_required"),
    ("STATUS", "player-tunnel", "logres_candidate"),
    ("STATUS", "target-presentation", "logres_candidate"),
    ("STATUS", "target-auras", "logres_candidate"),
    ("STATUS", "party-and-compact-party", "stock_required"),
    ("STATUS", "target-of-target", "stock_required"),
    ("STATUS", "native-aura-fallback", "stock_required"),
    ("CAM", "camera-profile", "stock_required"),  # D-047 frozen baseline
)
SURFACE_KEYS = tuple(name for _, name, _ in SURFACES)
STOCK_REQUIRED = frozenset(name for _, name, mode in SURFACES if mode == "stock_required")
CANDIDATES = frozenset(name for _, name, mode in SURFACES if mode == "logres_candidate")


def _validate(name: str, values: Mapping, keys, allowed) -> None:
    if type(values) is not dict or set(values) != set(keys):
        raise ValueError(f"{name}: expected exactly {len(keys)} keys")
    if any(type(value) not in allowed for value in values.values()):
        raise ValueError(f"{name}: invalid value type")


def empty_capabilities():
    """Conservative baseline: no new domain ownership has been runtime proven."""
    return {key: False for key in SURFACE_KEYS}


def evaluate(requested, capable, fallback_ready, current=None, restored=None):
    """Pure requested/effective/pending/fallback-per-surface model.

    Explicit `capable` and `fallback_ready` attestations are independent.
    A requested domain does NOT imply these are true. Leaving a Logres-owned
    surface requires evidence of native restoration BEFORE relinquishment.
    """
    _validate("requested", requested, DOMAINS, {str})
    if any(value not in MODES for value in requested.values()):
        raise ValueError("requested: invalid mode")
    _validate("capable", capable, SURFACE_KEYS, {bool})
    _validate("fallback_ready", fallback_ready, SURFACE_KEYS, {bool})
    if current is None:
        current = {key: "blizzard" for key in SURFACE_KEYS}
    if restored is None:
        restored = {key: current[key] == "blizzard" for key in SURFACE_KEYS}
    _validate("current", current, SURFACE_KEYS, {str})
    _validate("restored", restored, SURFACE_KEYS, {bool})
    if any(mode not in MODES for mode in current.values()):
        raise ValueError("current: invalid mode")
    if any(current[key] != "blizzard" for key in STOCK_REQUIRED):
        raise ValueError("stock-required surface cannot have Logres effective owner")

    result = {}
    for domain, surface, kind in SURFACES:
        wish = requested[domain]
        if kind == "stock_required":
            effective, reason, pending = "blizzard", "stock-required", False
        elif wish == "blizzard":
            effective, reason, pending = "blizzard", "native-selected", False
        elif not capable[surface]:
            effective, reason, pending = "blizzard", "capability-unproven", False
        elif not fallback_ready[surface]:
            effective, reason, pending = "blizzard", "fallback-unproven", False
        else:
            effective, reason, pending = "logres", "activation-eligible", False
        if current[surface] == "logres" and effective == "blizzard" and not restored[surface]:
            effective, reason, pending = "logres", "native-restore-deferred", True
        result[surface] = {
            "domain": domain,
            "requested": wish,
            "effective": effective,
            "fallback": "native-required" if effective == "logres" else "native",
            "pending": pending,
            "reason": reason,
        }
    return result


def evaluate_mask(mask, capable=None, fallback_ready=None):
    return evaluate(from_mask(mask), capable or empty_capabilities(),
                    fallback_ready or empty_capabilities())
