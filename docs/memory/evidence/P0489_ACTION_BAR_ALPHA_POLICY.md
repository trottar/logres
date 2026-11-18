# P0489 — Action and pet opacity policy / protected death-target deferral (2026-11-18)

## Baseline, requirement, scope

GitHub `main` P0488 `56fd6711025ad3fe8fa032b9da28c15cfb72fa4e` tree
`81491bf44eb2b67f5c6ca2a37f82fa17f04ea4ca`, verified. User says
L-054 intermittent Blizzard buff fallback has occurred twice, will monitor;
no P0488 in-client PASS or new evidence is asserted. New intent:
non-primary action bars and player pet actions fully invisible out of
combat, primary remains 100%, combat pet matches secondary. Also wants
automatic clearing on enemy death, or automatic next engaged enemy in combat.

## Source finding and policy

The original `ActionContext` uses 0.45/0.20 world, 0.75/0.40 PvP,
0.70/0.45 instance, and 1.00/0.75 combat for the secondary/utility
roles. Bar4 inherits secondary; Bar5 inherits utility via immutable
`ACTION_BARS_V1.json` role mapping. The pet action panel is an addon-owned
`PetActionExecutionProbe` secure button cluster, with an addon-owned
feedback/keylabel frame per button under UIParent (likewise all primary,
secondary, utility, Bar4/5 buttons). Merely fading clusters leaves
floating feedback labels. No native Blizzard pet bar alpha or secure
attributes need modification.

P0489 assigns OOC **0.00** to secondary and utility in world/PvP/
instance, **1.00** to primary in all states. Combat retains secondary
1.00/utility0.75, hence Bar4=1.00/Bar5=0.75. Pet addon-owned cluster and
10 feedback frames track the secondary role 0.00/1.00. Other side bars'
48 feedback frames follow their role. Context OnDisable returns to
visible combat alpha for fail-open. On pet re-arm, reapply last stored
alpha to avoid an out-of-context visual flash. Do not change bindings,
secure button attributes, click actions, paging, stock replacement,
pet visibility trial, animation assets or layout. No polling/timers.

## Protected targeting boundary — L-056 deferred

`ClearTarget` and `TargetNearestEnemy` are `#protected` APIs requiring
secure, user-initiated execution. A dead-target event, combat log event,
UNIT_HEALTH, or timer in insecure addon Lua cannot autonomously invoke
either to select/clear a player target. Nor can Logres establish and
securely select *only* enemies actively fighting the player using the
normal addon code path. External references:
- https://warcraft.wiki.gg/wiki/API:ClearTarget
- https://addonstudio.org/wiki/WoW:API_TargetNearestEnemy
- https://warcraft.wiki.gg/wiki/Making_a_macro

**Not implemented:** auto untarget/auto retarget on death. No unsafe
pre-click hook, secure action replacement, combat attribute reassignment,
scripted target change or visual-only illusion of no target. A separately
user-keypressed secure macro `/cleartarget [dead,harm]` followed by
`/targetenemy [combat,noexists]` is a supported alternative but chooses
nearest hostile, **not** guaranteed to be an already-engaged enemy; it
could pull unrelated enemies. Provide as optional user-created macro,
never install it silently or rewrite primary action buttons.

## Contract impacts and validation boundaries

Historical `check_action_context_contract.py` and
`check_context_policy_contract.py` encoded the *older* positive-OOC
alpha policy, intentionally superseded by this user change. Update their
policy expectations while preserving action-page/role/stock/secure and
non-inspection prohibitions. `Core/Commands.lua` expected-alpha table,
Action Check and Context Policy Check must reflect OOC alpha0 and pet
matching. New actual-source fixture covers world/PvP/instance/combat,
feedback 48+10 and module-disable fallback. New static checker guards
protected non-mutation. All historical static checkers, checker-version
policy, memory health, applier baseline/refusal/rollback and complete
postwrite should PASS before release; no WoW PASS is claimed.

L-055 is OPEN until live fades/reveal, hotkeys, mouse safety, pet
presence/re-arming and stock fallback are validated. L-056 is
BLOCKED-BY-PROTECTED-API pending a separately accepted user-triggered
interaction; automatic combat death targeting is not promised.

## Assistant first candidate negative results

Initial full audit encountered a documentation/contract mismatch: putting
P0489 ahead of historical first-marker P0486 broke multiple older
CURRENT/HANDOFF-to-roadmap contracts. Returning P0486 to first position
retains the existing continuity contract while recording P0489 as current
new work and P0489 in the Next Action. Separately, L-056's original
`BLOCKED — PROTECTED API` status was not a permitted canonical ledger
status; corrected it to `BLOCKED` with the cause in evidence. No runtime
source or secure-action policy was weakened to clear those failures.

## Candidate audit result

First full audit 333/350, 17 historical documentation-contract failures
(previous first checkpoint and invalid issue status). After corrections,
all **350/350 STATIC checks PASS**, including the two revised historical
context-policy contracts, unchanged stock/secure checks, new P0489
source contract, actual-source Lua fixture, version policy and memory
health. No WoW client PASS asserted. Exact frozen ZIP transactional
checks remain release gates.

## Packaging validation harness correction

The first isolated package harness launch raised `FileNotFoundError`
before any package validation because its copied fixture referenced
`p0489_work/baseline` instead of the already verified
`p0489_work/verified` tree. No user checkout or patch files were
written. The test harness path was repaired; the exact repo source and
release-gate requirements were unchanged.
