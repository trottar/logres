# P0510 — General holiday quest eligibility gate (2026-11-22)

## Authority and observed failure

GitHub `main` P0509 `b7552e8d5105ed2370663cc0721987ba7a348735`
verified before edits. Forever P0508 incident #22357 (NPC15892 quest8870)
proved a Lunar Festival quest marker in November with no native offer.
P0509 added only one Lunar-only calendar gate; user correctly rejected that
narrow scope and requested the complete supported holiday-classification fix.
L-030 remains PARTIAL; P0509 had no independent in-client proof.

## Source findings

QuestieDB `zoneOrSort` is a numeric QuestSort, not an active-season signal.
QuestSort6x reference explicitly identifies these separate event sorts:
-21 Hallow's End, -41 Day of the Dead, -364 Darkmoon Faire,
-366 Lunar Festival, -369 Midsummer, -370 Brewfest, -374 Noblegarden,
-375 Pilgrim's Bounty, -376 Love is in the Air, -378 Children's Week.
`-22` means only *Seasonal*, not a specific event. Winter Veil, Harvest
Festival, and some special/anniversary quests lack a uniquely identified
sort in this provider: matching them to any active holiday would be wrong.
Sources: https://trinitycore.atlassian.net/wiki/spaces/tc/pages/8552472/QuestSort6x
and https://trinitycore.info/database/335/world/quest_template .

The client/server calendar ID is not a safe, verified cross-flavor identity:
P0509 treated 327 as Lunar, while AzerothCore's Holidays data lists 327
as Brewfest (and inconsistent servers/DBC publications exist). Calendar
HOLIDAY titles are used with exact normalized English aliases, not numeric
IDs or hardcoded dates. Non-English localized titles cannot currently
qualify a DB-only holiday inference; recorded as an explicit limitation.
A title from a PLAYER event is not HOLIDAY evidence. Darkmoon Faire
location suffixes are enumerated; a generic `Darkmoon Faire Setup` prefix
does not authorize DB quest-giver markers. No calendar APIs are
mutated and no time-based guess is made. See
https://www.azerothcore.org/wiki/game_event .

## P0510 policy

A classified DB-only holiday quest requires an ordinary same-day
`C_Calendar.GetDayEvent` with matching HOLIDAY name. Missing/secret/failed
calendar facts veto inference with a diagnostic reason; unrelated HOLIDAY
names cannot authorize it. Calendar event list changes and changes in the
realm-local day invalidate the quest eligibility cache without polling.

For generic `zoneOrSort=-22`, the provider cannot identify *which* holiday
owns the quest. Do not accept inference merely because some other holiday
is active: retain the quest as historical data but require the existing
native-confirmed offer to display an available quest giver. The same
boundary applies to unclassified event quests; they retain the current
baseline behavior and warrant evidence-specific mapping rather than a
speculative keyword/ID blacklist. This can produce false negatives for
unconfirmed generic seasonal quests even during their own holiday; L-030
remains PARTIAL and native stock/quest UI still works. Quest35/quest333
and generic nonseasonal categories retain existing eligibility.

P0509's old eventID=327 Lunar fallback is removed because it can confuse
Brewfest and Lunar across databases. Its historical Lua/checker contract
is updated, not bypassed, to assert all original Lunar protections plus
correct name-based identity. The new P0510 fixture exercises ten
categories and active/inactive/cross-event/player-event, unknown/secret,
midnight cache invalidation, native-offer override, generic Seasonal,
nonseasonal quest35/333, and no calendar manipulation.

## Validation and negative evidence

No WoW Forever P0510 runtime test has occurred. Static/fixture success
cannot establish calendar population or localized holiday names in-client.
The legacy P0509 assumption about eventID 327 is rejected by conflicting
published holiday-ID tables; only current-day matched titles are trusted.
The first source-only P0510 checker run refused because the evidence file
had not yet been created; no runtime changes were discarded or applied to
the user's repository. Keep this as a preflight, not a client failure.
Exact candidate historical static checks, Lua compilation and ZIP byte
readback are release gates; append their actual outcomes below.

## Actual assistant preflight result

The first parallel full-suite audit reported **365/370 PASS**: five
historical documentation-ordering contracts refused after P0510 was
initially placed above the required active P0486 heading. Specifically:
`check_p0381_integrated_gameplay_contract.py`,
`check_p0408_chat_preflight_contract.py`,
`check_p0443_owned_enemy_matte_contract.py`,
`check_p0448_world_enemy_aura_refresh_contract.py`, and
`check_p0449_native_world_aura_container_contract.py`.
The P0510 sections were moved after P0486 in the relevant roadmaps and
ACTIVE file. Each of the five checks then passed individually; the
second **full 370/370 static audit passed**. `check_memory_health.py`
reported zero errors/warnings, runtime version policy PASS, and 17/17
changed-file whitespace diffs were clean. No WoW client validation was
performed. Final audit-bearing candidate and archive integrity must be
verified after recording this receipt.

A further source review found that an open-ended `darkmoonfaire*` prefix
could mistake an upcoming setup-stage calendar entry for the running faire.
The candidate now recognizes only named Darkmoon Faire and enumerated
location-suffix variants; a `Darkmoon Faire Setup` fixture is rejected.
The intermediate 370/370 audit overlapped this final source refinement,
so it is not used as an exact-final receipt. A full stable-byte rerun is
required before release.

## P0510 R1 — PREWRITE inventory refusal and correction (2026-11-22)

User's original P0510 ZIP passed SHA-256 and extracted but the guarded
PREWRITE phase refused before tracked writes: `checker list differs from the
packaged candidate`. Its generated checker manifest incorrectly listed the
nonexistent `check_p0503_r2_quest_compass_contract.py` and omitted the tracked
`check_p0502_camera_visit_pace_contract.py`. Both candidate inventories
contained 370 names, which disguised the mismatch in assistant-side counts.
The assistant's initial 370-check shadow run therefore was not an accurate
full P0509 historical inventory. The root cause was reconstructing an older
author-kit baseline with hand-added recent checkers instead of reconciling
against current GitHub `main` inventory. This is a **packaging failure**, not
a gameplay regression or a failed quest gate.

P0510_R1 repairs that exact inventory, retains P0509 SHA and all original
quest/compass behavior, and requires the genuine P0502 camera checker plus
all other historical contracts in PREWRITE and POSTWRITE. Do not weaken the
list guard, bypass failures, or claim client holiday correctness from static
tests. P0510 initial refusal is preserved as negative evidence.

### R1 corrected-suite verification

The corrected candidate with the exact GitHub P0509 inventory plus
`check_p0510_all_holidays_contract.py` passed **370/370** historical
`tools/check_*.py` contracts (independent process runs, no failures).
The genuine P0502 camera contract passed. The R1 archive must carry this
receipt and be reaudited without further payload changes before release.
This establishes only static fitness, not WoW calendar correctness.
