# P0206 R6 — Preserve Blizzard PetActionBar as fail-open stock

Baseline: P0205 pushed GitHub `main` `79a8e2308a37135b61db8ad8a0433cae5ec8b4bd`, with uncommitted locally applied P0206 R5 `0.0.111-dev` candidate. No commit or push by this patch.

## Narrow source correction

The older `NativeSurfaceReplacement:Ready("petActions")` returned readiness for the Logres PetActionExecutionProbe and allowed `Native:Fold("petActions")` to call Blizzard frame `Hide()`. Quarantining only `PetCombatCandidate` left that native fold intact. In R5, the user reproduced missing stock pet controls after Immersion OFF, with an initial native diagnostic `petActions:folded` despite candidate `QUARANTINED`. See `docs/memory/evidence/P0206_R5_STOCK_PET_RESTORE_FAILURE.md`.

R6 changes **only the petActions readiness gate**: `return false` means this feature is explicitly not allowed to fold the Blizzard PetActionBar. All other native folds, authored status/auras, action controls, H.2/D-045 anchors and the six-row Phase H developer panel remain intact. The trial's ON control remains blocked and its source remains free of native frame mutation. Runtime advances to `0.0.112-dev` with Bootstrap/TOC matching, and the candidate static checker enforces the fail-open gate independent of runtime version.

No polling, combat Hide, protected-parent reparent, visibility read, secret comparison or blind native Show is used. The Blizzard frame remains stock-owned for normal and unsupported contexts. The overlapping native bar when Immersion ON remains P0197 OPEN; this patch explicitly prioritizes functional pet controls over cosmetic suppression.

## Gate

Static: baseline blob/payload and R5 manifest guards, all `tools/check_*.py` in shadow, `git diff --check`, proper manifest. Actual in-game: deploy and `/reload`; Phase H **Native Access Check** should show `petActions:stock`, **Pet Combat Trial Check** should read QUARANTINED/armed=false; Phase D **Immersion OFF** must display a clickable Blizzard pet-action bar when a pet is present; Phase D **Immersion ON** should not destroy that stock bar. Verify no new BugCatcher errors. If any fails, STOP, preserve diagnostics and do not commit. This patch has no in-game PASS until user supplies runtime observation.

## Preserved failures

P0206 R0 panel overflow; R1 rejected slash-only regression; R2 protected/restoration failure; R3 exact-version checker failure; R4 missing baseline checker payload; R5 still-folded Blizzard pet bar and restoration failure. None is erased by this correction.
