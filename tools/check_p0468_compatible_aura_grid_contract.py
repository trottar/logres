#!/usr/bin/env python3
"""P0468: four-column aura expansion without weakening secret/native fallback."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda f:(R/f).read_text(encoding='utf-8')
H=read('Logres/HUD/PlayerHelpfulAuras.lua')
S=read('Logres/HUD/StatusAuras.lua')
N=read('Logres/HUD/NativeDebuffs.lua')
F=read('Logres/Immersion/NativeSurfaceReplacement.lua')
T=read('Logres/Media/Theme.lua')
B=read('Logres/Core/Bootstrap.lua')
TOC=read('Logres/Logres.toc')
C=read('Logres/Core/Commands.lua')
E=read('docs/memory/evidence/P0468_COMPATIBLE_AURA_GRID.md')
L=read('docs/memory/investigations/ISSUE_LEDGER.md')

def need(ok,why):
    assert ok,why

for code in ('local FILTER = "HELPFUL"', 'local MAX_SCAN = 40',
             'local MAX_ICONS = 40', 'local COLUMNS = 4',
             'C_Secrets.ShouldUnitAuraIndexBeSecret',
             'if isSecret(predicateResult) then',
             'if isSecret(aura) then', 'if isSecret(icon) then',
             'scanExhausted = false', 'snapshot.scanExhausted = true',
             'snapshot.secretSkips == 0 and snapshot.failures == 0',
             'and snapshot.scanExhausted ~= true',
             'local column = (index - 1) % COLUMNS',
             'local row = math.floor((index - 1) / COLUMNS)',
             'self.root:SetHeight(',
             'GameTooltip:SetUnitAura("player", slot.auraIndex, FILTER)',
             'Logres.Layout.Bind(root, "passiveStatus", "LEFT", "CENTER")'):
    need(code in H, 'player helpful contract lost: '+code)
need('HELPFUL|PLAYER' not in H, 'player helpful still self-cast-only')
need('or debugAfter.visibleCount == 9' in C, 'player preview diagnostic pinned to old four icons')
need('error=%s coverage=%s exhausted=%s)' in H, 'helpful fallback provenance not emitted')
need(H.split('local PREVIEW_AURAS = {',1)[1].split('local function styleValue',1)[0].count('icon =')==9,
     'player deterministic preview no longer exercises >4 icons')
preview=S.split('local PREVIEW = {',1)[1].split('-- Retain category-level',1)[0]
need(preview.count('icon =')==18, 'status preview no longer tests 6 per lane')
readbody=H.split('local function readAura(index)',1)[1].split('function HelpfulAuras:ReadSnapshot()',1)[0]
need(readbody.index('if isSecret(predicateResult) then')<
     readbody.index('if predicateResult ~= false then')<
     readbody.index('C_UnitAuras.GetAuraDataByIndex,')<
     readbody.index('if isSecret(aura) then')<
     readbody.index('local icon = aura.icon')<
     readbody.index('if isSecret(icon) then'), 'secret-first player index/payload boundary')
for code in ('local MAX_SCAN = 40', 'local TARGET_HARMFUL_SCAN = 40',
             'local MAX_ICONS = 40', 'local COLUMNS = 4',
             'local columns = COLUMNS',
             'targetHarmfulCandidates[#targetHarmfulCandidates + 1] = aura',
             'seen[aura.instanceID] = true',
             'if isSecret(predicate) then', 'if isSecret(aura) then',
             'if isSecret(instanceID)',
             'Logres.Layout.Bind(root, anchorKey',
             'renderLane(self.lanes.targetHelpful, snapshot.helpfulRows, active)'):
    need(code in S, 'ordinary status contract lost: '+code)
need(S.count('{ filter = "HARMFUL", kind = "harmful" }')>=2 and
     '{ filter = "HELPFUL", kind = "helpful" }' in S,
     'canonical helpful and harmful coverage absent')
for code in ('local MAX = harmfulStyle.maxIcons or 40',
             'local columns = 4', 'frame:SetFlowLayoutMaximumLineSize(width)',
             'frame:SetFlowLayoutMaximumLineSize(4 * ICON + 3 * GAP)',
             'maxFrameCount = MAX,',
             'button:SetIcon(icon)', 'frame:SetUnit(unit)',
             'local visual = presentation.CreateBase(button)',
             'button:SetDurationText(duration, {})',
             'button:SetApplicationCount(count, {})',
             'Native.RestoreWorldAuraOwner'):
    # Exact restore function is ReleaseWorldAuraOwner in P0464.
    if code == 'Native.RestoreWorldAuraOwner':
        code='function Native.ReleaseWorldAuraOwner(owner)'
    need(code in N, 'native rendering/restoration contract lost: '+code)
need('maxFrameCount = 12,' not in N, 'world aura 12-icon cap remains')
need('and helpful.lastCoverageReady == true' in F and
     'self:Restore(key)' in F and 'if InCombatLockdown() then' in F,
     'native player BuffFrame capability-gated restoration lost')
need('maxIcons = 40' in T and
     'aura_frame_passive.tga' in T and
     'aura_count_plate.tga' in T,
     'accepted aura art or theme geometry lost')
for unsafe in ('C_Timer.NewTicker', 'SetScript("OnUpdate"',
               'GetAuraSlots', 'GetAuraDataBySlot',
               'BuffFrame:Hide', 'DebuffFrame:Hide',
               'TargetFrame:Hide', 'SetParent('):
    need(unsafe not in H+S+N, 'unsafe aura operation introduced: '+unsafe)
need('L-051' in L and 'P0468' in E and 'UNVERIFIED' in E,
     'issue / evidence boundary missing')
need(re.search(r'^Logres.VERSION = "0\.0\.336-dev"$',B,re.M) and
     re.search(r'^## Version: 0\.0\.336-dev$',TOC,re.M),
     'P0468 source versions not synchronized')
need(len([x for x in TOC.splitlines() if x.endswith('.lua')])==96,
     'loaded source inventory changed')
print('P0468 four-column compatible aura grid: PASS (STATIC; WoW UNVERIFIED)')
