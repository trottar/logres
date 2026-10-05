# P0128 — NPC Quest Interaction Source / Capability Audit

Date: 2026-10-05
Result: **INSTALLED / PUSHED — DOCS / SOURCE EVIDENCE ONLY** (`0ec74fe5`)
Baseline: `ef56075dbea1fdb8c613e3ee88c38e2684ef4170`
Runtime: unchanged at `0.0.58-dev`

## Purpose

Resolve the source/API layer of the D-035 NPC quest-interaction audit and choose
the smallest evidence-backed next runtime slice.

Canonical evidence:
`../evidence/P0128_NPC_QUEST_INTERACTION_SOURCE_AUDIT_2026-10-05.md`.

## Result

Source availability is broad enough to continue:
- narrative/progress/completion text APIs exist on Forever;
- reward item/choice/currency/spell read APIs exist;
- Accept/Decline/Continue/finalize APIs exist;
- structured gossip quest/option reads and selection APIs exist.

But source existence is not mutation ownership proof.

Only the tested `QUEST_DETAIL` passive-read path and reward XP have prior runtime
proof. Progress/completion/reward-choice/gossip-list reads remain unproven, and
all quest/gossip mutation calls remain unproven.

## Next slice

**P0129 — read-only NPC quest interaction runtime capability probe.**

The probe will:
- register the relevant gossip/quest events;
- read narrative/reward/gossip data secret-first;
- expose one Phase-H developer-panel diagnostic;
- record mutation-function presence without invoking mutation;
- leave Blizzard UI fully available.

## Boundary

Docs/source evidence only.

No Lua/runtime files change.
No WoW redeploy or `/reload` is required.
