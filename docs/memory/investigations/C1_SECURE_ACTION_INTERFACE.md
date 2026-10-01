# C.1 — Secure Action Interface

Status: COMPLETE
Opened: 2026-10-01
Closed: 2026-10-01

## Goal

Resolve the secure-action architecture for Logres action clusters before writing the first Phase C runtime implementation.

## Resolution

C.1 is source-resolved.

Canonical evidence:
`../evidence/C1_SECURE_ACTION_SOURCE_REVIEW_2026-10-01.md`

Canonical decision:
`../decisions/D-018_SECURE_ACTION_INTERFACE_CONTRACT.md`

## Confirmed

- secure action execution through `SecureActionButtonTemplate`;
- `"action"` attribute path for action slots;
- combat-lockdown protected mutation boundary;
- secure state/attribute driver option for required in-combat state changes;
- current Forever `C_ActionBar` presentation APIs;
- native action-button registration;
- secret-safe DurationObject cooldown route;
- direct secret-safe display-count forwarding;
- session-only override binding strategy;
- no-combat action pickup/edit boundary;
- stock action bars remain until replacement proof.

## C.2 handoff

Next:
**C.2 — Primary Action Cluster**

First runtime target:
- 12 named secure buttons;
- compact rectangular/square cluster;
- existing primary action bindings routed to matching Logres buttons;
- icon/cooldown/count/usability/range presentation;
- stock Blizzard action bars still visible;
- developer-panel diagnostic for action cluster readiness.

C.2 must prove both:
- mouse click action execution;
- keyboard binding execution.

Combat validation must confirm:
- actions continue working;
- no forbidden protected mutation occurs;
- binding/layout updates requested in combat are deferred rather than executed insecurely.
