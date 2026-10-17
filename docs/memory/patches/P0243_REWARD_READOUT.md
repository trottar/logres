# P0243 — Read-only quest-completion reward summary

Baseline main P0242 `18b0fa0` verified. Runtime load 315 confirms registration, natural completion probe now resolves `Lesser Healing Potion x3` and 1050 XP. User reports Logres quest panel lacks Complete and rewards; P0242 was prose only. New candidate 0.0.143-dev adds bounded safe optional reward readout to existing dialogue footer while preserving **all** Blizzard reward presentation, Complete/Claim interaction and their fallback. Does not change suppression, gossip, action routing, compass or settings. Actual reward display and usable native fallback require positive runtime test; status UNVERIFIED. Detailed negative result in `docs/memory/evidence/P0243_QUEST_REWARD_VISIBILITY_AND_STOCK_FALLBACK.md`.

## R1 pre-write repair

P0243 R0 aborted cleanly at the existing P0242 checker because it pinned an
empty completion objective string. R1 updates the predecessor checker narrowly
for the new read-only reward summary and preserves the previous safe path,
source checks and forbidden mutation rules. No reward-selection or claim
ownership is added. See P0243 evidence for the exact error and status.
