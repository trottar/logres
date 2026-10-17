# P0233 — Automatic compass startup and one physical quest-giver match

Date: 2026-10-17. GitHub `main` baseline P0232 `ca639c9`. Evidence: user-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` (0.0.137-dev, loadCount 307) and direct user gameplay observation.

## Positive runtime evidence

- After a normal `/reload`, the user performed **Compass Check before QuestieDB Location Probe**. Load 307 `status` precedes one `compasscheck`; there is no `questiedbprobe` or `panel-map-diagnostic` recorded at load 307.
- `Logres compass nearby: provider=ready candidates=4 shown=2`. Therefore nearby-provider readiness and addon-owned compass marker state were observed **without manual panel-driven retry in this load**. This closes the narrow P0232 startup-readiness question for the tested login/map; it does not verify all zones or future reloads.
- The user reports that actual compass markers appeared, that following one marker led **directly to a quest-giver NPC**, and that the directions were useful. This is **one user-observed positive physical location match**, independent of the in-addon candidate count. NPC ID, quest eligibility, quest offer, and matching database row were not captured; none is asserted.
- The user perceived many possible quest-giver markers, not exclusively those appearing close by; they explicitly consider this acceptable for initial tests. At the instant of the exported `compasscheck`, the addon reported four candidates and two shown. These are snapshots and do not establish total markers encountered over movement. The 50-yard QuestieDB source filter remains configured; no broad-distance rendering defect is reproduced from these observations.
- The historical P0230 load 305 `map-not-in-provider-zone-table` / zero-scan result is retained as a real failure; load 306 source readiness was obtained after manual retry. Neither failure is retroactively erased by load 307 success.

## Limits and next work

- Runtime source and visual wayfinding **PASS within the tested local context**; one observed physical quest-giver match. Unassisted startup **PASS for load 307**. Universal zone coverage, navigation through zone transitions, verified active quest availability, NPC categorization, all service/tracking POIs, and exact world-spawn identity coverage remain OPEN.
- Database records indicate possible historical NPC spawn points, not proof an eligible quest is currently available. Keep Logres compass primary; hidden Blizzard minimap is not a visible substitute.
- The current four-candidate / two-shown snapshot does not justify a new poller, forced rescan, radius change, coordinate guesses, or additional travel tests.
- Next H.3 work is a narrow category-and-presentation coverage audit: distinguish native/current, QuestieDB candidate, and unavailable live tracking feeds; inspect existing glyph caps and prioritization before changing behavior. Protect P0223 focused quest / waypoint paths. No runtime change is part of P0233.

Status: **P0233 DOCS-ONLY EVIDENCE CHECKPOINT**, no in-game redeployment required.
