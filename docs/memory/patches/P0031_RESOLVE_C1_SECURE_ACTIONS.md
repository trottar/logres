# P0031 — Resolve C.1 secure actions

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Trigger

P0030 was pushed at `74ccfc3`.

Phase C entered C.1 source review.

## Result

C.1 source review is complete.

Adds:
- C.1 source evidence;
- D-018 secure action interface contract;
- expanded action-cluster architecture;
- C.2 implementation scope.

## Key decisions

- protected actions use SecureActionButtonTemplate;
- C.2 starts with 12 primary secure buttons;
- existing primary bindings are preserved with session override clicks;
- saved bindings are not rewritten;
- protected mutation is out-of-combat unless handled by a verified secure driver;
- cooldown/count use secret-safe native consumer paths;
- stock Blizzard action bars remain visible during C.2 proof;
- drag/drop editing is deferred.

## Code changes

None.

## Deployment

No redeploy required.
