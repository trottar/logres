# P0206 R5 — Runtime restore failure after quarantining the parent trial

Status: **FAIL / OPEN**, observed by user on Forever 1.60.1.70338; **not** proof that Blizzard's protected restoration path is broken independently of Logres.

## Evidence

- R5 `0.0.111-dev`, `LogresDB.meta.loadCount=262` was deployed and reloaded.
- Phase H `Pet Combat Trial Check` recorded `QUARANTINED requested=false armed=false`, zero trial activations; Trial ON explicitly rejected. Hence the R2 experimental hidden parent did not activate in this session.
- Simultaneously **the older NativeSurfaceReplacement module** recorded `petActions:folded`, total `folded=4`, `restores=0` at the initial Phase H audit. Later `petbar-reshow` captured `onShow=4 immediateRefolds=4` following `PET_BAR_UPDATE` while Immersion was ON. These are addon-owned folding observations, not inspection of Blizzard visibility.
- User reported Blizzard's PetActionBar was **still absent after Immersion OFF**. There is no Native Access Check immediately after Immersion OFF in the uploaded log, so the exact post-OFF snapshot state and any resulting protected action cannot be inferred from this file. A user's visible runtime failure remains a failure regardless of counters.
- The prior R2 generic `ADDON_ACTION_PROTECTED` report remains preserved separately; this session does not establish a new stack trace or prove the same protected error recurred.

## Cause and correction

R5 quarantined `PetCombatCandidate` but restored old P0205 `NativeSurfaceReplacement` semantics byte-for-byte. Therefore it **did not eliminate PetActionBar hiding** by the older module. In R6 the native readiness gate returns false for `petActions`, so new sessions cannot enter its `Fold("petActions")` path. Reconciliation treats that domain as stock and preserves the original Blizzard parent, shown state, event and control behavior. No new periodic hooks, `Show`, `Hide`, parent mutations or secret-value inspections are introduced in the R6 gate.

This is a **fail-open safety rollback**, not a combat-duplicate fix. The older P0197 combat overlap is expected to be visible again whenever Blizzard's own bar is shown. Do not classify as accepted until a `/reload` and in-game Immersion OFF demonstrate native usable pet buttons. A static checker PASS never establishes visual restoration.

## Negative history retained

P0206 R0 prewrite panel overflow; R1 rejected slash-only panel regression; R2 runtime protected/restoration FAIL; R3 version-pin checker FAIL; R4 missing payload prewrite FAIL; R5 runtime stock-pet restoration FAIL. All remain open historical evidence. The corresponding detailed R2–R4 and R5 delivery records must not be overwritten.
