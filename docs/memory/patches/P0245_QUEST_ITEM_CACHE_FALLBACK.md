# P0245 — Fail-open one-shot quest item name cache fallback

Verified baseline P0244 main `1ce1de1`. P0244 screenshot confirms 7s/1050 XP and stock Complete, but Logres displays native-review fallback where stock shows Lesser Healing Potion x3. Probe yields ordinary `itemID=858, count=3` with empty name/link. One bounded, secret-checked `GetItemInfo(itemID)` read is permitted only when `GetQuestItemInfo` supplied no ordinary name. If missing, keep the current fallback with all stock interactions usable. No quests mutated, no timers, no suppression; monitor runtime separately. Details `docs/memory/evidence/P0245_QUEST_REWARD_ITEM_NAME_CACHE.md`. The P0244 money result is accepted only for this observed quest.

## R1 packaging repair

R0 aborted before tracked writes: the new durable checker hard-coded the
`0.0.145-dev` version and failed `check_checker_version_policy.py` during
shadow validation. R1 removes the version pin while requiring the TOC and
Bootstrap versions to agree. The reward reader and fail-open mutation boundary
are unchanged. See the P0245 evidence; actual client validation is pending.
