"""P0327 authored, inert merchant/flight service presentation MODEL FIXTURES.

Offline Python-only planning samples; not the live Lua renderer, a source reader,
a WoW visual preview, a secure/native transaction adapter, or runtime evidence.
Do not load into Logres.toc or wire action handlers to these models.
"""
from copy import deepcopy

SERVICES = ("merchant", "flight")
SCENARIOS = ("sample-list", "sample-empty", "source-unavailable", "native-handoff")
STOCK = {
    "merchant": ("Browse", "Sell", "Buyback", "Repair", "Close"),
    "flight": ("Route map", "Fares", "Route selection", "Travel", "Close"),
}

# Deliberate synthetic labels without identities, eligibility, money, fares,
# route connectivity or transactional instructions. They are NOT game data.
EXAMPLES = {
    "merchant": (
        ("Illustrative supply", "Synthetic catalogue text"),
        ("Illustrative equipment", "Synthetic catalogue text"),
    ),
    "flight": (
        ("Illustrative destination", "Synthetic map description"),
        ("Illustrative connection", "Synthetic map description"),
    ),
}


def fixture(service, scenario):
    """Produce a fresh, display-only model with explicit native fallback.

    Every field is authored synthetic material. There are no command IDs,
    enabled controls, source references or native Blizzard frame reads.
    """
    if type(service) is not str or service not in SERVICES:
        raise ValueError("service must be merchant or flight")
    if type(scenario) is not str or scenario not in SCENARIOS:
        raise ValueError("unknown synthetic scenario")
    if scenario == "sample-list":
        message = "Illustrative entries only; the Blizzard service remains authoritative."
        rows = [{"label": label, "description": detail, "actionable": False}
                for label, detail in EXAMPLES[service]]
    elif scenario == "sample-empty":
        message = "Synthetic zero-row layout; not evidence the native catalogue is empty."
        rows = []
    elif scenario == "source-unavailable":
        message = "Service data unavailable; leave native presentation and control intact."
        rows = []
    else:
        message = "Continue in Blizzard's native service; no Logres transaction or travel."
        rows = []
    return deepcopy({
        "service": service,
        "scenario": scenario,
        "source": "authored-fixture",
        "sourceVerified": False,
        "previewOnly": True,
        "renderingStatus": "model-only-not-in-game",
        "title": "Merchant service" if service == "merchant" else "Flight service",
        "message": message,
        "rows": rows,
        "nativeOwner": "Blizzard",
        "nativeRequired": list(STOCK[service]),
        "nativeFrame": "unresolved",  # Even MerchantFrame is a candidate, not proven.
        "nativeControlsPreserved": True,
        "interactions": [],
        "canPurchase": False,
        "canSell": False,
        "canRepair": False,
        "canSelectRoute": False,
        "canTravel": False,
    })
