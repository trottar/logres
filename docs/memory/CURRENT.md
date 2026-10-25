---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item
**P0336 — L-032 compass glyphs on one true-bearing baseline; PREPARED / WoW UNVERIFIED.** GitHub `main` verified pushed P0335 `ffdbbca3ccb4de7e8f504f57387845f3a2c0e318` (2026-10-25), 206/206 PRE/POST manifest; L-027 native popup provenance diagnostic is committed, transient Blizzard owner OPEN. Source investigation of `Compass:RefreshAvailableQuestPOIs` confirms that vertical lane increments and family-specific offsets cause stacked/fanned quest/POI/service/tracking symbols. P0336 uses a shared fixed-bearing horizontal interval reservation for all four families plus existing user waypoint. Colliding secondary glyphs are hidden (with diagnostic count), never moved to false bearings or vertically stacked. Same geometry helper in already-approved Compass Art preview and live painter; P0220/P0222 historical contracts migrated. No navigation source, quest eligibility, distance, native minimap, camera, UI security, saved preference or P-tab registry changes. 207 static contracts required; WoW closed until November 4.

## Verified State
- Verified GitHub main P0335 `ffdbbca` (2026-10-25) pushed, manifest 206/206 PREWRITE/POSTWRITE; L-027 popup owner remains unidentified and WoW UNVERIFIED.
- Verified GitHub main P0334 R3 push `1b7b1ff` (2026-10-25), 205/205 PRE/POST static manifest; R0/R1/R2 historic contract failures retained. L-023 PvP in-client visual/source remains UNVERIFIED.
- Verified GitHub `main` P0333 push `68c0955` (2026-10-25), manifest records 204/204 PREWRITE and POSTWRITE static checks. Pet keybind/active outline runtime remains UNVERIFIED.
- Verified GitHub main P0332 `cbc2015` pushed (2026-10-24); full static execution recorded in P0332 manifest, source fallback corrected; native aura client behavior UNVERIFIED.
- Verified P0331 push `dce2355` (2026-10-24), 202-checker manifest; L-025/L-029 layering remains WoW UNVERIFIED.
- P0330 `1f48bbe` verified pushed, 201/201 checker manifest; death/ghost behavior remains UNVERIFIED while client is closed.
- Verified remote `main` P0329 `126d165` (2026-10-24) includes 200/200 checker manifest; gameplay snapshot and L-020–L-032 intake are committed, but WoW runtime is DEFERRED until November 4.
- P0328 internal-only alpha staging and November 4 runbook are pushed, **not validated in WoW**, and no public release is approved. P0328's CURRENT text was stale about the P0328 push; P0329 reconciles that fact.
- Source-history compatibility: P0317, P0318, P0319, P0320 (native-backed gossip), P0322, P0323, P0324, P0325 (five-domain models), and P0326, P0327 (native merchant/flight preparation) remain separately evidenced; no new client PASS is implied.
- P0321 GossipFrame single-window parking was pushed `9a180c8` but WoW runtime remains **UNVERIFIED / DEFERRED until November 4**. P0317–P0320 gossip/quest links have positive observations only in tested scopes; Quest 237 is reserved. Merchant/flight native services remain Blizzard-owned and flight frame identity unresolved.
- The five D-048 live selectors and saved-variable migration **do not exist**: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`; Camera/DynamicCam remains frozen D-047. Existing pet, action, target and compass boundaries remain accepted unless runtime evidence proves a defect.
- L-020–L-032 are user-reported needs and regressions. P0329 offers capture only; L-021–L-032 are OPEN / not fixed. Live player HP and secret-capable aura values are never read or serialized by the new command.
- License/distribution gate L-019 remains unresolved; LibCamera notice retained, optional QuestieDB not bundled. Internal stage ZIP is not an approved release.

## Next Action
Apply P0336 to exact clean P0335 `ffdbbca` with 207 PREWRITE shadow and 207 POSTWRITE static checks; user commits/pushes then verify GitHub main. Then isolate L-030 eligibility for QuestieDB potential quest givers and L-031 approximate focused yards using ordinary source facts; never invent quest offers. November 4 prioritize P0321 gossip restoration, then existing Compass Art ON/OFF visual preview and natural cluster/overlap observations, P0330–P0335 deferred gameplay tests. L-022 artifact remains screenshot-gated. L-027 source attribution remains open; no generic Blizzard suppression.

## Success Criteria
For all compass quest, POI, service and tracking glyphs, preserve true `candidate.x` and draw displayed glyph centers at one `TAPE_Y`. Independently sourced coincident candidates are decluttered by a deterministic size-aware cross-role interval, not stacked, moved to misleading bearings or reclassified as ineligible. Scan continues to later noncolliding candidates until each bounded pool fills. Addon-owned collision count is reported; original source, focused quest, depth, and Blizzard minimap access unchanged. The same interval logic is exercised by existing inert art preview and pure fixtures. Full 207 PRE/POST static results do not constitute a visual/runtime PASS: L-032 remains **UNVERIFIED** until the client reopens.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/evidence/P0336_COMPASS_SINGLE_BASELINE.md` and `docs/memory/patches/P0336_COMPASS_SINGLE_BASELINE.md` — source defect, deterministic declutter tradeoff, visual acceptance gate.
- `docs/memory/evidence/P0335_NATIVE_POPUP_PROVENANCE.md` and `docs/memory/patches/P0335_NATIVE_POPUP_PROVENANCE.md` — L-027 unresolved native owner/source boundaries and one-shot capture.
- `docs/memory/evidence/P0334_PVP_BADGES.md` and `docs/memory/patches/P0334_PVP_BADGES.md` — L-023 source correction, preview and runtime gates.
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
