# G.2 — World/Combat Camera Zoom Capability

Status: CLOSED — RUNTIME + INTEGRATION PASS
Opened: 2026-10-02
Closed: 2026-10-02

Profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

Source audit:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`

P0095 failure evidence:
`../evidence/G2_P0095_COMBAT_CLASSIFICATION_FAIL_2026-10-02.md`

P0096 runtime PASS evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`

## Correct target behavior

World:
- if current zoom > 5, target 5;
- otherwise leave the closer zoom alone;
- ordinary transition 2.5 seconds.

World (Combat):
- if current zoom < 15, target 15;
- otherwise leave the farther zoom alone;
- ordinary transition 2.5 seconds.

Zoom restore:
`never`.

## Combat predicate correction

DynamicCam situation 006 explicitly uses:

`return not IsInInstance() and UnitAffectingCombat("player")`

P0095 did not measure that predicate. It recorded cached
`Logres:GetState().combat`, whose value is tied to event-refreshed lockdown
observation.

I-001 already established that lockdown timing can lag early combat events.
P0095 therefore proved camera movement out of combat but did not prove the live
DynamicCam combat context.

P0096 corrected only the diagnostic classifier and retained the other signals
independently:
- `combat`: live UnitAffectingCombat;
- `lockdown`: live InCombatLockdown;
- `cachedCombat`: existing Logres state;
- `mismatch`: live combat versus cached combat.

Core state behavior was not changed.

## P0096 runtime result

Current runtime:
`0.0.40-dev`.

Two captured live-combat probes both reported:
- `combat=true`;
- `lockdown=true`;
- `cachedCombat=false`;
- `mismatch=true`;
- `targetReached=true`;
- `moved=true`;
- `restored=true`;
- `secret=false`;
- `error=nil`.

The out-of-combat path remained clean.
A post-combat probe returned to `combat=false` with restoration PASS.

Run All was then performed on the current `0.0.40-dev` runtime and every
emitted check passed through `checkall: complete`.

## Classification

Primary camera path out of combat:
**PASS.**

Primary camera path in live DynamicCam-equivalent combat:
**PASS.**

Integration on current runtime:
**PASS.**

G.2:
**CLOSED — RUNTIME + INTEGRATION PASS.**

The `cachedCombat=false` / `mismatch=true` observation is retained as positive
evidence for the signal distinction. Production camera selection must use the
profile's live combat predicate rather than cached Logres combat state.

## Production consequence

G.3 may now implement automatic World/Combat camera ownership using the proven
signals and primary movement path.

G.3 must not:
- redefine core State.combat because of this mismatch;
- adopt the unproven temporary-CVar camera fallback;
- invent zoom restoration contrary to the captured `never` policy;
- permit simultaneous DynamicCam and Logres camera movement ownership.
