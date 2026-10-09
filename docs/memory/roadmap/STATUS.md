# Roadmap Status

As of 2026-10-08.

Current checkpoint: P0168 R1 is verified and user-confirmed; P0169 is a Bars 4–5/layout candidate, not runtime-accepted. Earlier P0168 runtime-pending prose below is historical.

## Active work stream

**Phase H.1 reopened — finish redundant Blizzard presentation suppression before visual calibration.**

P0167 is verified on main at `f58bccfb` / `0.0.84-dev`; user-supplied runtime confirms Phase H Layout Check (13/15, zero errors) and Run All PASS. The user's correction supersedes the P0164 claim that H.1 was finished merely because P0165 hid Accept/Decline; already-existing D/C suppression is not new H.1 work.

P0168 candidate `0.0.85-dev` suppresses the remaining ordinary quest-offer **QuestFrame shell** while the validated Logres narrative/actions own that offer. It preserves QuestFrame lifecycle (no `Hide`, no `SetParent`), disables the full captured stock mouse subtree, and restores exact presentation/mouse state before Logres withdraws. All unsupported offer and quest states remain Blizzard-owned. Runtime validation is pending; no broad UI removal is claimed.

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
| G — Cinematic Camera | COMPLETE — P0162 RUNTIME PASS; ENVIRONMENTAL DEFERRALS PRESERVED |
| H — Integration and Polish | ACTIVE — H.1 REOPENED; P0168 QUEST-OFFER SHELL RUNTIME GATE |

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

P0161 remains accepted for observed scope. P0162 reactive mouse-wheel zoom is runtime-accepted at `4628f49e` / `0.0.81-dev`; G.6 and Phase G are closed for claimed observed scope.

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

**INSTALLED / PUSHED + RUNTIME PASS FOR OBSERVED TAXI/SETTINGS/SHOULDER SCOPE** at `2a959094` / `0.0.80-dev`.

Accepted evidence includes Taxi target `50`, continuous yaw `-20`, City landing return about `4.97-5.01`, rotate-back completion, City max-distance factor `1` with captured original factor `4`, and zero profile/camera secret/runtime failures.

## P0162 — reactive mouse-wheel zoom

**INSTALLED / PUSHED + RUNTIME PASS** at `4628f49e` / `0.0.81-dev`.

The bounded wheel gate passed with active/hooked `OutQuad`, final `wheel=36`, `quick=9`, `resets=2`, `native=4`, `corrections=15`, OFF/ON release/reacquire, user-confirmed native wheel while OFF, and zero hook conflicts/secrets/failures.

## P0163 — Phase G closure

P0163 records the P0162 pass, closes Phase G for claimed observed scope, preserves Teleport/NPC/Fishing/Gathering/unobserved-AFK environmental deferrals, and makes Phase H primary. No WoW runtime code changes or redeploy are required.


## P0164 — Phase H.1 stock-surface suppression audit

**AUDIT COMPLETE — DOCS/EVIDENCE ONLY; NO RUNTIME MUTATION.**

The ownership matrix confirms existing runtime-proven suppression for Quiet Mode passive chat/social presentation, selective Player and Target shells, and conditional stock Bar 2–3 replacement. It preserves stock minimap, Party/CompactPartyFrame, target aura/status and target-of-target, Main/Override/special action surfaces, PetActionBar/PetFrame, class/resource/special surfaces, full quest tracking/log, persistent XP, nameplates, and unsupported quest states.

Hide Anything-style product guidance plus source-backed MoveAny mechanics were reviewed. Logres adopts only per-surface snapshot/restore, appropriate alpha+mouse or hidden-parent mechanics, combat protection, and evidence-specific reconciliation; it does not adopt blanket hiding, polling, timer retry loops, or permanent parent locks.

P0165 is the selected first new suppression slice: stock quest-offer Accept/Decline controls only, after exact Forever source/lifecycle verification. The whole QuestFrame and all unsupported quest/gossip states remain Blizzard-owned.

## P0169 — screenshot-grounded Bar 4–5 and layout candidate (2026-10-08)

