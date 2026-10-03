# Phase F — Quest Experience

Status: COMPLETE
Closed: 2026-10-02

## Product Objective

Create an immersive quest experience that presents only the quest information
the player actually needs while preserving Blizzard control surfaces until
safe replacements exist.

## Standing Boundaries

Phase F owns the capability work it actually completed:
- passive quest/XP presentation policy;
- additive NPC quest detail;
- restrained runtime-proven objective updates.

During Phase F, Blizzard retained:
- quest interaction controls;
- watch/super-track mutation;
- stock quest-log interaction;
- stock Objective Tracker interaction.

That was the accepted **Phase F implementation boundary**. D-035 now clarifies
that Blizzard ownership of NPC quest interaction is not the final product
endpoint. Future Logres quest-interaction ownership is a separate capability
slice and does not reopen or invalidate the completed Phase F proofs.

## F.1 — Quest-experience capability contract

**COMPLETE — D-031.**

Established passive observation versus Blizzard-owned interaction/control.

## F.2 — Quest/XP runtime capability proof

**COMPLETE.**

Runtime-proven quest/XP sources and event behavior.

Quest destination APIs produced negative samples rather than a usable route.

## F.3 — Contextual XP pulse

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

Brief XP-change presentation without a permanent XP bar.

## F.4 — Additive NPC quest detail presentation

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

Blizzard quest/gossip controls remain available.

## F.5 — Objective / progress runtime capability proof

**COMPLETE — RUNTIME PASS.**

Proved populated incomplete/completed objective rows and same-quest progress
refresh.

## F.6 — Contextual objective progress pulse

**COMPLETE — RUNTIME + VISUAL PASS.**

Final P0092 commit:
`5f8e9e96`.

Runtime:
`0.0.38-dev`.

Final proof:
- baseline two rows with no false pulse;
- natural same-quest progress;
- one meaningful change;
- one production pulse;
- immediate live Quest Probe update;
- user visual acceptance.

Canonical evidence:
`../evidence/F6_P0092_RUNTIME_VISUAL_PASS_2026-10-02.md`.

## Deferred quest/navigation capability

Quest IDs `436`, `237`, and `1338` remain negative destination samples.

Quest compass marker remains unsupported until a real usable destination is
runtime-proven.

This is a capability deferral, not a Phase F blocker.

## Deferred future ownership

Phase F intentionally did not replace:
- stock Objective Tracker;
- quest-log controls;
- quest accept/decline/continue/complete controls;
- reward selection;
- watch/super-track controls.

D-035 now accepts **NPC quest interaction** as a future Logres-owned product
domain, including accept/decline, continue/complete, reward selection, source
text paging, and required quest-related gossip transitions.

That future work remains capability-gated and fail-open. Quest-log management,
watch/super-track mutation, stock Objective Tracker ownership, and non-quest
gossip are not automatically claimed by D-035.

## Phase F Exit

Exit criteria are satisfied:
- accepted quest/XP presentation is runtime-proven;
- no Phase F implementation depends on speculative quest destination data;
- no Blizzard control surface was removed without a deliberate replacement;
- retained Blizzard surfaces have explicit ownership/fallback boundaries.

**PHASE F COMPLETE.**

Further quest work requires new evidence or a new accepted capability slice;
there is no mandatory undefined F.7 implementation.
