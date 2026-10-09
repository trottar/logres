# P0182 — target nameplate-only harmful aura inclusion

Date: 2026-10-09. Exact verified baseline: `2adce36688ee1d3fdddd75e373598a0e9d6f04e8` (P0181; runtime `0.0.96-dev`). Candidate: `0.0.97-dev`. **Runtime PENDING**.

## Narrow hypothesis / source evidence

The live target status reader in `Logres/HUD/StatusAuras.lua` used `HARMFUL|PLAYER` and `HARMFUL`, but neither requests `INCLUDE_NAME_PLATE_ONLY`. The 1.60.1-compatible `C_UnitAuras.GetAuraDataByIndex` filter contract says auras marked nameplate-only are excluded unless `INCLUDE_NAME_PLATE_ONLY` is set; documented in https://warcraft.wiki.gg/wiki/API:C_UnitAuras.GetAuraDataByIndex. This is a concrete class of unqueried target debuffs; it is not proof every absent target debuff belongs to this class. Existing P0180 evidence has no ordinary positive hostile harmful read, and numerous restricted events. The filter must **not** bypass secret restrictions.

## Implementation

Add target filter `HARMFUL|PLAYER|INCLUDE_NAME_PLATE_ONLY` immediately before existing `HARMFUL|PLAYER`, and `HARMFUL|INCLUDE_NAME_PLATE_ONLY` before existing unqualified `HARMFUL`. The inclusive order retains player-owned priority and deduplication by auraInstanceID. Existing player harmful filter sequence, `C_Secrets.ShouldUnitAuraIndexBeSecret`, icon/stacks checks, separate target harmful and helpful rows, render/tooltip behavior, preview and fallback remain intact. No new event, timer, action, frame suppression, spell identity cache, or diagnostics. Add permanent static contract to prevent nameplate filter regression. Version bump is synchronized in Bootstrap/TOC; 35-row ownership audit remains unchanged.

## Validation / boundaries

Applier checks exact HEAD, clean tracked baseline and per-file blob hashes, constructs a candidate in a shadow git-archive tree, runs all repository static checkers including new contract and git diff whitespace checks **before** tracked write, then writes transactionally and emits a manifest. User must test in WoW via Phase H Status Aura Preview ON/OFF and Status Aura Check; Phase 0 Run All and UI Ownership Check. A readable naturally populated target harmful status should be visible in target harmful lane, with stock fallback preserved. If none occurs, the meaningful result is *DEFERRED*, not PASS. Target secret/protected indices must remain untouched. Do not require contrived combat, edit special control routing, or remove Blizzard auras.

## Preserved failures

P0175 R2 nil-row failure and original P0178 >60-upvalue startup failure remain recorded. Earlier assistant repeatedly prioritized diagnostics/action ownership ahead of unresolved debuff delivery and asked for duplicate slash-command testing despite the panel-only instruction; P0182 restores correct priority and test method. Intermittent ObjectiveTracker loot flash and secure Main/Override actions remain OPEN separately.
