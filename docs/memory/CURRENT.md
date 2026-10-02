---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.4 — Additive NPC quest detail presentation.**

P0082 is verified pushed at `c6395f10`.

F.3 is closed:
**runtime + integration + visual PASS.**

P0083 prepares the first NPC quest presentation slice.

Production runtime target:
`0.0.32-dev`.

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete.
- F.3 proof includes:
  - real positive XP delta `124`;
  - progress `89.1%`;
  - production pulse count `1`;
  - auto-hide;
  - Immersion OFF/ON policy behavior;
  - repeated integrated Run All PASS;
  - user visual PASS.
- TargetFrame restoration historical failures remain tracked:
  **OPEN — INTERMITTENT / UNREPRODUCED under repeated P0081 targeting.**
- F.2 proved passive NPC quest-detail reads on Forever for quest `436`:
  - quest ID;
  - title;
  - quest text;
  - objective text;
  - `QUEST_DETAIL`;
  - `QUEST_ACCEPTED`.
- Populated active objective rows remain unproven.
- Quest IDs `436` and `237` have not produced a usable destination.
- Quest compass marker remains unsupported.

## Next Action

Apply/push P0083.

Then deploy `0.0.32-dev` and validate F.4 through the developer panel:

1. Quest Dialogue Check;
2. Quest Dialogue Preview;
3. open one ordinary NPC quest detail page;
4. verify the real Logres quest presentation;
5. accept or close through Blizzard controls and verify Logres clears;
6. Immersion OFF -> Quest Dialogue Preview is suppressed;
7. Immersion ON -> Quest Dialogue Preview displays;
8. Run All;
9. no Lua/taint/secret errors;
10. stock quest controls/UI remain usable and unchanged.

Persist with `/reload` and export diagnostics.

## Success Criteria

F.4 succeeds when:
- production presentation starts only from passive `QUEST_DETAIL`;
- quest values are secret-checked before inspection/string handling;
- the additive title/body/objective presentation is readable and temporary;
- cleanup occurs on accepted/finished/world/timeout/Immersion OFF;
- no Blizzard quest-control surface is hidden or mutated;
- Quest Dialogue Check and Run All pass;
- no Lua/taint/secret errors occur;
- user visually accepts the presentation.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **F.3 contextual XP:** complete / visual PASS.
- **TargetFrame restoration issue:** tracked intermittent/unreproduced.
- **Populated objective rows:** unproven.
- **Quest IDs 436/237 destination output:** negative tested evidence.
- **Quest compass marker:** unsupported until a usable destination is proven.
- **Quest interaction controls:** Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/F3_CONTEXTUAL_XP_VISUAL_PASS_2026-10-02.md`
- `docs/memory/evidence/P0083_DELIVERY_FAILURE_2026-10-02.md`
- `docs/memory/investigations/F3_CONTEXTUAL_XP_PULSE.md`
- `docs/memory/investigations/F4_NPC_QUEST_DETAIL_PRESENTATION.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
