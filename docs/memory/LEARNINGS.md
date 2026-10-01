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
