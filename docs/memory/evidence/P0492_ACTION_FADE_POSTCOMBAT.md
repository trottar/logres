# P0492 — L-055 action fade after combat exit (2026-11-18)

## Verified baseline and observed client failure

P0491 verified on GitHub main `3f579042972f1e7f2419dcecc47e5467dd39b9f3`.
Forever 0.0.357-dev session176 incident #18277 (22:00:43 EST)
recorded combat=true with action bars visible; #18280 (22:00:47)
recorded combat=false with action bars faded; #18282 (22:01:06)
recorded combat=false again but several Logres action clusters visible.
Image/incident filename match is an export-time mtime inference, not
client-authoritative screenshot identity. User directly reports combat
reveal consistently works, but subsequent out-of-combat fade does not.
Do not mark P0491 PASS. #18277 also has a generic addon action warning;
its caller is unverified, and L-055 OPEN. Prior P0489 OOC scoped PASS and
P0490 hover scoped PASS remain; later failure is a regression.

## Narrow source finding, hypothesis and fix

P0491 secure `[combat] combat; rest` driver restores six combat alpha
values while intentionally leaving secure `rest` inert to preserve a held
hover across alternate callback orders. Context subscribes to state changes
but its `PLAYER_REGEN_ENABLED` event is registered only during pending
module-disable teardown. A state callback that skips protected roots
while locked can leave combat alpha without an explicit post-lockdown
reconciliation. This is a source-supported failure path, not a proven
reconstruction of every visible frame in #18282; that later reappearance
could also come from a stale hover token or an unobserved owner refresh.

P0492 registers active ActionContext for one-shot `PLAYER_REGEN_ENABLED`.
Once lockdown ends, addon-owned action buttons are checked for ordinary,
non-secret mouseover results; a fully observed group clears a missed
`OnLeave`, while unknown/secret results are kept without inspecting them.
A truly held hover remains at its requested alpha. Then ordinary Lua
reapplies the *rest* policy to all six addon-owned action roots and their
UIParent feedback siblings. The secure driver remains combat-only; no
secure handler rest write, timers, OnUpdate polling, fake hit frames, native
Blizzard mutation, binding, paging, action attribute, or quest change.
Module disable in combat still defers safe teardown and restores visible
controls after regen. The driver-unavailable path continues to fail open.

## Incident evidence added

Report Bug now includes `snapshot.actionContext` policy, requested and
read-only addon-owned OOC actual alpha for six roots, six hover tokens,
secure driver and regen counts/results. The getter deliberately declines
combat/secret/unsupported reads; it never touches Blizzard-owned roots.
This distinguishes stale hover from an alpha override in the next natural
capture, without a probe requiring repeated gameplay or changing UI.

## Validation and known limits

P0492 actual-source fixture simulates a missed out-of-combat state callback,
post-combat recovery, stale/held hover, unavailable/secret mouseover,
normal secure combat transitions, deferred disable and driver absence.
Historical P0489/P0490/P0491 fixtures and all repository checks must PASS
on exact transformed bytes; static PASS is not WoW PASS. UI results remain
UNVERIFIED until the user observes a natural combat/exit/hover sequence.
A recurrence after this one-shot event is not automatically closed or
explained; inspect actionContext actual/requested alpha and hover fields.

## Live check

Deploy and `/reload`; one naturally occurring combat encounter with
pointer away from action clusters. During combat primary/Bar4 100%,
secondary/pet 85%, utility/Bar5 75%; after combat all 0% while unhovered.
Hover each group after leaving combat and verify respective reveal.
Developer panel Phase C **Action Check**, **Pet Action Probe Check**;
Phase D **Context Policy Check**. Left-click **Report Bug** in any failed
state and export `tools/export_panel_diagnostics.py`. Check normal secure
clicks, pet actions, bindings and error messages. User owns runtime PASS.
