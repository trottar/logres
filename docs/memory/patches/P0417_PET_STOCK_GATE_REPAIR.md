# P0417 — Native pet suppression readiness following HUD panel migration

Pinned source: P0416 main `d11b76ab786f3b08151c426e52502a3415fb4877`.
Single runtime fix: PetBarVisibilityTrial.Ready uses the extant
NativeSurfaceReplacement.Toggle("pet") stock fallback rather than the
removed native.buttons.pet display control. Version advances to 0.0.294-dev.
No secure state-driver algorithm, action execution, bindings, pet source,
other HUD geometry or stock fallback mutation is changed. Update precise
L-008 runtime negative evidence and narrow contract checker. Client UNVERIFIED.
See `docs/memory/evidence/P0417_PET_STOCK_GATE_REPAIR.md`.
