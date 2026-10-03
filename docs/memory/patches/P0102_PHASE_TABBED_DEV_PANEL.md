# P0102 — Phase-Tabbed Developer Panel

Date: 2026-10-02
Result: PREPARED — RUNTIME UI CORRECTION; G.3 RETEST PENDING

## Baseline

P0101 verified pushed:
`86660959f4ba7d48a0d205c992e39712343a6aca`.

P0101 is the docs-only Selective Hybrid E / visual-component checkpoint. P0102
preserves that work and does not repurpose its patch identity.

## Runtime

`0.0.41-dev -> 0.0.42-dev`.

## Trigger

The first P0100 in-game validation produced two distinct observations:

1. camera movement was not exercised because controller status reported
   `outside-slice:resting`; this is an expected G.3 relinquish condition and is
   recorded as an environmental deferral;
2. the developer panel's flat action grid overflowed its fixed button region and
   obscured diagnostic output.

Canonical evidence:
`../evidence/G3_P0100_RESTING_DEFERRAL_PANEL_OVERFLOW_2026-10-02.md`.

## Intervening repository checkpoint

While the panel correction was being prepared, repository P0101 was pushed as
`86660959` to record D-034 Selective Hybrid E and the visual-component inventory.
That docs-only checkpoint is authoritative and is preserved by this rebase.

The panel correction therefore advances to P0102.

## Delivery history retained

Two pre-rebase panel artifacts used the now-colliding P0101 identity and did not
produce an applied repository checkpoint.

First delivery:
- reached repository validation;
- failed in `tools/check_camera_world_combat_contract.py` because that G.3
  feature checker pinned Bootstrap and TOC to exact runtime `0.0.41-dev` while
  the panel runtime correction bumped to `0.0.42-dev`;
- the applier rolled back tracked changes.

Second delivery:
- the user reported the same checker error again;
- inspection of the retained R2 archive showed replacement logic for the stale
  version literal before checker execution;
- the exact repeat cause is not independently established from repository state,
  so it is not guessed here.

Third delivery (rebased P0102 first apply):
- advanced through the camera checker and the new phase-tab panel checker;
- failed in `tools/check_stock_replacement_contract.py` because that feature
  checker asserted the old flat-panel geometry (`PANEL_HEIGHT=590`, button-host
  height `270`, and results top offset `-348`);
- those coordinates are presentation details owned by the developer-panel
  contract, not stock Bar 2-3 replacement behavior;
- the applier rolled back tracked changes.

Fourth delivery:
- all repository checkers passed, including the corrected stock-replacement
  contract;
- manifest generation then failed because the applier parsed `git status --short`
  with a fixed character slice and produced `ogres/Core/Bootstrap.lua` instead
  of `Logres/Core/Bootstrap.lua` on the user's Git output;
- this was a delivery-script path parser defect, not a repository/runtime failure;
- the applier rolled back tracked changes.

## Root contract correction

`tools/check_addon_structure.py` already parses both TOC `## Version` and
`Logres.VERSION` and fails when they disagree.

P0102 therefore removes the redundant exact-runtime assertion from the G.3
camera feature checker instead of replacing `0.0.41-dev` with another feature-
specific literal. The camera checker returns to checking camera behavior/load
order; global version synchronization stays in the global addon-structure
checker.

This prevents unrelated future runtime bumps from breaking the G.3 feature
contract solely because its implementation version changed.

The stock-replacement feature checker also carried obsolete fixed developer-panel
geometry assertions that were originally added only to ensure enough room for
replacement controls. P0102 removes that cross-feature geometry dependency.
Stock replacement remains validated through its production module, commands,
routing ownership, and TOC load order; developer-panel layout is validated only
by `tools/check_dev_panel_contract.py`.

## Panel change

The developer panel is reorganized around the project roadmap:
- tabs: `0`, `A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`;
- each developer action declares exactly one phase;
- only the selected phase's actions render;
- Phase G is the default selected tab for current work;
- Phase 0 contains Run All, Status, Preference, and Lifecycle;
- Phase H remains visible even with no registered diagnostics;
- diagnostic output and `LogresDiagnosticsDB` persistence remain shared across
  tabs.

The static developer-panel contract verifies phase metadata and caps each phase
at 12 actions for the three-column/four-row control area.

## Camera scope

No G.3 camera predicate, target, movement, restoration, or coexistence behavior
changes in P0102.

The next movement test must occur outside resting/City.

## Deployment

Runtime code changed.
WoW redeploy required after verified push.
