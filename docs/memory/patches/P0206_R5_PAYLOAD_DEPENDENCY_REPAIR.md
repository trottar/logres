# P0206 R5 — Repair R4 package dependency; quarantine failed runtime trial

Baseline: **pushed** P0205 GitHub `main` `79a8e2308a37135b61db8ad8a0433cae5ec8b4bd`. Local checkout remains the **uncommitted P0206 R2** working tree, not a clean P0205 checkout. **R5 does not implement a new pet suppression mechanism.** Runtime quarantine is still unvalidated.

## Chronology and negative evidence (retain permanently)

- **R0 — PREWRITE FAIL:** 18 Phase H actions exceeded the old 15-button panel contract. No tracked writes.
- **R1 — REJECTED DESIGN:** slash-only pet trial controls sacrificed the established developer-panel workflow. The user rejected this workaround; the panel is canonical.
- **R2 — RUNTIME FAIL:** hidden-parent native PetActionBar was absent in and out of combat, but Immersion OFF did not restore Blizzard pet controls; BugCatcher reported generic `ADDON_ACTION_PROTECTED`, without function identity or stack. The trial's addon-owned arm/disarm count was not proof of stock restoration. **Never commit R2.** See `docs/memory/evidence/P0206_R2_RUNTIME_FAILURE.md`.
- **R3 — PREWRITE STATIC FAIL:** newly authored `check_pet_combat_candidate_contract.py` froze `0.0.111-dev`, rejected by `check_checker_version_policy.py`. No corrected tracked writes.
- **R4 — PREWRITE PACKAGE FAIL:** the distributed ZIP did not contain `P0206_R4_PAYLOAD/check_pet_combat_candidate_contract.py` even though the R4 applier used `r2.NEW` to load the original R2 checker for exact-baseline verification. Its separately included `_R4.py` checker was the replacement, not the baseline. Python raised `FileNotFoundError`. No corrected tracked writes.

## R5 correction and release gates

R5 includes **both** the original R2 checker (exact bytes from the distributed R2 ZIP) and the corrected version-neutral R4 checker. The applier validates its full payload inventory **before** loading reconstructed R2 content or touching tracked files; it verifies the original checker's fixed SHA-256 and confirms the corrected checker contains no historical runtime pin. An extracted-archive dependency audit and syntax tests were performed before delivery. The full repository static checker suite runs against a prewrite shadow of the exact local candidate; it must reach the final `P0206 R5 APPLY PASS` before deployment. Any checker failure is a negative result, not a PASS.

R5 retains the R3/R4 quarantine design unchanged: P0205 native pet handling is restored byte-for-byte, the experimental `PetCombatCandidate` performs no native frame mutation, Phase H keeps all 18 controls in the six-row grid, and the Trial ON button explicitly rejects activation. Runtime `0.0.111-dev` is a **candidate only**.

**Next:** after R5 applies, deploy and `/reload`; use the developer panel (Phase H Trial Check/ON Blocked/OFF, native PET access, Phase D Immersion OFF/ON) and inspect BugCatcher. Stock pet controls must be visible/clickable after Immersion OFF and no protected errors may recur. On failure, stop; do not commit or push. Original P0197 combat duplication remains OPEN. No forced combat reproduction is required for quarantine validation.

## R5 runtime result — FAIL (observed)

After deployment at `0.0.111-dev`, loadCount 262, candidate QUARANTINED/armed=false, yet NativeSurfaceReplacement `petActions:folded` and the Blizzard pet bar remained absent after Immersion OFF by user observation. The R5 quarantine did not address the older native-fold path. No post-OFF native diagnostic or exact BugCatcher stack is present. **Do not commit R5.** Replaced by the unaccepted fail-open R6 checkpoint; preserve this failure permanently. See `docs/memory/evidence/P0206_R5_STOCK_PET_RESTORE_FAILURE.md`.
