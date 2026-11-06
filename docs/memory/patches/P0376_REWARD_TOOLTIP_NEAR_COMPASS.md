# P0376 — guarded reward tooltip / near-quest compass integration

Baseline: verified P0375 `5b45be81db1eba4c60cf96010e5d27b95176a751`, version `0.0.261-dev`, 245 static contracts.
Candidate: `0.0.262-dev`, 246 static contracts; **runtime UNVERIFIED**.

- `Logres/Quest/Dialogue.lua`: ordinary quest item ID and guarded quest item link passed to passive reward cards (read-only).
- `Logres/Quest/RewardVisual.lua`: passive live item hover can display standard item tooltip with optional Shift comparison; native live click remains gated to synthetic preview callback only.
- `Logres/Navigation/Compass.lua`: 3yd center for quest-linked candidates, 4yd release to avoid jitter, no `~` in valid distance labels; other bearing sources remain unchanged.
- `tools/check_p0338_focused_compass_yards_contract.py`: revise old literal `~` fixture, no source gates changed.
- `tools/check_p0374_issue_ledger_contract.py`: increase canonical ledger to L-038.
- `tools/check_p0376_reward_tooltip_near_compass_contract.py`: new read-only hover and near-center static contract.
- Memory ledger, active investigations, roadmap, patch index, evidence and handoff updated together. User screenshot of recipe-learning toasts recorded under L-027, **not hidden in this patch**.

This patch neither commits/pushes nor claims in-game PASS. Applier verifies baseline blobs, clean tracked state, unique source anchors, memory history and byte limits, prewrite shadow 246-contract suite, postwrite 246-contract suite and `git diff --check`. Failure refuses and rolls back tracked changes.

No camera or dynamic profile changes, no native reward claim/reward choice mutation, no polling, no blanket suppression of Blizzard XP/recipe/quest UI, and no quest tracker switching.
