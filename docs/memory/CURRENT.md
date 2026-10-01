---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.6 — HUD Integration Validation.**

P0029 prepares an in-game developer/control panel so B.6 no longer depends on repeatedly copy/pasting slash commands.

The panel reuses the existing command implementations and adds no parallel diagnostic logic.

## Verified State

- Phase A complete.
- B.1 health vignette complete.
- B.2 primary resource percentage complete.
- B.3 target presentation complete.
- B.4 cast confirmation complete with current-target caster true-path environmental deferral.
- B.5 allies and pets complete.
- P0028 pushed at `22e1ff1`.
- runtime baseline before P0029: `0.0.12-dev`.
- P0029 version: `0.0.13-dev`.
- developer-panel static contract passes.
- B.6 integrated runtime validation still pending.

## Next Action

Install/review/commit/push P0029.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

The Logres Control / Diagnostics panel should auto-open.

Use **Run All** instead of manually issuing each diagnostic command.

Verify:
1. panel displays `0.0.13-dev`;
2. panel is movable and closeable;
3. Run All shows PASS results for the recurring checks;
4. individual check buttons work;
5. Immersion OFF hides the Logres HUD but leaves the panel visible;
6. Immersion ON restores the HUD.

Then rerun the B.6 integrated HUD scenario through the panel:
- healthy idle;
- target acquisition/damage;
- player resource change;
- player cast/channel/interruption;
- safe player damage/vignette;
- pet/party updates if present;
- target change/clear cleanup;
- integrated immersion OFF/ON;
- combat exit.

Classify any finding as:
- functional bug;
- stale-state regression;
- Lua/secret error;
- layout/readability debt.

Do not require a target caster solely for B.6.

## Success Criteria

B.6 succeeds when:
- developer panel is a functional reusable validation surface;
- Run All and individual diagnostics work;
- panel survives immersion OFF;
- Phase B HUD components coexist without functional regressions;
- target/cast lifecycle cleanup leaves no stale cues;
- integrated immersion hide/restore is correct;
- no Lua/secret-value errors occur;
- layout is usable enough to proceed;
- visual polish debt remains explicitly separate.

## Do Not Reopen Without New Evidence

- **B.1:** complete.
- **B.2:** complete.
- **B.3:** complete.
- **B.4:** complete with target-caster true-path environmental deferral.
- **B.5:** complete.
- **Developer panel:** shared command execution; no duplicate check logic.
- **Target caster:** retry naturally; do not force travel solely for proof.
- **Deployment:** full deploy block required for P0029 runtime validation.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-016_DEVELOPER_CONTROL_PANEL.md`
- `docs/memory/architecture/DEV_PANEL.md`
- `docs/memory/investigations/B6_HUD_INTEGRATION_VALIDATION.md`
- `docs/memory/evidence/B5_ALLIES_PETS_RUNTIME_PROOF_2026-10-01.md`
- `Logres/Dev/Panel.lua`
- `Logres/Core/Commands.lua`
- `tools/check_dev_panel_contract.py`
