#!/usr/bin/env python3
"""Static checks for the Logres Phase A module lifecycle contract."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
MODULES = ADDON / "Core" / "Modules.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"
LIFECYCLE = ADDON / "Core" / "Lifecycle.lua"
TOC = ADDON / "Logres.toc"

errors = []

modules = MODULES.read_text(encoding="utf-8") if MODULES.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
lifecycle = LIFECYCLE.read_text(encoding="utf-8") if LIFECYCLE.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""

required_module_fragments = [
    "function Logres:RegisterModule(name, definition)",
    "function Logres:GetModuleStatus(name)",
    "function Logres:InitializeModule(name)",
    "function Logres:EnableModule(name)",
    "function Logres:DisableModule(name)",
    "function Logres:InitializeModules()",
    "function Logres:EnableDefaultModules()",
    "function ModuleMethods:OwnCleanup(cleanup)",
    "function ModuleMethods:SubscribeState(handler)",
    "function ModuleMethods:SubscribePreferences(handler)",
]

for fragment in required_module_fragments:
    if fragment not in modules:
        errors.append(f"Modules.lua missing contract fragment: {fragment}")

if "for index = #module._cleanups, 1, -1 do" not in modules:
    errors.append("module cleanup must run in reverse ownership order")

if 'error("Logres module already registered: " .. name)' not in modules:
    errors.append("duplicate module registration must be rejected")

if "pcall(module.OnEnable, module)" not in modules:
    errors.append("enable callback must permit cleanup before surfacing errors")

if "pcall(module.OnDisable, module)" not in modules:
    errors.append("disable callback must permit cleanup before surfacing errors")

required_lifecycle = [
    "Logres:InitializeModules()",
    "Logres:EnableDefaultModules()",
]

for fragment in required_lifecycle:
    if fragment not in lifecycle:
        errors.append(f"Lifecycle.lua missing module startup call: {fragment}")

if "/logres lifecyclecheck" not in commands:
    errors.append("Commands.lua must expose /logres lifecyclecheck")

if 'Logres:RegisterModule("DevLifecycleProbe"' not in commands:
    errors.append("Commands.lua missing disabled-by-default lifecycle probe module")

if "Core\\Modules.lua" not in toc:
    errors.append("Logres.toc does not load Core\\Modules.lua")

state_index = toc.find("Core\\State.lua")
modules_index = toc.find("Core\\Modules.lua")
commands_index = toc.find("Core\\Commands.lua")
lifecycle_index = toc.find("Core\\Lifecycle.lua")

if not (
    state_index != -1
    and modules_index != -1
    and commands_index != -1
    and lifecycle_index != -1
):
    pass
elif not (state_index < modules_index < commands_index < lifecycle_index):
    errors.append(
        "TOC order must load State -> Modules -> Commands -> Lifecycle"
    )

print("Logres module lifecycle")
print("=======================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
