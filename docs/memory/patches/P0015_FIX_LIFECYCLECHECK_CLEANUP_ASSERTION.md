# P0015 — Fix lifecyclecheck cleanup assertion

Date: 2026-09-30  
Result: PREPARED — runtime proof pending

## Trigger

P0014 `/logres lifecyclecheck` reported FAIL with:

```text
beforeInit=true
beforeEnabled=false
initializedAgain=false
enabled=true/false
disabled=true/false
init=1->1
enable=0->1
disable=0->1
cleanup=0->1
prefEnabled=2
prefDisabled=0
afterEnabled=false
afterCleanup=0
```

## Diagnosis

The lifecycle behavior is correct.

The diagnostic assertion was wrong.

It expected:

```lua
cleanupCount == cleanupBefore + 2
```

but only one owned cleanup increments that explicit counter.

The preference unsubscribe is independently proven by:
- `prefDisabled=0`;
- `afterCleanup=0`.

## Fix

Change:

```lua
cleanupBefore + 2
```

to:

```lua
cleanupBefore + 1
```

No lifecycle-manager behavior changes.

## Version

Bump:
`0.0.5-dev -> 0.0.6-dev`

This makes deployment verification explicit.

## Runtime proof

After commit/push, deploy and verify:

```text
/logres status
```

shows `0.0.6-dev`, then:

```text
/logres lifecyclecheck
```

must report PASS.

## Classification

Diagnostic false negative, not product lifecycle failure.
