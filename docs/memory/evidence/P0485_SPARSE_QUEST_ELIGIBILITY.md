# P0485 — L-030 sparse QuestieDB optional-field handling (2026-11-18)

## Source authority and client evidence

Verified remote main P0484 `3277132e6484a3ecb9a30389daddf1e3e6ffc561`,
tree `8254cac4ecc2c519a0aff0a89412661d4293d757`.
User session168 0.0.351-dev verified deployed/source-match; #17282,
#17284, #17286 at 12:06 Eastern show Marshal Dughan still unmarked.
QuestieDB index ready map1429/area12, nine nearby historical quest
spawns (eight returned to Compass); native offer0; native-confirmed0;
model-confirmed0; historical excluded8; rendered quest0. Screenshots
show Dughan selected in the world; session167 #17193/#17198 proved
Further Concerns (quest35) currently offered. No new current-offer
interaction was captured in session168, so do not infer its live dialogue
state there. P0484 FAIL on this case, L-030 OPEN/PARTIAL. L-035 fast-turn
improvement PARTIAL; old wrong-floor/tildes/jank failures retained.

## Narrow evidence-backed failure and correction

P0484 treated missing optional fields as failures (`requiredMaxLevel`,
`requiredRaces`, `requiredClasses`, prereq/chain IDs, `specialFlags`,
`questFlags`, `requiredSpell`/specialization). Its actual-source fixture
silently changed missing numeric QuestieDB values into zero; therefore it
was not representative of QuestieDB's sparse compiled records. The
published QuestieDB quest schema marks many fields nullable and the
provider read-performance report shows sparse scalar availability.
Also, `checkIDArray()` rejected empty ordinary prerequisite lists.

P0485 distinguishes successful ordinary nil (optional restriction absent)
from a read error, secret-capable field or malformed non-nil value
(UNKNOWN: reject). It accepts empty ordinary prerequisite/exclusive lists,
retains nonzero flags and unverified requirements as vetoes, maintains
current completed/active quest, level, race/class, chain and exclusion
checks, native-confirmed priority, 16 uncached quest reads per refresh,
2048 cache, eight-NPC/50yd limit, event invalidation and safe stock fallback.
Only additional additive Report Bug fields expose existing provider-owned
eligibility counters: qualification/rejection, cache/limited/last reason,
nearest rejected quest/NPC/reason and first qualified quest/NPC. The former
P0484 debug-only fields were never copied into incident snapshots; this
change closes the reporting gap, not the gameplay issue by itself.
No timer/CVar, protected frame inspection, 3D floor guess, compass visuals,
quest UI ownership or proximity/rotation change.

## Validation

A new actual-source `tools/test_p0485_sparse_quest_eligibility.lua`
uses true nil/empty optional QuestieDB fields for quest35, confirms
positive gating; then injects a failing and secret-valued optional getter
and requires both to reject. Reuses explicit active/completed,
prerequisite, restriction, native priority and eight-cap cases. Historical
P0484 fixture still passes. `check_p0485_sparse_quest_eligibility_contract.py`
asserts source and incident wiring and executes new fixture when Lua is
available. First local parallel audit 344/347 FAIL only at historical CURRENT
bold-marker assertions P0482/P0483/P0484; restored the markers
before restarting checks. Frozen builder was cancelled before release.
Full repository static suite/ZIP transactional guarded
PREWRITE/POSTWRITE and rollback gates are release conditions, not WoW PASS.

## Runtime follow-up

At a naturally available Dughan/other quest giver, capture Report Bug
**before** interacting; the `questCompassDB` fields must now show whether
P0485 admitted a candidate, and if not why. Check the actual compass
quest icon, completed/future NPC false positives, source parity and Lua
errors. P0485 is not accepted until this client evidence is supplied.
