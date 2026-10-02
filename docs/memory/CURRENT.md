---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.2 — Quest / XP runtime capability probe, blocked by restoration failure diagnosis.**

P0078 is verified pushed at `8b38fe64`.

Production runtime remains:
`0.0.30-dev`.

## Verified State

- Phase E is complete.
- F.1 is complete under D-031.
- P0078 F.2 runtime evidence proves:
  - current/max/rested XP are usable normal scalars in the tested world state;
  - `PLAYER_XP_UPDATE` fired;
  - `UPDATE_EXHAUSTION` fired;
  - quest-detail passive reads worked for quest `436`;
  - `QUEST_DETAIL` and `QUEST_ACCEPTED` fired;
  - super-tracked quest identity worked.
- Contextual XP source/event capability is proven.
- Quest-giver passive detail reads are proven for the tested detail flow.
- Populated objective rows remain unproven:
  completed quest `436` returned an empty objective table.
- Quest compass destination remains unsupported:
  quest `436` again returned no usable `GetNextWaypoint` or
  `GetNextWaypointForMap` destination.
- `Run All` produced a real Restoration Check failure:
  `opposite preference state did not settle`.
- Cleanup succeeded and final restoration state reconverged (`finalOK=true`).
- Existing Restoration Check output did not identify the failing intermediate
  subdomain.
- P0079 adds diagnostic detail only; it does not change suppression behavior.

## Next Action

Apply/push P0079 and redeploy Logres.

In the developer panel:
1. run **Restoration Check** once;
2. run **Run All** once;
3. `/reload`;
4. export `LOGRES_DIAGNOSTICS_LATEST.lua`.

If the restoration failure recurs, use the new persisted breakdown to identify
the failing subdomain.

If it does not recur, preserve P0078 as an intermittent/unreproduced runtime
failure; do not invent a behavioral fix.

## Success Criteria

P0079 succeeds when:
- Restoration Check behavior is unchanged;
- failure output identifies readiness/desired/recovery/ownership/error category;
- action/Quiet/Player/Target recovery ownership is persisted on failure;
- no timer, polling, broad hook, or periodic reassertion is introduced;
- Restoration Check and Run All provide enough evidence to classify the P0078
  failure;
- no Lua/taint/secret-value errors occur.

F.2 production advancement remains blocked until that targeted evidence is
reviewed.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **Minimap:** Blizzard-owned / stock by D-030.
- **F.1:** complete / D-031 accepted.
- **Contextual XP capability:** source/event path runtime-proven.
- **Quest detail reads:** proven for tested detail flow.
- **Quest IDs 436/237 destination output:** negative tested evidence.
- **Quest compass marker:** unsupported until a usable destination is proven.
- **P0078 restoration failure:** real; final cleanup recovered; subdomain
  unresolved.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/F2_P0078_QUEST_XP_RUNTIME_EVIDENCE_2026-10-02.md`
- `docs/memory/evidence/P0078_RESTORATION_SETTLE_FAILURE_2026-10-02.md`
- `docs/memory/investigations/F2_QUEST_XP_RUNTIME_CAPABILITY_PROBE.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
