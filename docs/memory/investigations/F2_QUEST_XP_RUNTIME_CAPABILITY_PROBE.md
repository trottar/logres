# F.2 — Quest / XP Runtime Capability Probe

Status: ACTIVE — CAPABILITY EVIDENCE CAPTURED; BLOCKED BY RESTORATION FAILURE
Opened: 2026-10-02

Canonical contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Runtime evidence:
`../evidence/F2_P0078_QUEST_XP_RUNTIME_EVIDENCE_2026-10-02.md`

Probe:
`../../../tools/probes/LogresQuestAudit`

## Proven

- XP/current/max/rested values were normal non-secret scalars in tested world
  state.
- `PLAYER_XP_UPDATE` registered and fired.
- `UPDATE_EXHAUSTION` registered and fired.
- Quest detail passive reads worked for quest `436`.
- `QUEST_DETAIL` and `QUEST_ACCEPTED` fired.
- super-tracked quest identity worked.

## Negative / deferred

- quest `436` again produced no usable next waypoint or player-map waypoint;
- quest compass marker remains unsupported;
- completed quest `436` returned an empty objectives table, so populated
  objective rows remain unproven;
- progress/complete/turn-in/watch-update events were not naturally observed.

## Capability conclusions

Contextual XP source/event path:
**PROVEN.**

Quest-giver passive detail reads:
**PROVEN for tested detail flow.**

Populated objective rows:
**UNPROVEN.**

Quest destination / quest compass marker:
**UNAVAILABLE in tested quest 436; DEFERRED.**

## Blocking runtime failure

The final P0078 Run All produced a real Restoration Check failure at:
**opposite preference state did not settle**.

Cleanup succeeded and final state reconverged.

The existing diagnostic did not persist enough intermediate detail to identify
the failing replacement domain.

P0079 adds diagnostic detail only.

## Exit

Do not advance to the contextual XP production slice until the P0079 targeted
restoration diagnostic is run.

If restoration passes without recurrence, preserve the P0078 failure as
intermittent/unreproduced and decide whether it remains blocking based on the
new evidence.

If it fails, investigate the identified subdomain before advancing.
