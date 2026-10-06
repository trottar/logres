#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PRESENTATION = ROOT / "Logres" / "HUD" / "PetActionPresentation.lua"
TOC = ROOT / "Logres" / "Logres.toc"
PROBE = ROOT / "Logres" / "HUD" / "PetActionExecutionProbe.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
errors = []

for path in (PRESENTATION, TOC, PROBE, COMMANDS):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if PRESENTATION.is_file():
    source = PRESENTATION.read_text(encoding="utf-8")
    required = [
        "local originalCreate = ActionButton.Create",
        "function ActionButton.Create(...)",
        'button:HookScript("OnAttributeChanged"',
        'button:HookScript("PostClick"',
        "primeAttributes(button)",
        "readEffectiveAttribute(button, name, mouseButton, expectedType)",
        "SecureButton_GetModifiedAttribute",
        'mouseButton == "LeftButton" and "1" or "2"',
        'local petType, slot, mouseButton = resolvePetBinding(button)',
        "refreshPetBinding(current)",
        'name == "type1"',
        'name == "action1"',
        'name == "type2"',
        'name == "action2"',
        "button.logresPetActiveWash:Show()",
        "button.logresPetAutocastRail:Show()",
        "GetPetActionInfo",
        "rawIsActive",
        "rawAutoCastAllowed",
        "rawAutoCastEnabled",
        "ordinaryBoolean(rawIsActive)",
        "ordinaryBoolean(rawAutoCastAllowed)",
        "ordinaryBoolean(rawAutoCastEnabled)",
        "setBorderShown(button.logresPetActiveBorder, activeShown)",
        "setBorderShown(button.logresPetAutocastBorder, autocastShown)",
        "button.logresPetActivePip:Show()",
        "button.logresPetAutocastPip:Show()",
        'eventFrame:RegisterEvent("PET_BAR_UPDATE")',
        'eventFrame:RegisterEvent("PET_UI_UPDATE")',
        'eventFrame:RegisterEvent("UNIT_PET")',
        'eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")',
        'eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")',
        'Logres:RegisterModule("PetActionPresentation"',
        '"petactionexecprobe arm"',
        "defaultArmDispatchCount",
        "combat-deferred",
        "function Presentation:GetDiagnosticLines()",
        'diagnosticAttribute(button, "type")',
        'diagnosticAttribute(button, "type1")',
        'diagnosticAttribute(button, "action1")',
        'diagnosticAttribute(button, "type2")',
        'diagnosticAttribute(button, "action2")',
        "button.logresPetBindingButton",
        "diagnosticPetState(button.logresPetSlot)",
        'pcall(Logres.GetModule, Logres, "PetActionExecutionProbe")',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"PetActionPresentation.lua missing: {fragment}")

    forbidden = [
        "SLASH_LOGRESPETSTATE",
        "function Presentation:PrintDiagnostic()",
        "CastPetAction(",
        "TogglePetAutocast(",
        "PickupPetAction(",
        "C_Timer.",
        'SetScript("OnUpdate"',
        'HookScript("OnUpdate"',
        "PetActionBar:Hide",
        "PetActionBar:Show",
        "PetFrame:Hide",
        "PetFrame:Show",
        "button:SetChecked(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"presentation overlay contains forbidden path: {fragment}")

    secret_index = source.find("local function isSecret")
    effective_read = source.find("pcall(\n        SecureButton_GetModifiedAttribute")
    effective_sanitize = source.find("return ordinaryAttribute(value, expectedType)", effective_read)
    effective_branch = source.find('if actionType == "pet" then')
    if min(secret_index, effective_read, effective_sanitize, effective_branch) == -1:
        errors.append("effective pet binding secret-first path is incomplete")
    elif not (secret_index < effective_read < effective_sanitize < effective_branch):
        errors.append("effective secure attributes must be sanitized before pet binding branch")

    info_index = source.find("pcall(GetPetActionInfo, slot)")
    active_sanitize = source.find("local isActive = ordinaryBoolean(rawIsActive)")
    active_branch = source.find("local activeShown = isActive == true")
    if min(secret_index, info_index, active_sanitize, active_branch) == -1:
        errors.append("pet state secret-first path is incomplete")
    elif not (secret_index < info_index < active_sanitize < active_branch):
        errors.append("pet state must sanitize ordinary booleans before branching")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    presentation_index = source.find("HUD\\PetActionPresentation.lua")
    probe_index = source.find("HUD\\PetActionExecutionProbe.lua")
    if presentation_index == -1 or probe_index == -1:
        errors.append("Logres.toc missing pet presentation/probe runtime files")
    elif presentation_index > probe_index:
        errors.append(
            "PetActionPresentation.lua must load before PetActionExecutionProbe.lua "
            "so every probe-created shared button is decorated"
        )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in (
        'command == "petactionexecprobe"',
        "petactionexecprobe",
        'command == "petstate"',
        "runPetStateDiagnostic()",
        '"petStateDiagnostic"',
        '"Pet State Diagnostic"',
        '"petstate"',
    ):
        if fragment not in source:
            errors.append(f"Commands.lua missing pet presentation diagnostic route: {fragment}")

print("Logres pet-action presentation/default-on contract")
print("==================================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
