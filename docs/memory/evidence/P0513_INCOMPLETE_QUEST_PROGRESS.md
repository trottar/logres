# P0513 — L-005 incomplete NPC quest progress (L-061 trainer coverage intake)

2026-11-23. Verified GitHub main P0512 `0963499b0ce2ab7d7ce7af1dacf96321d0162d95`,
tree `10e9b733bce64b38d124df2903d8e4b59f663fa2`, version `0.0.377-dev`.
Reconstructed exact tree from the P0511 author kit, P0512 payload, and
verified remote manifest; Git tree hash matches. Candidate `0.0.378-dev`.
Forever build 71037 interface 16001. Source/deployed/capture versions match.

## Observed failure and causal boundary

User: trainer item preview works pretty well, some recipe stats missing;
more importantly, no Logres NPC interface for an active quest. The latest
bundle's #23224 (session207, 15:35:05 EST) screenshot shows Alba Fairmoon,
Testing the Wells, with native parchment progress, required item names
Jansen Stead Water Sample, Molsen Farm Water Sample, Well Water Sample Kit,
and disabled Continue. Association inferred by mtime (0 seconds), not
client filename proof. The incident snapshot is questID 92742, rootShown
false, presentationShown false, progressActive false, lastPresentationReason
`progress-stock-owned`, offer suppression false/restored. Session206
#23076–23082 and session207 #23217–23223 show QUEST_PROGRESS handoff,
Logres presented then dismissed with `progress-not-completable`. This is
not a failure to receive the event or a missing quest-offer/gossip row.
The P0381 Continue-only gate refused incomplete quests by design, and
HandleQuestProgress explicitly withdrew the panel. L-005 PARTIAL, this
variant FAIL. L-002 transient completion flash remains separately OPEN.
Actual accepted quests 153/92742/92744 in sessions206/207 are scoped
positive for native-event-confirmed accept; no new completion PASS.

## Candidate

The existing progress read/renderer and stock restoration are reused.
Read only current event title/body, native `GetNumQuestItems`,
`GetQuestItemInfo("required", index)` and `GetQuestMoneyToGet` (cost,
not payout); require ordinary bounded item name and quantity, ordinary
count and money. The item-ID-backed bag count is optional and explicitly
labeled, not a turn-in eligibility inference. API source contract:
Warcraft Wiki API_GetQuestItemInfo and API listing; existing P0128 audit
and completion cost gate. Actual Forever incomplete-source coverage
remains UNVERIFIED. A separate gate requires ordinary false readiness,
same questID, known disabled native Continue, shown native progress stage,
noncombat and original nonprotected complete stock snapshot. Missing or
secret data/protection remains native. Use existing paginated narrative
style, append requirements and not-ready text, keep final-page pager
clear of centered **View in Blizzard** action. Native item tooltips and
all further detail remain deliberately reachable via that explicit action.
No Continue request, timer, reward/accept or purchase dispatch occurs in
read-only state. Goodbye restores stock then requests existing native
CloseQuest only on validated same-stage user click; failed/unsupported
close leaves usable stock. Existing ready Continue and completion bridge
remain unchanged. On meaningful source/readiness change, combat entry or
uncertain identity, event-driven fail-open withdrawal restores stock; no
polling/reassertion or auto-repark. Unchanged source on a bag/quest/money
event retains ownership. Diagnostic state adds addon-owned read-only and
last progress reason, not native presentation probes. Camera/compass,
tracker, trainer transaction, and approved visuals unchanged.

## Trainer intake / L-061

P0512 scoped positive user report; not all recipe previews work. No
specific missing lesson/identity/cache status was captured in the latest
incident. Earlier journal training is not evidence of all P0512 recipe
previews. Preserve existing exact link and cache policy; don't guess output
by name/icon or conflate with L-033 purchase. On next missing recipe, Report
Bug with lesson selected, then export; missing-link/data cause UNKNOWN.
Prior natural-occurrence P0510/P0511 testing still PENDING, not PASS/FAIL.

## Regression gate

Actual-source fixture uses Dialogue, NarrativePages and OfferStockSuppression
with simulated ordinary incomplete native rows and original input tokens;
checks unchanged update, missing/secret/protected inputs, item/money,
readiness/combat change, restore-before-native view and Goodbye, and
original ready Continue plus bounded fallback. Historical suite and guarded
archive checks required; no gameplay PASS until tested. Natural Forever
visit to unfinished quest, read text/items, view native explicitly, reopen
and Goodbye; check other ordinary NPC offer/ready Continue/claim as they
naturally occur. Unknown data must preserve stock. Report Bug on failure.
