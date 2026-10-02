# P0078 — F.1 Contract / F.2 Quest-XP Probe

Date: 2026-10-02
Result: PREPARED — RUNTIME PROBE PENDING

## Baseline

P0077 verified pushed:
`bf73fcf49e31177e9305652e509fd46a4aad12dc`

## Purpose

Resolve the Phase F source/capability contract and immediately open the targeted
runtime proof without an extra docs-only checkpoint.

## F.1

D-031 accepted.

Key result:
- passive observation and Blizzard interaction/control are separate;
- first production candidate is contextual XP;
- quest compass integration requires runtime-proven quest destination output;
- no quest/objective/XP stock suppression is authorized.

## F.2 probe

Adds:
`tools/probes/LogresQuestAudit`

Adds developer-panel action:
**Quest Probe**

Captures:
- quest-giver read state;
- selected/super-tracked quest identity;
- objectives;
- next-waypoint data and current-map bearing;
- XP/max/rested XP;
- Forever XP preset;
- quest/tracking/XP event registration/counts.

## Safety

Probe is passive.

It does not:
- accept/decline/complete quests;
- choose rewards;
- mutate watches/super-tracking/waypoints;
- suppress stock UI;
- send chat.

## Runtime

Production runtime remains:
`0.0.30-dev`.

Diagnostic integration changes `Commands.lua`.

WoW deployment is required after push verification.

## Delivery repair

The first apply attempt failed repository memory health because the generated
`CURRENT.md` omitted the canonical `Verified State` and `Success Criteria`
headings.

The repair restores the required memory schema and reruns the complete P0078
checker set before creating the manifest.

This failure is recorded in:
`../evidence/P0078_DELIVERY_FAILURE_2026-10-02.md`.
