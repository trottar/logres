# F.1 — Quest Experience Source / Capability Review

Status: CLOSED — D-031 ACCEPTED
Opened: 2026-10-02
Closed: 2026-10-02

Canonical decision:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Evidence:
`../evidence/F1_QUEST_EXPERIENCE_SOURCE_REVIEW_2026-10-02.md`

## Result

Source/API review establishes viable passive observation candidates for:
- quest identity/objectives;
- quest-giver interaction text;
- selected/super-tracked quest state;
- XP/rested XP;
- quest destination APIs that may return nothing.

No source finding authorizes replacing Blizzard quest interaction controls.

First production candidate:
**contextual XP pulse**, runtime-gated by F.2.

Quest compass integration remains conditional on F.2 proving a usable real
quest destination.

## Next

F.2 — passive quest/XP runtime capability probe.
