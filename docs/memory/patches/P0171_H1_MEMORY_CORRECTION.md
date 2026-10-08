# P0171 — H.1 objective and negative-evidence memory correction

Date: 2026-10-08. Baseline `95aaa5930a39cf898aff06d65669d5ab49816b04`. Docs-only, no addon version bump, no gameplay code changes.

## Checkpoint

Replace only CURRENT and CURRENT_HANDOFF with verified P0170 status and the integrated remaining-Blizzard-UI objective. Append a compact active investigation, roadmap/dated notes, and create the canonical negative-evidence record `P0171_H1_SCOPE_AND_DELIVERY_FAILURES_2026-10-08.md` documenting false H.1 closure, screen-wide assumption, repeated scope drift, false P0169 diagnostic PASS, P0167/P0168/P0170 generated patch delivery defects and stale current status. Keep previous runtime failures and successes intact; no rewrite of historical records.

## Delivery and validation

Applier requires exact verified `main` baseline and unmodified tracked worktree; verifies expected Git blobs and refuses existing new files; builds a detached temporary local shadow, runs `git diff --check` and all `tools/check_*.py` before any tracked write; applies files transactionally, repeats checks, creates P0171_MANIFEST.txt, deletes its extracted payload, and never commits/pushes.

Runtime deployment: **not required** (documentation only). The next runtime checkpoint is one coherent remaining UI/fallback and positioning implementation, with one consolidated real-screen acceptance gate. H.1 remains OPEN.
