# Current Handoff — P0263 N3 shared decision button visuals

Authority: `docs/memory/CURRENT.md`, D-046, D-047, P0260 audit, P0262 evidence, and `docs/memory/evidence/P0263_N3_DECISION_VISUAL_EXTRACTION.md`.

Verified GitHub main `36d43f6` contains P0262. User observed all five requested P-tab previews and page navigation working as expected; newest `0.0.160-dev` export reports questdialogue/questoffercontrols/checkall PASS with synthetic action result `preview-only`. This is scoped preview regression evidence, NOT live choice/claim, generic gossip, or full camera regression.

P0263 relocates the original Accept/Decline/Complete button visual factory, including colors, texture, label and cosmetic hover/press behavior, into `UI/DecisionVisual.lua`. Exactly two original physical quest buttons remain. All `OnClick` callbacks, source/ownership/geometry and native completion restoration stay in `Quest/Dialogue.lua` and existing controllers. No camera or DynamicCam files touched. Full WSL checkers run before any tracked write, then repeat after; N3 remains in-game unverified until the five P-tab page-1 previews visually match and inert clicks remain preview-only.

Next after acceptance: add dedicated inert generic decision-state fixtures via the same visual, then source-backed option list N4 only after a second concrete use case. Preserve quest237 and native controls; bank/auction remain post-modularity deferred.
