---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Durable Project Memory

This file contains long-lived project facts and rules. It is not a chronological development log.

## Identity

**Logres** is an immersive, world-first interface addon for World of Warcraft Forever.

The name is Arthurian/Camelot-adjacent: an homage to the Camelot/Classic+ lineage without naming the addon `Camelot` itself.

## Core product thesis

Logres should move the player's attention away from interface abstraction and back toward the world, character animation, spatial awareness, sound, and encounter behavior.

Minimalism alone is not the goal. **Selective information disclosure** is part of the experience.

Three information classes guide the design:

1. **Always perceptible** — information needed instinctively, such as primary actions, resource state, severe health danger, and current target.
2. **Contextually revealed** — information that becomes useful in combat, PvP, interactions, quest updates, or other relevant states.
3. **Intentionally obscured** — information the game may know but Logres deliberately does not foreground, such as exact player health, numeric enemy level, explicit elite classification, and explicit difficulty labels.

## Established design facts

- Player health has no conventional health bar.
- Player danger is communicated through an organic charcoal/cold-burgundy peripheral health tunnel whose clear usable field contracts as health worsens; no conventional player health bar is used.
- Resource presentation is compact and percentage-oriented; the accepted production baseline uses a shared compact bar with visible `%` text for percentage-based Logres-owned values except player health.
- Cast bars are not part of the intended visual language. A minimal cast-confirmation glyph may exist only to confirm that a cast/channel is active when animation alone is ambiguous.
- Enemy level is not shown numerically.
- Enemy relative danger may be hinted by restrained name color/text treatment.
- Elite/rare classification is not proactively exposed by default; unexpectedly discovering that an enemy is formidable is an intended experience.
- Allies and pets use the same restrained information philosophy, with role/accessibility exceptions to be designed deliberately.
- Action buttons are organized as square/rectangular clusters, not primarily as a long horizontal row.
- Primary actions remain legible; secondary/tertiary and utility clusters are contextually faded/revealed.
- Immersion mode is an orchestrated project state, not merely "hide chat."
- The compass is part of immersion/world presentation and should automatically disappear in instances. Heading and manual-waypoint production visuals are proven; quest/POI/tracking roles remain capability-gated.
- PvP flagging modifies immersion toward greater situational usefulness rather than simply turning immersion off.
- Questing, XP presentation, camera behavior, social silence, and later navigation should share one visual/state language.
- D-039 is the approved twelve-sheet World Ghost / Selective Hybrid E visual baseline.
- D-040 makes `Logres/Media/` plus `Logres/Media/Theme.lua` the production asset/token boundary for approved visual translation.
- Active Quest is an optional one-focus presentation, not a permanent multi-quest tracker; exact mechanical counts belong behind deliberate inspection/hover in the approved baseline.
- P0126 makes that Active Quest baseline production-proven at `89b0c563` / `0.0.58-dev`: count-free objective labels remain visible, progress is bar-only, exact counts stay hover-only, and Blizzard quest-management surfaces remain available.
- D-035 defines NPC quest interaction as a future Logres-owned experience only after per-surface information/control capability is proven; fail open to Blizzard until then.
- P0129 makes the observed NPC quest-offer read path runtime-proven at `e50676b9` / `0.0.59-dev`: real offer title/body/objective, stable available-gossip quest ID/title, and one two-choice reward metadata sample were ordinary/non-secret with zero call failures; all quest/gossip mutation function groups were present but `invoked=0`. `QUEST_PROGRESS` / `QUEST_COMPLETE` and other unobserved categories remain deferred.
- P0130 makes the bounded/paged NPC quest-offer narrative production-proven on `0.0.61-dev`: full source prose is paged, objective text is wrapped, Blizzard controls remain available, and the active narrative restores across Immersion OFF -> ON. The initial `0.0.60-dev` restore failure remains preserved as evidence.

## Development facts

- Canonical host/development environment: Windows 11 with WSL.
- Source repository lives in the WSL Linux filesystem.
- User performs all commits and pushes.
- Failures/rejections/rollbacks are durable knowledge and must be recorded.
- The current DynamicCam `RPG` profile was captured in G.1 on 2026-10-02; exact camera values must come from `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md` and its canonical JSON, not conversational memory. Request a fresh export again only if the profile changes or later evidence conflicts.

## Open technical facts

WoW Forever API feasibility is not considered settled until the relevant capability work records it.

In particular, do not assume unrestricted availability of:
- health/power data during combat;
- target classification;
- cast information;
- unit auras;
- map position;
- quest position/objective bearings;
- chat automation;
- secure action mutations during combat;
- camera changes in every context.

Record source findings and runtime behavior separately.

