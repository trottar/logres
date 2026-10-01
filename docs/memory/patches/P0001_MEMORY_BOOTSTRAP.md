# P0001 — Memory bootstrap

Date: 2026-09-30  
Result: PREPARED — not durable until user commits/pushes

## Intent

Establish the repository-native memory architecture before addon code begins.

## Adds

- WSL-safe text/Git ignore policy;
- project roadmap;
- agent operating rules;
- authoritative current state;
- curated durable memory;
- learnings;
- maintenance policy;
- design principles;
- architecture records;
- accepted initial design decisions;
- active investigation index;
- queued Forever API audit;
- evidence directory;
- handoff;
- roadmap status;
- dated history;
- memory health checker.

## Negative-result policy

This bootstrap explicitly makes failures, rejected paths, regressions, unsupported APIs, and rollbacks durable project knowledge.

## Validation required

Before commit:
- `python3 tools/check_memory_health.py`
- `git diff --check`
- inspect `git status --short`
- review the diff scope.

## Result recording

After the user commits/pushes, update the next dated/patch record with the actual commit and verified repository state. Do not retroactively claim this PREPARED artifact was already installed.
