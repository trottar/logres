#!/usr/bin/env python3
# Static contract checks for selective stock action-bar replacement.

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPLACEMENT = ROOT / "Logres" / "Actions" / "StockReplacement.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (REPLACEMENT, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if REPLACEMENT.is_file():
    source = REPLACEMENT.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("StockActionReplacement"',
        'frameName = "MultiBarBottomLeft"',
        'frameName = "MultiBarBottomRight"',
        'frameName = "MultiBarRight"',
        'frameName = "MultiBarLeft"',
        'self:SuppressBar(bar4Snapshot)',
        'self:SuppressBar(bar5Snapshot)',
        'self:RestoreBar(snapshot.bar4)',
        'self:RestoreBar(snapshot.bar5)',
        'actions:SetBindingRoutingEnabled("bar4", true)',
        'actions:SetBindingRoutingEnabled("bar5", true)',
        'snapshot.frame:SetAlpha(0)',
        'snapshot.frame:EnableMouse(false)',
        'snapshot.buttons[index].frame:EnableMouse(false)',
        'actions:SetBindingRoutingEnabled("secondary", true)',
        'actions:SetBindingRoutingEnabled("utility", true)',
        '"PLAYER_REGEN_ENABLED"',
        "InCombatLockdown()",
        "function StockReplacement:RequestEnabled(enabled)",
        "self.sourceDeferrals = self.sourceDeferrals + 1",
        "self.retryCount = self.retryCount + 1",
        "self.lastRetryEvent = event",
        "self.pending = true",
        "function StockReplacement:IsRoutingManaged(key)",
        "function StockReplacement:GetDebugStatus()",
        "mainActionBarSuppressed = false",
        "unsupportedBarsSuppressed = false",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"StockReplacement.lua missing: {fragment}")

    forbidden = [
        "Settings.SetValue(",
        "MultiActionBar_Update(",
        "MainActionBar:Hide(",
        "OverrideActionBar:Hide(",
        "MultiBarBottomLeft:Hide(",
        "MultiBarBottomRight:Hide(",
        "SaveBindings(",
        "SetBinding(",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                f"StockReplacement.lua forbidden path present: {fragment}"
            )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "local function runStockReplacementCheck()",
        "local function handleStockReplacement(argument)",
        'if command == "stockreplace" then',
        'if command == "stockreplacecheck" then',
        '"Stock Replace Check"',
        '"Stock Replace ON"',
        '"Stock Replace OFF"',
        "replacement:IsRoutingManaged(key)",
        'replacement owns this routing domain. Turn Stock Bars "',
        '"Replace OFF first."',
        "runStockReplacementCheck()",
        "local lifecycleConsistent =",
        "debugStatus.lastError == nil",
        "debugStatus.snapshotReady == expectedEnabled",
        "Logres stockreplacecheck startup: deferrals=%s retries=%s lastEvent=%s",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing replacement path: {fragment}")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    context_index = source.find("Actions\\Context.lua")
    replacement_index = source.find("Actions\\StockReplacement.lua")
    commands_index = source.find("Core\\Commands.lua")

    if min(context_index, replacement_index, commands_index) == -1:
        errors.append("Logres.toc missing stock replacement entries")
    elif not context_index < replacement_index < commands_index:
        errors.append(
            "StockReplacement must load after Context and before Commands"
        )

print("Logres stock replacement contract")
print("=================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
