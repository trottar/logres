---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Phase H.1 reopened at the user's direction: finish removing redundant Blizzard presentation where Logres already has a complete safe replacement before H.2 visual calibration.** The previous H.1 closure overstated progress: P0165 hid only stock Quest Accept/Decline; the rest of the cited quiet/player/target/Bar 2–3 suppression predated Phase H. No blanket hiding or loss of required native controls is authorized.

## Current Work Item

**P0168 R1 — ordinary supported QuestFrame offer-shell visual suppression, candidate `0.0.85-dev`.** Extend P0165's already runtime-accepted offer-only gate so that the *stock quest frame stays shown for internal lifecycle/escape*, but its redundant offer visual shell becomes alpha-zero and all captured descendant frame mouse regions are disabled. Use exact mouse/alpha snapshots, limited 512-frame recursion, secret-first fail-open, out-of-combat gating, and restore on Immersion OFF, action start/failure, event/quest state transition, or module disable. Progress, completion, reward, gossip, PvP-confirmation, auto-accept, and unsupported states stay native. Existing Quest Offer Stock Check reports addon-owned shell state. R0 failed before tracked writes because its checker looked for the wrong visual snapshot assignment; R1 repairs that contract and removes the false `QUEST_ITEM_UPDATE` restoration trigger. The candidate is **NOT runtime accepted** until in-game proof.

## Verified State

Verified P0167 main `f58bccfb91fe8f6165b543c936cea4bb0ac29a06` / `0.0.84-dev`; uploaded diagnostics show Phase H Layout Check 13 anchors, 15 bindings, zero failure/missing/mismatch, plus integrated Run All PASS. Phase G previously accepted for its observed scope. P0165 R1 supported offer Accept/Decline suppression and restoration passed; P0166 semantic layout anchors passed; P0167 panel registration passed. These do not establish whole QuestFrame suppression yet.

## Next Action

Apply P0168 candidate only after shadow full-suite/static and git diff --check pass. Deploy to Forever test client, `/reload`; Phase H Quest Offer Stock Check and Phase 0 Run All must PASS. Open one **ordinary** quest offer: stock QuestFrame visual absent and no invisible click regions, Logres narrative/paging/buttons usable; test Immersion OFF restores full QuestFrame and ON removes it again; use a Logres Accept or Decline and ensure normal quest handoff/restoration. If untestable, record environmental deferral. Any Lua/taint/protected/secret failure blocks advancement. User pushes only after runtime PASS; verify main then address other eligible sub-surfaces before H.2 spacing.

## Success Criteria

Normal supported offer: quest frame remains internally shown, its stock visuals and all captured mouse regions are suppressed, Logres narrative and actions operate, no invisible stock clickable areas, exact restore through preference and quest lifecycle. Unsupported offers and states show usable Blizzard UI; candidate checks and Run All pass; no errors. Visual proof is required, not implied by static checks.

## Do Not Reopen Without New Evidence

Existing Quiet Mode, Player/Target selective suppression and Bar 2–3 replacement are accepted for proven scope. Primary MainActionBar/Override and special actions require secure fallback + key routing; PetActionBar needs binding/edit/autocast/feedback coverage; minimap, Party/CompactParty, target auras/ToT, full Objective Tracker/log/watch, permanent XP, class/rune/totem/alternate power, nameplates and unsupported quest states remain native until their capability gaps are closed. No exact player HP/conventional health bar, PvP remains a modifier. The prior P0164 closure classification is superseded, but its blocker matrix remains evidence.

## Relevant References

- `docs/memory/evidence/P0168_QUEST_OFFER_SHELL_SOURCE_GATE_2026-10-07.md`
- `docs/memory/patches/P0168_QUEST_OFFER_SHELL_SUPPRESSION.md`
- `docs/memory/evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`
- `docs/memory/patches/P0165_QUEST_OFFER_STOCK_SUPPRESSION.md`
- `docs/memory/patches/P0167_LAYOUT_CHECK_PANEL_REGISTRATION.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
