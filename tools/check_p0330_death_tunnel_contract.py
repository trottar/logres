#!/usr/bin/env python3
"""P0330 guarded death/ghost tunnel corpse-travel override contract and offline lifecycle fixture."""
from pathlib import Path
import re

R=Path(__file__).resolve().parents[1]
read=lambda path:(R/path).read_text(encoding='utf-8')
hud=read('Logres/HUD/HUD.lua')
cmd=read('Logres/Core/Commands.lua')
current=read('docs/memory/CURRENT.md')
handoff=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
issues=read('docs/memory/investigations/ISSUE_REGISTER.md')
evidence=read('docs/memory/evidence/P0330_DEATH_TUNNEL.md')
phase=read('docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md')
index=read('docs/memory/patches/PATCH_INDEX.md')
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')

def need(condition,reason):
    if not condition:
        raise AssertionError(reason)

# Exact living visual contract and secret-safe transport remain in place.
for s in ('local HEALTH_BANDS = {', 'name = "deathCollapse"',
          'name = "nearDeathTunnel"', 'function HUD:UpdateHealthVignette()',
          'local alpha = UnitHealthPercent("player", true, band.curve)',
          'band.texture:SetAlpha(alpha)', 'function HUD:ApplyHealthPreviewPercent(previewPercent)',
          'function HUD:SetHealthPreviewPercent(previewPercent)'):
    need(s in hud,'living D-036 source contract lost: '+s)
need(hud.count('local alpha = UnitHealthPercent("player", true, band.curve)')==1,
     'health-percent source unexpectedly duplicated')

start=hud.index('local function readOrdinaryDeathTravelState()')
end=hud.index('\nfunction HUD:RefreshDeathTravelState(event)',start)
read_block=hud[start:end]
for s in ('type(UnitIsDeadOrGhost) ~= "function"',
          'type(issecretvalue) ~= "function"',
          'pcall(UnitIsDeadOrGhost, "player")',
          'pcall(issecretvalue, result)',
          'if not tested or secret then',
          'if type(result) ~= "boolean" then'):
    need(s in read_block,'ordinary-only death classification missing '+s)
need(read_block.index('pcall(issecretvalue, result)')<read_block.index('type(result) ~= "boolean"'),
     'secret classification must precede inspection')
need('if result then' not in read_block and 'if not result' not in read_block,
     'must not branch on unclassified result')

start=hud.index('function HUD:RefreshDeathTravelState(event)')
end=hud.index('\nfunction HUD:UpdateHealthVignette()',start)
life=hud[start:end]
for s in ('if event == "PLAYER_DEAD" then',
          'self.deathTravelMode = true',
          'elseif event == "PLAYER_UNGHOST" then',
          'self.deathTravelMode = false',
          'local ordinaryState = readOrdinaryDeathTravelState()',
          'if ordinaryState ~= nil then',
          'self.deathTravelMode = ordinaryState',
          'self:UpdateHealthVignette()'):
    need(s in life,'death lifecycle branch missing '+s)
need('UnitHealthPercent' not in life,'death lifecycle must not inspect secret health')

start=hud.index('function HUD:UpdateHealthVignette()')
end=hud.index('\nfunction HUD:UpdateResource()',start)
paint=hud[start:end]
for s in ('if self.deathTravelMode then',
          'self.healthBands[index].texture:SetAlpha(0)',
          'if self.previewEnabled then',
          'local alpha = UnitHealthPercent("player", true, band.curve)',
          'band.texture:SetAlpha(alpha)'):
    need(s in paint,'corpse mask/live health compositor missing '+s)
need(paint.index('if self.deathTravelMode then') < paint.index('if self.previewEnabled then')
     <paint.index('local alpha = UnitHealthPercent('),
     'dead override must precede preview/live health')
need('return\n    end' in paint.split('if self.deathTravelMode then',1)[1].split('if self.previewEnabled then',1)[0],
     'must short-circuit before live secret health lookup')
for forbidden in ('if alpha', 'alpha <', 'alpha >', 'alpha ==', 'tostring(alpha)',
                  'UnitHealth("player"', 'UnitHealthMax("player"'):
    need(forbidden not in paint,'secret-derived health inspection: '+forbidden)

for s in ('self.deathTravelMode = false\n    self.healthBands = {}',
          'deathTravelMode = self.deathTravelMode and true or false',
          'self:RefreshDeathTravelState("initial")',
          'self:RefreshDeathTravelState(event)',
          'if self.deathTravelMode then\n            self:UpdateHealthVignette()',
          'boolText(hud.deathTravelMode)',
          'Logres gameplaycapture HUD: rootShown=%s preview=%s previewPercent=%s bands=%s targetReady=%s deathTravel=%s'):
    need(s in (hud+cmd),'death override diagnostics or preview integration missing '+s)
for event in ('PLAYER_DEAD','PLAYER_ALIVE','PLAYER_UNGHOST','PLAYER_ENTERING_WORLD'):
    need(f'self.healthEventFrame:RegisterEvent("{event}")' in hud,
         'death lifecycle event not registered: '+event)
need('self.healthEventFrame:UnregisterAllEvents()' in hud,
     'lifecycle cleanup must unregister death events')
need('C_Timer.After(' not in life and 'SetScript("OnUpdate"' not in life,
     'no retry/polling allowed in death lifecycle')
need('SetFrameStrata(' not in life and 'InCombatLockdown(' not in life,
     'do not mutate protected/native frame geometry in death lifecycle')

# Pure offline transition fixture: event is control signal, observation is
# ALREADY CLASSIFIED ordinary bool or unknown. Never synthesize a health value.
def advance(mode,event,ordinary):
    if event=='PLAYER_DEAD':return True
    if event=='PLAYER_UNGHOST':return False
    return mode if ordinary is None else ordinary
cases=[
    (False,'PLAYER_DEAD',None,True),
    (True,'PLAYER_ALIVE',True,True),        # spirit release
    (True,'PLAYER_UNGHOST',None,False),    # reclaimed corpse
    (True,'PLAYER_ALIVE',False,False),     # pre-release resurrection
    (False,'PLAYER_ENTERING_WORLD',True,True), # login ghost
    (True,'PLAYER_ENTERING_WORLD',False,False),# login living
    (False,'PLAYER_ENTERING_WORLD',None,False),# unknown no inference
    (True,'PLAYER_ALIVE',None,True),       # unknown never overwrites
    (True,'PLAYER_DEAD',False,True),      # event authoritative
]
for start,event,ordinary,expected in cases:
    need(advance(start,event,ordinary) is expected,
         f'offline death transition fixture failed: {start}/{event}/{ordinary}')

v=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',boot)
need(bool(v and b and v.group(1)==b.group(1)), 'runtime version parity')
need('P0329' in current and 'P0330' in current and 'P0330' in handoff and 'CURRENT.md' in handoff,
     'current/handoff checkpoint drift')
for term in ('P0326','P0327','P0328','P0329'):
    need(term in handoff, 'historical handoff marker missing '+term)
for n in range(317,331):
    need(f'P{n:04d}' in current,'historical current marker missing')
need('| L-026 |' in issues and 'P0330 PREPARED' in issues,
     'L-026 triage missing')
need('P0330' in phase and 'P0330' in index and 'P0329' in index,
     'Phase H / patch index history missing')
need('UNVERIFIED' in evidence and 'November 4' in evidence,
     'environmental deferral/lifecycle risk evidence missing')
print('P0330 dead/ghost health tunnel and nine offline lifecycle fixtures')
print('PASS: bounded corpse mask override, living D-036 native curve, secret-safe guard and memory')
