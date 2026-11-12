# P0455 — Secondary unrelated threat-update flicker repair (2026-11-12)

## Verified baseline and incident

GitHub `main` P0454 `1424fd740ad5be8d8ba32c2d09a7c967ec24ea2a`,
tree `302f0a6b2ff77d305c5ea53716445dd2efdb7929`. User provided
Forever bundle `LOGRES_BUG_REPORT_LATEST.zip`, SHA-256
`736787cb5ce5cccc89bfb304f7e09a2a441f286b18a42b63e244bb525c273600`,
with byte-identical standalone/ZIP diagnostic Lua SHA-256
`e78f11e15bd48ffcd4eb4ffb09170e92d676bbd7da120e11922376f718429f24`.
Export provenance source/deployed/capture all `0.0.323-dev`; no stale
capture. Session 119 #12547 at 00:09:20 EST: 5 secondary attaches, 4
detaches, 4 native restores, 5 eligible events, 0 failures; #12549 at
00:09:25 EST: 9 attaches, 9 detaches, 9 restores, 9 eligible, 0
failures. Last result `secondary-event-token-unknown`. Screenshots
filesystem-matched to incidents (not verified client filenames) show
name/HP presentations near the same enemy(s); user reports repeated
Blizzard↔Logres flicker while the secondary remained 50% scaled.
These are event counts, not unique enemies or exact transitions.

## Narrow cause

The P0454 `HUD:ObserveSecondaryAggroTrial` branch for a non-nameplate
`eventUnit` unconditionally hid any attached secondary with
`secondary-event-token-unknown`. The lifecycle frame also dispatches
`UNIT_THREAT_LIST_UPDATE`, `UNIT_THREAT_SITUATION_UPDATE`, and other
non-removal events whose payload is not necessarily an attached
`nameplateN`. Those events contain **no observed evidence** that the
attached secondary lost aggro, and forcing a restore/reclaim makes
the user's visual flicker plausible. This explains the source-level
failure; per-event causality cannot be fully reconstructed from
aggregate counters. Status `0/1`, missing/secret result for a matching
ordinary attached unit remains a reason to restore (fail open).

## P0455 proposed behavior and safety

For `NAME_PLATE_UNIT_REMOVED`, preserve existing conservative relevant
or unknown identity restoration before touching native anchors.
For *other* lifecycle events with no ordinary nameplate token, ignore
the event for current secondary ownership, without retaining new
unit/frame data. Count ignored unrelated updates while attached and
record the last real detach reason. Same-unit negative/unknown threat,
combat exit, target switch, World Enemy OFF, immersion OFF, and
actual nameplate removal continue to call native restore before hiding
Logres. Preserve selected 100% HP/auras, secondary 50% scale/opacity,
blizzard native auras/cast/mouse, native opaque alpha restoration,
no polling, no secret branching. Production secondary remains disabled.

## Status

P0454 **RUNTIME VISUAL FAIL**, scope session 119. Zero reported
mutations/restoration API errors are not a flicker PASS. P0455
Forever runtime UNVERIFIED until deployed; examine ignored count,
actual detach reason, failures, name/HP continuity and click/cast,
OFF and combat exit naturally. L-011 PARTIAL/L-028 OPEN. Do not close
on static checks alone. No contrived combat/travel test required.
