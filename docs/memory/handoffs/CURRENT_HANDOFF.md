# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0163 `23c2b964ef4fcad385cf9d1bb4c5dc952d46bacb` / runtime remains `0.0.81-dev`.

## Phase H.1 audit result

P0164 is docs/audit only. It changes no WoW runtime code.

Already suppressible and runtime-proven:
- Quiet Mode passive chat/social presentation;
- selective PlayerFrame conventional shell;
- selective TargetFrame conventional shell/disallowed metadata, while preserving target auras/context and target-of-target;
- stock Bar 2/3 presentation + mouse path only while matching Logres Secondary/Utility routing is active.

Keep stock:
- minimap;
- Party/CompactPartyFrame;
- target aura/status, target-of-target, Focus/boss frames;
- player aura completeness;
- MainActionBar/OverrideActionBar/Bars 4–5;
- PetActionBar/PetFrame;
- class/resource/Rune/Totem/alternate-power and stance/vehicle/override/possess/extra-action surfaces;
- Objective Tracker/full quest log/watch, persistent XP bar, nameplates;
- quest progress/complete/reward/gossip states.

## Hiding-addon guidance

The user requested Hide Anything-style guidance. Broad UI-hider addons are useful for mechanics, not ownership policy. Public MoveAny source demonstrates snapshot/restoration, hidden-parent or alpha+mouse techniques, combat protection, and hook-based reassertion. Logres uses only the minimum technique justified for each owned surface and does not import blanket parent locks, timers, polling, or broad permanent reassertion.

## Exact next work item

**P0165 — source-backed suppression/restoration of Blizzard quest-offer Accept/Decline controls only.**

Do not hide the whole QuestFrame. Preserve gossip, progress/Continue, completion/Complete, reward selection, and unsupported states. Fail open to Blizzard and restore stock controls before Logres interaction is withdrawn.

## Key references

- `../CURRENT.md`
- `../evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`
- `../patches/P0164_PHASE_H_SUPPRESSION_AUDIT.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