The verified P0168 main `b455e7cf` and user-confirmed ordinary quest-offer suppression do not establish whole-screen stock-UI completion. The current screenshot reveals significant native presentation still visible. This is negative integration evidence. P0169 candidate `0.0.86-dev` adds source-backed Bar 4/5 secure Logres clusters + reversible normal-bar suppression, extends layout anchors from 13 to 15, and calibrates five ordinary action clusters. Main/Override, PetActionBar/PetFrame, minimap, full tracker, permanent XP, micro-menu and other unsupported controls stay stock and accessible. H.1 is ACTIVE; runtime/manual visual PASS is required before checkpoint acceptance; H.2 final layout is not closed.

## P0170 — P0169 startup error and diagnostic correction (2026-10-08)

Verified GitHub main `74ff4156` / `0.0.86-dev` is P0169. Uploaded diagnostics reveal early Bar 4/5 source configuration unreadable with `requested=false applied=false` while `stockreplacecheck` incorrectly emitted PASS. Later `Run All` induced a preference reconciliation and the normal Bar 2–5 replacement, extra routing and layout reported PASS. The failure and the later success are both preserved, with clean-login still OPEN. P0170 candidate `0.0.87-dev` preserves requested state on transient unreadable settings, retries on specific Blizzard lifecycle events, preserves last-known cluster presentation, and makes stockreplacecheck require expected/applied agreement/no pending/error. No new native hiding; Phase H.1 remains ACTIVE. Runtime acceptance requires **first post-reload** panel check before any Run All or preference mutation.

## P0171 — corrected H.1 product objective and P0170 acceptance (2026-10-08)

GitHub main `95aaa593` / `0.0.87-dev` is verified. Uploaded post-login diagnostics show P0170 startup recovery PASS with `expected=true requested=true applied=true pending=false`, one deferral/one `PLAYER_ENTERING_WORLD` retry, and accepted stock Bars 2–5 routing plus Layout Check 15/17. That is a **narrow fix**, not completed Blizzard UI replacement. Earlier P0169 startup false PASS and generated-patch failures remain negative evidence. The assistant repeatedly diverted the user's request into serial audit/one-surface work and incorrectly claimed that all working matches had been hidden; the screenshot and surviving Main/pet/minimap/quests/XP/menu disprove this. **H.1 ACTIVE**: next one coherent missing-replacements/on-demand-fallback/suppression and positioning checkpoint; one combined visual/interaction/restoration gate. Source-backed secure protection and fail-open rules remain mandatory. Canonical failure record: `../evidence/P0171_H1_SCOPE_AND_DELIVERY_FAILURES_2026-10-08.md`.

## P0172 — coordinated four-domain native access (2026-10-08)

Against verified P0171 `26fa1ef7`, P0172 candidate `0.0.88-dev` implements a compact anchored access dock for navigation, full objective tracking, progress/status and micro-menu/bags, with native root capture/hide/restore, combat deferral and diagnostic counters. User-visible navigation/quest/menu functions remain reachable on demand. Main and pet protected action/control bars remain native until safe coverage exists; their remaining work is part of the same OPEN H.1 integration objective. Static source findings are not a full-screen runtime pass. Test screenshot, click regions, Blizzard lifecycle, manual access, OFF/ON and combat before accepting.

### P0173 — primary stock ownership gate

P0172 is verified on GitHub main `3a5028c8` / `0.0.88-dev`. User confirms most stock presentation folded and dock buttons working; Main normal primary remains visible. The final Native Access diagnostic was post-manual-open (0 folded/4 open), not an independent folded-persistence proof. P0173 `0.0.89-dev` source-backed read-only Primary ownership diagnostic is the current runtime candidate: classify ordinary Main 12-button source, five secure mode flags, current Logres routing/page readiness, while leaving Main and special controls stock. Phase H.1 remains OPEN, with next product gate combat-safe Main special/edit fallback and visual integration. Do not mistake diagnostics-only PASS for suppression.

### P0174 — action interaction, native cast and tracker coexistence (2026-10-08)

