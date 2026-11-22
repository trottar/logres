# P0509 — L-030 Lunar Festival seasonal classification gate (2026-11-21)

## Evidence and fixed hypothesis

Verified main P0508 `6ce984feb07708352e1680efadaee1f21de62a27`.
Forever source/deployed/capture `0.0.373-dev`, session200 incident **#22357**
(2026-11-21 15:01:17 EST) shows `Lunar Festival Emissary [quest]`.
Snapshot: map1453 area1519, first qualified NPC **15892**, quest **8870**;
`dbEligibilityQuestCandidates=2`, `dbConfirmedQuestCandidates=0`,
`dbNativeOfferCount=0`, `availableQuestPoiShown=1`, arrival NPC15892.
No native offer was proven. The external WoW Forever quest listing associates
quest8870 with `zoneOrSort=-366`; QuestieDB's `zoneOrSort` is its numeric
quest category, while quest sort 366 is Lunar Festival. The game calendar
lists Lunar Festival outside November (next published 2027-02-02), but
calendar schedules are not used as hardcoded runtime truth.

## Design and exclusions

P0509 checks **only** the QuestieDB lunar category (`zoneOrSort=-366`),
using ordinary realm-local `C_DateAndTime.GetCurrentCalendarTime` and
read-only `C_Calendar.GetNumDayEvents` / `GetDayEvent` for the current day.
The quest remains eligible only if the calendar has a HOLIDAY event
with eventID327 or English title `Lunar Festival`; no generic season,
level, class, gossip or quest list changes. Unavailable, failed, secret,
malformed, or incomplete calendar facts cannot authorize a DB-inferred
holiday quest. The existing *native current-offer first* branch remains
higher priority, even if the calendar is missing or lists no event.
`CALENDAR_UPDATE_EVENT_LIST` invalidates cached eligibility; ordinary
quest/zone events retain their prior invalidation behavior.
No host-clock month gate, NPC ID blacklist, blanket holiday classification
or Blizzard UI mutation is introduced. This rule is bounded to quest
category -366, not NPC15892 or quest8870, and cannot affect quest35
(which is not Lunar Festival) or other ordinary quest categories.

## Verification boundary

Source/fixture tests must cover current-month absence, genuine holiday
presence, unrelated/player-calendar entries, failures, secret-capable
values, cache invalidation, quest35, and native-overrides. Full historical
repository checks, Lua syntax, ZIP readback, baseline hashes and diff
whitespace checks are release gates. **No in-game P0509 validation yet.**
L-030 remains PARTIAL until Forever reproves no November marker and an
actual live native-offer path remains visible. Other seasonal quest
categories and custom server events are untested; do not overgeneralize.

## Preflight refusal retained

The first local handoff draft exceeded the 8000-byte handoff ceiling
(8027 bytes) and was corrected before any package was built. The first
whole-suite attempt encountered historical `CURRENT.md` <9800-byte and
`CURRENT_HANDOFF.md` <8000-byte contracts (the draft measured 9866 and
8000 bytes); this was documentation-only, not a gameplay-code failure.
Summary text was shortened to 9787 and 7992 bytes respectively. The
corrected complete source candidate then passed **369/369** historical
checkers including the P0509 real-source fixture. Exact final evidence
receipt and ZIP parity must be rechecked after these updates.
