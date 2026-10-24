# P0327 — Merchant and flight-master inert presentation model fixtures

**Baseline:** verified pushed P0326 `7949d7c` on GitHub `main`, source audit `P0326_MERCHANT_FLIGHT_AUDIT.md`. **Evidence:** authored offline Python models only. **WoW visual/runtime UNVERIFIED.** This checkpoint does not implement an in-game D-046 preview, a live adapter or a merchant/flight controller.

## Narrow question

Can merchant and flight use a **common, read-only presentation envelope** for deterministic empty, unavailable, descriptive and handoff states without confusing it with Blizzard transactions or route-map identity? **Fixture result: YES within synthetic model scope; real source and rendering remain separately unproven.**

## Model contract

`tools/p0327_service_model.py` implements `fixture(service, scenario)`: two families (`merchant`, `flight`) times four states (`sample-list`, `sample-empty`, `source-unavailable`, `native-handoff`) = **8 deterministic inert scenarios**. Each fresh returned value contains `source=authored-fixture`, `sourceVerified=false`, `previewOnly=true`, `renderingStatus=model-only-not-in-game`, `nativeOwner=Blizzard`, `nativeFrame=unresolved`, and no executable actions. Rows contain only synthetic label/description/nonactionable metadata—no item IDs, route IDs, costs, fares, availability, purchasing, repair or travel APIs. Values must never be represented as live game state.

| Fixture state | Merchant | Flight | Shared guarantee |
| --- | --- | --- | --- |
| `sample-list` | Illustrative catalogue descriptions | Illustrative destination descriptions | Synthetic labels only, no identity or actions |
| `sample-empty` | Synthetic zero-row panel | Synthetic zero-route panel | Does **not** assert an actual empty NPC inventory or route map |
| `source-unavailable` | Source unavailable | Source unavailable | Native service remains accessible; no guessed data |
| `native-handoff` | Use native browse/buy/sell/repair | Use native map/fare/travel | No Logres transaction or travel handler |

Merchant required native controls: Browse, Sell, Buyback, Repair, Close. Flight required native controls: Route map, Fares, Route selection, Travel, Close. Every fixture preserves the full appropriate native-control category list, even if source data is absent or the presentation is empty. **No native roots are suppressed or moved.**

## Exact reuse boundaries

Current Lua already includes a pure `NPCServiceCatalogue.Filter/Window/Find`, a source-neutral `NPCServiceEmptyState.Build`, `NPCOptionModel.Preview(services)`, and `PanelSurface.Paint`, plus trainer-scoped `NPCServiceSession`. These are **candidate integration seams**, not proof of compatibility with this Python-only envelope. D-046 requires actual WoW `P — Previews` using the **same renderer and model** as live data, with visual acceptance before guarded API binding; P0327 does **not** satisfy that visual criterion. If later implemented, keep the source adapter, model, renderer and transaction controller separate; use a service-specific capability gate.

`FlightMapFrame` (service policy) and `TaxiFrame` (element index) remain conflicting *candidate source hints*, not a defect or verified native-frame ownership. Merchant `MerchantFrame` remains a source candidate. `NPCServiceSession` is registered only for trainer and neither parking implementation supports merchant/flight. No additional registration, OnShow/OnHide hook, parking, native geometry inspection, fake service identity, camera interaction or auto-travel is allowed by this fixture. D-047 frozen camera and D-048 five-domain independence are preserved.

## Next gates

1. Keep full Blizzard merchant/flight usability for alpha and leave L-003/L-004 **FEATURE GAP / runtime untested**.
2. On November 4, prioritize P0321 gossip native-root restoration. With a naturally open merchant or flight master, use developer panel H **Native Service Frame Audit** and H **Native NPC Services Check**, both READ-ONLY; avoid H **Native Auto Position (TEST)**. Verify actual root/readiness, stock close, control usability and handoff without forced purchases or flights.
3. After source and native fallback proof, implement an **inert in-game P — Previews visual** consuming a matching Lua presentation model and the eventual production renderer, not a look-alike. Only then consider a guarded live adapter, with no native transactions/flight routing unless separately proven.

**Negative evidence:** No Forever source read, item/route identity, merchant buy/sell/repair, flight travel, native-root restore, visual preview, or runtime service registration was attempted in P0327. No new runtime defect was reproduced. P0321 remains **WoW UNVERIFIED / deferred** and Quest 237 remains reserved. Static model tests establish only model consistency and non-transactional boundaries.
