# D.4 P0057 Target Runtime Proof — 2026-10-01

Status: VERIFIED WITH INTERMITTENT FOLLOW-UP
Baseline: `fc848b9b01199ee57b38d5805cf0e2be601a2b52`

## Result

P0057 was pushed before runtime testing.

The user then tested through the developer panel and reported:
- Target Frame Check PASS;
- Immersion Check PASS;
- Run All PASS;
- target selective replacement behavior looked good.

The P0056 secret-boolean diagnostic failure is therefore fixed in P0057.

## Accepted target behavior

For the tested workflow:
- selective stock TargetFrame suppression works;
- Logres target presentation remains;
- secure Logres target interaction works;
- Target diagnostics are secret-safe;
- Immersion ON/OFF integration works;
- no new Lua/secret/taint regression was reported.

## Preserved aura/status behavior

Target buffs/status remain visible.

This is intentional under D-027 because Blizzard target auras are currently a
preserved context surface.

Player buffs/status also remain visible because PlayerFrame selective
replacement never claimed ownership of the global aura/status domain.

This is not a D.4 failure.

A future aura/status presentation domain should define:
- information priority;
- contextual visibility;
- player vs target behavior;
- world/instance/PvP policy;
- stock aura suppression only after replacement capability exists.

## Intermittent TargetFrame reappearance

The user observed one unreproduced incident where stock TargetFrame visuals
returned while immersion was active.

A `/reload` restored expected suppression.

The issue could not be reproduced.

Classification:
**OPEN / INTERMITTENT / UNREPRODUCED**

Do not add periodic forcing or broad hooks without evidence.

If it recurs, capture:
- what happened immediately before;
- current context/combat/PvP state;
- Target Frame Check result before reload;
- whether Logres still reports replacement applied;
- whether Immersion OFF/ON reasserts suppression without reload.

Working hypothesis only:
a Blizzard TargetFrame update path may have reasserted presentation after
Logres applied suppression.

This hypothesis is not established.

## Conclusion

**D.4 Target selective replacement — PASS for the tested workflow.**

The intermittent reappearance remains a non-blocking tracked defect.

D.4 may close with Party suppression explicitly deferred by capability gate.
