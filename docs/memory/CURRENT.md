---
memory_schema: 1
as_of: 2026-10-08
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN.** Integrate world-first native UI, maintaining complete required information and combat-safe fallback. P0173 was verified on main `f9c99685` / `0.0.89-dev` and its normal Primary routing gate passed in client. P0174 `0.0.90-dev` has been locally applied (user supplied manifest) but **not pushed to GitHub**; its initial in-game screenshot exposes native reappearance defects. P0174 R2 has a user-confirmed ordinary quest-tracker visual PASS, but its native cast/channel bars continue to reappear during combat (FAIL). The other interaction additions have not been separately accepted. P0174 R1 failed safely in the shadow checker before tracked writes because its generated CURRENT.md omitted required Success Criteria and Relevant References headings; it is superseded by R2.

## Current Work Item

**P0174 R3 (`0.0.90-dev` corrective candidate, unpushed)**. Preserve the R2 tracker OnShow repair and address the source-specific combat cast presentation failure without any combat-time protected mutation. Pinned Forever `CastingBarMixin` reads native `showCastbar` through `ShouldShowCastBar` on cast starts and exposes `SetAndUpdateShowCastbar`. Arm false only when folding the three native player/overlay/target cast roots while out of combat, store original values as opaque restoration tokens, and restore via the same native setter when CAST opens or Immersion turns OFF. Preflight all roots and setters; fail open on unavailable source. Record any in-combat cast OnShow as a persistent negative result. This does **not** authorize hiding unrelated native aura, focus, boss, vehicle, or special controls; D-041 enemy/player harmful and private aura replacements remain OPEN.

## Verified State

Remote main remains P0173 `f9c99685` / `0.0.89-dev`, while the user has installed P0174 and P0174 R2 locally (`0.0.90-dev`). The previous R1 artifact failed safely before tracked writes because required CURRENT headings were missing; this failure stays recorded. The user explicitly confirms R2 Objective Tracker no longer reappears: **PASS for naturally observed ordinary quest updates**. The user explicitly confirms native cast/channel bars still appear during combat: **FAIL in that scope**. Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` includes normal out-of-combat `nativeuicheck PASS` with 5 folded/0 open, source-specific tracker OnShow refolding and `combatDeferred=2`, `pending=0` after release. That is not an in-combat success. Source review finds `CastingBarMixin:ShouldShowCastBar` evaluates the native flag and `SetAndUpdateShowCastbar` updates it, permitting an out-of-combat native-policy hypothesis. R3 has no runtime proof yet; MainActionBar special routing and complete target aura visuals still lack replacement coverage.

## Next Action

Apply R3 **on the exact locally applied P0174 R2 checkout**, without reverting, recommitting, or pushing any predecessor first. The applier must verify the P0174/R2 manifests and current HEAD, run the complete static suite and diff checks in a shadow checkout, then apply the native-gate and memory correction transactionally. Deploy and `/reload`, run Native Access Check before Run All, validate CAST open/fold and Immersion OFF/ON restoration, naturally test cast/channel in combat and check diagnostics again. If protected/secret errors or cast bars still return, preserve FAIL and do not push. After complete acceptance, the user stages and pushes P0174 + R2 + R3 together. No travel or contrived gameplay solely to prove environmental coverage.

## Success Criteria

Tracker stays folded in naturally encountered quest updates; source-specific native cast flag is armed while CAST is folded, restored by CAST/Immersion OFF, and bars do **not** reappear in naturally observed combat casts/channels. A failure to arm must leave native information/control visible (fail open) and the diagnostic cannot claim PASS after even one in-combat gate escape. No Lua, taint, protected-action or secret-value errors; no suppression of Main/special or unowned target/player aura frames. Full H.1 completion is not claimed from this bounded proof. R3 runtime test is pending.

## Do Not Reopen Without New Evidence

No general OnUpdate/polling; no broad Blizzard show hook; no protected visibility readback; native showCastbar may only be captured as opaque restoration token and passed directly to its setter; no hide, alpha, or native setter mutation under combat lockdown; no direct MainActionBar hide; no aura suppression until D-041 replacement policy and world-target anchor proof. Keep native casting detail available through intentional CAST dock access before combat; Logres cast-state cue does not provide time/progress. No secure CAST toggle in combat is claimed. Preserve P0171 prior false-scope claims, P0170 false diagnostic PASS, P0174 current screen/cast/aura negative results.

## Relevant References

- `docs/memory/evidence/P0174_R3_CAST_NATIVE_GATE_2026-10-08.md`
- `docs/memory/patches/P0174_R3_CAST_NATIVE_GATE.md`
- `docs/memory/evidence/P0174_R2_QUEST_CAST_RESHOW_2026-10-08.md`
- `docs/memory/patches/P0174_R2_QUEST_CAST_RESHOW.md`
- `docs/memory/patches/P0174_INTERACTION_NATIVE_COHERENCE.md`
- `docs/memory/decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`
- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
