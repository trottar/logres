# Current Handoff

Authoritative state: `../CURRENT.md`.

P0083 is verified pushed at `484323bb`.

Phase F / F.4 remains active.

P0083 QuestDialogue runtime:
- Preview PASS;
- real `QUEST_DETAIL` PASS;
- quest `436`;
- body/objective present;
- accept cleanup PASS;
- Immersion OFF suppression PASS;
- Immersion ON recovery PASS;
- Quest Dialogue Check PASS.

Visual acceptance remains pending.

Integrated Run All exposed the exact TargetFrame restore defect:
`SetIgnoreParentAlpha` rejected a secret-capable captured restoration token.

P0084:
- removes IgnoreParentAlpha mutation;
- leaves preserved contextual children untouched;
- alpha-suppresses only nine unwanted contextual children;
- restores opaque alpha tokens;
- adds no retry/polling/hook.

Runtime target:
`0.0.33-dev`.

User performs all commits/pushes.
