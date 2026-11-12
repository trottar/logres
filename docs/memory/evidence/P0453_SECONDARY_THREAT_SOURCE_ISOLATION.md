# P0453 — Secondary aggro source isolation (2026-11-11)

## Verified baseline and evidence

Main P0452 `e96506e58ee465387cc375811511268778cd59a5`, tree
`4a2bb6bb14b69898b5794b82e292cf0574e97fc2`, author kit SHA-256
`a1607bb3379db89f542cc237d6eb5c57dc2e8f7220f57c068451bad6ff44bb25`.
Kit's `baseline.tar` SHA-256 `00b230b88f6f055e786599fed4cd1ca4743d2bac6a31fae7dcc226bf8570e441`
matched metadata. P0451 #12124 session 114 0.0.321-dev inspected via
`tools/export_panel_diagnostics.py --inspect --expected-version 0.0.321-dev`:
diagnostics SHA-256 `764a8463e0b39d09cb93fad12b81fd3b1703bee7f96d9b2bd0956140dce900cd`.
14 secondary threat events, 12 secret deferrals, two no-table events,
zero qualified/primary/failure; World Enemy trial OFF in saved capture.
These are samples, not unique units or proof of sustained aggro. No additional
Forever test or source/deployment change preceded this candidate.

## Narrow source hypothesis

P0451 short-circuits when either `UnitThreatSituation("player", unit)` or
`UnitDetailedThreatSituation("player", unit)` yields a secret. It therefore
cannot say whether basic threat status is independently ordinary. A third-party
Forever addon source (MIT, https://github.com/HexToolFactory/ThreatOnNameplate,
read for behavioral context; no source copied) describes ordinary basic
threat status on nameplate units despite restricted detailed values.
This is external source evidence, NOT Forever Logres runtime confirmation.

P0453 retains the P0451 strict paired qualifying path and only adds independent
per-event provenance categories for basic status (ordinary primary 2/3,
ordinary nonprimary 0/1, secret, missing, invalid/failure, unavailable)
and detailed Boolean (ordinary tanking or not, secret, missing, failure,
unavailable). `basicEligible` counts ordinary primary status with same-event
ordinary hostile, attackable, combat, targeting-player and safe-anchor gates.
`basicEligibleDetailSecret` indicates that *only the detailed cross-check*
blocked the historical paired gate in such an event. Both are diagnostic
samples, not unique enemies, persistent aggro or renderer authorization.

Add `UNIT_THREAT_SITUATION_UPDATE` to the existing event-time lifecycle
registration; unsupported registrations are already guarded by `pcall`.
Record scalar counters/last categories in Report Bug `nameplateLifecycle` and
existing Phase H Nameplate Lifecycle output. No polling, timers, persistent
nameplate token/GUID, secret comparisons, native UI changes, alpha takeover,
aura rework or secondary display. Selected transparent world health and
native delegated aura +/-25px, fallback, click/cast/CC and P0450 restoration
stay untouched. The P0443 black backing remains rejected.

## Capability blocker and validation

Only a `basic` ordinary primary 2/3 plus all same-event gates could support a
future secondary aggro path; even then continuity, removal and 50%-display
restoration remain unproven. If basic result is secret or unavailable,
secret-safe Lua cannot branch on it to select a secondary renderer. Do not
infer aggro from targeting events, secret values, or screen color.

Static author-check/guarded apply and WoW tests are separate. Runtime P0453
is UNVERIFIED. After user push/deploy, natural multi-enemy combat and one
Report Bug export can classify basic/detailed sources; no repeated P0451
encounter without the new question. If source remains secret, keep secondary
50% disabled and defer awaiting a verified supported ordinary capability.
P0450 selected visual PASS is scoped; World Enemy OFF/taint/click/cast full
acceptance remains incomplete. L-011 PARTIAL, L-028 OPEN.
