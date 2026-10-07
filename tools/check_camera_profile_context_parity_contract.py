#!/usr/bin/env python3
"""Static contract for captured DynamicCam profile context parity."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTEXTS = ROOT / "Logres" / "Camera" / "ProfileContexts.lua"
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"
errors = []

for path in (CONTEXTS, CONTROLLER, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if CONTEXTS.is_file():
    source = CONTEXTS.read_text(encoding="utf-8")
    required = [
        'local SOURCE_COMMIT = "ae586a9c973c3f868c10440358d4a6e8c2fab5ff"',
        "local FISHING_SPELL_ID = 7620",
        "8690", "50977", "1273401", "2575", "8613", "2366",
        '"QuestFrame"', '"MerchantFrame"', '"FlightMapFrame"',
        "UnitCastingInfo", "UnitChannelInfo", "UnitIsAFK", "UnitExists",
        "issecretvalue", "snapshot.teleport = true",
        "snapshot.gathering = true", "snapshot.afk = readBoolean",
        "snapshot.interaction = readNPCInteraction",
        "snapshot.fishing = readFishing",
        "Logres.CameraProfileContexts = Contexts",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"ProfileContexts.lua missing: {fragment}")

    for fragment in (
        "SetCVar(", "C_CVar.SetCVar", "CameraZoomIn(", "CameraZoomOut(",
        "C_Timer.NewTicker", "C_Timer.NewTimer", "C_Timer.After",
    ):
        if fragment in source:
            errors.append(f"ProfileContexts.lua forbidden contract: {fragment}")

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        "local TELEPORT_TARGET = 20",
        "local INTERACTION_TARGET = 5",
        "local FISHING_TARGET = 50",
        "local GATHERING_TARGET = 5",
        "local TELEPORT_TRANSITION_DURATION = 5",
        "local FISHING_TRANSITION_DURATION = 2",
        "local GATHERING_TRANSITION_DURATION = 3",
        "local FISHING_EXIT_DELAY = 1",
        "Logres.CameraProfileContexts",
        'return "teleport", "teleport-cast", false',
        'return "afk", "afk", false',
        'return "gathering", "gathering-cast", false',
        'return "interaction", "npc-interaction", false',
        'return "fishing", "fishing-channel", false',
        "function Controller:ResolveContextDelay(context, reason)",
        '"fishing-exit-delay"',
        "self.fishingHoldUntil = GetTime() + FISHING_EXIT_DELAY",
        "self:SetAnimationActive(self.fishingHoldUntil ~= nil)",
        "contextAllowsEngineClamp(context)",
        "contextAllowsLimitedTarget(",
        "contextZoomDirection(context)",
        "transitionDurationForContext(",
        'Logres:RegisterEvent("PLAYER_FLAGS_CHANGED"',
        'Logres:RegisterEvent("UNIT_SPELLCAST_START"',
        'Logres:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START"',
        'Logres:RegisterEvent("GOSSIP_SHOW"',
        'Logres:RegisterEvent("QUEST_DETAIL"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"WorldCombat.lua missing profile parity fragment: {fragment}")

    order = [
        "if state.onTaxi then",
        "if snapshot.teleport then",
        "if snapshot.afk then",
        "if snapshot.gathering then",
        "if snapshot.interaction then",
        "if not state.inInstance and liveCombat then",
        "if snapshot.fishing then",
        "if state.resting then",
        "if state.inInstance then",
    ]
    positions = [source.find(fragment) for fragment in order]
    if min(positions) == -1:
        errors.append("could not locate full captured-profile priority chain")
    elif positions != sorted(positions):
        errors.append("captured-profile priority order is incorrect")

    for fragment in (
        'SetCVar("cameraDistanceMaxZoomFactor"',
        "C_CVar.SetCVar",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
    ):
        if fragment in source:
            errors.append(f"WorldCombat.lua profile parity regression: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        'status.selectedContext == "teleport"',
        'status.selectedContext == "afk"',
        'status.selectedContext == "gathering"',
        'status.selectedContext == "interaction"',
        'status.selectedContext == "fishing"',
        "profileReadFailures",
        "Logres cameraprofile contexts:",
        '"Camera Profile Check"',
        '"Camera Profile Reconcile"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing profile diagnostic fragment: {fragment}")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    p = source.find("Camera\\ProfileContexts.lua")
    c = source.find("Camera\\WorldCombat.lua")
    if p == -1:
        errors.append("Logres.toc missing Camera\\ProfileContexts.lua")
    elif c == -1 or p > c:
        errors.append("Camera\\ProfileContexts.lua must load before Camera\\WorldCombat.lua")

print("Logres captured DynamicCam profile context contract")
print("===============================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
