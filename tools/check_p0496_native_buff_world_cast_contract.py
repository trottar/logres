#!/usr/bin/env python3
"""P0496 native player helpful mirror + selected-world cast cue contract."""
from pathlib import Path
import shutil, subprocess, re
R=Path(__file__).resolve().parents[1]
H=(R/'Logres/HUD/PlayerHelpfulAuras.lua').read_text()
N=(R/'Logres/HUD/NativeDebuffs.lua').read_text()
F=(R/'Logres/Immersion/NativeSurfaceReplacement.lua').read_text()
U=(R/'Logres/HUD/HUD.lua').read_text()
P=(R/'Logres/Dev/Panel.lua').read_text()
for frag in ('function Native.CreatePlayerHelpfulMirror(anchor)',
             'CreateFrame("AuraContainer", "LogresNativePlayerHelpfulGrid"',
             '"CustomAuraContainerTemplate"',
             'frame:AddAuraGroup("LogresPlayerHelpful", "HELPFUL"',
             'frame:SetUnit("player")','frame:SetEnabled(true)',
             'frame:UpdateAllAuras()', 'frame:Show()',
             'frame:SetPoint("BOTTOMLEFT", anchor, "LEFT", 0, -iconSize / 2)'):
    assert frag in N, frag
for frag in ('function HelpfulAuras:PrepareNativeHelpful()',
             'native.CreatePlayerHelpfulMirror(self.root)',
             'self.nativeHelpfulActive = true',
             'and (self.nativeHelpfulActive ~= true or self.previewEnabled == true)',
             'if not self.nativeHelpfulActive then',
             'self:PrepareNativeHelpful()',
             'owner:Restore("playerBuffs")'):
    assert frag in H, frag
assert F.index('and helpful.lastCoverageReady == true') < F.index('and helpful.nativeHelpfulActive == true')
assert F.index('and helpful.nativeHelpfulActive == true') < F.index('and type(Logres.ToggleDevPanel) == "function"')
for frag in ('self.worldEnemyLiveFrame.enemyCastCue',
             'hideCastCue(self.targetCastCue, true)',
             'handleCastEvent(worldCue, event, "target")',
             'function HUD:HideWorldNativeCastStrip()',
             'function HUD:RestoreWorldNativeCastStrip()',
             'nativeDecorField(unitFrame, "CastBarsContainer")',
             'safeNativeDecor(castRegion)',
             'self.worldEnemyNativeCast = {region=castRegion, original=original}',
             'pcall(entry.region.SetAlpha, entry.region, entry.original)',
             'self:HideWorldNativeCastStrip()',
             'self:RestoreWorldNativeCastStrip()'):
    assert frag in U, frag
# Always verify safe cast surface before any attempted alpha dimming.
cast=U.split('function HUD:HideWorldNativeCastStrip()',1)[1].split('function HUD:RestoreWorldNativeCastStrip()',1)[0]
assert cast.index('safeNativeDecor(entry.region)') < cast.index('pcall(entry.region.SetAlpha, entry.region, 0)')
assert 'SetScript("OnUpdate"' not in H+N+U
assert 'GetAuraDataByIndex' not in N
for fld in ('"nativeHelpfulActive"','"nativeHelpfulLastResult"',
            '"worldEnemyCastCueOwner"','"worldEnemyNativeCastEligible"',
            '"worldEnemyNativeCastDimmed"'):
    assert fld in P, fld
A=(R/'Logres/Core/Bootstrap.lua').read_text();T=(R/'Logres/Logres.toc').read_text()
assert re.search(r'Logres.VERSION = "([^"]+)"', A).group(1) == re.search(r'^## Version: (\S+)', T, re.M).group(1)
assert len([x for x in T.splitlines() if x.endswith('.lua')])==96
for file in ('docs/memory/evidence/P0496_NATIVE_BUFF_AND_WORLD_CAST.md',
             'docs/memory/CURRENT.md', 'docs/memory/PRE_HANDOFF_AUDIT.md'):
    assert 'P0496' in (R/file).read_text()
ledger=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert '| L-057 |' in ledger and 'P0495 is combat FAIL' in ledger
engine=shutil.which('texlua') or shutil.which('lua')
if engine:
    subprocess.run([engine,str(R/'tools/test_p0488_player_buff_recovery.lua')],cwd=R,check=True)
    subprocess.run([engine,str(R/'tools/test_p0496_native_helpful_mirror.lua')],cwd=R,check=True)
print('P0496 native helpful mirror and guarded selected-world cast: PASS (STATIC)')
