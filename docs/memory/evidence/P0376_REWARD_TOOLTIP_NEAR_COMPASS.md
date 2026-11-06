# P0376 — Reward tooltip and near-quest compass; live-issue intake

Date: 2026-11-05. Baseline: P0375 `5b45be81db1eba4c60cf96010e5d27b95176a751`, `0.0.261-dev`, 245 static checks; candidate: `0.0.262-dev`. **WoW runtime UNVERIFIED.** All source conclusions below are limited to the checked baseline and the supplied SavedVariables journal.

## Live observations, not source-level fixes

- User reports **L-027** Blizzard XP overlay still appears. Supplemental user screenshot shows two central **`New Recipe Learned!`** popups: `Runed Copper Rod` and `Enchant Bracer - Inferior Stamina` above an Enchanting trainer; screenshot SHA-256 `d39ccc85e0a5dccc00c3df292024b51d562399d0f53c4934a840057a4c2348e5`. The trainer is an independent interaction/control surface. The screenshot does not identify the notification frame owner; **no Blizzard popup is suppressed in P0376**. Desired policy: Immersion ON hides passive recipe/XP/task notifications once exact ownership is confirmed, without suppressing trainer interactions, actual recipe learning, or native safety fallback. Immersion OFF restores stock behavior. L-027 stays OPEN.
- User reports Blizzard frame on **Continue** during turn-in (L-002); missing reward stats and Shift hover (L-038); inability to complete some choice quests (L-005); compass quest marker jitter at <=3yd (L-035); yard labels should omit `~` (L-031); camera rotates repeatedly through one NPC conversation (L-036); `/reload` interface overlaps quest tracker (L-025); and quest tracker needs styled previous/next quest controls (L-037).
- Supplied P0375 journal session 9: `0.0.261-dev` login seq840; quest 33 `completion-stock-fallback` reason `choices-or-unknown` seq927, then `QUEST_TURNED_IN` seq930. Quest 15 `completion-owned` seq959, `completion-click-result: native-handler-invoked` seq960 and `QUEST_TURNED_IN` seq961. Quest 21 `accepted: event-confirmed` seq978. Report Bug screenshots: seq914/918/928/939/969; client screenshot image bytes are not embedded in SavedVariables. Sequence 927 is deliberate stock fallback, not proof of an unexpected stock mutation. The two turn-in events prove those quest IDs were turned in, **not** all reward variants or all visual policies.

## Narrow source findings and candidate

1. `Logres/Quest/RewardVisual.lua` previously enabled live reward mouse interaction only for synthetic preview choices; the view had no real item tooltip. `Logres/Quest/Dialogue.lua` built passive reward cards but discarded their item ID/link. P0376 retains only ordinary, validated item ID and `GetQuestItemLink` hyperlink and enables **hover only** on the live cards, using `GameTooltip` to show available item metadata and optional Shift comparison. No native reward selection, claiming, or protected UI suppression is added. If link and ID are absent or tooltip APIs fail, the row is passive and stock UI remains usable. Full live tooltip behavior is **UNVERIFIED**.
2. `Logres/Navigation/Compass.lua` rendered real same-map distance with a literal `~`, and positioned quest markers at raw bearing even at point-blank distance where bearing noise dominates. P0376 removes the tilde for all ordinary sourced focus labels and centers only quest-linked markers at <=3yd. A marker previously centered releases only at >=4yd; unavailable, secret, other-map, and service distances retain existing source gates. Existing single-tape collision priority remains in force. Live movement test is **UNVERIFIED**.
3. `tools/check_p0338_focused_compass_yards_contract.py` has historical fixture expectations for the `~`; P0376 updates only that explicit display expectation. New checker `check_p0376_reward_tooltip_near_compass_contract.py` enforces read-only item hover and the near-center hysteresis contract. Existing P0248/P0249/P0264 and all other historical static contracts must pass before writes.

## Deferred work stays open

- **L-002 / L-005:** Never suppress Blizzard Continue/reward-selection controls without a safe, scoped Logres replacement and confirmed native claim. Quest 33 required fallback. Reward tooltips alone do not resolve quest choice/claim.
- **L-027:** Identify the exact Blizzard XP/recipe toast frame and lifecycle with evidence before capability-gated suppression; preserve actual learning and related interaction controls.
- **L-025:** Need layout provenance for the `/reload` overlap; no global strata changes.
- **L-036:** D-047 camera profile is frozen. Diagnose NPC conversation lifecycle and prevent per-page rotations only after owner and context are evidenced; do not change DynamicCam baseline speculatively.
- **L-037:** Requires a separately designed preview-first quest-cycle control, explicit ordinary quest ID source, and safe super-track switching; no automatic quest selection here.

## Runtime verification after push

- In WoW Forever `0.0.262-dev`, `/reload`; visit a natural quest reward with item cards, hover with and without Shift to inspect ordinary tooltip/stats. Verify left click on live choice does *not* silently claim a reward and Blizzard's fallback remains usable.
- Focus a known same-map quest marker and approach from 5yd to 2yd; verify it centers under 3yd, doesn't oscillate between 3 and 4, exits at 4yd, and the distance label contains no `~`. Service bearings unaffected.
- Use Report Bug at any failure; `/reload`, then export `python3 tools/export_panel_diagnostics.py`. Never classify unobserved paths as PASS.

L-002 OPEN; L-005 PARTIAL; L-025 PARTIAL; L-027 OPEN; L-031 DEFERRED pending client test; L-035 OPEN; L-036 OPEN; L-037 DEFERRED; L-038 OPEN. Static PASS is not runtime resolution.
