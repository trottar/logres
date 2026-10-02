# F.4 P0083 Quest Dialogue Runtime + Target Restore Root Cause — 2026-10-02

Status: QUEST DIALOGUE RUNTIME PASS / INTEGRATED TARGET RESTORATION FAIL
Date: 2026-10-02
P0083 commit: `484323bb19e589d4987bbc25d703c856d6cfbf6b`

## Runtime

Forever:
- client `1.60.1`;
- build `70170`;
- interface `16001`.

Logres:
- runtime `0.0.32-dev`;
- loadCount `65`.

## Quest dialogue

Preview:
PASS.

Real detail check:
- PASS;
- `detailEvents=1`;
- `presentations=1`;
- `questID=436`;
- body present;
- objective present;
- secret false;
- no error.

Later:
- `detailEvents=3`;
- `accepted=2`;
- `finished=6`;
- `presentations=3`;
- presentation hidden;
- reason `QUEST_ACCEPTED`;
- no error.

Immersion OFF Preview:
PASS / suppressed.

Immersion ON Preview:
PASS / shown.

## Integrated Run All

Quest Dialogue Check:
PASS.

Restoration Check:
FAIL.

Exact error:
`SetIgnoreParentAlpha` rejected the captured secret-capable restoration token
because secret values are only allowed during untainted execution for that
argument.

Final cleanup reconverged.

## Conclusion

F.4 QuestDialogue runtime is proven for the tested path.

Integrated closure is blocked by the root-caused TargetFrame restoration
mechanism addressed in P0084.

F.4 visual acceptance remains unrecorded.
