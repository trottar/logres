# P0350 — State and sensor diagnostic ownership seam

**Baseline:** verified pushed GitHub `main` P0349 R1 `4e59c8f2f03daf30b630fb15e3e14d5f38cc8da6`, 220/220 PREWRITE/POSTWRITE STATIC, version `0.0.238-dev`. Client UNVERIFIED; P0321 GossipFrame restoration remains the first contingent in-client safety gate. L-022/L-027/L-028 OPEN; L-019 public release BLOCKED.

## Narrow source observation

`Core/Commands.lua` contains adjacent development diagnostics `runStateCheck()` and `runSensorCheck()`. The former checks defensive state snapshots and no-op revision/subscription semantics using a temporary listener; the latter compares the *current* cached mounted/resting/taxi/interaction status with normal client signals. These are command-invoked diagnostics of the existing `Core/State.lua` state engine, not separate UI owners. The former invokes `Logres:RefreshState("DEV_STATECHECK_NOOP")`; therefore the pair is not characterized as strictly passive or side-effect-free, although the intended no-op should leave persistent state unchanged. Neither requires inspecting protected Blizzard presentation state or adding polling.

## Candidate extraction and behavior boundary

Move the original bodies of the two checks unchanged into `Logres:RunDevStateCheck(emit)` and `Logres:RunDevSensorCheck(emit, boolText)` in the earlier-loaded `Core/State.lua`. Preserve the command-local function symbols as one-call wrappers, keep the original emitter and boolean formatter, four original PASS/FAIL messages and formatting, command tokens, Run All order and existing phase-A actions. No new module, TOC load entry, event, timer, native UI mutation, saved schema migration, camera routing or D-048 domain selector. TOC and Bootstrap advance together to `0.0.239-dev`; exactly 94 addon Lua files, 120 panel actions and 38 P previews remain required.

`tools/check_state_contract.py` continues to require a Commands-level consumer of GetState and both command routes; Commands still contains other state consumers. `tools/check_dev_panel_contract.py` checks retained command tokens and action registrations. Prior P0349 native reporting remains in `UIOwnershipAudit.lua`. Source historical string search found no additional state/sensor report-owner assertion; the complete 221-checker suite remains the acceptance gate and will reject an overlooked contract.

## Validation and deferred outcomes

P0350 adds checker #221 covering both retained wrappers, State ownership, output strings and order, semantics, load precedence, panel inventory, version parity, historical continuity and absence of added protected frame operations. The guarded WSL applier constructs the complete shadow candidate and requires all 221 PREWRITE and POSTWRITE STATIC checks plus whitespace hygiene before generating the manifest. These checks are source-only; no claim of FPS improvement or in-client behavior follows. Any PREWRITE failure must be reported with the named checker, without staging files. No client deployment requested while WoW is unavailable.

Original P0349 R0, P0347 R0 and earlier rejected candidates remain historical negative evidence; do not erase or reinterpret them.
