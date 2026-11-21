# P0506 — L-030 quest eligibility boundary and accepted item-gated exceptions (2026-11-21)

## Authority and observed result

Verified remote Logres main `3bf5a2cb0bd085e9ebfb1909d07711f9633d5ad0`
(P0505). This is a **documentation-only** investigation checkpoint, not a
new fix or a runtime PASS. User's P0502 Forever screenshot/diagnostic
incident #20897 showed Sergeant De Vries (NPC 955) marked `[quest]` about
2 yards away, but the user observed no available quest. QuestieDB
quest 91738 qualified from independent player metadata, native offer
corroboration was absent, and the compass displayed a DB-inferred marker.
P0504's exact-NPC no-offer suppression acts only **after** a native
`GOSSIP_SHOW` or `QUEST_GREETING` that supplies ordinary zero-offer data.
It cannot guarantee an accurate pre-interaction marker in all cases.

## Source audit / negative result

`Logres/Navigation/QuestieDBNearby.lua` currently tests current player
level, class/race masks, accepted/completed quests, prerequisites,
exclusivity, chain state, and conservatively excludes unresolved
profession/reputation/spell/specialization and special flag conditions.
P0485's sparse-data correction and P0486's SHARABLE quest flag fix are
necessary to preserve real Marshal Dughan quest 35 (P0487 client PASS).
The QuestieDB public `src/meta/questMeta.lua` schema exposes quest
requirements and `requiredSourceItems`, but does **not** expose a
universal, verified *offer-time possession requirement* or a per-quest
server current-season/current-phase eligibility fact. The existence of
`requiredSourceItems` does not establish an offer-time gate. QuestieDB's
season-dependent corrections and server events cannot be inferred from
calendar time or a generic quest starter entry. Community reports
suggest quest 91738 depends on a special item; this exact causal gate
was **not** independently verified in the supplied Forever incident.

Adding generic inventory-presence vetoes, hard-coded NPC/quest IDs,
calendar-only holiday rules, or a global requirement for native-offer
corroboration was rejected: each could suppress legitimately available
quests, notably q35. No safe general runtime source change is justified
by this one event. No game interaction or new report was collected in
this checkpoint, and no new diagnostic or code change was made.

## User decision / boundary

User explicitly accepts rare exceptional item/event-triggered false
positives if no reliable general eligibility signal is available.
Continue to use P0504's interaction-confirmed no-offer evidence and
native-offer priority. Keep L-030 PARTIAL, not PASS/CLOSED. Revisit only
when a repeated false-positive pattern has a provider-backed, ordinary
safe eligibility signal (or client proof of a narrowly modelable rule).
Do not change camera, compass proximity, DB data, quest 35 gating, or
any Blizzard fallback to chase unverified one-off requirements.

## Validation / handoff

No runtime files changed, no WoW redeploy required, no new gameplay PASS.
The documentation checkpoint must pass repository text/source contracts,
exact baseline/payload byte checks and guarded applier checks before
submission. P0505 flight map visual approval is independent of L-030.
