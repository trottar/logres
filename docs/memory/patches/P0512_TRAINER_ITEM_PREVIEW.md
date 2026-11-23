# P0512 — Trainer crafted-item detail preview

- Baseline: verified main P0511 `80813b22ad90aa1c0c0e8f0add0161ef553eceac`.
- Runtime: `0.0.377-dev`; code paths are `NativeTrainerServiceProbe.lua`, `TrainerLiveTrial.lua`,
  `TrainerLandscape.lua`, TOC and Bootstrap.
- New source fixture/checker: `tools/p0512_trainer_item_preview_fixture.lua`,
  `tools/check_p0512_trainer_item_preview_contract.py`.
- Display-only native service-indexed item link -> bounded tooltip fact
  lines with native full-item hover; exact item data event refresh.
  The existing lower-left detail renderer/Train controller remains.
- Guarded ZIP package verifies exact baseline, tracked cleanliness,
  all checkers before and after writes, payload hashes, rollback.
- Static candidate check != client PASS. Forever output/stat/link
  provenance and actual trainer purchase remain UNVERIFIED.
- Previous natural-occurrence test remains PENDING. L-033 stays OPEN.
- Evidence: `docs/memory/evidence/P0512_TRAINER_CRAFTED_ITEM_PREVIEW.md`.
