#!/usr/bin/env python3
"""P0334 synthetic preview and secret-safe PvP HUD presentation contract."""
from pathlib import Path
import re
root=Path(__file__).resolve().parents[1]
read=lambda path:(root/path).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua')
c=read('Logres/Core/Commands.lua')
current=read('docs/memory/CURRENT.md')
handoff=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
issues=read('docs/memory/investigations/ISSUE_REGISTER.md')
t=read('Logres/Logres.toc');b=read('Logres/Core/Bootstrap.lua')
def require(ok,reason):
    if not ok: raise AssertionError(reason)
reader=h[h.index('local function readOrdinaryPvPFlag(unit)'):h.index('local function createPvPBadge(parent)')]
for term in ('type(UnitIsPVP) ~= "function"','type(issecretvalue) ~= "function"',
             'pcall(UnitIsPVP, unit)','pcall(issecretvalue, raw)',
             'if not checked or secret ~= false then','if type(raw) ~= "boolean" then',
             'return raw'):
    require(term in reader,'safe source transport missing '+term)
require(reader.index('pcall(issecretvalue, raw)')<reader.index('type(raw) ~= "boolean"'),
        'secret inspection must precede ordinary boolean branching')
require('if raw then' not in reader and 'if not raw' not in reader,
        'branch on raw secret-capable PvP state')
renderer=h[h.index('local function createPvPBadge(parent)'):h.index('local function createCastCue(parent, name)')]
for term in ('badge:EnableMouse(false)','text:SetText("PvP")',
             'function HUD:RefreshPvPIndicators()', 'function HUD:SetPvPPreview(enabled)',
             'if self.pvpPreviewEnabled then','self.playerPvPBadge:Show()',
             'self.targetPvPBadge:Show()', 'readOrdinaryPvPFlag("player")',
             'readOrdinaryPvPFlag("target")', 'SetShown(playerFlag == true)',
             'SetShown(targetFlag == true)'):
    require(term in renderer,'badge/preview renderer missing '+term)
pre=renderer.split('if self.pvpPreviewEnabled then',1)[1].split('local playerFlag =',1)[0]
require('UnitIsPVP' not in pre and 'readOrdinaryPvPFlag(' not in pre,
        'preview may not query live flag')
for term in ('createPvPBadge(root)','playerPvPBadge:SetPoint("LEFT", resourceBar, "RIGHT", 8, 0)',
             'targetPvPBadge:SetPoint("TOPLEFT", targetFrame, "TOPRIGHT", 4, -1)',
             'pvpPreviewEnabled = self.pvpPreviewEnabled == true',
             'playerPvPObserved = self.playerPvPObserved',
             'targetPvPObserved = self.targetPvPObserved',
             'self.pvpEventFrame:UnregisterAllEvents()'):
    require(term in h,'HUD badge hierarchy/lifecycle missing '+term)
for event in ('PLAYER_FLAGS_CHANGED','PLAYER_TARGET_CHANGED','PLAYER_ENTERING_WORLD'):
    require(f'self.pvpEventFrame:RegisterEvent("{event}")' in h,'missing '+event)
for event in ('UNIT_FACTION','UNIT_FLAGS'):
    require(f'self.pvpEventFrame:RegisterUnitEvent("{event}", "player", "target")' in h,
            'missing unit-filtered event '+event)
require('pvpEventFrame:SetScript("OnEvent", function()' in h,
        'do not inspect potentially opaque event payload')
for term in ('if command == "pvppreview" then','hud:SetPvPPreview(argument == "on")',
             '"pvpBadgePreviewOn"','"pvpBadgePreviewOff"',
             '"pvppreview on"','"pvppreview off"'):
    require(term in c,'same renderer preview route missing '+term)
gallery=read('tools/check_p0256_preview_hub_contract.py')
require("required.add('nativeTrainerEmptyPreview')" in gallery and
        "required.update({'pvpBadgePreviewOn', 'pvpBadgePreviewOff'})" in gallery and
        'if len(required) != 35:' in gallery and
        'if len(required) != 38:' in gallery,
        'P0256 reviewed gallery migration must retain P0310 and add only the PvP preview pair')
