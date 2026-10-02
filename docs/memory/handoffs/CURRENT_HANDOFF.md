# Current Handoff

Authoritative state: `../CURRENT.md`.

P0080 is verified pushed at `cde9b726`.

Phase F / F.3 remains active.

P0080 XP result:
- XP Check PASS;
- real XP event `delta=124`;
- progress `89.1%`;
- production pulse count `1`;
- Immersion OFF preview suppression PASS;
- Immersion ON preview recovery PASS.

Integrated blocker:
Run All reproduced the restoration failure.

P0079 detail now identifies the failing domain as TargetFrame restoration:
requested=false while applied/snapshot/watch/mouse/presentation suppression
remained active.

The exact TargetFrame error string was not included in the P0079 summary.

P0081 adds that error/reason/result detail only.

No behavior workaround.

Production runtime remains:
`0.0.31-dev`.

User performs all commits/pushes.
