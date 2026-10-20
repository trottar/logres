# P0276 R1 — Native Trainer Skin: Original Reversible Visual Trial

Date: 2026-10-20. Source of truth GitHub `main` `75e8024917a9f24dab0aac079a12bd28b0ce0434` (P0275). **PREPARED; WSL and WoW result pending.** No claim of successful in-client reskin, texture-API support, alpha restoration, or landscape layout.

## Failure / correction

P0274's tiny decorative line visually failed despite activation. P0275's oversized 640×540 decorative shell **visually FAILED**: the user's screenshot shows a small opaque Blizzard trainer window floating inside a disconnected, mostly empty Logres border. P0276 R0 artifact was a diagnostic-only trial with **no newly registered developer-panel test actions**, despite user requesting progress toward a reskin. User's reported WSL attempt found no downloaded ZIP so R0 was **not applied in that attempt**; verified remote main remains P0275. This is a concrete assistant-delivery/workflow failure. R1 supersedes that uninstalled checkpoint without inventing client diagnostic findings or assuming clean local state.

## Source comparison (not copied code)

Aurora Classic Trainer skin demonstrates region-level backdrop stripping and preserving `ClassTrainerTrainButton` / list and native trainer selection. ElvUI differentiates Classic scrollframe globals from Forever `ClassTrainerFrame.ScrollBox`, `.FilterDropdown`, category headers and native `ClassTrainerFramePortrait`. These upstream implementations establish *technique classes*, not proof that the local WoW Forever skin can safely use a particular region index. Their original code/assets are **not** copied. P0276 R1 uses existing Logres quest-panel artwork and independently written Lua.

## Testable hypothesis

A reversible, visibly dark/gold trainer surface is possible **inside the actual native trainer frame** by (1) isolating native root-only `Texture` regions tagged `BACKGROUND` or `BORDER`; (2) capturing each region's current alpha only as an **opaque restoration token**, without interpreting it; (3) temporarily setting those root decorations to alpha 0; and (4) adding nine slices of *the same Logres quest narrative panel* inside the native frame. Unlike P0275, no oversize border frame is placed behind a narrow stock window. Blizzard skill row/list, details, filters, money, purchase buttons and Train All remain untouched. No native frame, child, button, scroll box, font, event or transaction resizing/reparenting. This is a styling **trial**, not landscape reflow or accepted design.

## Capability and restoration boundaries

- Explicit H **Trainer Skin ON (TEST)** only, normal current trainer interaction type=7, real `ClassTrainerFrame` shown, ordinary/unprotected, out of combat; dimensions bounded to 260–1000 wide and 280–1000 high.
- Only direct frame texture regions (never descendants), with ordinary type `Texture`, and ordinary native draw layer `BACKGROUND` or `BORDER`. Bounded 1–24 candidates, full alpha-snapshot before first write. If client hierarchy does not supply candidates, **DEFER and leave Blizzard entirely stock**. Unknown/secret values must not be inspected, compared, formatted or coerced. Alpha `GetAlpha()` result passes only straight back into `SetAlpha()` as an opaque restoration token.
- H **Trainer Skin OFF** restores, native trainer `OnHide` restores, activation failure rolls back, combat restoration waits only for `PLAYER_REGEN_ENABLED` (no timer, polling or repeated OnUpdate). Failure to fully restore is **FAIL**, not a static/runtime PASS. The addon visual art remains mouse-disabled; no invisible native click regions.
- Dedicated P **Trainer Skin Art Preview** presents only the shared 9-slice art painter and a plainly inert label; it does not create fake training actions or mutate Blizzard UI. The same `paint()` supplies both P and live H paths (D-046 visual parity), but preview success does not prove native skin success.
- H pagination is enabled because there are 20 H actions, with existing 18 preserved, not deleted. First H page prioritizes ON and OFF. H **Native Service Frame Audit** is extended with bounded read-only native control/region inventory from R0 so unsupported native texture roles are observable.
- DynamicCam, all camera source, gossip, merchant and other services, quests (including reserved quest 237), transaction and other unrelated modules frozen.

## User-facing runtime validation — required

1. Apply guarded R1 patch from exact pushed `75e8024`, WSL shadow full-suite and postwrite full-suite, diff --check, no commit by assistant. Deploy and `/reload`.
2. `/logres` → **P — Previews**, find **Trainer Skin Art Preview** (page 2 of alphabetically sorted P actions, page position may vary). Click; CLOSE developer panel to view synthetic exact painter; click again to hide. This must not require an NPC.
3. Naturally open a real trainer; `/logres` → **H — Integration and Polish**, page **1 / 2**, click **Trainer Skin ON (TEST)** then close developer panel. Observe whether actual original native trainer backing changes (NOT a giant wrapper), and whether list, scroll/filter, details, prices, button labels, Train, Train All if present, close controls remain visible and usable. Do not purchase for this visual test. A `DEFERRED` command result means client gating is missing, **not a successful skin**.
4. With trainer still open, `/logres` → H **Trainer Skin OFF**, close panel; verify complete original Blizzard trainer background, control styling, and position restored. Repeat ON then close native trainer directly; reopen, stock should remain. If restoration fails, halt and export diagnostics immediately.
5. Open real trainer → H **Native Service Frame Audit** (may be on H page 2), capture bounded trainer `control/region` lines, then H **Native NPC Services Check** and 0 **Run All**. Export diagnostics from `LogresDiagnosticsDB` after `/reload`, include full screenshot with developer panel CLOSED.
6. Report PASS only for explicit tested checks, visual acceptance only after screenshot shows unified appearance. Do not infer future safe landscape reshaping from a root-only alpha test. Taint, Lua/protected/secret errors, missing native controls or incomplete stock restoration are failures.

## Open / deferred

- Exact WoW Forever trainer region identity and whether root BACKGROUND/BORDER removal covers the opaque native center (requires H read-only audit and actual screenshot).
- Art draw order/texture cropping on the Forever client.
- Landscape 2-column reflow and safe native child relocation.
- Merchant reuse, bank/auction, gossip live adapter (out of scope).
- P0272 original WSL proof gap; quest claim/flash and other historical OPEN issues unchanged.
