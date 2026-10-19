# P0269 — Restore native NPC service ownership per D-047

Baseline pushed main `53fe8ae` (P0268). This rollback removes the misleading active synthetic service catalogues and fake confirmation routing, while retaining historical evidence and the approved generic NPC/quest presentation. A read-only addon-state service ownership policy and H-tab diagnostic replace the speculative service transaction UI direction. No Blizzard frames touched, no native calls or camera changes. Full repository checker suite and WoW review required separately; native styling/position feasibility remains OPEN. See `docs/memory/evidence/P0269_D047_NATIVE_SERVICE_RESET.md`.

## R1 delivery correction

R0 prewrite suite failed because the retired P0268 checker in the payload
was not overlaid into the candidate. R1 corrects payload staging without
changing native ownership scope. See evidence for exact failure and gate.