- P0131 proves quest-offer Accept / Decline mutation capability on Forever: Decline passed on `0.0.62-dev`; Accept passed on corrected `0.0.63-dev` after preserving correlation across intermediate `QUEST_FINISHED` until matched `QUEST_ACCEPTED`. Capability proof does not authorize Blizzard control suppression; production Logres controls must be proven first.

- While Blizzard quest-offer fallback remains simultaneously visible, Logres mirrors its left/right action order: Accept left, Decline right. P0132's opposite ordering was functionally correct but confusing in-client, so P0133 makes this an explicit visual-integration contract.

- P0133 accepts the production quest-offer action ordering on `0.0.65-dev`: Accept left / Decline right, matching Blizzard while the fallback remains simultaneously visible. P0133 is runtime + visual PASS at `f2feead6`; quest Continue/Complete/reward/gossip ownership remains separately gated.
- After P0133, the next exact approved visual capability slice is P0135: aura/status source + priority-policy audit. Stock aura/status surfaces remain until replacement completeness is proven.

- P0135 resolves the aura/status source and priority-policy layer against exact Forever source `e3ecc27b` / `1.60.1.70205`: `C_UnitAuras` payload reads are secret-capable, `C_Secrets` exposes per-index/instance/slot aura secrecy predicates, and `UNIT_AURA` is the event model. D-041 prioritizes urgent player harmful status over passive helpful status, keeps target status world-associated as a future endpoint, and preserves private/group/stock surfaces. P0136 read-only runtime proof is required before production aura/status wiring.

- P0136 implements the first aura/status runtime probe on `0.0.66-dev`: player/target only, bounded indexed scans, `ShouldUnitAuraIndexBeSecret` before every payload query, field-level secret checks, `UNIT_AURA` payload arguments discarded, and no polling/mutation/suppression. Runtime capability evidence remains pending; stock/private/group surfaces stay Blizzard-owned.

- P0136 `0.0.66-dev` runtime-proves ordinary populated player `HELPFUL` / `HELPFUL|PLAYER` aura data and selected metadata with zero failures. Populated player harmful and target aura categories, plus the runtime secret-skip branch, remain deferred. Production work may advance only for player helpful status, with Blizzard stock retained as completeness fallback.

- P0137 keeps production aura presentation deliberately narrow: only runtime-proven player `HELPFUL|PLAYER` data, at most four passive native-icon tiles, ordinary stack count only, no duration countdown/timer sweep/polling, and Blizzard player aura presentation retained as completeness fallback. Player harmful/urgent, target, private, and group aura ownership remains gated.

- P0137 `2b578759` / `0.0.67-dev` accepts the passive player `HELPFUL|PLAYER` production baseline: at most four native-icon tiles, restrained frame, ordinary lower-right stack count, event-driven updates, no duration timer sweep/polling, and Blizzard stock retained as completeness fallback. Player harmful/urgent, populated target, private, and group aura ownership remains gated.
- After P0137, do not manufacture deferred harmful/target aura gameplay evidence solely to continue sequencing. The next justified approved visual capability slice is P0139: world-attached target source + anchoring/fallback audit.

- P0139 resolves the world-target anchor/fallback policy against Forever `1.60.1.70205`: the only approved anchor candidate is an accessible `C_NamePlate.GetNamePlateForUnit("target", false)` result; forbidden plates and nameplate-CVar manipulation are excluded; the existing screen-space target is canonical fallback; reaction must be ordinary runtime-proven state; relative danger is limited to runtime-proven `UnitIsTrivial` low-danger de-emphasis without exact level/classification/difficulty inspection. P0140 runtime proof is required before production relocation.

- P0140 `f7e2c31d` / `0.0.68-dev` runtime-proves the observed D-042 fallback/reaction scope: direct `"target"` nameplate query safely returns the no-accessible-nameplate fallback, friendly reaction is ordinary, `UnitIsTrivial=false` was ordinary, zero probe failures/secret skips were recorded, and integrated checks passed. No accessible target nameplate was observed, so behind-camera and hidden addon-owned attachment remain environmental deferrals; production relocation stays blocked and the screen-space target remains canonical fallback.
- Do not manipulate nameplate settings or manufacture gameplay state solely to close the P0140 positive-anchor deferral. Natural future evidence may reopen that exact capability path.
- After P0140, the next independent approved visual capability slice is P0142: audit the D-037 navigation/minimap source layer for quest destination, local POI/service, tracking results, safe position/distance inputs, update semantics, and minimap completeness before any runtime implementation or stock minimap suppression.

