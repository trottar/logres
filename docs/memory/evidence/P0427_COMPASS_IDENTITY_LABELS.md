# P0427 — Source-backed focused compass identity labels

Date: 2026-11-09. Verified remote P0426 baseline
`32451c20b2a76bc6b689459251900c5e04b1fd6c`.

## Report and root cause

User reports focus labels such as `Possible repair`, requests
`<Name> [profession, repair, quest, etc.] - <N> yd`. The source in
`Compass.lua` prepends `Possible ...:` by service kind (and sometimes
`Possible quest giver:` for historical DB candidates). The common label
renderer formerly added a centered dot before yards. This is presentation,
not an eligibility or provider-coverage problem.

## Change scope

Use ordinary source-name and typed role at candidate construction. Current
`trainer` flag is displayed as `profession` without claiming a trainer
subtype; `repair` remains repair; only native-corroborated quest-giver DB
rows are included by existing P0337 logic. No external record/position
created. Unknown/secret/missing identity suppresses the focused text, not
the position marker. Unknown yards stays `distance unavailable`, and
manual waypoint uses its own `[waypoint]` role. Leave marker scale/bearing,
source eligibility, current offer checks and collision priority untouched.

## Validation boundary

Historical source/format contracts and a new P0427 checker provide static
evidence only. WoW Forever runtime PASS for service/quest/waypoint names and
unknown-distance behavior remains **UNVERIFIED**. L-043 stays OPEN until
user validation. Missing real quest givers (L-030) and QuestieDB freshness
(L-044) remain separate; P0428 follows.
