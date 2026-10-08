# Phase H — Integration and Polish

Status: ACTIVE — H.1 REOPENED, P0169 EXTRA BARS/LAYOUT RUNTIME GATE

## Product objective

Integrate the proven Logres capabilities into one authored world-first
composition, expose only the settings needed to preserve meaningful player
choice, and finish fallback/restoration/accessibility behavior without turning
Logres into a general-purpose UI construction toolkit.

Canonical direction:
- `../decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `../decisions/D-033_PARALLEL_ART_DIRECTION_AND_WORLD_GHOST.md`
- `../decisions/D-034_SELECTIVE_HYBRID_E_AND_VISUAL_COMPONENTS.md`
- `../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `../decisions/D-036_HEALTH_TUNNEL_VISIBLE_FIELD_CONTRACT.md`
- `../decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `../decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `../decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `../decisions/D-040_PRODUCTION_VISUAL_ASSET_TRANSLATION_CONTRACT.md`
- `../architecture/WORLD_FIRST_LAYOUT.md`
- `../architecture/VISUAL_SYSTEM_DIRECTION.md`
- `../architecture/VISUAL_COMPONENT_INVENTORY.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../../design/approved/README.md`

## Accepted inputs

Phase H begins from these settled directions:
- world before abstraction;
- approved continuous player-health tunnel in which clear/usable visual field
  roughly follows remaining health, with increasingly severe critical collapse;
- four semantic navigation roles: manual waypoint, quest destination, local radius
  POI, and tracking; local POI/tracking capability remains unproven;
- D-038 compass focus/depth treatment: exact-bearing glyph anchors, center-focused
  identity with continuous angular fade, proximity-first focus selection when safe
  comparable distance exists, and bounded depth scaling for major destinations;
- stock minimap remains available until the complete D-037 replacement gate is
  satisfied;
- authored semantic screen regions;
- optional Active Quest current-focus presentation;
- NPC quest interaction is a future Logres-owned experience, with Blizzard
  fallback retained until each information/control surface is capability-proven;
- dedicated transient Context region;
- fixed Primary role plus user assignment of supported bars to
  Secondary/Utility roles;
- separate pet/class/special-control domains;
- world-attached target presentation as the intended default endpoint;
- urgent player debuffs near reaction/resources;
- passive player buffs/auras peripheral;
- target status attached to the world target when safe;
- every removed Blizzard surface requires a deliberate replacement/fallback.

## Phase G handoff — P0163

P0162 R3 is durable at `4628f49e` / `0.0.81-dev` and runtime-accepted. Phase G is complete for claimed observed scope. Hearth/Teleport, NPC Interaction, Fishing, Gathering, and unobserved AFK priority behavior remain explicit environmental deferrals. DynamicCam UI fading remains a Phase H presentation/suppression policy question.

P0164 completes the first Phase H audit. Existing proven suppression remains authoritative for Quiet Mode chat/social presentation, selective Player/Target shells, and conditional Bar 2–3 replacement. Incomplete domains remain stock. P0165 is the first new suppression slice: only Blizzard quest-offer Accept/Decline controls, with exact source/restoration proof before runtime mutation.


## H.1 audit result — P0164

Canonical evidence:
`../evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`.

P0164 uses Hide Anything as broad product guidance and source-backed MoveAny mechanics as implementation reference. The transferable rules are snapshot before mutation, disable interaction with invisible presentation, respect protected/combat constraints, restore exactly, and use targeted reconciliation only when a concrete lifecycle requires it.

The audit does **not** authorize a generic Logres hide-anything framework. Broad hidden-parent ownership, global Show/SetShown forcing, timer retries, polling, and parent locking remain inappropriate without surface-specific evidence.

P0165 R1 is durable at `0e83af06` / `0.0.82-dev` and runtime-accepted. Ordinary supported quest offers now use exact-source-backed stock Accept/Decline alpha+mouse suppression with exact restoration and zero observed suppression failures/secrets in the accepted gate. The preserved R0 camera rebase Lua failure was corrected without changing quest policy. H.1 is closed for currently replacement-proven stock surfaces.

P0166 R1 is durable at `a67e0cce` / `0.0.83-dev` and structurally runtime-accepted. `Integration/Layout.lua` owns named semantic anchors while preserving the current accepted coordinates. Objective Progress is decoupled from `LogresHUDTarget`; the pet-action cluster is decoupled from `LogresHUDAllies`. No new suppression or capability ownership is added.

P0167 corrects one developer-panel integration defect discovered after the push: Layout Check existed as a slash command and Run All diagnostic but was not registered in Phase H. The panel is already capped at 15 actions, so P0167 moves the two legacy quest-offer TEST mutation probes to Phase F and adds Layout Check to H. No layout coordinate or ownership change is included.

## Execution order

The high-level Phase H order is now explicit. Exact implementation details remain
capability-gated inside each step.

### 1. Stock-surface ownership, suppression, and coexistence

Start from the real in-client screen rather than from another broad concept pass.

For each Blizzard surface:
- determine whether Logres already provides every information/control function it
  intends to replace;
- require proven restoration/fail-open behavior;
- suppress/hide only the proven replaceable presentation layer;
- preserve Blizzard interaction/information where Logres is incomplete.

This is a surface-by-surface ownership pass, not blanket UI suppression. In
particular, existing minimap, party/CompactParty, target aura/status,
target-of-target, unsupported class/special-control, vehicle/override, and other
explicit fallback gates remain in force until separately replaced.

### 2. Authored layout and proper positions

Once coexistence is correct:
- establish stable integration-owned anchors for the accepted semantic regions;
- put Logres surfaces into their intended default positions;
- decouple incidental cross-module anchors;
- calibrate spacing and collision behavior at realistic combat/noncombat density;
- keep stock fallback surfaces in the composition where they remain required.

This step authors the default composition; it does not create an unrestricted
drag-anything UI construction toolkit.

### 3. Final polish and remaining visuals

Only after the suppression/coexistence and layout baseline is stable:
- whole-screen spacing, contrast, scale, opacity, and ornament calibration;
- action-density/hotkey/count refinement;
- pet-button ornament/contrast;
- health-tunnel and Compass final calibration;
- remaining accepted state variants;
- settings/accessibility presentation;
- genuinely uncovered visual work for newly capability-proven domains.

Capability-deferred data/control domains remain deferred until evidence exists.

## Candidate work slices

Within the execution order above, likely slices include:
- establish authored layout anchors / integration geometry;
- decouple transient Context from incidental module anchors;
- Active Quest toggle, ambient wording, and exact hover detail;
- Logres-owned NPC quest interaction: bounded/paged source text,
  accept/decline, continue/complete, reward choice, required quest-related
  gossip transitions, eligibility/error feedback, and fail-open fallback;
- broaden supported action sources and role assignment safely;
- optional limited action-grid/whole-cluster adjustments if justified;
- world-attached target capability and fallback policy;
- source/runtime audit for local POI, tracking-result, quest-destination, and
  remaining minimap information/control capabilities before any minimap suppression;
- integrate the accepted four-role compass marker system only for proven sources;
- aura/status ownership, filtering, and placement;
- coherent settings/toggles for optional Logres feature domains;
- accessibility, compatibility, restoration, performance, packaging, and final
  visual consistency.

## Parallel art-direction preparation

Phase H visual preparation can begin before Lua integration work reaches this
phase.

Parallel deliverables may include:
- moodboards / art-direction sheets;
- full-screen representative mockups;
- typography/color/opacity/spacing/motion tokens;
- reusable asset-family exploration;
- health-tunnel asset/mask implementation studies constrained by the frozen D-036
  visible-field mapping;
- compass state/detail sheets covering heading, manual waypoint, quest destination,
  local POI, generic tracking glyphs, center-focus identity/fade, collision lanes, and
  bounded depth states without implying source capability;
- canonical component boards from `VISUAL_COMPONENT_INVENTORY.md`, including full 36-button combat-density stress tests and state sheets.

Current preferred working direction:
**Selective Hybrid E on the World Ghost foundation** — authored/thematic treatment for meaning-heavy surfaces, simple high-density interaction controls, restrained Warcraft-native Logres/Camelot cues, and a shared percentage-bar primitive for percentage-based Logres-owned values except player health.

These outputs inform implementation later; they do not replace capability
proofs.

## Non-goals

Phase H does not automatically imply:
- arbitrary draggable frame construction;
- general action-bar profiles/editors;
- removal of stock fallbacks before replacements are proven;
- a permanent conventional player-health bar;
- a permanent multi-quest objective tracker.

## Exit

Phase H completes when the accepted Logres experience is integrated,
configurable at the intended product boundaries, fail-open, visually coherent,
and validated across the contexts/capabilities the project claims to own.

## Approved visual baseline — D-039

The twelve approved visual reference sheets are now tracked under
`docs/design/approved/` and accepted by D-039.

For the represented families, Phase H should default to implementation translation,
not another broad concept pass:
- derive production texture/mask/glyph assets;
- establish reusable art/tokens and stable authored anchors;
- wire approved primitives into already-proven runtime producers first;
- open separate capability slices where controls/data/ownership are still unproven;
- validate the final treatment in client at realistic density and world contrast.

The canonical component-by-component split between art, runtime plumbing, and
capability ownership is `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`.

Residual visual design remains for class-specific discrete mechanics,
settings/accessibility, exact hotkey/count/36-button density calibration, and any
future capability-proven surface absent from the approved sheets.

This parallel visual checkpoint remains valid. P0163 closes Phase G and activates the P0158 handoff: execute Phase H integration/coexistence first, authored layout second, and final polish last.

## First production translation — P0116

P0116 establishes `Logres/Media/` plus `Theme.lua` as the production asset/token
boundary and wires the approved action-button frame/state family into the
already-proven secure action runtime.

This is parallel Phase H preparation while G.5 remains active.

The implementation deliberately does not change:
- secure execution or paging;
- key routing;
- Primary/Secondary/Utility geometry;
- contextual alpha policy;
- stock Bar 2–3 replacement/restoration.

Static contract checks precede an in-client visual gate. A later evidence
checkpoint must record the real-scale result before the action primitive is
considered production visually proven.


## Action visual refinement — P0118

P0116's core production action primitive is accepted in client. P0118 applies
the approved aura-metadata readability idea to action keybinds with a stronger
near-black bronze-edged plate, compact modifier labels (`s-Q`, `c-C`, `a-E`),
and a modest 42 px default button size. Bottom-right counts and all secure action
behavior remain unchanged.

This remains parallel Phase H preparation while Phase G / G.5 runtime proof is
active.

## Parallel production visual translation — P0120–P0126

While Phase G remains the formal active roadmap phase, the user has explicitly
chosen to finish the already-approved visual translation sequence before
returning to Camera work.

Accepted parallel visual checkpoints:

- P0120: shared percentage-bar production baseline — accepted, additional
  ornament deferred;
- P0121: cast-state production glyph family — player cast runtime + visual PASS,
  target cast/channel naturally deferred;
- P0122: shared Context-message primitive — durable runtime/preview path PASS,
  objective-completion variant naturally deferred;
- P0123: heading/manual-waypoint Compass asset translation — runtime + visual
  PASS at `1721eb4d` / `0.0.53-dev`;
- P0124: organic player-health tunnel — runtime + visual baseline accepted at
  `1e7e27e` / `0.0.54-dev`; broad final polish deferred to whole-interface
  calibration;
- P0126: Active Quest one-focus presentation — runtime + visual PASS at
  `89b0c563` / `0.0.58-dev`; count-free objective labels, bar-only progress,
  hover-only exact detail; final whole-screen polish deferred.

P0128 source-audit result:
**SOURCE LAYER RESOLVED.**

Narrative/reward/gossip read sources exist on Forever, and the expected quest and
gossip action APIs exist, but mutation ownership remains runtime-unproven.

P0129:
**INSTALLED / PUSHED + READ-ONLY PASS FOR OBSERVED OFFER/GOSSIP SCOPE** at
`e50676b9` / `0.0.59-dev`.

Observed evidence proves offer title/body/objective, one stable available-gossip
quest row, and one real two-choice reward metadata sample without secret/call
failures. All expected mutation function groups were present with `invoked=0`.
Progress/complete and other unobserved categories remain deferred.

P0130:
**RUNTIME + VISUAL PASS — `0.0.61-dev`.**

Approved sheet 07 is now production-proven for the quest-offer state: full source
paging, Previous / Next, wrapped objective text, Blizzard-control coexistence, and
same-conversation Immersion OFF -> ON restoration. The initial restore failure is
preserved in evidence and corrected in R1.

P0131:
**ACCEPT + DECLINE CAPABILITY PASS.**

Decline is proven by `QUEST_FINISHED`; Accept is proven by a matched
`QUEST_ACCEPTED` after the intermediate `QUEST_FINISHED`, with no polling/timer or
new mutation surface.

P0132:
**RUNTIME + CONTROL PASS; VISUAL ORDER CORRECTION REQUIRED — `0.0.64-dev`.**

Production Decline and Accept both pass through the proven action path, preview is
non-mutating, final-page gating works, Blizzard controls remain visible, and
integrated checks pass.

Manual review found one visual integration defect: Logres placed Decline left /
Accept right, opposite Blizzard's simultaneously visible fallback.

P0133:
**RUNTIME + VISUAL PASS — `0.0.65-dev`.**

Accept-left / Decline-right now matches Blizzard's simultaneous fallback, while
preview/final-page gating, production routing, and integrated checks remain clean.

The quest-offer visual/control slice is accepted.

P0135:
**SOURCE + PRIORITY-POLICY LAYER RESOLVED.**

The exact Forever `C_UnitAuras` / `C_Secrets` source contract is pinned, and D-041
defines urgent player, passive player, target-status, private/group, PvP, and
accessibility boundaries.

No aura/status stock suppression is authorized.

P0136:
**RUNTIME PROBE PASS WITH ENVIRONMENTAL DEFERRALS on `0.0.66-dev`.**

Ordinary populated player helpful data is proven; selected metadata is ordinary.
Player harmful populated categories and populated target categories were absent,
so those remain DEFERRED. No secret branch was encountered. Integrated checks
pass.

P0137:
**RUNTIME + VISUAL PASS — `0.0.67-dev`.**

The passive player `HELPFUL|PLAYER` lane is accepted at real UI scale:
- native icon remains dominant;
- approved minimal frame;
- lower-right stack metadata;
- event-driven updates;
- no countdown/timer sweep/polling;
- integrated check remains clean.

Player harmful/urgent and populated target aura data remain environmental
deferrals. Private/group aura ownership and stock suppression remain gated.

P0139:
**INSTALLED / PUSHED — SOURCE + FALLBACK POLICY LAYER RESOLVED** at `b0122136`.

D-042 accepts only conditional accessible nameplate anchoring, with
`includeForbidden=false`, behind-camera/no-nameplate fallback, no nameplate CVar
mutation, and no Blizzard frame mutation.

Reaction candidates are source-available; relative danger is restricted to
`UnitIsTrivial` low-danger de-emphasis if runtime-proven ordinary.

P0140:
**RUNTIME PASS WITH ENVIRONMENTAL ANCHOR/ATTACHMENT DEFERRAL — `f7e2c31d`, `0.0.68-dev`.**

The diagnostic proves safe no-nameplate fallback and ordinary friendly
reaction/triviality reads with zero recorded failures. No accessible target
nameplate was observed, so behind-camera and hidden attachment proof remain
environmentally deferred. Production target relocation stays blocked.

P0142:
**SOURCE-CAPABILITY LAYER RESOLVED — DOCS/PRIMARY-SOURCE EVIDENCE ONLY.**

The exact Forever source establishes:
- ordinary quest waypoint and broader current-navigation source families;
- multi-select tracking filter state;
- no public per-detected tracking-result positions;
- no service-instance positions from service tracking filters;
- positioned `C_AreaPoiInfo` as a distinct runtime candidate;
- minimap view radius and map/world geometry as runtime-gated distance inputs;
- continued stock minimap completeness requirements.

D-043 records the fail-open/source policy.

P0143:
**INSTALLED / PUSHED — RUNTIME PASS FOR OBSERVED NAVIGATION-SOURCE SCOPE WITH ENVIRONMENTAL DEFERRALS** at `b9b2f90b` / `0.0.69-dev`.

P0143 proves ordinary current-map/player geometry, map world size, minimap view
radius, and bounded multi-select tracking selector metadata/state with zero
secret skips/failures. The tested state had no AreaPOI rows and no current,
quest, or user-waypoint destination; those branches remain DEFERRED. Integrated
`Run All` passed.

P0144 is durable at `47534363`.

P0145:
**INSTALLED / PUSHED — SAME-MAP DISTANCE + CLEAR-STATE PASS at `60244841` / `0.0.70-dev`.**

P0147:
**RUNTIME/MECHANICAL PASS; VISUAL FAIL at `c274a9d1` / `0.0.71-dev`.**

Live minimap-radius close/near/medium/far mechanics work, but the original
`1.05 -> 0.90` amplitude was too subtle at real UI scale.

P0148:
**RUNTIME + VISUAL PASS at `6f381a77` / `0.0.72-dev`.**

The stronger `1.20 / 1.05 / 0.85 / 0.70` depth anchors are accepted as the
production baseline. Further amplitude refinement is deferred to whole-interface
polish. P0123 remains off-tape authority; quest/POI/tracking and minimap ownership
boundaries remain unchanged.

P0149:
**SOURCE/CAPABILITY LAYER RESOLVED — DOCS/PRIMARY-SOURCE EVIDENCE ONLY.**

D-044 separates pet secure casting, stance/form, totem, class-resource,
alternate-power, PetFrame, and possess/override/vehicle/extra-action ownership.
No stock suppression or runtime mutation is authorized by the source audit.

P0150:
**RUNTIME PASS FOR OBSERVED READ-ONLY SCOPE WITH ENVIRONMENTAL DEFERRALS — `46e06295`, `0.0.73-dev`.**

The corrected R3 probe passes with 22/22 expected events, required APIs present,
populated pet-action state, one safely secret-skipped Warlock power value, ordinary
false special-mode flags, zero failures, and a separate clean Run All.

Stance/forms, active totems, DK runes, active special modes, and meaningful nonzero
class-resource presentation remain DEFERRED.

P0151 also records current-client source continuity: Forever build 70235 commit
`a84e2b1b41d3d4137127c07e4da448aa3251d6f1` differs from the P0149 70205 pin
only by `version.txt`; the audited secure pet source files are unchanged.

P0152:
**R12 RUNTIME + CONTROL + STATE-PRESENTATION PASS — `00aef4a9`, `0.0.74-dev`.**

The pet-action slice now uses the shared Logres action-button language, appears by default, resolves ten click-specific pet bindings, reports seven naturally readable/occupied slots, shows two active-state indicators and one autocast indicator, and retains working user-confirmed button execution. Stock PetActionBar remains available.

Exact pet-button ornament/contrast is deferred to later whole-interface polish. Pet edit/reorder, binding replacement, PetActionBar suppression/restoration, PetFrame ownership, and unrelated class/special controls remain separately gated.

P0153 records one unrelated final Run All camera World/Combat timeout as OPEN / INTERMITTENT / UNREPRODUCED. Before the next runtime slice, use the existing Phase-G developer-panel check to classify recurrence; do not patch an unreproduced camera event.

Preserve direct class-resource children, RuneFrame, TotemFrame, PetFrame, alternate
power, and all unsupported special-control fallbacks until each domain is deliberately
runtime/capability-proven.

## P0166 — H.2 integration-owned anchors

P0165 R1 closes H.1 for the currently replacement-proven stock surfaces.

P0166 begins the authored-layout pass with a deliberately low-risk structural checkpoint: stable integration-owned anchors are established first, using the existing accepted coordinates. This makes later spacing/collision calibration explicit and centralized instead of hiding geometry in producer modules.

The first dependency corrections are:
- Objective Progress no longer anchors to the detached target fallback;
- the pet-action cluster no longer anchors to the allies container.

All stock fallback and secure/capability gates remain unchanged.

## P0168 — correct premature H.1 closure

The user correctly rejected the notion that hiding only quest Accept/Decline in Phase H completed the original removal objective. P0164's ownership matrix remains useful for blockers but its closure classification is superseded. P0168 extends the P0165 ordinary offer ownership to the visible QuestFrame presentation, leaving the Blizzard quest frame shown for internal lifecycle/escape functions. The offer's Logres body/objectives and actions are already runtime-proven. Unsupported quest states (progress/complete/reward/gossip), special offers, missing/secret data, combat and unsafe frame capture fail open to Blizzard. No new primary-action/minimap/party/pet/full-tracker suppression is authorized without completing those capability gates.

**Next:** in-game P0168 visual+interaction/restoration gate, then revisit remaining eligible *sub-surfaces*, then H.2 spacing. No static analysis is runtime PASS.

## P0169 — combined action-source coverage and geometry (candidate)

The user's production screenshot supersedes the misleading generalization that previous selective stock suppression had cleaned up the whole screen. P0169 adds **new working matches** for native Bar 4 and Bar 5 via 12 fixed-slot native-registered secure action buttons each, temporary matching bindings, native cooldown/activation state, and exact stock alpha/mouse restoration. The supplemental Logres clusters are visible only if their original native bar was visible at initialization. Excluded Main/Override and protected special states remain untouched. Integrating five clusters into distinct authored lower regions is a candidate positioning pass; all other geometry remains preserved except class/pet displacement. Check panel action+stock replacement+layout and visual/mouse behavior together. No untested suppression claim.

## P0170 — deterministic clean-login Bar 2–5 replacement (candidate)

The accepted P0169 follow-up diagnostics contain a significant distinction: full `checkall` eventually passed after its preference-cycle triggered a second suppression attempt, but the first clean-login Stock Replace Check falsely passed while replacement was not applied and retained a Bar 4/5 settings read error. This is a real startup failure; preserve it, do not claim the P0169 clean-login gate passed. P0170 keeps stock UI available while settings are unreadable, retains the suppression request, retries only from Blizzard lifecycle events (`PLAYER_ENTERING_WORLD`, `EDIT_MODE_LAYOUTS_UPDATED`, `PLAYER_REGEN_ENABLED`), and preserves the prior known Logres extra-bar display while a later read is unavailable. The stricter diagnostic reports FAIL if desired=ON yet unapplied/deferred/errored. Full in-game first-reload evidence still required. This does not reopen the protected special Main/pet/minimap/full tracker/persistent XP capability gates.

## P0171 — process correction: integrated remaining-native-UI checkpoint

P0170 is verified at `95aaa593` / `0.0.87-dev`: the clean-login Bar 4/5 settings race now defers once and reconciles on `PLAYER_ENTERING_WORLD`; first Stock Replace, Action, Layout and Run All checks pass. Earlier P0169 first-login failure and P0170 R0 applier failure are preserved. **No full-screen suppression completion claim follows.** The user's consistent requirement is to finish the remaining Blizzard UI and move Logres elements in one coordinated pass, rather than isolate Main alone, request additional generic audits, or start visual polish. Build a capability/fallback-complete Main/special, pet, minimap, full quest tracker, permanent XP and micro-menu integration, retaining safe Blizzard access for unsupported modes, then evaluate the resulting whole screen in one game test. This is a coordinated deliverable goal, not permission to use unsafe blanket suppression. Source, secure constraints, exact restoration and fail-open remain gates. See `../evidence/P0171_H1_SCOPE_AND_DELIVERY_FAILURES_2026-10-08.md`.

## P0172 — integrated native access dock runtime candidate

The next unified presentation checkpoint, P0172 `0.0.88-dev`, moves stock navigation, all watched objectives, full status/XP and menu/bags behind four compact on-demand Logres dock controls. This approach deliberately preserves the complete native functions that the current Compass, one-focus Active Quest, transient XP and existing HUD do not replace. Native roots are hidden as complete frames only when ordinary captured state, initialization, and combat gates allow, not by permanent preference changes or alpha-only invisible click layers. Every domain has exact source identity and restoration snapshot. Phase H Layout Check adds the authored nativeAccess anchor; Native Access Check and Run All are integrated. Runtime visual/interaction proof still required. Protected Main/Override and PetActionBar are not included because their special/combat/edit support is unproven. H.1 remains open for them and any native root this trial fails to fold safely; do not redirect to H.2 before resolving actual screen duplication.

### P0173 — primary stock ownership gate

P0172 is pushed at `3a5028c8`; normal-world user report says native UI is mostly removed and the dock controls operate, but the Main action bar remains visible. `0.0.88-dev` integrated diagnostics PASS while Primary still reports key routing disabled and stock Main retained. Source `MainActionBar.xml`/`MainActionBar.lua` shows page buttons, edit mode and dynamic attachment plus MKB/gamepad transitions; D-044 additionally requires vehicle/override/possess secure fallback. P0173 `0.0.89-dev` is a focused read-only primary-source/mode diagnostic available in Phase C, with normal optional binding-routing manual test. It is **not** authorization to hide Main, a new unrelated exploratory phase or completed H.1. Complete the safe Main edit/secure/special fallback and integrated one-screen presentation after this gate; do not switch to H.2 polish prematurely.
