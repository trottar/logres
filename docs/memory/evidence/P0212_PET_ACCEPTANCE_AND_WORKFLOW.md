# P0212 — User-accepted pet visibility, P0211 startup trace, panel-first method

Date: 2026-10-15. Docs-only acceptance; no Lua runtime change or WoW redeployment.

## Source versus observed outcome
P0211 candidate `0.0.121-dev` added addon-owned readiness handoffs to the P0209 R8 secure visibility driver. User reports the original reload defect is now fixed: with Immersion ON after `/reload`, **Blizzard PetFrame and PetActionBar are absent**; Immersion OFF returns stock controls visually; ON removes those native surfaces again; combat did not unexpectedly reveal Blizzard duplicates. User encountered no other issue in these tests and considers the observed problem fixed. Prior test also confirmed proper Blizzard frames when entering Edit Mode. This is a user-confirmed **bounded visual/behavioral PASS**, not a complete proof of action clicks, autocast, PET STOCK interaction, Edit Mode exit or absence of Lua/taint.

Latest supplied `LOGRES_DIAGNOSTICS_LATEST.lua`: `LogresDB.meta.loadCount=279`, saved Immersion ON. Status `0.0.121-dev`. The final `petbardriver check` (after OFF/ON toggles, not immediately at first-world frame) reports `requested=true armed=true pending=false nativeDriver=true logresDriver=false activations=6 restores=5 failures=0`; startup diagnostics report `worldArmed=no worldReason=logres-secure-pet-actions-unavailable firstArmEvent=pet-probe-armed readinessWakeups=6 lastWake=pet-probe-armed editModeGate=manager-initial-idle`. This supports the original hypothesis: at the initial `PLAYER_ENTERING_WORLD` observation the probe dependency was unavailable, but an explicit post-arm notification established suppression. No Blizzard protected presentation fields were read. The final snapshot alone is not a proof that first-world was already hidden; the user-visible reload result supplies that confirmation.

Historical P0210 wrongly recorded a reload PASS before the user's corrective report; P0211 evidence records the subsequent observed reload FAIL. Both are retained as history, not silently rewritten. P0197 duplication, P0206 protected/restoration and P0209 R0–R7 experiments remain historical failures; tested normal reload and observed combat duplicate presentation now have positive coverage in P0211.

## Process findings and decisions
The user explicitly reinforced that **in-game developer panels** are the mandated first choice for test actions; sending slash-command tests when an identical panel button exists was a repeated workflow failure. Future instructions lead with the exact panel phase and button. Slash commands appear only if the panel lacks the action or a specific console-only action is needed.

Before reengineering native action/pet/UI behavior, study the established **Bartender4** and **Dominos** source patterns and the relevant Blizzard Forever API, compare versions and supported restrictions, and attempt the smallest safe integration. These addons are **references**, not dependencies or automatic authorization to transplant hidden-parent/reparenting or protected code. A faster earlier source-based resolution does not retroactively make an unsafe pattern suitable. Test in Wow Forever; preserve protected/secret rules and fail-open stock fallback.

## Authority and remaining uncertainty
At preparation, `https://api.github.com/repos/trottar/logres/branches/main` still returned commit `4076d2502a02613a8767815d4911b0311e11e1bf` (P0210), despite the user's statement that P0211 was pushed. This is a **verification discrepancy**, not evidence that the user did not perform a local commit/push. P0212 applier requires the P0211 candidate to exist in the current worktree and main ancestry from P0210. Future checkpoint should verify P0211 and P0212 commits on remote main before claiming durability.

## Next work
Do not alter working pet visibility. Proceed with H.3 approved screen-wide art/interaction polish starting from D-039 and H.2 v4 layout. Any pet button/autocast/PET STOCK/Edit Mode exit/BugCatcher claim needs its own actual in-game evidence; mark other cases unverified rather than retest by default.
