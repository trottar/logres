---
memory_schema: 1
as_of: 2026-10-15
project: logres
---

# Current State

## Active Objective
**Phase H integration and polish.** P0211 `0.0.121-dev` addresses the P0209 R8 startup pet-visibility defect using addon-owned event-driven readiness notification. The user has now confirmed Blizzard PetFrame and PetActionBar are absent on Immersion-ON `/reload`, return with Immersion OFF, disappear on ON, and remain absent through observed combat. This **closes the observed pet-duplication/initial-reload presentation defect for those tested paths**, not untested secure-click/autocast/taint scenarios. P0211's GitHub commit was **not independently verified** when this checkpoint was authored: latest remote `main` returned `4076d25` (P0210). The local patch must verify the applied P0211 source and repo ancestry; a successful WoW test alone does not establish a Git push.

## Current Work Item
**P0212 docs-only evidence acceptance and development method correction.** Preserve P0211 runtime source without further pet visibility edits; correctly record the latest user and diagnostics evidence; stop repeating pet frame suppression experiments in the absence of a new defect. Default validation path is the **in-game developer panel**, where matching actions exist. Before inventing secure-action-bar or native pet/visibility mechanics, compare established, current Bartender4 and Dominos implementations with the exact target Blizzard/Forever API and build. Use their designs as references, never assume cross-version compatibility or add either as a dependency.

## Verified State
- Last independently verified remote `main` before P0212 creation: P0210 `4076d2502a02613a8767815d4911b0311e11e1bf`; P0211 push not yet verified.
- User test: Immersion-ON reload lacks Blizzard PetFrame/PetActionBar; OFF restores stock visually; ON re-suppresses; combat keeps stock copies absent; no additional issue seen in tested scope.
- Latest `LOGRES_DIAGNOSTICS_LATEST.lua`: `0.0.121-dev` loadCount 279, `immersionEnabled=true`; final pet trial `requested=true armed=true pending=false nativeDriver=true activations=6 restores=5 failures=0`; startup trace `worldArmed=no`, `worldReason=logres-secure-pet-actions-unavailable`, `firstArmEvent=pet-probe-armed`, `readinessWakeups=6`, `editModeGate=manager-initial-idle`. The first-world snapshot was **not yet armed**, but the specific readiness-edge handoff armed it afterward. No native visibility value was read.
- Prior user testing confirmed stock pet frames appear in Edit Mode. Fresh P0211 Edit Mode exit, PET STOCK clicks, secure pet-action activation/autocast, taint and protected-action checks are not independently proven in this latest report; classify as UNVERIFIED/DEFERRED, not PASS.
- Historical P0197/P0206/P0209 failures stay in earlier evidence and investigations; closure is bounded to now-observed duplicate/reload presentation, not erasure of failures.

## Next Action
Proceed to **H.3 authored visual/interaction integration**, using existing approved D-039/H.2 v4 design and current real client screen. Begin with a bounded native/action/pet UI consistency review and approved art fidelity, not another blanket Blizzard suppression scheme. For future secure action-bar work, study Bartender4 and Dominos first, then inspect exact Blizzard Forever source and run focused in-game developer-panel checks. If a fresh pet issue occurs, preserve its diagnostic and narrow reproduction before modifying the working driver. Verify the actual P0211/P0212 pushed GitHub commit before considering either durable.

## Success Criteria
Approved world-first design, single intentional pet/action presentation in supported normal/combat states, required secure controls and native fallbacks accessible, no regressed Edit Mode behavior or orphan click regions, and scoped panel/runtime evidence for any newly claimed behavior. Unobserved special modes, pet clicks/autocast and taint remain unverified until explicitly tested.

## Do Not Reopen Without New Evidence
Do not reintroduce hidden-parent native pet reparenting, protected-frame manual Hide/Show, polling/timer/OnUpdate reassertion, combat-time protected mutation or native secret-value inspection. Do not remove stock fallback without a proven replacement. Preserve D-039 approved art, H.2 v4 geometry, the complete Phase H developer panel, intentionally absent exact player HP, stock party/target auras and special-action fallbacks.

## Relevant References
- `docs/memory/evidence/P0212_PET_ACCEPTANCE_AND_WORKFLOW.md`
- `docs/memory/patches/P0212_PET_ACCEPTANCE_AND_WORKFLOW.md`
- `docs/memory/evidence/P0211_PET_STARTUP_RECONCILIATION.md`
- `docs/memory/evidence/P0209_R8_IMMERSIVE_PET_OWNERSHIP_EVIDENCE.md`
- `docs/memory/evidence/P0210_WORKTREE_RECONCILIATION.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/design/H3_APPROVED_ART_RUNTIME_FIDELITY.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/investigations/ACTIVE.md`
- `docs/ROADMAP.md`
