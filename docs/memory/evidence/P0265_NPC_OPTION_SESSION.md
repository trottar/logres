# P0265 — combined NPC option interaction session

Date: 2026-10-19. Baseline: verified pushed `main` `6b3ed9655d149cda6f600ffbb1d135bfac7d211d` (P0264).

## Observed user evidence and project failure

The user reports P0264 reward selection, resetting and synthetic Complete feedback **worked as expected**. Uploaded `0.0.162-dev` diagnostics have eight authored preview choice clicks and PASS Quest Dialogue/Offer Controls/Run All checks with no quest production action. The last `npc previewchoices` audit after Run All is `inactive`, which records teardown rather than denying the user's visual acceptance. The actual commit `6b3ed96` on `main` is verified. This does not accept live multiple-choice claiming, generic gossip, service transactions, reserved quest 237, nor the native quest claim flash.

**Negative process evidence:** P0263 cosmetic-only extraction failed to provide player-visible progress; P0264 originally required three archives because R0's custom checker contained a prohibited historical build pin and R1's generated CURRENT_HANDOFF omitted `CURRENT.md` authority. R2 fixed both. The user explicitly rejects repeated one-off cosmetic or preview fixture patches. For P0265, four related functional families and diagnostics are bundled. Static full-suite and in-game verification remain separate; avoid falsely calling a fixture live NPC ownership.

## Combined implementation

One coherent P0265 checkpoint adds `Quest/OptionModel.lua` (four deterministic node graphs and a source-independent plain-envelope contract), `UI/OptionList.lua` (six-per-page two-column buttons, gold hover/disabled appearance, Back and option page controls), and `Quest/OptionSession.lua` (isolated preview-only controller with validated next-node navigation, previous-node stack/page restoration, overflow navigation, native action count 0). The original `QuestDialogue:PresentText` renders narrative text for all branch nodes. The option list only appears on the final narrative page; one long branch exercises the existing narrative paginator. `QuestDialogue` creates and resets the option session; non-option presentations disable its click regions. The existing reward choice interaction is unchanged.

Four new **P — Previews** actions use the SAME option model/view/controller: **NPC Choices: Branching** (history, road, nearby services, Farewell, locked gate); **NPC Choices: Services** (merchant, trainer, innkeeper, flight, repair, bank, auction description nodes; NO service operation); **NPC Choices: Overflow** (11 options, 6/page, preserve option page across Back); **NPC Choices: Locked** (two disabled entries with requirements and two enabled exits). F — Quest Dialogue Check prints read-only `npcoptions` counters, node, page, depth, result and nativeActions=0. Existing panel and camera source is unchanged, but gallery inventory static contracts rise from 30 to 34 P previews and 98 to 102 registered actions.

## Safety, limitations and expected runtime verification

No native gossip API read or Select, no quest Accept/Decline, GetQuestReward, protected UI mutation, polling, gossip window suppression, camera/DynamicCam change, new transaction or service assumption. This patch does NOT provide actual live NPC option selection and does not take over Blizzard's windows. Native bank/auction remain intentionally untouched; example service descriptions are representative authored UI cases, not proof of Forever availability. Options are synthetic, explicit preview-only, and have their own controller gating. Quest 237 must remain uncompleted.

Prepare candidate against exact pushed baseline; prewrite full suite of at least 131 `tools/check_*.py` in shadow, differential whitespace check, then postwrite full suite, manifest and rollback on failure. Script reports ALL checker failures rather than only first. Runtime acceptance requires P-tab four scenarios, long narrative final page, back, overflow, locked, existing reward preview regression, F and H checks with diagnostic export. Do not claim runtime PASS before user tests.

## Known deferrals and next meaningful scope

Real live gossip adapter, safe native option selection, all NPC services, reward claiming and Blizzard frame flash remain OPEN/DEFERRED pending direct capability/runtime evidence. Additional visual-only fixture changes must not be mistaken for those completions. The actual camera/session continuity is accepted as working and must remain frozen absent explicit new evidence.

## P0265 R0 prewrite failure — 2026-10-19 (preserved)

The user ran the original P0265 applier against verified P0264 and a clean tracked worktree. Baseline and candidate preparation PASS, but the 132-checker shadow suite reported **1 failure**: `check_p0263_n3_decision_visual_contract.py` with `ERROR: N3 visual must load before original quest frame construction`. Since this is a prewrite failure, no tracked repo files were changed. Root cause: R0 inserted `UI\OptionList.lua` between `UI\DecisionVisual.lua` and `Quest\ContextVisual.lua`, violating a historical four-source adjacency invariant. This was a packaging regression, not WoW runtime evidence.

**R1 corrective action:** insert new `UI\OptionList.lua` *before* `UI\NarrativePages.lua` instead. This preserves exact `UI\NarrativePages.lua` → `UI\DecisionVisual.lua` → `Quest\ContextVisual.lua` adjacency and puts the new renderer ahead of its OptionModel/OptionSession consumers. Add explicit candidate preflight assertions for both the legacy adjacency and new load order. Do **not** relax or edit the historical P0263 checker. No changes to camera, Quest native controllers, reward visual, or synthetic option behavior. R1 must rerun the complete shadow and postwrite suites; client validation remains pending.
