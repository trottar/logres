# Project Logres Roadmap

Project Logres is an immersive, world-first interface addon for World of Warcraft Forever.

The roadmap is capability-gated. A phase advances only when its success criteria are satisfied and repository memory is synchronized.

## Phase 0 — Foundation

**Status: COMPLETE.**

## Phase A — Core State Engine

**Status: COMPLETE.**

## Phase B — Core HUD

**Status: COMPLETE.**

## Phase C — Action Interface

**Status: COMPLETE.**

## Phase D — Immersion Controller

**Status: COMPLETE.**

## Phase E — Compass and Navigation

**Status: COMPLETE.**

Established heading compass, manual user-waypoint compass marker, fail-open navigation, and Blizzard-owned stock minimap.

## Phase F — Quest Experience

**Status: ACTIVE — F.6 contextual objective progress pulse.**

F.1/F.2 complete. F.3 contextual XP and F.4 additive NPC quest detail presentation are complete with runtime/integration/visual proof. F.5 objective/progress capability proof is complete.

F.6 current evidence:
- P0090 durable at `afcc37c`;
- current-objective Preview PASS;
- Immersion Preview policy PASS;
- duplicate-count presentation FAIL;
- P0091 fixes shared objective label formatting only;
- production automatic pulse remains unproven.

F.6 constraints remain baseline-first, no permanent tracker, no stock Objective Tracker suppression, no watch/super-track mutation, fail-open secret/invalid handling, and no polling/retry workaround without evidence.

Deferred: stock Objective Tracker replacement/suppression and quest destination / quest compass marker.

Canonical phase record: `memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`

## Phase G — Cinematic Camera

Translate the user's established DynamicCam behavior into Logres when Phase G begins; request a fresh export then.

## Phase H — Integration and Polish

Unified settings, profiles, visual consistency, performance, accessibility/configurability, packaging, release documentation, and compatibility testing.
