# P0090 Workflow Realignment — 2026-10-02

Status: RECORDED; FOLDED INTO P0090
Date: 2026-10-02

## What happened

After the user pushed the P0089 memory/runtime state, the assistant failed to
verify the new remote `main` before continuing an obsolete local recovery path.

This produced unnecessary P0090 recovery artifacts and repeated state
classification attempts even though the repository had already advanced.

The assistant also:
- combined apply and Git handoff after the user had asked for separate blocks;
- gave a shell guard using `exit 1`, which exited the interactive terminal;
- continued diagnosing local partial-state artifacts instead of first checking
  the pushed remote checkpoint.

## Authoritative correction

Remote `main` was then verified:
- `ee298f58` synchronized memory after P0088;
- `1781c038` pushed the intended `0.0.35-dev` runtime placement correction.

Repository authority therefore superseded the obsolete recovery path.

No standalone workflow-repair checkpoint is created.

This evidence is folded into the next coherent P0090 product checkpoint in
accordance with L-015.

## Durable procedure

After the user says `pushed`:
1. verify remote `main` immediately;
2. treat verified remote state as authoritative;
3. reread CURRENT and task-linked memory from that checkpoint;
4. do not continue a pre-push recovery theory after the repository has moved;
5. keep apply and Git handoff as separate user command blocks;
6. never use `exit` in a command block intended for an interactive shell;
7. after any apply error, stop and diagnose before giving Git commands.
