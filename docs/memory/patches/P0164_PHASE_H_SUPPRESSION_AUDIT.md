# P0164 — Phase H Stock-Surface Suppression Audit

Date: 2026-10-07
Expected baseline: `23c2b964ef4fcad385cf9d1bb4c5dc952d46bacb`
Runtime impact: **NONE — DOCS / EVIDENCE ONLY**

## Purpose

Resolve H.1 quickly from existing durable runtime evidence and external UI-hider implementation guidance, without creating another generic hide framework or removing an incompletely replaced Blizzard surface.

## Result

P0164 classifies current stock surfaces into:
- `SUPPRESSIBLE NOW — EXISTING`;
- `KEEP STOCK`;
- `DEFERRED`.

Already-proven Logres suppression remains authoritative for Quiet Mode chat/social presentation, Player conventional shell, Target selective shell/metadata, and conditional Bar 2–3 replacement.

All known incomplete domains remain stock, including minimap, Party/CompactPartyFrame, target aura/status and target-of-target, Main/Override/special action surfaces, PetActionBar/PetFrame, class/resource/special children, full quest tracking/log, persistent XP, and unsupported quest states.

## External implementation guidance

The user requested Hide Anything-style guidance. P0164 uses Hide Anything as a broad product reference and audits public MoveAny source at `a313a5cb05c83ea5dd35e5366e6de209ff6505a4` for inspectable mechanics: snapshot/restore, hidden-parent where safe, alpha plus mouse suppression, protected/combat guards, and targeted hook-based reassertion.

Logres deliberately rejects importing blanket hidden-parent, timer retry, global frame interception, or permanent parent-lock behavior without surface-specific evidence.

## Next

P0165 is the first new suppression slice: source-backed suppression/restoration of Blizzard **quest-offer Accept/Decline controls only**, while retaining the QuestFrame and every unsupported quest/gossip state as stock fallback.

## Files

Adds:
- `docs/memory/evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`;
- `docs/memory/patches/P0164_PHASE_H_SUPPRESSION_AUDIT.md`.

Updates active Phase H memory/roadmap state to P0165.

## Validation

Docs-only:
- exact HEAD and target blob verification;
- candidate anchor validation before write;
- shadow `tools/check_memory_health.py`;
- shadow and live `git diff --check`;
- transactional rollback on post-write failure.

No WoW redeploy or `/reload` is required.
