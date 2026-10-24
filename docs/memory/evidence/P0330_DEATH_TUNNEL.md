# P0330 — L-026 corpse-navigation health-tunnel correction

**Baseline:** GitHub main pushed P0329 `126d16526ebc68525abed4565d3812d9332fec76` (2026-10-24). **Outcome:** source-level correction PREPARED; WSL check results and WoW gameplay remain UNVERIFIED / ENVIRONMENTALLY DEFERRED until November 4.

## Observed report and narrow cause

User reported: 0 HP on death drives the health tunnel to maximum intensity and makes navigating back to the corpse nearly impossible (L-026). `Logres/HUD/HUD.lua` has five D-036 alpha curves whose 0% entries create heavy masks, with `deathCollapse` 1.00 and `nearDeathTunnel` 1.00, and only `UNIT_HEALTH`/`UNIT_MAXHEALTH` driving live refresh. There was no death/ghost state exception. This is sufficient evidence to design a narrow lifecycle override, but the client is inaccessible and the exact user-observed sequence is not independently reproduced.

## Intended behavior and implementation

A dead or ghost character needs visibility for corpse travel, while a living player at 0–5% must retain D-036's severe perceptual threat. Distinguish lifecycle state rather than inspecting native secret-capable player HP. On `PLAYER_DEAD`, set addon-owned `deathTravelMode` and forward ordinary zero directly to all five Logres mask textures. Do not query player health in that branch. `PLAYER_ALIVE` can mean release at graveyard *or* resurrect before release; a guarded, positively ordinary `UnitIsDeadOrGhost('player')` observation decides, otherwise retain existing state. `PLAYER_UNGHOST` marks resurrection after ghost and restores normal live native `UnitHealthPercent('player', true, band.curve)` -> `texture:SetAlpha(alpha)` on subsequent vignette update. `PLAYER_ENTERING_WORLD` and initialization can adopt only positively nonsecret boolean death state, supporting reload while ghost where available. Existing previews and Immersion preference remain; corpse travel override takes priority over preview display for navigation. The new cached debug field is included in P0329's saved gameplay snapshot without querying protected/secret values.

This is capability-gated, event-driven, and does not poll, alter native frame visibility, read/branch on HP, change CAM, or modify the D-036 curve/asset bytes. Blizzard controls, safe stock fallback, health transport and existing proof remain intact.

## Offline candidate contract and limitations

P0330 adds one static checker to the 200 existing checks (201 total), plus explicit ordinary/death/ghost event transition fixtures with unknown-state cases; requires exact committed P0329 baseline SHA and blob hashes, prewrite prepared-candidate hygiene, full 201-checker shadow and postwrite suites, `git diff --check`, transactional rollback and manifest. An offline model tests intended transitions but is not a WoW runtime observation. Developer WoW checks and actual death/ghost behavior are **UNVERIFIED**. No beta-client test should be requested before access reopens.

## November 4 acceptance

After initial high-priority P0321 gossip restoration runbook, verify living 5% preview remains original tunnel, actual PLAYER_DEAD clears all masks, release to graveyard remains navigable, corpse recovery/PLAYER_UNGHOST returns to live curve, resurrection before release via PLAYER_ALIVE, Immersion OFF/ON, preview attempted during ghost, and reload/login while ghost if naturally encountered. Inspect saved `deathTravelMode` and Lua/secret/taint errors. If `UnitIsDeadOrGhost` is absent/secret on reload, classify this specific reentry as DEFERRED; never guess an alive state or inspect opaque values. A real error means FAIL, not environmental PASS. Avoid contrived gameplay purely for test proof.

**Next:** following verified push, continue bounded source-level L-025/L-029 HUD/menu stratification, L-028 harmful target aura investigation and other remaining user reports. Do not mark L-026 fixed until the client provides evidence.