P0173 verified at `f9c99685` / `0.0.89-dev`: Primary read-only normal ownership PASS, optional routing ON `candidate=true`, routing OFF stock restored, all four original native domains folded, Run All clean. New user-reported limitations: action drag rearrangement absent, native cast bars still displayed, intermittent quest tracker return, Logres actions/aura tooltips absent. P0174 `0.0.90-dev` combines source-backed drag/swap and hover tooltips with reversible CAST native-access domain and event-targeted objective/cast re-fold; runtime candidate, all newly changed behaviors untested. Qualitative cast glyphs do not replace cast duration, so native on-demand CAST access is mandatory. No Main secure suppression or H.1 closure.

### P0174 R1 — failed pre-write shadow memory check (2026-10-08)

P0174 R1 SHA-256 `91146e93ad9c01a297976da316327ffc5325ea149cdff4b39aaca2b14f808c8d` reached the shadow static checker suite, then failed at `check_memory_health.py`: the generated `docs/memory/CURRENT.md` contained zero `## Success Criteria` and zero `## Relevant References` headings. User provided full terminal output proving this failure. R1 refused before tracked writes; the user's P0174 local changes remained in place. R1 is SUPERSEDED by P0174 R2; do not stage/reset/reapply R1. R2 restores canonical headings, validates the same combined candidate, and preserves the runtime issues as OPEN.

### P0174 R2 — tracker/cast native reappearance correction (2026-10-08)

P0174 `0.0.90-dev` was applied locally and its static manifest uploaded, but remote main remained P0173 `f9c99685`. First screenshot shows the native Objective Tracker visibly back over the native-access dock; user reports the tracker intermittently vanishes/reappears, while native player/target cast bars return in combat and Blizzard auras remain. The user's explicit report is negative runtime evidence, not a PASS. P0174's `Fold()`/`Refold()` policy holds an existing snapshot but event-only invalidation can miss later native `Show()` calls. R2 makes source-specific OnShow re-folds outside lockdown, preserving intentional manual dock opens and restoration, and adds accurate reappearance/combat-deferral counters. **No secure combat cast suppression is claimed.** Comprehensive player harmful/private and target aura visuals and suppression remain OPEN under D-041; no unsafe blanket aura hide. R2 runtime not yet tested. P0174 and R2 are one checkpoint, with no intervening Git push.

### P0174 R3 — combat cast visibility gate (2026-10-08)

