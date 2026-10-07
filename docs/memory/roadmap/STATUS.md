# Roadmap Status

As of 2026-10-07.

## Active work stream

**Complete captured DynamicCam RPG camera parity in consolidated source-backed layers, then enter Phase H integration-first: safe stock-surface suppression/coexistence, authored UI positioning, then final polish and remaining visuals.**

P0161 is durable at `2a959094` / `0.0.80-dev` and runtime-accepted for the observed Taxi/settings/shoulder-offset scope.

Phase G remains active only for:
1. P0162 source-backed reactive mouse-wheel zoom;
2. explicit closure with environmental deferrals for naturally unavailable contexts.

Phase H becomes primary after those Camera-only slices close.

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
| G — Cinematic Camera | ACTIVE — P0162 FINAL REACTIVE-ZOOM SLICE |
| H — Integration and Polish | QUEUED — NEXT AFTER PHASE G CAMERA PARITY |

## Phase G / G.5

P0160 R2 is durable at `ae75989b` / `0.0.79-dev`.

The normal-Taxi zoom gate now passes.

Outbound:
- start about `4.0096`;
- target/final `50`;
- 347 samples;
- 346 toward / 0 away;
- 0 switches;
- 2 rebases;
- failures=0.

Landing:
- start `50`;
- target `5`;
- final about `4.9806`;
- 158 samples;
- 156 toward / 1 away;
- 0 switches;
- 2 rebases;
- failures=0.

The user visually confirmed zoom-out during Taxi and return close after landing.

Classification:
**G.5 TAXI ZOOM CONVERGENCE CLOSED FOR OBSERVED SCOPE.**

The earlier P0117/P0159 landing failures remain preserved as historical evidence.

P0161 is accepted for observed scope. P0162 reactive mouse-wheel zoom is now the active G.6 implementation layer.

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
**INSTALLED / PUSHED — RUNTIME FAIL; REVERSAL PATH NOT EXERCISED** at `e9be312d` / `0.0.76-dev`.

The retest recorded camera `50 -> 50`, elapsed about `23.523s`, one sample, zero commands, and zero switches.

P0156:
**INSTALLED / PUSHED — OBSERVED NORMAL WORLD-ENTRY RUNTIME PASS** at `e1be731b` / `0.0.77-dev`.

World start/current/final about `5.0795`, target `5`, targetReached=true, failures=0, secret=false, error=nil; separate Run All clean. `firstDelay=0`, `switches=0`.

P0157:
**INSTALLED / PUSHED — DOCS / EVIDENCE + MEMORY-SCHEMA CHECKER HARDENING** at `328f1543`.

Records the P0156 pass, preserves two rolled-back delivery failures, hardens CURRENT heading validation, and returns Phase G.5 to the pending P0119 normal-Taxi landing proof.

P0158:
**INSTALLED / PUSHED — DOCS / ROADMAP SEQUENCING CHECKPOINT** at `27670624`.

Its high-level order remains:
Camera parity -> Phase H safe suppression/coexistence -> authored positions -> final polish.

## P0159 — captured-profile context + zoom parity

P0159 R1 is **INSTALLED / PUSHED** at
`8ddcf09844961adec7bc90621f0f5ca294f15aef`
on `0.0.78-dev`.

Observed runtime:
- ordinary Camera Profile Check PASS;
- separate Run All clean;
- profile secretSkips=0 / readFailures=0;
- Taxi target `50` PASS twice around `49.75597`;
- post-Taxi City `~49.75597 -> 5` FAIL at final zoom `0`;
- 97 samples / 80 switches / max absolute position error about `49.471`.

Classification:
profile/context and Taxi-entry behavior pass in observed scope; the shared bespoke zoom driver fails the destination transition.

## P0160 R2 — source-backed LibCamera zoom driver

P0160 R2 is **INSTALLED / PUSHED + RUNTIME PASS** at
`ae75989bc0acadf550bd26e39c9bc70acee3e46c`
on `0.0.79-dev`.

Base Camera Profile Check and separate Run All pass.

Normal Taxi:
- outbound `~4.0096 -> 50`, final `50`;
- landing `50 -> ~4.9806`;
- source rebase exercised twice in each direction;
- zero direction-switch oscillation;
- zero camera failures.

The user visually confirmed the expected zoom-out and landing return.

## P0161 — captured profile rotation/settings parity

**PREPARED — RUNTIME EVIDENCE REQUIRED.**

P0161 ports the next audited DynamicCam/LibCamera layer:
- five captured rotation behaviors with rotate-back;
- captured standard dynamic-pitch/focus settings;
- standard/NPC zoom-based shoulder curves;
- explicit City max-distance factor `1`;
- exact pre-ownership CVar restoration.

The absent standard max-distance profile field is not invented; the pre-ownership live value is the ordinary baseline outside City.

Reactive mouse-wheel zoom remains the final non-presentation Phase G slice.

DynamicCam UI fade remains Phase H presentation policy.

Next:
**Apply/deploy P0161, run Camera Profile Check + Run All, verify ordinary manual zoom, then verify normal-Taxi continuous left yaw and landing rotate-back.**
