# P0007 — A.1 state consumer contract

Date: 2026-09-30  
Result: PREPARED — runtime proof pending

## Intent

Harden the Core State Engine boundary before any later Logres module depends on it.

## Code changes

### Private authority

Removes public exposure of the authoritative mutable state table.

### Consumer reads

Adds:

```lua
Logres:GetState()
```

which returns a fresh scalar snapshot.

### Consumer subscriptions

Adds:

```lua
Logres:SubscribeState(handler)
```

which:
- subscribes to real state transitions;
- returns an unsubscribe function;
- supplies fresh payload copies to each subscriber.

### Transition contract

Callback:

```text
handler(current, previous, changes, reason)
```

Revision:
- initial transition -> 1;
- +1 per actual canonical transition;
- unchanged for no-op refresh.

### Development validation

Adds:

```text
/logres statecheck
```

which verifies without travel:
- snapshot isolation;
- no-op revision stability;
- no callback on a no-op observation.

### Static validation

Adds:

`tools/check_state_contract.py`

which rejects direct `Logres.State` consumer access and checks the contract entry points.

## Decision

Adds D-009 as the durable state consumer contract.

## No new sensors

A.1 deliberately does not add:
- mounted;
- resting;
- interaction;
- taxi/travel;
- immersion preference.

Those remain A.2/A.3 work.

## Failures

No runtime result is claimed yet.

Static checks must pass before commit. Runtime proof occurs after deploy with `/logres statecheck`.

## Validation

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
git diff --check
```