The user tested P0174 R2 `0.0.90-dev`: the native Objective Tracker no longer reappears, accepted for the observed quest-update scope. **Native player/target cast/channel bars still reappear during combat.** Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` shows `nativeuicheck` 5 folded/0 open, source-specific tracker `onshow-refold`, `nativeShows=30/20`, `combatDeferred=2`, and `pending=0` after combat. The out-of-combat PASS does not prove combat-time native presentation. Remote main remains P0173 `f9c99685`; P0174 and R2/R3 are local, unpushed candidates. Preserve this negative evidence.

Pinned Forever Blizzard source `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca` (`Blizzard_UIPanels_Game/Shared/CastingBarFrame.lua`, `Blizzard_UnitFrame/Mainline/TargetFrame.lua`) implements `CastingBarMixin:ShouldShowCastBar()` through `self.showCastbar` and offers `SetAndUpdateShowCastbar(showCastbar)`. R3 arms each of the three exact P0174 native cast sources' native show policy **out of combat**, before folding them; captures original flags only as opaque restoration tokens; and restores them through Blizzard's own setter when CAST is manually opened, Immersion turns OFF, or the module is disabled. No SetCVar, combat-time Hide/alpha, secure-handler snippets, reparenting, global hooks, or polling. If the setter is unavailable or fails, no cast folding authorization is granted, and stock remains the fallback. Native `OnShow` during combat while armed is recorded as a persistent escape, not a PASS after release. The existing CAST access dock is the explicit opt-in native casting-detail fallback (open before combat if exact progress is needed); Logres's production cast cue remains symbolic-only. Special-mode and combat-time CAST toggle are not claimed complete; full D-041 enemy/player aura replacement remains OPEN. Runtime validation of the new gate is PENDING; a source-backed hypothesis is not a PASS.

## P0175 — additive priority status lanes (2026-10-08)

Remote main verified at `996f6099` / `0.0.90-dev`, completing combined P0174/R2/R3 as a user-accepted observed runtime checkpoint. The post-R3 diagnostic records native access 5 folded/0 open, `castGate=true/true`, `gateEscapes=0`, integrated PASS. Earlier R1 shadow memory failure and R2 combat reappearance stay preserved as negative results. P0175 `0.0.91-dev` is an untested candidate providing real additive player urgent and target harmful/helpful priority aura icon lanes near authored screen-space fallback with native hover inspection and static preview. It does not hide stock auras, own private/group auras, prove world target attachment, or close H.1. D-041 and D-042 remain gates. In-game visual, natural source and safety tests required before acceptance.

### P0175 R1 — panel validation and target helpful coverage correction (2026-10-08)

The first P0175 delivery omitted the Status Aura Check/Preview controls from the developer panel despite panel-centric established validation; this was an integration failure. User also reports no visible enemy buff/debuff icons; P0175 source lacked an unqualified target `HELPFUL` fallback, while whether naturally populated enemy status was available remains unverified. R1 registers Status Aura Check, Preview ON, Preview OFF in Phase H and relocates the unchanged three pet-action execution probe buttons to Phase C (both phases stay within 15 buttons). It adds a general target `HELPFUL` fallback after urgent/priority target filters and distinguishes preview, populated live evidence, and environmental deferral in the status diagnostic. Blizzard aura frames remain stock, with D-041/D-042 gates unchanged. R1 is a corrective candidate until in-game validation; do not count static preview as populated runtime coverage.
### P0175 R2 — target debuff separation and loot flash (2026-10-08)

The user saw buffs on player and enemy but no debuffs after R1, plus one short quest-frame flash while looting. Runtime diagnostics proved preview icons (`2/3`) but did not prove populated live harmful data (player empty, target absent). A five-icon shared enemy status capacity could allow helpful effects to crowd out harmful effects. R2 splits target helpful/harmful into independent event-driven rows with separate category diagnostics, retains the existing player harmful row, source secret preflights, Blizzard aura fallback and Phase H status panel controls. It records the brief loot-associated Objective Tracker flash as OPEN / INTERMITTENT / UNREPRODUCED, not fixed by repeating Hide or polling; targeted cause and live harmful proof remain next acceptance gates. No blanket native aura or tracker suppression is authorized.

### P0175 R3 — preference-transition resource-bar regression (2026-10-08)

R2 failed in WoW: Phase 0 Run All stopped after Sensor Check with `StatusAuras.lua:273: attempt to index local 'rows' (a nil value)`, and persisted `immersionEnabled=false` hid the Logres mana resource bar. The R2 disabled aura snapshot omitted target `harmfulRows` / `helpfulRows` while the renderer always indexed those tables. P0175 R3 adds empty row tables on this disabled path and a new regression checker, retains player/target status visual features and Blizzard aura fallback. Runtime proof pending; no push. See `docs/memory/evidence/P0175_R3_PREFS_RESOURCE_RESTORE_2026-10-08.md`.

### P0176 — event-latched aura evidence and R3 runtime acceptance (2026-10-08)

P0175 R3 is now verified on `main` at `c55b6d7` / `0.0.91-dev`. Latest in-client `checkall` reached completion: Preference/Lifecycle/HUD and Status Aura checks passed; saved Immersion ON and HUD `visible=true`; no repeated nil-rows error. This closes R2's diagnosed Run All failure within its observed scope without erasing that failure. Live harmful samples remained empty/target absent and are DEFERRED, not PASS; brief looting quest flash remains OPEN/INTERMITTENT. P0176 `0.0.92-dev` is an untested read-only, event-latched per-category evidence candidate exposed in the existing Phase H Status Aura Check. Native aura fallback and all secure/protected boundaries remain unchanged.

### P0176 R1 — prewrite checker-compatibility correction (2026-10-08)

The original P0176 applier FAILED SAFELY before tracked writes after `check_status_aura_disabled_contract.py` could no longer isolate the disabled snapshot. The live-history instrumentation had been inserted within the active `elseif` branch. This prewrite failure is preserved, not counted as a WoW test or a successful patch. R1 moves the history call after the completed snapshot branch, gated on active/non-preview state, without modifying the R3 regression checker, rendering or aura sources. R1 requires fresh full-suite and WoW validation; original P0176 is superseded.

### P0177 — Independent Logres aura-source engine comparison (2026-10-08)

P0176 R1 is verified on main at `5379a9f` (`0.0.92-dev`). Runtime loadCount 224 confirmed two clean Run All completions and preview-excluded history; target helpful max=1 / positiveReads=4, player/target harmful max=0, final aggregate 456 secret skips across 53 scans (not unique auras), no source failures. Harmful-source capability is still DEFERRED. A source audit of WeakAuras (AuraUtil enumeration/trigger pipeline) and Plater (helpful/harmful separation, slot enumeration) informs P0177's *independently written* source engine, but their full code and restricted-source read strategies are not copied. Candidate `0.0.93-dev` adds a strictly read-only, per-index secret-preflight comparison of canonical HARMFUL/HELPFUL versus priority filters through the existing Phase H Status Aura Check. Preview and unsupported/absent targets defer; production renderers, stock aura coverage, native cast gate and quest native access remain unchanged. No renderer promotion or live harmful PASS until in-client evidence. The loot quest-tracker flash remains OPEN/INTERMITTENT.

### P0177 R1 — Recover uncommitted source files (2026-10-09)

The user pushed P0177 but GitHub `main` at `a2eed84` contains only the 12 modified tracked files: the TOC and Commands refer to a source engine not present on GitHub. The new `AuraSourceEngine.lua`, checker, patch/evidence and manifest were omitted. This is a real durability failure, not an in-game failure: client loadCount 225 at `0.0.93-dev` ran the local reader and completed Run All. Source compare observed target HELPFUL base ordinary=1 vs priority=0; HARMFUL remained empty/secret-restricted and hostile-only target proof remains deferred. P0177 R1 reconstructs missing files from the original ZIP and updates memory; no runtime logic changes. Verify the complete new-file set in the next user push before advancing. Loot quest flash and primary secure ownership remain open.

## P0178 — permanent Blizzard/Logres UI ownership checker (2026-10-09)

After GitHub verified P0177 R1 at `0f3f0b7`, the user requested a **flag-aware, expandable whole-interface** checker instead of repeated single-domain diagnostics, explicitly noting existing diagnostics already cover most behavior. P0178 adds a centrally registered, read-only inventory of Blizzard surfaces and Logres replacement/fallback (including deliberately stock domains), and displays the matrix in Phase 0 plus Run All. It consumes existing module debug snapshots; no new direct Blizzard presentation reads, polling or frame mutation. Classifications are PASS/FAIL/DEFERRED/STOCK; STOCK means intended retained fallback, not empirically verified visibility. Existing harmful-source limits, primary secure action fallback, and loot ObjectiveTracker flash remain open. Candidate `0.0.94-dev` requires full static and WoW validation before acceptance.

## P0178 R1 — Lua command-dispatch startup regression (2026-10-09)

Original P0178 `0.0.94-dev` failed in-client: `/logres` unavailable and another addon recorded `Commands.lua:4921: function at line 4566 has more than 60 upvalues`. Cause: added locally captured `runUIOwnershipCheck` exceeded Forever Lua's handler upvalue limit. The static checker and mock tests had missed whole-file compatibility. Preserve this as FAIL. Corrective R1 candidate `0.0.95-dev` dispatches via already-captured `Logres:RunUIOwnershipCheck()` instead, enhances the permanent audit checker to reject the local capture, and retains the same 35 ownership registrations. R1 requires exact-base/mixed-original-source validation, shadow static suite, deployment, `/reload`, restored `/logres`, UI Ownership Check, and Run All. This is a candidate, not runtime PASS. See `docs/memory/evidence/P0178_R1_SLASH_UPVALUE_FIX_2026-10-09.md`.
