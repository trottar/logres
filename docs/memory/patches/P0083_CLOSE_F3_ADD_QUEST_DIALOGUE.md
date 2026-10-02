# P0083 — Close F.3 / Add NPC Quest Detail Presentation

Date: 2026-10-02
Result: PREPARED — RUNTIME + VISUAL PROOF PENDING

## Baseline

P0082 verified pushed:
`c6395f102a735f7589e67dfffbc17816e503b91d`

## F.3 close

User reported:
**visual passed**.

Combined with prior runtime/integration evidence, F.3 contextual XP is closed:
**RUNTIME + INTEGRATION + VISUAL PASS.**

## F.4 implementation

Adds:
`Logres/Quest/Dialogue.lua`.

Production trigger:
`QUEST_DETAIL`.

Presentation:
- quest title;
- restrained body excerpt;
- optional objective;
- centered upper-world text;
- approximately ten seconds;
- no mouse input.

Cleanup:
- `QUEST_ACCEPTED`;
- `QUEST_FINISHED`;
- `PLAYER_ENTERING_WORLD`;
- timeout;
- Immersion OFF.

## Diagnostics

Adds:
- Quest Dialogue Check;
- Quest Dialogue Preview.

Run All includes Quest Dialogue Check.

## Safety / ownership

No Blizzard quest frame/control mutation.

No:
- accept/decline;
- completion;
- reward choice;
- watch/super-track mutation;
- objective tracker suppression;
- minimap mutation.

## Runtime

`0.0.31-dev -> 0.0.32-dev`.

WoW redeploy required after push verification.

## Delivery repair

The first apply attempt failed after the intentional `0.0.32-dev` bump because
the older F.3 XP checker permanently required `0.0.31-dev`.

Repair:
- make the XP checker validate Bootstrap/TOC version synchronization instead of
  historical version identity;
- apply the same rule to the F.4 dialogue checker to prevent the next runtime
  bump from repeating the defect;
- rerun the complete P0083 checker set;
- create the final manifest only after all checks pass.

Evidence:
`../evidence/P0083_DELIVERY_FAILURE_2026-10-02.md`.
