# P0432 — Event-time World Target evidence / OOC selected-only policy

Status: AUTHOR-PREFLIGHT DRAFT; NOT DEPLOYED. Baseline P0431 main
`ee923bf172bafb1803cf8a5d3d53a7d9559edf8c`.

## Accepted player-facing behavior

The player showed a hostile selected target displaying a nameplate outside
combat while a second nearby hostile wolf had none. Out of combat, the
selected hostile target alone receives the world label (100% size and alpha),
not all nearby hostiles. During combat, the selected hostile target stays
100%; a different hostile with *confirmed aggro on the player* receives
50% size/alpha only while that confirmation remains. Other enemies have no
Logres frame. Friendly and neutral target behavior and usable fallback must
remain intact. Do not enable global nameplate display or change CVars.

## Observed diagnostic state and prior error

Forever 1.60.1 build 70888, Logres 0.0.304-dev session 91 incident 10283:
Report Bug captured sanitized `snapshot.worldTarget`; hostile/canAttack true,
`anchorPresent=false`, `attachmentState=not-attempted`, candidate=false,
`fallback=no-accessible-nameplate`, secret skips and failures zero, and
nameplate add/remove counts zero. This is a contextual OOC snapshot, not
negative evidence for combat attachment. The assistant wrongly interpreted
missing out-of-combat anchor as a request to force enemy nameplates. User
confirmed target-only outside-combat presentation and no passive other wolf.

Earlier deployment instructions incorrectly targeted `_classic_beta_` although
WoW Forever and the export tool use `_forever_`. The user correctly deployed
and verified the specified beta path, so the assistant's attribution to user
installation error was incorrect. P0431 was subsequently deployed to the
Forever path and its Report Bug capture verified at 0.0.304-dev.

## Proposed diagnostic-only code

Retain the original current-target, includeForbidden=false nameplate query,
secret-first read, combat-guarded hidden proxy, and event-payload discard.
Record session-scoped scalar latches when event-time target anchor is ordinary,
separately for combat and noncombat. Retain event reason, last combat fallback,
combat-deferred attachment, and the OOC positive proxy-attachment latch even
if a later manual capture sees no plate. Report Bug includes those fields.
Never capture Blizzard frame references, enumerate plates, change nameplate
settings, infer aggro, read threat/secret values, or modify the production
screen-space target. No new combat polling or protected mutation.

## Capability gates

Positive target attachment requires a naturally available OOC target nameplate
and `worldCandidateEverSeenOutOfCombat=true` (a hidden addon-owned proxy
attachment passed). Combat anchor access is observed separately and may show
`attachment-deferred-combat` by design. Secondary unit-token ordinary/anchor
capability and a reliable ordinary per-enemy confirmed-aggro signal are still
UNPROVEN; no 50% secondary renderer is authorized. Production relocation,
saved screen-space toggle and target aura migration remain DEFERRED pending
D-042/L-011 capability proof and full implementation.

## Validation / release gate

The full 297-checker exact candidate suite, diff hygiene, guarded apply and
rollback verification must pass in the author's WSL checkout. They were NOT
executed by Chat and no WoW result for P0432 exists. Do not treat this draft
as deployment ready. Once a checked implementation is pushed, deploy into
`_forever_/Interface/AddOns`, `/reload`, select a hostile wolf out of combat
and naturally enter combat with the same target. Left-click Report Bug after
the encounter (while the current target remains selected if practical),
`/reload`, export bundle, examine latest incident `snapshot.worldTarget`
`outOfCombatEventSamples`, `worldCandidateEverSeenOutOfCombat`,
`combatEventSamples`, `targetAnchorEverSeenInCombat`, `lastCombatFallback`,
`lastCombatAttachmentState`, `secretSkipCount`, `failureCount`. A later manual
capture cannot erase event-latched positive evidence. No forced nameplate
settings or contrived combat beyond natural gameplay are required.
