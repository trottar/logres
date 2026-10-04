#!/usr/bin/env python3
"""Static contract for the approved Logres cast-state cue visual translation."""
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
HUD = ROOT / "Logres" / "HUD" / "HUD.lua"
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
TOC = ROOT / "Logres" / "Logres.toc"

ASSETS = {
    "Logres/Media/Cast/cast_frame.tga": "0e31ad5519fe6612367e3e6c6acc669ee5630ce25f6838a843a59666d2eedfb6",
    "Logres/Media/Cast/player_cast.tga": "3af6ad72cc30affe4f890550cfe88c40cbf69cdbdd9c3e84eb9ad3c23869837d",
    "Logres/Media/Cast/player_channel.tga": "cb31fc0405cd1729bdc0beaf9e3f10053bc24e3d2ed7579beb1260a987b99fb3",
    "Logres/Media/Cast/target_cast.tga": "b318c075f066ef1b76a20282948e25de08392b8f62bae1e55a3c475c3159a759",
    "Logres/Media/Cast/target_channel.tga": "a58b5fabf89d11da4a70db58840a2336a21d8519052935d766800c1bfc7558f7",
    "Logres/Media/Cast/interrupted.tga": "4caf691477f853d8a8433f5bb46f2e666037ab2fd4df83e03caf25c33660820c",
}

errors = []

for rel, expected in ASSETS.items():
    path = ROOT / rel
    if not path.is_file():
        errors.append(f"missing cast cue asset: {rel}")
        continue
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        errors.append(f"cast cue asset hash mismatch: {rel}: {actual}")

hud = HUD.read_text(encoding="utf-8") if HUD.is_file() else ""
theme = THEME.read_text(encoding="utf-8") if THEME.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""

for fragment in (
    "theme.castCue = {",
    "size = 24",
    'frame = MEDIA_ROOT .. "Cast\\\\cast_frame.tga"',
    'playerCast = MEDIA_ROOT .. "Cast\\\\player_cast.tga"',
    'playerChannel = MEDIA_ROOT .. "Cast\\\\player_channel.tga"',
    'targetCast = MEDIA_ROOT .. "Cast\\\\target_cast.tga"',
    'targetChannel = MEDIA_ROOT .. "Cast\\\\target_channel.tga"',
    'interrupted = MEDIA_ROOT .. "Cast\\\\interrupted.tga"',
):
    if fragment not in theme:
        errors.append(f"Theme.lua missing cast cue token/path: {fragment}")

for fragment in (
    "local castCueStyle =",
    "local castCueAssets = castCueStyle.assets or {}",
    "local DEFAULT_CAST_CUE_SIZE = castCueStyle.size or 24",
    'local frameTexture = cue:CreateTexture(nil, "OVERLAY")',
    'local glyph = cue:CreateTexture(nil, "ARTWORK")',
    "cue.frameTexture = frameTexture",
    "cue.glyph = glyph",
    "cue.glyph:SetTexture(asset)",
    'asset = castCueAssets.playerChannel',
    'asset = castCueAssets.targetChannel',
    'asset = castCueAssets.interrupted',
    'asset = castCueAssets.playerCast',
    'asset = castCueAssets.targetCast',
    'handleCastEvent(self.playerCastCue, event, "player")',
    'handleCastEvent(self.targetCastCue, event, "target")',
):
    if fragment not in hud:
        errors.append(f"HUD.lua missing cast cue visual contract: {fragment}")

for forbidden in (
    "cue.inner",
    "cue.core",
    "UnitCastingInfo(",
    "UnitChannelInfo(",
):
    if forbidden in hud:
        errors.append(f"HUD.lua retains forbidden/old cast visual path: {forbidden}")

# Cue remains symbolic only: no cast timer/progress surface is introduced.
for forbidden in (
    "LogresHUDCastBar",
    "castProgress",
    "castTimer",
):
    if forbidden in hud:
        errors.append(f"HUD.lua introduces disallowed cast progress/timer surface: {forbidden}")

if "Media\\Theme.lua" not in toc or "HUD\\HUD.lua" not in toc:
    errors.append("TOC must load Theme.lua and HUD.lua")
elif toc.find("Media\\Theme.lua") > toc.find("HUD\\HUD.lua"):
    errors.append("Theme.lua must load before HUD.lua")

print("Logres cast-state cue visual contract")
print("====================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
