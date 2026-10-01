#!/usr/bin/env python3
"""Static checks for the Logres Phase A state consumer contract."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
STATE = ADDON / "Core" / "State.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"

errors = []

if not STATE.is_file():
    errors.append("missing Logres/Core/State.lua")
    state_source = ""
else:
    state_source = STATE.read_text(encoding="utf-8")

required_state_fragments = [
    "function Logres:GetState()",
    "function Logres:SubscribeState(handler)",
    "function Logres:RefreshState(reason)",
    "local State = {",
    "local stateListeners = {}",
]

for fragment in required_state_fragments:
    if fragment not in state_source:
        errors.append(f"State.lua missing contract fragment: {fragment}")

if "Logres.State =" in state_source:
    errors.append("authoritative state must not be exposed as Logres.State")

for lua_path in sorted(ADDON.rglob("*.lua")):
    source = lua_path.read_text(encoding="utf-8")

    if lua_path != STATE and "Logres.State" in source:
        errors.append(
            f"{lua_path.relative_to(ROOT)} accesses Logres.State directly; use GetState/SubscribeState"
        )

if COMMANDS.is_file():
    commands_source = COMMANDS.read_text(encoding="utf-8")
    if "Logres:GetState()" not in commands_source:
        errors.append("Commands.lua must consume state through Logres:GetState()")
    if "/logres statecheck" not in commands_source:
        errors.append("Commands.lua must expose the development statecheck command")
else:
    errors.append("missing Logres/Core/Commands.lua")

print("Logres state contract")
print("=====================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
