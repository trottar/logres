# P0245 — Quest reward identity intermittently unavailable; single item cache read

Date: 2026-10-17. Verified GitHub main P0244 `1ce1de1`.

## User-observed runtime result

User reports P0244 pushed and supplies screenshot plus `LOGRES_DIAGNOSTICS_LATEST.lua`. Screenshot displays quest 237 completion narrative, **1050 XP**, **7s**, stock quest reward item **Lesser Healing Potion x3**, and native **Complete Quest** still visible. Logres shows **Review rewards in Blizzard quest window** instead of the item, so P0244 money display is **VISUAL PASS SCOPED** but the original item-display guarantee from P0243 did not persist. This is **OPEN / INTERMITTENT item-name availability**, not accepted full reward parity or a new observed Lua error.

Diagnostic `0.0.144-dev`, loadCount=318, Phase F Quest Dialogue Check PASS and Phase 0 Run All complete, with completion event counters sampled before the interaction (`events=0`, `moneySource=not-observed`). Read-only Quest Interaction Probe subsequently captured natural `QUEST_COMPLETE` for ID 237, XP 1050, 1 guaranteed reward, 0 choices, `itemID=858`, `count=3`, **empty item name, nil link**, no probe API failures, no probe quest mutations. Previous runs (P0243 screenshot, load 316) showed ordinary item name, while separate captures showed empty name. Do not infer a global no-error verdict from panel checks; no full Lua/taint log supplied.

## Narrow source-gated repair

For exactly one guaranteed reward at `QUEST_COMPLETE`, preserve the existing secret-guarded `GetQuestItemInfo('reward', 1)` and quantity check. If the ordinary name is absent and the itemID returned at position 6 is a nonsecret finite integer in a bounded positive range, perform **one read-only** `GetItemInfo(itemID)` cache lookup. Only use an ordinary, nonempty string result. Retain the prior stock-review fallback if the API is missing, lookup fails, result is secret or uncached, or the ID is invalid. No polling, `C_Timer`, item-data load requests, invented item names, QuestieDB use, mutation, protected native state inspection, stock suppression or claim ownership. The reward diagnostic's existing `source` reason distinguishes `guaranteed-item-cache` from `guaranteed-item-ordinary` and `guaranteed-item-unavailable`.

## Validation and limits

P0245 targets `0.0.145-dev`. Run F — Quest Experience → Quest Dialogue Check then Phase 0 → Run All after `/reload`. In a naturally available completion, confirm XP, coin, one item quantity/name (or explicit native-review fallback), and usable Blizzard Complete Quest button. Source check PASS is not in-game positive cache proof: if no suitable event is observed, mark fallback effectiveness **DEFERRED**. Do not claim complete reward/claim/choice ownership. Player-triggered final claim remains a separate gate requiring evidence and a native fallback.
## P0245 R0 — pre-write checker-version-policy failure (2026-10-18)

User applied the original `P0245_QUEST_ITEM_NAME_CACHE.zip` (SHA-256
`f24fa38e23a0c9550da0063c51d64234f66428894d7aa9cce304a53868998445`).
Its pre-write shadow suite stopped at `tools/check_checker_version_policy.py`:
`ERROR: tools/check_p0245_quest_item_cache_contract.py freezes historical runtime version(s): 0.0.145-dev`.
The new P0245 feature checker had pinned the candidate version inside a durable
contract, contrary to repository policy. The failure is a **PRE-WRITE STATIC
CONTRACT FAIL**, not a WoW/runtime failure. The user reported only the three
existing untracked preview PNGs after the failed run; no tracked modifications
or P0245 manifest were reported. No P0245 runtime proof exists yet.

P0245 R1 corrects this in the *same* patch number: the checker now matches one
generic development-version format in each of the TOC and Bootstrap and
requires them to agree, without freezing a version. Existing item-cache
secret, ordinary-ID, single-lookup, no-polling, and no-quest-mutation gates
remain in place. The full shadow checker suite must pass before any write.
