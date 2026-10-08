#!/usr/bin/env python3
"""Static contract for Phase H.2 integration-owned semantic layout anchors."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"

LAYOUT = ADDON / "Integration" / "Layout.lua"
TOC = ADDON / "Logres.toc"
COMMANDS = ADDON / "Core" / "Commands.lua"

CONSUMERS = {
    ADDON / "HUD" / "HUD.lua": (
        'Logres.Layout.Bind(resourceBar, "playerReaction", "CENTER", "CENTER")',
        'Logres.Layout.Bind(targetFrame, "targetFallback", "CENTER", "CENTER")',
        'Logres.Layout.Bind(allyAnchor, "allies", "CENTER", "CENTER")',
    ),
    ADDON / "Actions" / "Primary.lua": (
        'Logres.Layout.Bind(cluster, "primaryActions", "CENTER", "CENTER")',
    ),
    ADDON / "Actions" / "SecondaryUtility.lua": (
        'layoutKey = "secondaryActions"',
        'layoutKey = "utilityActions"',
        'Logres.Layout.Bind(frame, config.layoutKey, "CENTER", "CENTER")',
        'layoutKey = "bar4Actions"',
        'layoutKey = "bar5Actions"',
    ),
    ADDON / "Navigation" / "Compass.lua": (
        'Logres.Layout.Bind(frame, "navigation", "TOP", "TOP")',
    ),
    ADDON / "Quest" / "XP.lua": (
        'Logres.Layout.Bind(root, "contextXP", "CENTER", "CENTER")',
    ),
    ADDON / "Quest" / "Progress.lua": (
        'Logres.Layout.Bind(root, "contextObjective", "CENTER", "CENTER")',
    ),
    ADDON / "Quest" / "ActiveQuest.lua": (
        'Logres.Layout.Bind(root, "activeQuest", "TOPRIGHT", "TOPRIGHT")',
    ),
    ADDON / "Quest" / "Dialogue.lua": (
        'Logres.Layout.Bind(root, "questDialogue", "TOP", "TOP")',
    ),
    ADDON / "HUD" / "PlayerHelpfulAuras.lua": (
        'Logres.Layout.Bind(root, "passiveStatus", "LEFT", "CENTER")',
    ),
    ADDON / "HUD" / "PetActionExecutionProbe.lua": (
        'self.layoutAnchor = "classPet"',
    ),
}

errors = []

for path in (LAYOUT, TOC, COMMANDS, *CONSUMERS.keys()):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if LAYOUT.is_file():
    source = LAYOUT.read_text(encoding="utf-8")
    required = [
        "Logres.Layout = Layout",
        "local ANCHOR_SPECS = {",
        'navigation = {',
        'activeQuest = {',
        'questDialogue = {',
        'contextObjective = {',
        'contextXP = {',
        'playerReaction = {',
        'targetFallback = {',
        'primaryActions = {',
        'secondaryActions = {',
        'utilityActions = {',
        'bar4Actions = {',
        'bar5Actions = {',
        'allies = {',
        'classPet = {',
        'passiveStatus = {',
        "function Layout.GetAnchor(key)",
        "function Layout.Bind(",
        "frame.logresLayoutAnchor = key",
        "function Layout.GetDebugStatus()",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Integration/Layout.lua missing: {fragment}")

    forbidden = [
        "OnUpdate",
        "C_Timer.",
        "SetCVar(",
        "C_CVar.SetCVar",
        "HideUIPanel(",
        "ShowUIPanel(",
        "SetParent(",
        "hooksecurefunc",
        "RegisterStateDriver",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"Integration/Layout.lua out-of-scope behavior: {fragment}")

for path, fragments in CONSUMERS.items():
    if not path.is_file():
        continue
    source = path.read_text(encoding="utf-8")
    for fragment in fragments:
        if fragment not in source:
            errors.append(
                f"{path.relative_to(ROOT)} missing layout integration: {fragment}"
            )

if (ADDON / "Quest" / "Progress.lua").is_file():
    source = (ADDON / "Quest" / "Progress.lua").read_text(encoding="utf-8")
    if "_G.LogresHUDTarget" in source:
        errors.append("Progress.lua still depends on incidental LogresHUDTarget anchor")

if (ADDON / "HUD" / "PetActionExecutionProbe.lua").is_file():
    source = (ADDON / "HUD" / "PetActionExecutionProbe.lua").read_text(encoding="utf-8")
    bind_pattern = re.compile(
        r'Logres\.Layout\.Bind\(\s*'
        r'self\.cluster,\s*'
        r'"classPet",\s*'
        r'"CENTER",\s*'
        r'"CENTER"\s*'
        r'\)',
        re.MULTILINE,
    )
    if bind_pattern.search(source) is None:
        errors.append(
            "PetActionExecutionProbe.lua missing integration-owned Class/Pet bind"
        )
    if "_G.LogresHUDAllies" in source:
        errors.append("PetActionExecutionProbe.lua still depends on incidental LogresHUDAllies anchor")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    theme_i = source.find("Media\\Theme.lua")
    layout_i = source.find("Integration\\Layout.lua")
    hud_i = source.find("HUD\\HUD.lua")
    if layout_i == -1:
        errors.append("Logres.toc missing Integration\\Layout.lua")
    elif min(theme_i, hud_i) == -1 or not (theme_i < layout_i < hud_i):
        errors.append("Integration\\Layout.lua must load after Theme and before HUD consumers")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "local function runLayoutCheck()",
        'Logres.Layout.GetDebugStatus()',
        '"Logres layoutcheck: %s (anchors=%s binds=%s failures=%s missing=%s mismatched=%s error=%s)"',
        'if command == "layoutcheck" then',
        'emit("  /logres layoutcheck")',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing layout diagnostic: {fragment}")

    panel_pattern = re.compile(
        r'Logres:RegisterDevPanelAction\(\s*'
        r'"layoutCheck"\s*,\s*'
        r'"Layout Check"\s*,\s*'
        r'"layoutcheck"\s*,\s*'
        r'"H"\s*'
        r'\)',
        re.MULTILINE,
    )
    if panel_pattern.search(source) is None:
        errors.append("Layout Check must be registered in the Phase H developer panel")

    run_start = source.find("local function runAllChecks()")
    run_end = source.find("local function handleHUDPreview", run_start)
    if run_start == -1 or run_end == -1:
        errors.append("could not isolate runAllChecks()")
    elif "runLayoutCheck()" not in source[run_start:run_end]:
        errors.append("Run All must include layoutcheck")

print("Logres Phase H.2 integration layout contract")
print("===========================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
