# P0348 — D-048 surface ownership and restoration boundary matrix

**Authority:** verified pushed P0347 R1 `b94beb4706005757497002927d80845d5355037f`, 218/218 PREWRITE/POSTWRITE STATIC, `0.0.237-dev`; P0323 (94-module inventory), P0324 (32-domain policy masks), P0325 (legacy migration dry run) and accepted D-048. All new behavior **UNVERIFIED** in WoW. No live five-domain switches exist.

## Gap and design contract

P0324 models one requested/effective owner per **domain**, but the STATUS domain includes protected stock party/auras and the ACT domain includes vehicle/override controls. Treating partial domain coverage as blanket replacement would falsely imply that a Logres selector authorizes removal of native controls. P0325 correctly preserves legacy schema-3 saved preferences and avoids inventing camera intent. The missing step is **per-surface** ownership plus independent native restoration proof.

P0348 adds the offline-only `tools/p0348_surface_handoff.py`: 19 explicit named surfaces across five D-048 domains, each either `logres_candidate` or `stock_required`. Candidate does **not** mean implemented or safe to activate. `stock_required` remains Blizzard-owned for every mask. A candidate may become effective Logres in the **model** only if BOTH independent evidence booleans `capable` and `fallback_ready` are true; their conservative defaults are false. Leaving current Logres ownership while Blizzard restoration remains unproven preserves the candidate owner and reports `pending` rather than abandoning interaction. No API probes or frame state reads are involved.

| Domain | Eligible for later capability-gated Logres trial | Stock-required until replacement evidence exists |
| --- | --- | --- |
| NAV | Compass | Minimap and unreplaced tracking |
| ACT | Primary actions, secondary/utility clusters | Pet controls; special/vehicle/override |
| NPC | Quest narrative, gossip choices, trainer presentation | Quest transactions; merchant transactions; flight transactions |
| STATUS | Player tunnel, target presentation, target auras | Party/CompactParty; target-of-target; native aura fallback |
| CAM | None while D-047 camera baseline is frozen | Camera profile (Blizzard/native ownership model only; does not modify current DynamicCam behavior) |

## Test scope

The #219 checker validates all 32 domain masks, cross-domain isolation on every single-bit toggle, the 19-surface coverage inventory, independent capability/fallback gates for each candidate, deferred-restore and resumed-stock cases, invalid inputs, frozen-camera and permanent stock invariants. It also confirms that the existing P0325 schema-3 `legacy` dry run remains unchanged. These are pure Python specifications, not client PASS or a source of runtime capability claims.

## Implementation order (not authorization)

1. Preserve current legacy Immersion and ActiveQuest preferences, plus D-047 Camera, without migration.
2. When the Forever client is available, first perform mandatory P0321 GossipFrame native restoration and remaining gameplay checks. A genuine failure blocks the affected surface's ownership trial.
3. Only after stock restoration, capability, and interaction evidence are accepted, implement *one* candidate adapter (NAV compass is a lower-risk starting point) behind an independent requested/effective/native/pending state, leaving other domains' legacy policy unchanged.
4. Build user-visible selectors and an additive, explicitly opted-in saved migration after isolated live transitions are proven. Never equate a five-domain request mask with native-control suppression.

**Negative evidence:** No new runtime behavior was tested. Source evidence alone cannot prove native frame visibility, taint safety, full aura coverage, secure action ownership, camera state or actual FPS. L-022 focused quest artifact, L-027 native popup identity and L-028 debuffs remain **OPEN**; L-019 licensing still blocks public distribution. Do not weaken Blizzard fallbacks, P0347 lifecycle cleanup, or stock transaction routes. `tools/p0348_surface_handoff.py` is not in the TOC; no WoW deployment for this docs/tools checkpoint.
