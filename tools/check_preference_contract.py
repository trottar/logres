#!/usr/bin/env python3
"""Static checks for Logres persisted preference contract."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
DATABASE = ADDON / "Core" / "Database.lua"
PREFERENCES = ADDON / "Core" / "Preferences.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"
TOC = ADDON / "Logres.toc"

errors = []

database = DATABASE.read_text(encoding="utf-8") if DATABASE.is_file() else ""
preferences = PREFERENCES.read_text(encoding="utf-8") if PREFERENCES.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""

required_database = [
    "local CURRENT_SCHEMA = 2",
    "immersionEnabled = true",
    "local function migrateDatabase(db)",
    "schema = 2",
]

for fragment in required_database:
    if fragment not in database:
        errors.append(f"Database.lua missing preference/schema fragment: {fragment}")

required_preferences = [
    "function Logres:GetPreferences()",
    "function Logres:GetPreference(name)",
    "function Logres:SetPreference(name, value, reason)",
    "function Logres:SubscribePreferences(handler)",
    'immersionEnabled = {',
]

for fragment in required_preferences:
    if fragment not in preferences:
        errors.append(f"Preferences.lua missing contract fragment: {fragment}")

required_commands = [
    "/logres preferencecheck",
    "/logres immersion [on|off|toggle]",
    'Logres:SetPreference(',
]

for fragment in required_commands:
    if fragment not in commands:
        errors.append(f"Commands.lua missing preference test/control fragment: {fragment}")

if "Core\\Preferences.lua" not in toc:
    errors.append("Logres.toc does not load Core\\Preferences.lua")

database_index = toc.find("Core\\Database.lua")
preferences_index = toc.find("Core\\Preferences.lua")
state_index = toc.find("Core\\State.lua")

if not (database_index != -1 and preferences_index != -1 and state_index != -1):
    pass
elif not (database_index < preferences_index < state_index):
    errors.append("Preferences.lua must load after Database.lua and before State.lua")

state_source = (ADDON / "Core" / "State.lua").read_text(encoding="utf-8")
if "immersionEnabled" in state_source:
    errors.append(
        "Observed State.lua must not contain immersionEnabled; user preference is a separate contract"
    )

print("Logres preference contract")
print("==========================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
