#!/usr/bin/env python3
"""P0403: a confirmed earlier offer cannot dismiss a newer owned quest stage."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/Dialogue.lua").read_text(encoding="utf-8")
accepted = source.split('if event == "QUEST_ACCEPTED" then', 1)[1].split(
    'if event == "QUEST_TURNED_IN" then', 1)[0]
guard = accepted.split("-- Accept can advance", 1)[1].split("self:ClearActiveDetail(", 1)[0]
for token in (
    "accepted ~= nil and accepted == self.pendingAcceptedOfferQuestID",
    "and self.presentationShown then",
    "if self.progressActive and self.progressOwned then",
    'activeQuestID, stage = self.lastQuestID, "progress"',
    "elseif self.completionActive and self.activeCompletion",
    "and self.completionControl and self.completionControl.applied then",
    'activeQuestID, stage = self.activeCompletion.questID, "completion"',
    "if activeQuestID and activeQuestID ~= accepted then",
    "self.pendingAcceptedOfferQuestID = nil",
    '"late-accepted-stage-preserved"',
):
    assert token in guard, token

assert accepted.index("ordinaryAcceptedEventQuestID(...)") < accepted.index(guard)
assert guard.index('"late-accepted-stage-preserved"') < guard.index("return")
assert accepted.rstrip().endswith('return\n            end')
assert '"QUEST_ACCEPTED"' in accepted.split("self:ClearActiveDetail(", 1)[1]
assert "P0403_QUEST_STAGE_HANDOFF.md" in (
    root / "docs/memory/investigations/ISSUE_LEDGER.md"
).read_text(encoding="utf-8")
print("P0403 late acceptance retains only a different owned quest stage: PASS (STATIC)")
