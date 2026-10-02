# F.2 — Quest / XP Runtime Capability Probe

Status: CLOSED — CAPABILITY MATRIX RESOLVED
Opened: 2026-10-02
Closed: 2026-10-02

Canonical contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Runtime evidence:
`../evidence/F2_P0078_QUEST_XP_RUNTIME_EVIDENCE_2026-10-02.md`

Targeted restoration follow-up:
`../evidence/P0079_RESTORATION_TARGETED_PASS_2026-10-02.md`

## Proven

- current/max/rested XP normal scalar access;
- `PLAYER_XP_UPDATE`;
- `UPDATE_EXHAUSTION`;
- quest-detail passive reads for quest `436`;
- `QUEST_DETAIL`;
- `QUEST_ACCEPTED`;
- super-tracked quest identity.

Contextual XP source/event path:
**PROVEN.**

Quest-giver passive detail reads:
**PROVEN for tested detail flow.**

## Negative / deferred

- quest `436` again produced no usable next waypoint or player-map waypoint;
- quest compass marker remains unsupported;
- completed quest `436` returned an empty objective table, so populated active
  objective rows remain unproven;
- progress/complete/turn-in/watch-update events were not naturally observed.

These are retained as explicit negative evidence or environmental deferrals.

## Integrated validation follow-up

P0078 Run All produced a real one-off Restoration Check failure:
`opposite preference state did not settle`.

Cleanup succeeded and final state reconverged.

P0079 then ran:
- standalone Restoration Check -> PASS;
- Run All -> PASS, including Restoration Check.

The failure did not reproduce, so no subdomain-specific diagnostic line was
generated.

Classification:
**OPEN — INTERMITTENT / UNREPRODUCED under targeted P0079 validation.**

No behavioral fix is justified.

## Exit

F.2 exit criteria are satisfied:
- contextual XP production input is authorized;
- populated objective rows are deferred;
- quest compass destination integration is deferred;
- unobserved lifecycle events are recorded as environmental deferrals;
- the unrelated restoration failure is preserved rather than erased.

Next:
**F.3 — Contextual XP pulse.**
