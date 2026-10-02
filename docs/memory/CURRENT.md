---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.2 — Quest / XP runtime capability probe.**

P0077 is verified pushed at `bf73fcf4`.

F.1 is complete under D-031.

Production runtime remains:
`0.0.30-dev`.

## Verified State

- Phase E is complete.
- F.1 source/capability review is complete under D-031.
- Forever-facing passive candidates exist for:
  - quest identity/title/objectives;
  - quest-giver detail/progress/reward text;
  - selected/super-tracked quest identity;
  - quest destination APIs that may return nothing;
  - current/max/rested XP;
  - quest/tracking/XP events.
- Blizzard remains owner of:
  - quest accept/decline;
  - continue/complete;
  - reward selection;
  - gossip navigation;
  - quest-log/watch controls;
  - stock objective-tracker interaction.
- No stock quest/objective/XP suppression is authorized.
- First production presentation candidate:
  **contextual XP pulse**, gated by F.2 runtime evidence.
- Quest compass extension remains conditional on runtime proof of a usable real
  quest destination.
- Prior negative evidence remains:
  super-tracked quest IDs `436` and `237` returned no usable next waypoint.
- P0078 adds the temporary passive `LogresQuestAudit` probe and exposes it
  through the existing developer panel as **Quest Probe**.
- Panel output auto-persists through the existing `LogresDiagnosticsDB`
  workflow.
- Initial P0078 apply failed only because this file omitted two required
  repository-memory headings; the runtime/probe design itself was not rejected.

## Next Action

Finish the repaired P0078 apply, commit/push it, then deploy Logres plus
`LogresQuestAudit`.

Run the F.2 scenarios only through the existing developer panel **Quest Probe**
action.

Do not use slash commands when the panel action is available.

## Success Criteria

F.2 evidence must distinguish:
- source absent vs present;
- call failure vs may-return-nothing;
- secret vs normal scalar data;
- no-objective vs unavailable objective data;
- quest destination absent vs usable;
- event registered vs observed firing.

The probe must remain passive:
- no quest interaction mutation;
- no watch/super-track mutation;
- no waypoint mutation;
- no stock UI suppression;
- no chat.

F.2 does not require contrived travel/gameplay for every event.

Unavailable environmental cases are recorded as deferrals, not PASS.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **Minimap:** Blizzard-owned / stock by D-030.
- **F.1:** complete / D-031 accepted.
- **Quest interaction controls:** Blizzard-owned.
- **Quest IDs 436/237 waypoint output:** negative tested evidence.
- **P0078 first apply memory-heading failure:** delivery failure, not runtime
  evidence against the F.2 probe.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/evidence/F1_QUEST_EXPERIENCE_SOURCE_REVIEW_2026-10-02.md`
- `docs/memory/evidence/P0078_DELIVERY_FAILURE_2026-10-02.md`
- `docs/memory/investigations/F2_QUEST_XP_RUNTIME_CAPABILITY_PROBE.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
