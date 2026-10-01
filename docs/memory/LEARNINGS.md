# Project Learnings

Reusable lessons belong here when they generalize beyond one immediate patch or investigation.

## L-001 — Preserve negative results

A failed implementation is valuable if it rules out a path, exposes an API boundary, identifies a visual failure, or falsifies an assumption.

Future work must be able to distinguish:
- never tried;
- tried and failed;
- tried and deferred;
- superseded;
- successful only under limited conditions.

Therefore negative results are retained in canonical records rather than omitted from history.

## L-002 — Design intent and API feasibility are different authorities

A design decision states what Logres wants the experience to be. An API investigation states what WoW Forever permits. Neither silently overwrites the other.

When they conflict:
1. preserve the intended experience;
2. record the technical restriction;
3. investigate approximations;
4. make an explicit superseding decision if compromise is required.

## L-003 — Do not let conventional MMO UI defaults erase intentional uncertainty

A conventional implementation may reveal level, elite status, exact HP, cast timing, or other metadata simply because the API provides it.

In Logres, availability is not sufficient justification for display. The disclosure policy must be deliberate.

## L-004 — Assume Lua 5.1-era compatibility unless runtime proves otherwise

The first runtime probe failed because `table.pack` was unavailable.

For Logres and its tooling, prefer compatibility helpers for standard-library features that are not guaranteed in WoW's Lua environment. A tool that fails before measuring the game API is a probe failure, not an API result.

## L-005 — Secret does not mean undisplayable

On Forever 1.60.1, player health/power percentages were secret even in ordinary open-world, out-of-combat snapshots.

Nevertheless:
- secret percentage -> `string.format` -> secret string -> `FontString:SetText` worked;
- secret normalized health -> `StatusBar:SetValue` worked;
- secret normalized health -> `Texture:SetAlpha` worked;
- the same display path continued to work during combat lockdown.

Therefore the correct architecture is to move secret values through permitted native transformations/display aspects, not to attempt to recover ordinary numbers.

## L-006 — Combat events and settled combat state are not identical moments

In the first runtime pass, `PLAYER_REGEN_DISABLED` fired before `InCombatLockdown()` had become true. Restriction state then changed through intermediate observations before later snapshots showed active lockdown.

State-engine code must read current state and tolerate event ordering rather than assuming a single event means all related restrictions have already settled.

## L-007 — Runtime validation must explicitly redeploy the current code patch

P0012 initially appeared to reject its new slash commands because the repository patch had been committed but the installed WoW addon had not been redeployed.

The game was correctly running an older deployed build.

This is a workflow failure mode, not an addon API/runtime failure.

For every patch that changes addon runtime code, validation instructions must explicitly include:
1. repository checks;
2. commit/push checkpoint;
3. `tools/deploy_logres.sh` invocation;
4. `/reload`;
5. in-game validation commands.

Do not rely on "deploy as usual" or assume deployment is implied by a prior patch.

## L-008 — Lifecycle diagnostics must distinguish cleanup-stack size from instrumented cleanup counters

P0014's lifecycle probe owned two cleanup callbacks but only one incremented the explicit `cleanupCount` test counter.

The diagnostic incorrectly expected the counter to increase by two, even though:
- the cleanup stack was emptied;
- the preference unsubscribe function worked;
- the explicit counted cleanup ran once.

When a test mixes functional cleanup assertions with instrumented counters, each assertion must match exactly what is instrumented.

For module cleanup, prefer multiple independent proofs:
- explicit counted cleanup ran;
- owned cleanup stack became empty;
- subscription no longer receives callbacks.

## L-009 — A secret-safe transport proof is not a visual usability proof

P0018 used the technically proven `UnitHealthPercent(..., curve) -> Texture:SetAlpha(secret)` path, but its first production vignette was not perceptible during ordinary injury.

The initial alpha/color choices were too conservative to satisfy the product behavior even if the transport was functioning.

For future secret-safe presentation:
- separate transport correctness from visual salience;
- include a non-secret preview/test presentation when it helps isolate geometry from secret input;
- do not force dangerous gameplay states merely to verify whether UI geometry exists.
## L-010 — Shared diagnostic routing must test both GUI and fallback sinks

P0029 refactored slash-command diagnostics so the new developer panel could
capture output through a shared `emit()` function.

The GUI path worked because it installed an output sink.

However, the no-sink fallback had accidentally become:

```lua
emit(message)
```

inside `emit()` itself instead of:

```lua
print(message)
```

That creates unbounded recursion for ordinary slash-command output.

B.6 did not reveal the defect because validation used the new GUI path.

The defect was found by source inspection while preparing C.2.

Reusable rule:
when one diagnostic implementation supports multiple output transports, test
or statically assert every transport independently.

For Logres:
- panel output sink must work;
- ordinary slash/chat fallback must work;
- static tooling should reject recursive fallback wiring.
## L-011 — Protected control replacement must fail open

P0032 automatically redirected the user's primary action keys to Logres before
the new secure buttons had been runtime-proven.

When secure execution failed, the user's normal keys also stopped working.

Rule:
new protected-control replacements must not seize a critical existing input
path before the replacement has runtime proof and an immediate restoration
path.

For Phase C:
- stock controls remain available;
- temporary key takeover is opt-in during proof;
- release/restoration controls must be accessible;
- automatic routing can be considered only after execution is proven.

This is the input-control analogue of D-017's UI suppression capability gate.

## L-012 — Feedback must survive its parent presentation policy

P0040 added activation feedback in code, but the user saw no perceptible
difference on the correct deployed version.

Critical feedback must be visually independent from the contextual fade policy
it is meant to confirm. A cue can exist in code and still be unusable if its
resting alpha, inherited alpha, or layering prevents perception.

Provide a diagnostic that can trigger the visual mechanism without depending
on secure action execution, so rendering and click-path failures can be
distinguished.

## L-013 — Secret-safe transport does not make diagnostic inspection safe

A protected/secret-capable value may be usable as an opaque token passed back
to a native UI API while still being illegal to inspect in Lua.

P0056 captured TargetFrame parent-alpha state successfully, but Target Frame
Check later did:

```lua
if region:IsIgnoringParentAlpha() then
```

and failed with a secret boolean error.

Rule:
- capture only when restoration requires it;
- store the value opaquely;
- pass it directly back to the matching native setter;
- never branch, compare, stringify, count, or otherwise inspect it;
- diagnostics should use addon-owned mutation state and visual/runtime proof
  instead of protected readback.
