# P0192 — Read-only H.2 geometry audit for approved v4 screen map

Date: 2026-10-11. GitHub main baseline: `57c3112bb3edc2bb9bc27cfd82e65f9b260dbf92` (P0191 confirmed pushed). Candidate addon version: `0.0.102-dev`.

## Purpose and scope

Extend the **existing Phase H developer-panel Layout Check** with a bounded, strictly read-only inventory of thirteen *Logres-owned* frame bounds, normalized to screen percentages and compared visually/textually against the exact thirteen P0191 v4 planned envelopes. The operation does not move, resize, show, hide, replace, parent or otherwise mutate any frame. It does not read Blizzard's protected presentation/visibility state. Neither an ordinary source geometry sample nor a clean existing layoutcheck constitutes in-game layout/collision acceptance.

`Logres/Integration/Layout.lua` owns the audit so the old P0166 anchors remain unchanged. `Commands.lua` appends 13 labeled rows to existing Layout Check output; it does not add a separate slash command, developer-panel action, or extra local capture to the already upvalue-sensitive command dispatcher. Missing/unlaid-out/restricted values remain MISSING/DEFERRED, not FAIL or zero. Measurements are unavailable in combat and require `issecretvalue` first; no secret-capable number is inspected, compared, formatted, or used for positioning. No gameplay event, timer, periodic polling, native frame write or protected mutation is introduced.

## Exact source-derived geometry and translation hazards

- `Actions/Button.lua`: default **42×42** buttons, **5** spacing; button cluster bounding geometry includes an extra **7**-unit cosmetic backing beyond the reported frame rectangle on each edge. This is a source fact, not an observed in-game collision measure.
- `Actions/Primary.lua`: **4 columns × 3 rows**, 12 buttons; inferred structural frame size **183×136** UI units. The accepted v4 **Main** area is **12% W × 38% H**, a tall envelope. Moving the existing anchor alone leaves this 4×3 cluster wide and short, so shape/reflow belongs in a separately tested geometry patch.
- `Actions/SecondaryUtility.lua`: **3×4** for Secondary, Utility and extra Bar 4–5, 12 buttons each; inferred **136×183** UI units. The v4 left **Secondary** envelope is 12%×38%; bottom-right **Utility** envelope is 23.4%×9.3%, thus the default Utility cluster also does not naturally match its flat design territory. Bar 4–5 remain independent and require collision review, not silent removal.
- `HUD/PetActionExecutionProbe.lua`: ten pet controls in a **5×2** grid, inferred **230×89** UI units. It is only a *proxy* for v4 `class` territory; it is not totem/stance/form or all special controls.
- `HUD/HUD.lua`: target fallback frame **260×54** UI units, ally anchor **190×118**. Resource bar uses a compact percentage-bar primitive; no player-health conventional bar is introduced. The existing target fallback is centered at a P0166 `targetFallback` anchor, not P0191's 72%-left target envelope.
- `HUD/StatusAuras.lua`: five 30-unit icons separated by four 5-unit gaps, inferred **170×30** aura lane size. `NativeDebuffs.lua` creates separate anonymous native `CustomAuraContainerTemplate` frames for harmful auras, with **170×30** initial geometry, which this read-only *named-frame* audit does **not** measure. Native harmful status therefore remains a distinct runtime calibration gate; no claim of target native debuff alignment can be made from this audit alone.
- `Quest/ActiveQuest.lua`: fixed width **320**; height is dynamic up to objective density (`MAX_OBJECTIVES=8`) and cannot be modeled as a permanently fixed rectangle. The approved v4 quest box is an intended envelope, not a content truncation contract.
- `Navigation/Compass.lua`: source fallback geometry **400×54**, subject to the active theme's matching dimensions. The approved v4 top-center compass envelope is 37.4%×6.9%.
- `Immersion/NativeAccess.lua`: independent stock-control dock **370×26** at the top right. Its retained access controls are not represented by one of the thirteen v4 rectangles; they are a mandatory collision/fallback check before any near-right quest positioning change.

## Read-only mapping and its limits

