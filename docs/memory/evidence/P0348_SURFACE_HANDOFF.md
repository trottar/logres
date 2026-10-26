# P0348 — D-048 candidate versus stock surface ownership (offline evidence)

**Baseline:** verified pushed P0347 R1 `b94beb4706005757497002927d80845d5355037f`, manifest 218/218 PREWRITE/POSTWRITE STATIC, version `0.0.237-dev`, WoW **UNVERIFIED**. P0347 R0 static checker refusal remains in prior evidence; P0321 Blizzard GossipFrame restoration remains first contingent runtime gate.

## Narrow hypothesis

Existing P0324 domain-level `partial` permits a Logres effective domain with `native-required` fallback, but it does not explicitly forbid treating the entire domain as replaceable. D-048 specifically forbids losing Blizzard minimap/tracking, unsupported ACT controls, NPC transactions, party/CompactParty, target-of-target or native aura information. A separate pure per-surface fixture is required before any independent live selector.

## Prepared source/model evidence

`tools/p0348_surface_handoff.py` defines 19 **model surfaces** grouped into NAV/ACT/NPC/STATUS/CAM. The `stock_required` subset is permanently Blizzard-owned in this fixture. Candidate surfaces require both a separately supplied `capable` attestation and an independent `fallback_ready` attestation before a *model* effective Logres result is possible. No attestation is inferred from `immersionEnabled`, source file size, phase, or a new preference. All capabilities default false. If currently effective Logres and native restoration is unproven, a requested native handoff is `pending` and does not relinquish interaction. The evaluator never touches saved settings or native UI.

New `tools/check_p0348_surface_handoff_contract.py` checks all 32 masks, cross-domain isolation, source boundary invariants, the unchanged offline P0325 legacy migration preview, negative invalid inputs and per-candidate restoration. #219 plus all preceding 218 checkers must pass PREWRITE and POSTWRITE in WSL. The prior P0346 historical checker already accepts >=217; no more checker count migration required.

## Limitations and continuing gates

This is an offline specification **only**. It does not demonstrate WoW runtime behavior, nor a working requested/effective controller, nor a real Blizzard native restoration. No `Logres/Core` or Lua/TOC change, no version bump, no command/panel registry change, no polling, no camera/DynamicCam behavior change, no saved-variable schema migration. P0321 first runtime check still **UNVERIFIED**. All L-022/L-027/L-028 are **OPEN** and L-019 public distribution blocked. The policy refuses attempts to give camera profile Logres ownership while D-047 is frozen.
