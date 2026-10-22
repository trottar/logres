#!/usr/bin/env python3
"""P0294: live-only trainer selection uses catalogue identity and dynamic detail bindings."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
read = lambda path: (ROOT / path).read_text(encoding="utf-8")
trial = read("Logres/Quest/TrainerLiveTrial.lua")
land = read("Logres/Quest/TrainerLandscape.lua")
probe = read("Logres/Quest/NativeTrainerServiceProbe.lua")
config = read("Logres/Quest/TrainerPanelConfig.lua")
prev = read("tools/check_p0293_trainer_local_browse_contract.py")
current = read("docs/memory/CURRENT.md")
evidence = read("docs/memory/evidence/P0294_TRAINER_LOCAL_SELECTION.md")
commands = read("Logres/Core/Commands.lua")
errors = []

def need(condition, message):
    if not condition:
        errors.append(message)

for token in (
    "local function selectLocalRow(position)",
    "local row = browse.model.rows[position]",
    "row.serviceIndex",
    "entry.serviceIndex == row.serviceIndex",
    "browse.selectedServiceIndex = chosen.serviceIndex",
    "entry.selected = entry.serviceIndex == chosen.serviceIndex",
    "browse.model.selected = {",
    "refreshBrowse()",
    "browse.rowHits",
    "hit:Hide()",
    "hit:Show()",
    "geometry.list.top + (i - 1) * geometry.list.pitch",
    'hit:SetScript("OnMouseUp"',
    'hit:SetScript("OnMouseWheel"',
    "hit:EnableMouseWheel(true)",
    "active == root and browse",
    "ordinaryInput(button)",
    "root:EnableMouse(false)",
    'filter:SetScript("OnMouseUp"',
    'wheel:SetScript("OnMouseWheel"',
    'control:SetScript("OnMouseUp"',
    'purchases=0, filterWrites=0, selectionWrites=0, nativeGeometryWrites=0',
):
    need(token in trial, "missing local interaction invariant: " + token)
for token in (
    "liveControls.detail = {",
    "name=selectedName",
    "requirement=selectedRequirement",
    "description=selectedDescription",
    "icon=selectedImage",
    "controls.detail.icon:SetTexture(view.selected.icon)",
    "controls.detail.name:SetText(view.selected.name)",
    "controls.detail.requirement:SetText(view.selected.requirement)",
    "controls.detail.description:SetText(view.selected.description)",
    "function Landscape.UpdateLiveRows(controls, view)",
    "return Landscape.Render(owner, Landscape.Fixture())",
):
    need(token in land, "missing live detail or inert fixture binding: " + token)
need("maxRows = 7" in config, "accepted seven-row landscape changed")
need("serviceIndex=native.index" in trial, "native service identity must be preserved")
need("MAX_SAMPLE = 64" in probe, "source sample bound changed")
need("check_p0293" not in prev, "do not recast historical check into new contract")
need('"nativeTrainerLiveOn"' in commands and '"nativeTrainerLiveOff"' in commands,
     "developer-panel backed H toggle actions absent")
for label, source in (("trial", trial), ("landscape", land)):
    for forbidden in (
        "SelectTrainerService(", "BuyTrainerService(",
        "SetTrainerServiceTypeFilter(", "SetTrainerSkillLineFilter(",
        'SetScript("OnUpdate"', "C_Timer.After(", "hooksecurefunc(",
        'CreateFrame("Button"',
    ):
        need(forbidden not in source, f"{label} must not use native mutation or polling: {forbidden}")
for term in ("P0294", "UNVERIFIED", "Blizzard", "scroll", "index", "filter", "preview", "OFF"):
    need(term.lower() in evidence.lower(), "evidence misses " + term)
need(current.count("## Next Action") == 1 and len(current.encode()) < 10000,
     "CURRENT.md health/maintenance target violated")
toc = read("Logres/Logres.toc")
boot = read("Logres/Core/Bootstrap.lua")
a = re.search(r"(?m)^## Version: (\S+)$", toc)
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', boot)
need(bool(a and b and a.group(1) == b.group(1)), "runtime version mismatch")
print("P0294 trainer local selection and live detail contract")
for err in errors:
    print("ERROR:", err)
if errors:
    raise SystemExit(1)
print("PASS: catalogue-index row selection, shared renderer, inert P fixture, no native writes")
