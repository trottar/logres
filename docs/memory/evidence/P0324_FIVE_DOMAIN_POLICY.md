# P0324 — independent-domain policy fixture evidence

**P0324 PREPARED / full WSL suite and WoW UNVERIFIED**. GitHub `main` P0323 `386a7ef` was verified before creation. P0323 audit of all 94 TOC Lua entries is the baseline; D-048 five-system contract governs.

## Positive source/test preparation

New fixture `tools/p0324_domain_policy.py` is standalone, pure Python. The checker is `tools/check_p0324_five_domain_policy_contract.py`: it verifies exactly 32 independent five-domain requested configurations with 160 one-bit independence comparisons; none/partial capability states, deferred native restore and reenable, invalid inputs and schema-3 legacy flags. The existing `immersionEnabled` and `activeQuestEnabled` saves remain untouched. P0324 adds **no Lua**, TOC, runtime version, saved migration, secure/native control or camera changes; no WoW redeploy is required.

## Limits and failures/deferrals

Policy results are synthetic. A returned `effective=logres` does **not** establish Logres actually owns a Blizzard frame or that protected restoration works. D-047 camera remains frozen; P0321 gossip parking still **UNVERIFIED / DEFERRED until November 4**. Merchant and flight-master native handoffs still untested; prior P0321 R0/R1/R2 packaging failures, P0322 R0 checker-pin failure and L-001–L-018 issue-register entries remain in durable history. No new WoW runtime failure was reproduced by this independent fixture. The full WSL **195/195 PREWRITE and POSTWRITE** suite is an applier gate, not claimed to have been run in the artifact authoring environment.
