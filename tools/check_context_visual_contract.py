#!/usr/bin/env python3
"""Static contract for the approved Logres context-message visual primitive."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
VISUAL = ROOT / "Logres" / "Quest" / "ContextVisual.lua"
XP = ROOT / "Logres" / "Quest" / "XP.lua"
PROGRESS = ROOT / "Logres" / "Quest" / "Progress.lua"
TOC = ROOT / "Logres" / "Logres.toc"
MEDIA = ROOT / "Logres" / "Media" / "Context"

errors = []

for path in (THEME, VISUAL, XP, PROGRESS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

for name in ("context_line.tga", "context_diamond.tga", "context_glow.tga"):
    if not (MEDIA / name).is_file():
        errors.append(f"missing Context media: Logres/Media/Context/{name}")

if THEME.is_file():
    source = THEME.read_text(encoding="utf-8")
    for fragment in (
        "theme.contextMessage = {",
        "variants = {",
        "xp = {",
        "objective = {",
        "normal = {",
        "complete = {",
        'line = MEDIA_ROOT .. "Context\\\\context_line.tga"',
        'diamond = MEDIA_ROOT .. "Context\\\\context_diamond.tga"',
        'glow = MEDIA_ROOT .. "Context\\\\context_glow.tga"',
    ):
        if fragment not in source:
            errors.append(f"Theme.lua missing context token: {fragment}")

if VISUAL.is_file():
    source = VISUAL.read_text(encoding="utf-8")
    for fragment in (
        "Logres.ContextVisual = ContextVisual",
        "function ContextVisual.Create(parent, name, variant)",
        "function ContextVisual.SetComplete(surface, complete)",
        'leftLine:SetTexture(',
        'rightLine:SetTexture(',
        'diamond:SetTexture(',
        'glow:SetBlendMode("ADD")',
        "surface.glow:Show()",
        "surface.glow:Hide()",
    ):
        if fragment not in source:
            errors.append(f"ContextVisual.lua missing: {fragment}")

    for forbidden in (
        "OnUpdate",
        "StatusBar",
        "Cooldown",
        "UnitHealth",
        "UnitPower",
        "GetQuestObjectives",
        "UnitCastingInfo",
    ):
        if forbidden in source:
            errors.append(f"ContextVisual.lua owns data/progress logic: {forbidden}")

if XP.is_file():
    source = XP.read_text(encoding="utf-8")
    for fragment in (
        'Logres.ContextVisual.Create(',
        '"xp"',
        "self.contextSurface = surface",
        "Logres.ContextVisual.SetComplete(self.contextSurface, false)",
        'self.text:SetText(text)',
    ):
        if fragment not in source:
            errors.append(f"XP.lua missing Context visual wiring: {fragment}")

if PROGRESS.is_file():
    source = PROGRESS.read_text(encoding="utf-8")
    for fragment in (
        'Logres.ContextVisual.Create(',
        '"objective"',
        "self.contextSurface = surface",
        "function Progress:PresentLines(lines, reason, completed)",
        "Logres.ContextVisual.SetComplete(",
        "finishedChanged and current.finished == true",
        "return changed, completed",
        "local changed, completed =",
        "self:PresentLines(",
        "changed,",
        "completed",
    ):
        if fragment not in source:
            errors.append(f"Progress.lua missing Context visual/completion wiring: {fragment}")

    for forbidden in (
        '"QUEST_COMPLETE"',
        '"QUEST_TURNED_IN"',
        "CompleteQuest(",
        "GetQuestReward(",
    ):
        if forbidden in source:
            errors.append(
                "Context completion styling must not invent quest-control semantics: "
                f"{forbidden}"
            )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    visual_index = source.find("Quest\\ContextVisual.lua")
    xp_index = source.find("Quest\\XP.lua")
    progress_index = source.find("Quest\\Progress.lua")
    if visual_index == -1:
        errors.append("Logres.toc missing Quest\\ContextVisual.lua")
    elif xp_index == -1 or progress_index == -1:
        errors.append("Logres.toc missing XP/Progress consumers")
    elif not (visual_index < xp_index and visual_index < progress_index):
        errors.append("ContextVisual.lua must load before XP.lua and Progress.lua")

print("Logres context-message visual contract")
print("======================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
