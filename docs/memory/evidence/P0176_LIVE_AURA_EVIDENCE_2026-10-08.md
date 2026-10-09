# P0176 — P0175 R3 acceptance and live-source diagnostic checkpoint (2026-10-08)

## Observed P0175 R3 runtime (accepted bounded scope)

User confirmed "pushed". GitHub `main` was read at `c55b6d7b1801229b7caa1eb1705dbd7100dc7d08` (commit `fix: restore immersion after status aura diagnostic transitions`). Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, version `0.0.91-dev`, loadCount 222, records saved `immersionEnabled=true`, Status Aura Preview ON with player harmful 2, target harmful 2 and target helpful 2 **preview-only**. Preview OFF and live Status Aura Check show player harmful 0/empty and target 0/unit-absent; live harmful evidence remains **DEFERRED**.

The last Phase 0 `checkall` prints PASS for State, Sensor, Preference, Lifecycle, HUD, Layout, Native UI, aura checks, action/replacement, controller, and camera/compass checks, then `Logres checkall: complete`. HUD reports `immersion=true visible=true`, Layout `anchors=16 binds=21`, Native UI `folded=5 open=0`, `castGate=true/true gateEscapes=0`; no Lua error in that run. This resolves the R2 `StatusAuras.lua:273` regression in the observed runtime scope. `HUD visible=true` does not independently prove the visual resource bar at pixel level; the user did not separately affirm its appearance.

## Open negative / deferred evidence

- R1 user visual: buffs on player and enemy, debuffs not visible; R2 separated rows but no populated live harmful sample was captured. **OPEN / ENVIRONMENTALLY DEFERRED**; do not call preview source proof.
- Loot-associated quick quest UI reappearance remains **OPEN / INTERMITTENT / UNREPRODUCED**. No source cause established, so no new Hide retries/hook/polling.
- Primary secure action replacement and world-attached target remain separately gated.

## P0176 hypothesis and planned validation

The one-shot live status diagnostic cannot retain a naturally occurring harmful source sample after the effect/target disappears. P0176 instruments the existing event-driven ordinary-read path with session-only counts and peaks, excludes previews/Immersion OFF, and reuses the Phase H status panel action. Exact ability identity is not captured. Static suite runs in applier; **in-game execution and naturally populated harmful-source proof are pending**. Do not mark live harmful coverage PASS before an actual positive sample and visual comparison.

## Delivery failure — original P0176 (2026-10-08)

The user ran `python3 P0176_APPLY.py`; the prewrite loop passed all earlier listed contracts but **FAILED** at `check_status_aura_disabled_contract.py` with `ERROR: cannot isolate disabled snapshot in StatusAuras:Refresh`. The applier exited before tracked writes; `git status --short` showed only unrelated untracked files. Thus this is an artifact/checker integration failure, not an in-game observation. The original ZIP is superseded by R1. The existing R3 disabled-snapshot checker is not relaxed or removed.
