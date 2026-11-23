#!/usr/bin/env python3
"""P0512: exact trainer service item provenance, shared preview and safe refresh."""
from pathlib import Path
import re
import shutil
import subprocess

root = Path(__file__).resolve().parents[1]
read = lambda path: (root / path).read_text(encoding="utf-8")
probe = read("Logres/Quest/NativeTrainerServiceProbe.lua")
preview = probe[probe.index("-- P0512: separate read-only item-detail adapter"): ]
trial = read("Logres/Quest/TrainerLiveTrial.lua")
landscape = read("Logres/Quest/TrainerLandscape.lua")
toc = read("Logres/Logres.toc")
boot = read("Logres/Core/Bootstrap.lua")
errors = []

def need(ok, message):
    if not ok:
        errors.append(message)

need("Quest\\NativeTrainerRegionAudit.lua\nQuest\\NativeTrainerServiceProbe.lua" in toc,
     "existing probe loading order must stay intact")
need('api("GetTrainerServiceItemLink")' in probe,
     "item source must use service-indexed native item link")
need("scalar(api(\"GetTrainerServiceItemLink\"), index)" in probe and "row.itemLink = itemLink" in probe,
     "item link must be captured as an independently ordinary source copy")
need("NPCTrainerItemPreview.ItemID(itemLink)" in probe,
     "copy only links proven to identify an item")
need("Logres.NPCTrainerItemPreview = Preview" in probe,
     "separate addon-owned preview adapter must remain exposed from source")
need("sourceItemLink=native.itemLink" in trial and "chosen.sourceItemLink" in trial,
     "selected output must follow captured native service identity")
need('Logres:RegisterEvent("ITEM_DATA_LOAD_RESULT", function(_, item, success)' in trial,
     "item completion must use event first argument convention")
need("selected.itemID ~= item" in trial and "browse.itemRequests[exactID]" in trial,
     "event must ignore unrelated items and request only once per visit")
need("preview.Summarize(chosen.sourceItemLink)" in trial,
     "selected detail must contain native tooltip-derived item stats")
need('description=selectedDescription,' in landscape and "hover=detailHover" in landscape,
     "shared renderer must own the detail input region")
need('controls.detail.description:SetText(view.selected.description)' in landscape,
     "shared renderer must retain the same live detail binding")
need('local detailHover = frame(selected, 6, 73, 460, 63)' in landscape,
     "item hover must be scoped to the already approved detail geometry")
need('Preview.ShowTooltip' in preview and 'SetHyperlink' in preview and 'GetHyperlink' in preview,
     "full native item tooltip and bounded client data path required")
need('if not ordinary(link)' in preview and 'if not ordinary(owner)' in preview,
     "secret-capable item links and native objects must be guarded")
need('model.trainEnabled = false' in trial and 'BuyTrainerService(' not in trial,
     "preview must not alter native purchase routing")
for name, code in (("preview", preview), ("probe", probe),
                   ("trial", trial), ("landscape", landscape)):
    for dangerous in ('SetScript("OnUpdate"', 'C_Timer.After(', 'SelectTrainerService(',
                      'BuyTrainerService(', 'SetTrainerServiceTypeFilter('):
        need(dangerous not in code, f"{name}: unexpected polling or native trainer mutation: {dangerous}")
for forbidden in ('GetTrainerServiceItemLink', 'GetTrainerServiceInfo',
                  'GetTrainerServiceDescription'):
    need(forbidden not in trial, "source-only native trainer read leaked into controller: " + forbidden)
a = re.search(r"(?m)^## Version: ([^ ]+)$", toc)
b = re.search(r'(?m)^Logres.VERSION = "([^\"]+)"$', boot)
need(bool(a and b and a[1] == b[1]), "TOC/Bootstrap mismatch")
need("P0512" in read("docs/memory/patches/PATCH_INDEX.md"), "missing patch index")
need("P0512" in read("docs/memory/CURRENT.md"), "missing active memory checkpoint")
need("P0512" in read("docs/memory/evidence/P0512_TRAINER_CRAFTED_ITEM_PREVIEW.md"),
     "missing source/runtime evidence and client validation plan")
if errors:
    for error in errors:
        print("FAIL:", error)
    raise SystemExit(1)
lua = shutil.which("lua5.4")
if lua:
    result = subprocess.run([lua, "tools/p0512_trainer_item_preview_fixture.lua"],
                            cwd=root, capture_output=True, text=True)
    if result.returncode:
        raise SystemExit("P0512 Lua fixture FAIL:\n" + result.stdout + result.stderr)
    print(result.stdout.strip())
else:
    print("P0512 Lua fixture deferred: lua5.4 executable unavailable (static checks still apply)")
print("PASS: P0512 exact trainer item provenance, safe item refresh, no purchase changes")
