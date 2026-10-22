# P0311 — Profession native-close Goodbye + read-only trainer filter signal

Baseline: verified GitHub main P0310 `cb1a83f2cc14796f42e8cedfc7491063b7c5e270`, 0.0.211-dev.
Candidate: 0.0.212-dev. **PREPARED / WSL AND WOW UNVERIFIED**.

- `Quest/TrainerProfessionCloseTrial.lua`: native close for ordinary, shown and unprotected profession trainers only, one explicit request following stock restoration.
- `Quest/TrainerFilterState.lua`: ordinary, read-only native service-filter indicators; no writes and no ownership inference.
- `Quest/TrainerLiveTrial.lua`: family-specific Goodbye routing; optional empty detail on known-filter OFF. Same renderer and local controls.
- Existing class close, class/profession purchase and Train All remain unchanged. Stock remains visibly usable for all profession trainer types.
- P0310 observed user runtime PASS for empty fixture/live Fishing is recorded in new CURRENT and canonical P0311 evidence; previous negative results preserved.
- No panel action change; P — Trainer Empty Preview is the existing inert fixture.
- Checks and manifest are produced by guarded one-time applier; user owns Git commit/push. Runtime test pending.
