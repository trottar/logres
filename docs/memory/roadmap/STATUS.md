# Roadmap Status

As of 2026-10-06.

## Active work stream

**P0152 pet-action baseline remains accepted; P0154 diagnosed a world-entry direction-switch defect and P0155 R1 prepares the bounded correction.**

The formal roadmap remains capability-gated and Phase G is still open. Broader
Camera feature work remains frozen, but the reproduced world-entry regression is
active until the transition driver is safe again.

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | COMPLETE |
| B — Core HUD | COMPLETE |
| C — Action Interface | COMPLETE |
| D — Immersion Controller | COMPLETE |
| E — Compass and Navigation | COMPLETE |
| F — Quest Experience | COMPLETE |
| G — Cinematic Camera | ACTIVE — G.5 OPEN / WORLD-ENTRY REGRESSION |
| H — Integration and Polish | QUEUED — approved visual translation underway in parallel |

## Phase G / G.5

P0119 is durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`
on `0.0.49-dev`.

Its frame-shaped MoveView transition correction is installed, but the normal-Taxi
landing retest has not been durably recorded as PASS. G.5 therefore remains open.

Camera work resumes only after the current approved visual sequence is finished.
No max-distance mutation, Taxi rotation, or Taxi UI fade is authorized.

P0154 is verified durable at `40dec187` / `0.0.75-dev` and the diagnostic passed while the behavior still failed. World entry started near `23.148`, targeted `5`, reached observed range `0 -> 50`, and timed out at `50`. The motion line recorded `142` inward commands and `1` outward command.

That one reversal exposes a concrete P0119 cleanup defect: when crossed-target correction changes direction, the old MoveView direction was not stopped before the opposite direction started. P0155 R1 corrects only that defect on candidate `0.0.76-dev`; positional rebasing and arbitrary world-entry delay remain unauthorized.

## Parallel approved visual translation

Accepted checkpoints:

- P0120 shared percentage/resource bar — core runtime + visual PASS; richer
  ornament deferred;
- P0121 cast-state cue — player cast PASS; target runtime proof deferred;
- P0122 Context-message primitive — runtime/preview path PASS; completion styling
  deferred;
- P0123 heading/manual-waypoint Compass — runtime + visual PASS;
- P0124 organic player-health tunnel — runtime + visual baseline accepted;
  whole-interface polish deferred;
- P0126 Active Quest one-focus presentation — runtime + visual PASS at
  `89b0c563` / `0.0.58-dev`; whole-interface polish deferred.

P0128 source audit:
**RESOLVED — API/source layer available; mutation capability not proven.**

P0129:
**INSTALLED / PUSHED + READ-ONLY RUNTIME PASS FOR OBSERVED OFFER/GOSSIP SCOPE** at
`e50676b9` / `0.0.59-dev`.

Progress/complete and other unobserved categories remain deferred. Mutation
function presence was proven without invocation.

P0130:
**RUNTIME + VISUAL PASS on `0.0.61-dev`** — bounded/paged offer narrative accepted;
initial immersion-restore failure preserved and corrected in R1.

P0131:
**ACCEPT + DECLINE CAPABILITY PASS** — Decline proven on `0.0.62-dev`; Accept proven
on corrected `0.0.63-dev` with matched `QUEST_ACCEPTED` after intermediate
`QUEST_FINISHED`.

P0132:
**INSTALLED / PUSHED + RUNTIME/CONTROL PASS; VISUAL ORDER CORRECTION REQUIRED** at
`671f9836` / `0.0.64-dev`.

Production Decline/Accept behavior passes and Blizzard fallback remains usable.
Manual review found the Logres horizontal order opposite Blizzard's simultaneous
fallback.

P0133:
**INSTALLED / PUSHED — RUNTIME + VISUAL PASS** at `f2feead6` / `0.0.65-dev`.

Accept-left / Decline-right now matches Blizzard while the fallback remains
visible; preview/final-page behavior and integrated checks pass.

P0135:
**SOURCE + PRIORITY-POLICY LAYER RESOLVED — DOCS/SOURCE EVIDENCE ONLY.**

D-041 establishes the urgency/fallback policy and pins the exact Forever aura
source/secrecy contract. Production ownership remains unproven.

P0136:
**INSTALLED / PUSHED — RUNTIME PROBE PASS WITH ENVIRONMENTAL DEFERRALS** at
`ef769f6` / `0.0.66-dev`.

Ordinary populated player helpful data is proven. Player harmful populated data,
populated target data, and the runtime secret-skip branch remain DEFERRED.
Integrated checks pass.

P0137:
**INSTALLED / PUSHED — RUNTIME + VISUAL PASS** at `2b578759` / `0.0.67-dev`.

The production player `HELPFUL|PLAYER` passive lane is accepted at real UI scale.
Player harmful/urgent and populated target aura categories remain environmental
deferrals; private/group aura ownership and stock suppression remain gated.

P0139:
**INSTALLED / PUSHED — SOURCE + FALLBACK POLICY LAYER RESOLVED** at `b0122136`.

D-042 accepts a conditional accessible nameplate as the only world-anchor
candidate, preserves the current screen-space target fallback, restricts reaction
to ordinary runtime-proven state, and limits relative danger to trivial-target
de-emphasis without exact difficulty inspection.

P0140:
**INSTALLED / PUSHED — RUNTIME PASS WITH ENVIRONMENTAL ANCHOR/ATTACHMENT DEFERRAL** at
`f7e2c31d` / `0.0.68-dev`.

Safe no-nameplate fallback, ordinary friendly reaction, ordinary
`UnitIsTrivial=false`, zero probe failures/secret skips, and integrated `Run All`
are proven for the observed scope. No accessible target nameplate was observed, so
positive anchoring, behind-camera behavior, and hidden attachment remain deferred.
Production target placement remains screen-space.

P0142:
**SOURCE-CAPABILITY LAYER RESOLVED — DOCS/PRIMARY-SOURCE EVIDENCE ONLY.**

D-043 records the source/fallback policy. Tracking selection is multi-select;
individual tracked-result and service-instance positions are not exposed by the
audited public source surface. Current-map `C_AreaPoiInfo`, minimap view radius,
broader current navigation, and same-map geometry survive as runtime candidates.

P0143:
**INSTALLED / PUSHED — RUNTIME PASS FOR OBSERVED READ-ONLY SOURCE SCOPE WITH ENVIRONMENTAL DEFERRALS** at `b9b2f90b` / `0.0.69-dev`.

Current map/player position, map world size, minimap view radius, and 23/23
tracking selector rows were ordinary with zero secret skips/failures. Four tracking
selectors were independently active. The tested map had no AreaPOI rows and no
current/quest/user-waypoint destination, so those paths and actual destination
distance remain DEFERRED. Integrated `Run All` passed.

P0145 `60244841` / `0.0.70-dev` proves manual-waypoint same-map distance and
clear-state fallback.

P0147 `c274a9d1` / `0.0.71-dev` proves the live-radius band mechanics but fails
visual calibration because the original scale span is too subtle.

P0148 `6f381a77` / `0.0.72-dev` is runtime + visual PASS with stronger
`1.20 / 1.05 / 0.85 / 0.70` anchors. The user accepts this as the production
baseline; exact amplitude refinement is deferred to later polish.

Quest/current-navigation, AreaPOI/service, tracking-result, and stock minimap
boundaries remain unchanged.

P0149 resolves the class/pet/special-control source layer against pinned Forever
`1.60.1.70205` source and accepts D-044. Pet secure casting is the strongest
control candidate, but no stock class/pet/special suppression is authorized.
P0150 bounded read-only runtime proof is next.

P0150:
**INSTALLED / PUSHED — RUNTIME PASS FOR OBSERVED READ-ONLY SCOPE WITH ENVIRONMENTAL DEFERRALS** at `46e06295` / `0.0.73-dev`.

The corrected R3 probe passes with 22/22 expected events, required APIs present,
10 pet slots scanned / 7 occupied, one safely secret-skipped Warlock power value,
ordinary false special-mode flags, and zero failures. Separate integrated Run All
passes.

Stance/forms, active totems, DK runes, active special modes, and meaningful nonzero
class-resource presentation remain DEFERRED.

Client build `70235` has matching Forever source at
`a84e2b1b41d3d4137127c07e4da448aa3251d6f1`; it is the direct child of the
P0149 `70205` pin and changes only `version.txt`. The audited secure pet source
files are unchanged.

P0151:
**INSTALLED / PUSHED — DOCS / RUNTIME-EVIDENCE CHECKPOINT** at `b62397b1`.

Records P0150 acceptance, 70235 source continuity, and opens P0152.

P0152:
**INSTALLED / PUSHED — R12 RUNTIME + CONTROL + STATE-PRESENTATION PASS; FINAL VISUAL POLISH DEFERRED** at `00aef4a9` / `0.0.74-dev`.

The accepted pet-state diagnostic recognizes ten click-specific pet bindings, seven naturally readable/occupied slots, two active indicators, and one autocast indicator. Default-on arming succeeds, and the user confirmed the visible state treatment and pet button execution. Stock PetActionBar remains available; edit/reorder/bindings/suppression/PetFrame and other class/special ownership remain separately gated.

P0153:
**INSTALLED / PUSHED — DOCS / EVIDENCE CHECKPOINT** at `7ad9be7e`.

Records P0152 acceptance and the initial world-entry camera timeout.

P0154:
**INSTALLED / PUSHED — DIAGNOSTIC PASS; RUNTIME CAMERA FAILURE PRESERVED** at `40dec187` / `0.0.75-dev`.

The diagnostic captured `145` samples, observed range `0 -> 50`, final/max easing error `45`, and command counts `142` inward / `1` outward.

P0155:
**R1 PREPARED — TARGETED DIRECTION-SWITCH CORRECTION on candidate `0.0.76-dev`.**

Stop/reset the previous MoveView direction before starting the opposite direction during P0119 crossed-target correction. No polling, arbitrary delay, positional rebase, CVar mutation, target/timing change, or Taxi expansion.

Next:
**Deploy P0155 R1, `/reload`, Phase G -> Camera World/Combat Check, then Phase 0 -> Run All, and upload diagnostics.**
