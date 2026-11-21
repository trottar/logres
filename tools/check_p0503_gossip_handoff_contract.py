#!/usr/bin/env python3
"""P0503: bounded native gossip option -> service handoff, scope and restore rules."""
from pathlib import Path
import re
import shutil
import subprocess

root = Path(__file__).resolve().parents[1]
read = lambda name: (root / name).read_text(encoding="utf-8")
live = read("Logres/Quest/NPCGossipPresentation.lua")
choice = read("Logres/Quest/NPCGossipChoice.lua")
quest = read("Logres/Quest/NPCGossipQuestChoice.lua")
parking = read("Logres/Quest/NPCGossipStockParking.lua")
dialogue = read("Logres/Quest/Dialogue.lua")
ledger = read("docs/memory/investigations/ISSUE_LEDGER.md")
evidence = read("docs/memory/evidence/P0503_NPC_INTERACTION_HANDOFF_AUDIT.md")
toc = read("Logres/Logres.toc")
boot = read("Logres/Core/Bootstrap.lua")

for token in (
    "function Live.BeforeNativeChoice(kind)",
    '(kind == "gossip-option" or kind == "quest-link") and active',
    "Logres.NPCGossipStockParking.IsParked()",
    "d:ScheduleGossipOptionHandoff(ticket)",
    'Logres.NPCGossipStockParking.RequestExit("native-choice-handoff")',
    "return restored, nil",
    "function Live.OnNativeChoice(ticket)",
    "if ticket ~= choiceTicket then return true",
    "function Live.OnNativeChoiceFailed(ticket)",
    "function Live.OnChoiceHandoffTimeout(ticket)",
    "function Live.CancelChoiceHandoff(reason)",
    'Logres:RegisterEvent("GOSSIP_CLOSED"',
    'choiceOutcome = "gossip-closed-awaiting-branch"',
    'choiceOutcome = "native-service-opened"',
    "ordinary(kind)",
    'if replacing and not shown then hide("next-gossip-stock-fallback") end',
    'hide("native-choice-handoff-timeout")',
    'choiceHandoffPending = choiceTicket ~= nil',
):
    assert token in live, f"missing bounded gossip-handoff guard: {token}"
for token in (
    'BeforeNativeChoice("gossip-option")',
    "pcall(fn, chosen.gossipOptionID)",
    "Logres.NPCGossipPresentation.OnNativeChoiceFailed(ticket)",
    "Logres.NPCGossipPresentation.OnNativeChoice(ticket)",
    "a.gossipOptionID ~= b.gossipOptionID",
):
    assert token in choice, f"missing verified native click/rollback: {token}"
assert choice.index('BeforeNativeChoice("gossip-option")') < choice.index('pcall(fn, chosen.gossipOptionID)')
assert 'BeforeNativeChoice("quest-link")' in quest and 'pcall(fn, chosen.questID)' in quest
assert quest.index('BeforeNativeChoice("quest-link")') < quest.index('pcall(fn, chosen.questID)')
assert 'Greeting.Restore("native-quest-selected")' in quest  # QuestFrame greeting unchanged
assert 'Logres.NPCGossipPresentation.OnNativeChoiceFailed(ticket)' in quest
assert 'function Dialogue:ScheduleGossipOptionHandoff(ticket)' in dialogue
assert 'return pcall(C_Timer.After, 0.8, function()' in dialogue
assert 'not ordinaryProgress(C_Timer.After)' in dialogue
assert 'Logres.NPCGossipPresentation.CancelChoiceHandoff(reason or "dialogue-hidden")' in dialogue
assert dialogue.index('CancelChoiceHandoff(reason or "dialogue-hidden")') < dialogue.index('Logres.NPCGossipStockParking.RequestExit(', dialogue.index('function Dialogue:HidePresentation(reason)'))
for forbidden in ('SetScript("OnUpdate"', 'HideUIPanel(', 'GetMouseFocus(', 'GetMouseFoci(', 'SetAlpha(', 'EnableMouse(', 'SetParent('):
    assert forbidden not in live and forbidden not in choice, f"gossip presentation/action writes native UI or polls: {forbidden}"
assert 'C_Timer.' not in live and 'C_Timer.' not in choice and 'C_Timer.' not in parking
assert 'UIParent, "BOTTOMLEFT", -64, -64' in parking
assert 'retry:RegisterEvent("PLAYER_REGEN_ENABLED")' in parking
assert 'L-001' in ledger and 'P0503' in ledger
assert 'P0502' in evidence and 'L-002' in evidence and 'GossipFrame' in evidence
assert 'client UNVERIFIED' in evidence
v1 = re.search(r'^Logres.VERSION = "([^"\n]+)"$', boot, re.M)
v2 = re.search(r'^## Version: (\S+)$', toc, re.M)
assert v1 and v2 and v1.group(1) == v2.group(1), "runtime version parity"
engine = shutil.which("lua5.4") or shutil.which("texlua") or shutil.which("lua")
assert engine, "P0503 Lua behavioral fixture requires an interpreter; refuse release if missing"
subprocess.run([engine, str(root / "tools/test_p0503_gossip_handoff.lua"), str(root)], cwd=root, check=True)
print("P0503 bounded gossip -> service selection, fallback, quest preservation, and actual-source Lua fixture STATIC PASS; client UNVERIFIED")
