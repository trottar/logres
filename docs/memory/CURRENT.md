---
memory_schema: 1
as_of: 2026-10-25
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item

**P0342 — L-028 one-shot target harmful renderer provenance; SOURCE-PREPARED / WoW UNVERIFIED.** Verified remote GitHub `main` P0341 R1 `fb3b2658985e7f6d05f7730a3de6eb7b7dca6ad9` pushed, manifest reports 212/212 PREWRITE and POSTWRITE static PASS; TOC/Bootstrap version `0.0.233-dev`. The existing P0329 Gameplay Snapshot prints ordinary fallback harmful row count even if P0183 native AuraContainer owns/hides that lane. P0342 appends one cached read-only native/ordinary owner line, no new aura queries, no source or UI changes, and no claim of visual correctness. Version bump in parity to `0.0.234-dev`; checker #213, static WSL and client UNVERIFIED. L-028 duplicates and missing debuffs remain OPEN pending route-correlated visual evidence; L-022 focused quest visual screenshot, L-027 popup native frame owner and L-019 license remain OPEN. Do not stop offline research solely because November 4 client is contingent; preserve P0321 native GossipFrame restoration as the first in-client safety gate.

## Verified State

- Verified pushed GitHub main P0341 R1 `fb3b2658985e7f6d05f7730a3de6eb7b7dca6ad9` on 2026-10-25/26 UTC. P0341 manifest 212/212 PREWRITE/POSTWRITE static PASS; WoW UNVERIFIED. Its R0 historical-version checker failure caused zero tracked writes and is retained in evidence.
- P0340 `27fb9eb` 211/211 static PASS; P0339 `8a5d3f86` 210/210 static PASS. Source-only internal packaging and November 4 matrix do not establish in-client behavior.
- P0338 R1 `342cab97` 209/209; P0337 R1 `cfdc07af` 208/208. Historical PREWRITE failures, narrow remedies and deferred L-031 focused-yard/quest-giver validation remain in their evidence files.
- P0336 `d535906` 207/207; P0335 `ffdbbca` 206/206; P0334 R3 `1b7b1ff` 205/205; P0333 `68c0955` 204/204; P0332 `cbc2015` 203/203; P0331 `dce2355` 202/202; P0330 `1f48bbe` 201/201; P0329 `126d165` 200/200. All counts are pushed static manifests, not client PASS. P0332 targets only ordinary aura fallback; the native AuraContainer remains a separate owner.
- P0328 internal alpha packaging/runbook only; P0317, P0318, P0319, P0320 are historical native gossip observations; P0321 `9a180c8` native GossipFrame parking is runtime UNVERIFIED and first November 4 safety gate. P0322, P0323, P0324, P0325 are inert D-048 five-domain planning/model checks; P0326 and P0327 assess native merchant/flight source and models only. Stock UI/Quest 237 preserved.
- D-048 independent live domain selectors and saved migration do not exist: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`. D-046 preview-first and D-047 frozen Camera/DynamicCam remain required. Native UI and protected/secret fallbacks remain accessible.
- L-020–L-032 are tracked user reports; source fixes are not client-accepted. L-028 duplicated/missing target debuffs remains OPEN; L-022 focused quest artifact requires screenshot, L-027 Blizzard transient popup requires `/fstack` owner evidence. L-019 root project license remains unresolved, public distribution NOT APPROVED.

## Next Action

Apply guarded P0342 against clean exact pushed P0341 R1 `fb3b265`, validate 213/213 candidate PREWRITE shadow and POSTWRITE suite, diff hygiene and manifest; user owns commit/push, verify remotely afterward. Continue evidence-backed offline source reviews of L-022 focused quest renderer and L-027 native popup source possibilities without claiming frame ownership or inventing visual fixes. On contingent November 4 client access, P0321 gossip restoration first; then use existing H Status Aura Check and P0342 one-shot Gameplay Snapshot to distinguish native/ordinary target harmful presentation while naturally reproducing L-028. Record PASS/FAIL/DEFERRED per scope. No in-game test requested while client unavailable. Public release L-019 BLOCKED.

## Success Criteria

Existing Phase 0 Gameplay Snapshot retains the original aura summary and appends one bounded cached addon-owned aura route line. `StatusAuras:GetDebugStatus` remains the only source for `nativeReady`, `nativeActive`, `targetHarmfulShown`, and `targetHarmfulVisible`, with no native frame visibility or secret-capable aura inspection. Exact loaded Lua inventory retained at 94, other Logres/Blizzard controls unchanged. 213 static checkers PASS in WSL is not a WoW or public release PASS; L-028 stays OPEN pending screenshot/source-owner correlation.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/evidence/P0342_TARGET_AURA_ROUTE.md` and `docs/memory/patches/P0342_TARGET_AURA_ROUTE.md`
- `docs/memory/evidence/P0341_FOCUSED_MARKER_DIAGNOSTICS.md` and `docs/memory/patches/P0341_FOCUSED_MARKER_DIAGNOSTICS.md`
- `docs/memory/evidence/P0340_ALPHA_PREFREEZE_AUDIT.md`, `docs/memory/patches/P0340_ALPHA_PREFREEZE_AUDIT.md`, `tools/alpha_prefreeze_audit.py`, `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md` and `docs/memory/evidence/P0339_GAMEPLAY_RUNTIME_MATRIX.md`
- `docs/memory/evidence/P0338_FOCUSED_COMPASS_YARDS.md` and `docs/memory/patches/P0338_FOCUSED_COMPASS_YARDS.md`
- `docs/memory/evidence/P0337_QUEST_GIVER_ELIGIBILITY.md` and `docs/memory/patches/P0337_QUEST_GIVER_ELIGIBILITY.md`
- `docs/memory/evidence/P0336_COMPASS_SINGLE_BASELINE.md` and `docs/memory/patches/P0336_COMPASS_SINGLE_BASELINE.md`
- `docs/memory/evidence/P0335_NATIVE_POPUP_PROVENANCE.md` and `docs/memory/patches/P0335_NATIVE_POPUP_PROVENANCE.md`
- `docs/memory/evidence/P0334_PVP_BADGES.md` and `docs/memory/patches/P0334_PVP_BADGES.md`
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