- P0142 resolves the D-037 navigation/minimap source layer against exact Forever source `e3ecc27b` / `1.60.1.70205` and accepts D-043. `C_Minimap` tracking state is multi-select and exposes filter metadata/state but no supported per-detected-result positions; service tracking filters likewise do not expose service-instance coordinates. Repeated tracking-result glyphs and town/service-instance markers are therefore source-blocked unless new primary source evidence appears. `C_AreaPoiInfo`, `C_Minimap.GetViewRadius`, broader `C_Navigation` waypoint output, and same-map `C_Map` geometry remain read-only runtime candidates for P0143. The Blizzard minimap remains the completeness fallback.

- P0143 `b9b2f90b` / `0.0.69-dev` runtime-proves ordinary current-map/player position, map world size, minimap view radius, and 23/23 multi-select tracking selector metadata rows with zero secret skips/failures and integrated checks passing. The captured map had no AreaPOI rows and no current/quest/user-waypoint destination, so those paths and actual destination-distance output remain environmental deferrals. P0142/D-043 source-blocked individual tracking-result/service-instance positions remain blocked. The next justified navigation slice is manual-waypoint comparable-distance / bounded depth only.

- P0145 prepares candidate runtime `0.0.70-dev` for the first production use of P0143-proven map geometry: manual user-waypoint distance is computed only when `UiMapPoint.uiMapID` is ordinary and equals the current player map, player/destination normalized coordinates are ordinary, and `C_Map.GetMapWorldSize` returns ordinary positive yard dimensions. Distance failure is non-fatal and falls back to the accepted P0123 marker at depth scale `1.0`; no exact distance text, identity, new navigation role, or minimap ownership is added. Runtime + visual proof remains pending.
- P0145 is durable at `60244841` / `0.0.70-dev` and runtime-proves ordinary same-map manual-waypoint yard distance plus clean clear-state fallback. Its four accepted populated samples (`45.5`, `51.7`, `115.8`, `116.0` yards) were all inside the old `120` yard near threshold and therefore prove only the old near endpoint (`depth=1.050`), not distance-dependent scale variation. The user reported no visible size change during that inadequate test. P0146's stronger depth-acceptance wording is superseded by P0147.
- P0147 `c274a9d1` / `0.0.71-dev` proves the live `C_Minimap.GetViewRadius()` close/near/medium/far waypoint-depth mechanics across real samples, including ratios from `0.05` through `12.04`, clean map-mismatch fail-open, and integrated `Run All` PASS. Visual validation FAILS: the original `1.05 -> 0.90` span on a `12x20` glyph is too subtle. Preserve this negative calibration evidence.
- P0148 `6f381a77` / `0.0.72-dev` widens only the proven manual-waypoint depth amplitude to `1.20 / 1.05 / 0.85 / 0.70`, render clamp `0.70–1.28`. Runtime samples exercise far `0.700`, medium `0.875`, and close `1.200–1.280`; integrated checks pass and the user visually accepts the size cue. This is the production baseline; finer amplitude tuning is later whole-interface polish. Navigation ownership boundaries remain unchanged.
- P0149 resolves the class/pet/special-control source layer against exact Forever source `e3ecc27b` / `1.60.1.70205` and accepts D-044. Pet actions have a supported secure `type="pet"` cast path, but stock autocast/edit/binding/restoration remain separate gates and PetFrame is a separate secure unit surface. Stance/form read state is available but control ownership is unproven. Totem and unit-power reads are secret-capable where documented. Runes/combo points/shards/charges/holy power/essence remain discrete mechanics, not generic percentages. Possess/override/vehicle/extra-action remain integrated Blizzard special modes outside ordinary Bar 1–3 routing.
- After P0149, P0150 is a bounded read-only runtime probe only. It may observe naturally available pet/stance/totem/class-resource/special-mode state but must not cast, toggle autocast, reorder, shapeshift, dismiss totems, mutate action pages, exit/cancel special modes, or suppress Blizzard surfaces. Environmental absence is DEFERRED.

- P0149 is verified durable at `dbe468f7` and resolves the class/pet/special source/fallback layer under D-044. P0150 prepares candidate `0.0.73-dev` as a bounded read-only source probe only: pet/stance/totem/resource/rune/special-mode reads are secret-first and event-driven; no cast, autocast/edit, form, totem, paging/state-driver, vehicle/possess, special-control, or Blizzard presentation mutation is authorized. Environmental absence is DEFERRED, and the contextual probe is run manually before a separate integrated Run All regression pass.

- P0150 initial `0.0.73-dev` runtime is a preserved diagnostic-contract failure: the probe registered 22/22 events and required APIs, but six pet rows returned numeric `GetPetActionInfo(...).isToken` values while the probe assumed boolean. One Warlock power result was safely secret-skipped with zero resource failures; special-mode detail flags were ordinary false; separate Run All passed. R3 keeps `0.0.73-dev`, treats `isToken` as opaque secret-first value data, and preserves false summary values; retest remains required.
