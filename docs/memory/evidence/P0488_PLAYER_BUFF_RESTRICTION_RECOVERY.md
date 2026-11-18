# P0488 — L-054 Player helpful buffs fail to recover after restriction release (2026-11-18)

## Authority and client evidence

GitHub `main` P0487 commit `8d2c525b93bb2542591a5fe43a4e85b97231d6d5`,
tree `7739657ba0236c079790101da622a40a096c69b1`, verified. This
checkpoint is based on the uploaded 2026-11-18 15:34 Eastern
`LOGRES_BUG_REPORT_LATEST.zip` and `LOGRES_DIAGNOSTICS_LATEST.lua`;
source, deployed Forever and capture `0.0.353-dev` all match.
Screenshot-to-incident pairing is inferred from filesystem timestamp
(0–1 seconds), not a native in-client image identifier.

- Session172 #17676 at 15:32:57 Eastern: user reports that player buff
  icons reverted to Blizzard. Screenshot displays stock-looking upper-right
  auras; `playerHelpful.rootShown=false`, `visibleCount=0`,
  `secretSkipCount=40`, `lastPresentationReason=UNIT_AURA`.
  `state.combat=false`, `changedBy=ADDON_RESTRICTION_STATE_CHANGED`.
- The journal records five prior combat-true/false cycles (#17666–17675)
  and last combat false at #17675 (15:31:07). No subsequent player aura
  refresh appears in the owned journal before the user reports the defect.
  Absence of a journal event alone does not establish which external
  Blizzard callbacks executed; the source *does* only subscribe
  PlayerHelpfulAuras to UNIT_AURA/PLAYER_ENTERING_WORLD.
- Session172 #17678 at 15:33:16: after user rebuffed, the Logres
  presentation recovered: `rootShown=true`, `visibleCount=6`,
  `secretSkipCount=0`, `lastPresentationReason=UNIT_AURA`.
  No error/taint assertion was reported in this capture. User describes a
  temporary switch to Blizzard until rebuff; do not misclassify as PASS.

## Narrow defect and correction

`Logres/HUD/PlayerHelpfulAuras.lua` P0468 full-HELPFUL bounded scan
correctly refuses to claim coverage when 40 indices are secret. This
may hide the Logres root, leaving usable Blizzard BUFFS as intended.
However the previous module refreshed only on player UNIT_AURA and
PLAYER_ENTERING_WORLD, not restriction release. A combat-restricted
snapshot can persist well into out-of-combat gameplay without another
UNIT_AURA; the 15:32:57 report is one such case. This is **L-054 OPEN**.

P0488 registers only `ADDON_RESTRICTION_STATE_CHANGED`, an event already
observed by Logres State. If combat lockdown remains active, do nothing.
Otherwise refresh the player HELPFUL source by the existing secret-first
40-index path and then ask the existing NativeSurfaceReplacement owner to
reconcile its own stock BuffFrame snapshot. This ordering does not depend
on the relative delivery order of Native's PLAYER_REGEN_ENABLED and
PlayerHelpful's event. Complete ordinary coverage may fold stock;
incomplete/secret/failure/preview/manual-open cases fail open to stock.
Only addon-owned outcome counters enter Report Bug. There are no new
timers, per-frame hooks, protected readbacks, forced Blizzard visibility,
new aura APIs, duration guesses, or changed 2/3yd compass behavior.
During genuinely restricted combat the stock fallback may remain visible;
P0488 specifically repairs the persistent *post-combat* failure.

## Additional L-030 gameplay evidence from same export

Session172 #17718/#17720/#17727: QuestieDB qualifies NPC261 quest37,
`dbEligibilityQuestCandidates=1`, `availableQuestPoiShown=1`; screenshot
shows Guard Thomas quest marker/greeting. Journal records quest35
`QUEST_TURNED_IN` (#17705), quest37 `QUEST_ACCEPTED` (#17747), and
quest52 `QUEST_ACCEPTED` (#17759) from live Logres actions. By #17760,
`availableQuestPoiShown=0`, one historical candidate is excluded, with
`eligibilityClosestRejectedReason=already-active-or-complete`.
This is a second distinct positive quest giver with active-quest filtering;
not exhaustive future/completed/conditional false-positive coverage.
L-030 therefore remains PARTIAL; P0486 PASS and P0487 verified remain.

## Source validation and runtime boundary

A P0488 actual-source Lua fixture reproduces 40 secret skips, hidden root,
stock restore at combat end and later ordinary recovery **without another
UNIT_AURA or rebuff**. It also proves incomplete coverage leaves stock
visible, combat-time restriction event does not force refresh, and manual
BUFFS access is preserved. A new static contract pins the exact event,
secret-first source, native owner reconciliation order and incident fields.
Historical contract suite, syntax, full exact-candidate audit,
ZIP prewrite/postwrite, refusal/rollback and diff checks are required
before user handoff. These are static/source tests, **not** a WoW PASS.
L-054 remains OPEN until naturally reproduced combat-to-world recovery.

## Candidate audit receipt

P0488 first full-check launch stopped at 50/349 and its second resumable
launch stopped at 75/349 because of tool execution limits. Neither run
reported a checker failure; neither was counted as complete. Continuing
from saved successful results completed all **349/349 STATIC PASS** with
zero recorded failures. The P0488 and P0468 actual-source Lua fixtures,
version policy and memory health PASS. These are candidate checks, not an
in-client buff restoration result. Final ZIP and transactional integrity
checks are separately required.
