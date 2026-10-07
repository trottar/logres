---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Execute Phase H integration-first: finish safe Blizzard-surface suppression/coexistence, then authored layout/positions, then final whole-screen polish.**

Phase G is complete for the scope Logres currently claims. P0164 resolves the Phase H.1 ownership audit without changing runtime behavior.

## Current Work Item

**P0165 — narrow Blizzard quest-offer Accept/Decline suppression/restoration.**

P0164 classifies the current stock surfaces from durable capability/restoration evidence. Existing Logres suppression that is already runtime-proven remains valid; incomplete domains remain stock.

P0165 is deliberately narrow: source-audit the exact Forever quest-offer control frames, then suppress only the stock **offer Accept/Decline controls** while the proven Logres offer narrative and controls are ready. Do not hide the whole QuestFrame, gossip, progress/complete, rewards, or any unsupported quest state.

Use the least invasive per-surface technique. Snapshot before mutation, remove invisible click regions, restore exact prior presentation/interaction before withdrawing the Logres replacement, defer protected mutations in combat if applicable, and fail open to Blizzard on any uncertainty.

## Verified State

P0164 Phase H.1 audit result:
- **SUPPRESSIBLE NOW / already implemented and runtime-proven:** Quiet Mode passive chat/social presentation; selective PlayerFrame conventional shell; selective TargetFrame conventional shell/disallowed metadata with preserved Blizzard context; stock Bar 2/3 presentation and mouse path while matching Logres Secondary/Utility routing is active.
- **KEEP STOCK:** minimap; Party/CompactPartyFrame; target auras/status and target-of-target; Focus/boss frames; player global aura completeness; MainActionBar/OverrideActionBar/Bars 4–5; PetActionBar/PetFrame; class-resource/Rune/Totem/alternate-power; stance/vehicle/override/possess/extra-action surfaces; Objective Tracker/full quest log/watch; persistent XP bar; nameplates.
- **DEFERRED / NEXT NARROW CANDIDATE:** Blizzard quest-offer Accept/Decline controls. Logres offer narrative plus explicit Accept/Decline are runtime/visual-proven, but stock-control suppression still needs an exact source/restoration slice.
- quest progress/Continue, completion/Complete, rewards, reward selection, and gossip remain stock/gated.

External hiding-addon guidance was audited for mechanics only. Hide Anything is a useful broad product reference; source-backed MoveAny patterns confirm hidden-parent, alpha+mouse suppression, combat guards, and explicit restoration. Logres does **not** adopt blanket parent locks, polling, or permanent reassertion from generic UI-hider addons.

## Next Action

Prepare P0165 against the verified main baseline:
1. audit the exact Forever source/lifecycle for stock quest-offer Accept and Decline controls;
2. implement suppression only when the Logres offer surface is production-ready for that exact offer state;
3. preserve every other Blizzard quest/gossip surface;
4. restore stock controls first on Immersion OFF, unsupported state, module disable, or failure;
5. add a bounded developer-panel check and run the normal integrated regression gate.

Do not spend another checkpoint on a second broad suppression audit unless new evidence invalidates P0164.

## Success Criteria

P0165 succeeds when:
- only the stock quest-offer Accept/Decline controls are hidden in the supported offer state;
- no invisible Blizzard click region remains;
- Logres Accept/Decline remain explicit player actions and preserve the proven quest identity/event correlation;
- paging/final-page gating remains coherent;
- unsupported quest states and all non-offer quest/gossip controls remain Blizzard-visible;
- Immersion OFF/module disable/failure restores the exact usable stock controls before Logres replacement interaction is removed;
- no polling, blanket Show/Hide hook, unrelated frame reparenting, saved Blizzard-setting mutation, taint, protected-action, Lua, or secret-value failure is introduced.

## Do Not Reopen Without New Evidence

- P0162 reactive mouse-wheel zoom and Phase G closure are accepted for claimed observed scope;
- existing Quiet Mode, Player shell, Target selective suppression, and Bar 2–3 replacement remain accepted for their tested scopes;
- the one-off TargetFrame reappearance remains OPEN / INTERMITTENT / UNREPRODUCED; do not add periodic forcing without recurrence evidence;
- no conventional player health bar;
- PvP is a modifier, not Immersion OFF;
- stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, PetFrame/PetActionBar, Main/Override/special action surfaces, unsupported class/special surfaces, alternate power, RuneFrame, TotemFrame, Objective Tracker, and quest states beyond the proven offer slice remain available until separately replaced;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate attachment remains deferred;
- individual tracking-result positions remain source-blocked by D-043.

## Relevant References

- `docs/memory/evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`
- `docs/memory/patches/P0164_PHASE_H_SUPPRESSION_AUDIT.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/decisions/D-023_SELECTIVE_STOCK_ACTION_REPLACEMENT.md`
- `docs/memory/decisions/D-025_QUIET_MODE_RUNTIME_SUPPRESSION.md`
- `docs/memory/decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `docs/memory/decisions/D-027_TARGET_SELECTIVE_SUPPRESSION.md`
- `docs/memory/decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `docs/memory/evidence/P0133_QUEST_OFFER_ORDER_RUNTIME_VISUAL_PASS_2026-10-05.md`
- `docs/ROADMAP.md`
