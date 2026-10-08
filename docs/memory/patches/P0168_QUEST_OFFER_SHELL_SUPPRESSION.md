# P0168 — Quest offer shell suppression (Phase H.1 reopened)

Status: R1 PREPARED — R0 SHADOW CONTRACT FAILURE; RUNTIME GATE REQUIRED
Date: 2026-10-07
Baseline: `f58bccfb91fe8f6165b543c936cea4bb0ac29a06`
Candidate: `0.0.85-dev`

- Reopens H.1 by user direction; preserves the prior mistaken closure as historical evidence.
- Extends P0165's supported ordinary offer gate to suppress stock QuestFrame root alpha and disable its captured descendant mouse tree while the native frame itself stays shown for event/escape lifecycle.
- Exact original alpha and all captured mouse states restored on Logres loss of ownership, Immersion OFF, action resolution and quest-state transitions. No hidden stock click regions intended.
- Safeguards: out-of-combat only for new suppression; no secret inspection; bounds subtree to 512; missing/unsafe state fails open; no periodic retries/global hooks/reparenting/HideUIPanel.
- Source anchor: Forever 70245 `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`.
- Adds visual ownership/captured mouse-frame count to existing Phase H Quest Offer Stock Check; no extra panel action.
- Preserves full Blizzard progress/complete/reward/gossip, PvP/auto-accept, Main/Override/pet/party/minimap, objective tracker, permanent XP, aura and class fallback.
- Static shadow checker suite and `git diff --check` must pass before tracked writes; live visual/interaction runtime acceptance is still open.

Runtime gate: `/reload`, Phase H Quest Offer Stock Check, Phase 0 Run All, one normal quest offer visual/mouse test, Immersion OFF/ON restoration, Logres action, no Lua/protected/taint/secret failures. Commit/push by user only after PASS.

## R0 delivery failure and R1 correction

R0 verified `f58bccfb` and constructed the candidate, then the **pre-write shadow checker** rejected it: `P0168 quest visual contract missing: visualSnapshot =`. The generated Lua correctly captures `local visualSnapshot, visualError = self:CaptureOfferPresentation()`, so R0's static contract expected the wrong assignment shape. User output confirmed only untracked delivery files and diagnostics; no tracked modifications. This is a delivery/checker self-mismatch, not a runtime failure or PASS.

R1 checks the exact generated declaration, and also removes the R0 `QUEST_ITEM_UPDATE` restore trigger: Blizzard can update quest items while an ordinary offer remains open, so that event is not proof that Logres should relinquish offer ownership. Existing `QUEST_ACCEPTED`, `QUEST_FINISHED`, `QUEST_PROGRESS`, `QUEST_COMPLETE`, detail-panel hide, and Immersion OFF restoration remain. Full suite and in-client validation are still required.