| v4 box ID | Named addon frame measured | Caveat |
| --- | --- | --- |
| compass | `LogresCompassFrame` | Navigation anchor only |
| quest | `LogresActiveQuest` | May be hidden/variable height |
| enemy-debuff | `LogresStatusAurastarget` | Lua aura lane proxy; NOT anonymous secure-native HARMFUL container |
| enemy | `LogresHUDTarget` | Sparse fallback; world-attached target remains future policy |
| enemy-buff | `LogresStatusAurastargetHelpful` | Lua helpful lane |
| group | `LogresHUDAllies` | Logres ally proxy; not protected Blizzard party frames |
| class | `LogresPetActionExecutionProbeCluster` | Pet-only proxy; not class/totem/stance group |
| secondary | `LogresSecondaryActionCluster` | 3×4, 12 action buttons |
| main | `LogresPrimaryActionCluster` | 4×3, 12 action buttons |
| player-debuff | `LogresStatusAurasplayer` | Lua status lane proxy; not anonymous native harmful container |
| resource | `LogresHUDResourceBar` | Resource percentage, NOT player health |
| player-buff | `LogresPlayerHelpfulAuras` | Helpful lane |
| utility | `LogresUtilityActionCluster` | 3×4, 12 action buttons |

`GetLeft`, `GetTop`, `GetWidth`, `GetHeight` are treated as possibly unavailable/restricted observations; rows are emitted only after secret-safe classification. The audit does not query `IsShown`, native Blizzard widgets, secure hit regions, or frame stacking, and does not infer actual visibility or collisions from hidden frames. Planned numbers stay identical to `SCREEN_MAP_V4.json`; the new checker verifies each literal mapping.

## Required WoW evidence before geometry mutation

Deploy the candidate, `/reload`, use **Phase H → Layout Check** and then **Phase 0 → Run All**. Save/export the new `Logres H2 v4 geometry AUDIT` lines and ordinary integrated diagnostics, plus a whole-screen screenshot at actual UI scale if available. Note which status lanes were naturally absent/DEFERRED. Do not force special-mode, target aura or combat scenarios. A zero-defect source scan never licenses hiding Blizzard fallbacks or moving protected action frames in combat.

## Next (after user test and push verification)

P0193 can translate the approved v4 geometry into safe, authored default anchors and deliberate action-cluster shape changes, out of combat only, with bounded reflow. The `Main`/`Secondary` 12×38% and `Utility` 23.4×9.3% mismatches are explicit architectural questions. Preserve navigation/dialogue/context, native access, XP, class/pet, target auras, extra Bar 4/5, party and special-control fallbacks. Runtime alignment and collision PASS remain **OPEN** pending in-game evidence.

## Historic failure retention

P0191 corrected prior assistant design errors (resource/debuff misplacement and center-target assumption); no repositioning is silently inferred from planning percentages. Prior P0187 R0 secure re-arm failure, P0187 R1/P0188 R0 delivery failures, earlier P0182/P0178/P0175 regressions, and intermittent post-loot ObjectiveTracker flash remain preserved.

## P0192 R0 delivery FAIL / R1 correction (2026-10-11)

The user ran original P0192 from the verified P0191 baseline and the applier stopped **before tracked-file writes**, printing `P0192 APPLY FAIL: P0191 durable status: expected unique anchor, got 0`. The following `git status --short` showed no modified tracked files; it contained existing untracked diagnostics, downloaded-file metadata and local artifacts. No P0192 manifest was generated. This is a **pre-write applier delivery FAIL**, not an in-game geometry failure or PASS; the user did not deploy the candidate.

Cause: the R0 applier searched for the outdated P0191 index text `PREPARED — DOCS ACCEPTANCE; H.2 OPEN`; actual P0191 `PATCH_INDEX.md` at verified `57c3112` uses `PREPARED — APPROVED DESIGN GEOMETRY, DOCS ONLY`. The R1 applier changes only that anchored match (and the resulting P0191 index status update); the runtime audit insertions and geometry mapping remain identical. R1 remains untested in WoW until the corrected artifact is applied, deployed and checked. Never treat the rejected R0 artifact as installed.