# P0334 R2: exact archived baseline (36) and two named additive previews (38)
# are checked by all earlier static contracts, not bypassed by broad >= assertions.
pair=('pvpBadgePreviewOn','pvpBadgePreviewOff')
for name in (
    'tools/check_p0271_native_placement_trial_contract.py',
    'tools/check_p0272_native_auto_handoff_contract.py',
    'tools/check_p0273_native_gossip_continuity_contract.py',
    'tools/check_p0274_native_service_accent_contract.py',
    'tools/check_p0276_r1_native_trainer_skin_contract.py',
    'tools/check_p0289_trainer_live_panel_contract.py',
    'tools/check_p0310_trainer_empty_catalogue_contract.py',
):
    historical=read(name)
    require(all(n in historical for n in pair),name+' must exclude only the two named P0334 previews from its historical baseline')
    require(('==36' in historical or '== 36' in historical) and
            ('==38' in historical or '== 38' in historical),
            name+' must assert BOTH original 36 and newly reviewed total 38')
for term in ("required.add('nativeTrainerEmptyPreview')",
             "required.update({'pvpBadgePreviewOn', 'pvpBadgePreviewOff'})"):
    require(term in gallery,'reviewed preview inventory drift '+term)
require('SetFrameStrata("BACKGROUND")' in h and 'root:SetFrameLevel(20)' in h,
        'P0331 menu/hud layer order changed')
require('self.deathTravelMode = false\n    self.healthBands = {}' in h,
        'P0330 death-travel initializer must remain adjacent and intact')
require('UnitHealthPercent("player", true, band.curve)' in h and
        'if self.deathTravelMode then' in h,'P0330 health transport changed')
for forbidden in ('SetAttribute(', 'RegisterStateDriver(', 'GetPoint(', 'OnUpdate',
                  'C_Timer', 'TargetFrame:Hide', 'SetCVar('):
    require(forbidden not in renderer+reader,'PvP indicator exceeds additive scope: '+forbidden)
# Offline classifier: opaque/indeterminate results cannot be assumed true.
def state(value,ordinary):
    if not ordinary or type(value) is not bool: return 'unknown',False
    return ('flagged' if value else 'unflagged'),value
for value,ordinary,expected in [(True,True,('flagged',True)),
 (False,True,('unflagged',False)),(None,True,('unknown',False)),
 (True,False,('unknown',False)),('true',True,('unknown',False))]:
    require(state(value,ordinary)==expected,'ordinary flag fixture drift')
def show(preview,p,t): return (True,True) if preview else (p is True,t is True)
require(show(True,None,None)==(True,True),'same-renderer synthetic preview must show both')
require(show(False,True,False)==(True,False),'player only')
require(show(False,False,True)==(False,True),'target only')
require(show(False,None,None)==(False,False),'unknown source fallback')
v=re.search(r'(?m)^## Version: (\S+)$',t);bv=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',b)
require(bool(v and bv and v.group(1)==bv.group(1)),'TOC/Bootstrap version parity')
require(len([line for line in t.splitlines() if line.endswith('.lua')])==94,'TOC inventory drift')
for n in range(317,335):require(f'P{n:04d}' in current,'CURRENT historical checkpoint missing '+str(n))
for term in ('CURRENT.md','P0326','P0327','P0332','P0333','P0334'):
    require(term in handoff,'handoff continuity missing '+term)
require('| L-023 |' in issues and 'P0334' in issues,'L-023 intake missing')
for path in ('docs/memory/evidence/P0334_PVP_BADGES.md',
             'docs/memory/patches/P0334_PVP_BADGES.md'):
    s=read(path);require('UNVERIFIED' in s and s.endswith('\n') and not s.endswith('\n\n'),
                          path+' evidence/hygiene missing')
print('P0334 guarded additive player/target PvP badges + preview contract')
print('PASS: source-only, secret guard, preview/live shared renderer, six deterministic cases, event cleanup')
