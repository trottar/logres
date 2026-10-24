#!/usr/bin/env python3
"""P0331: all Logres-owned passive gameplay roots under native menus."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
B=read('Logres/Actions/Button.lua')
H=read('Logres/HUD/HUD.lua')
C=read('Logres/Navigation/Compass.lua')
Q=read('Logres/Quest/ActiveQuest.lua')
XP=read('Logres/Quest/XP.lua')
PR=read('Logres/Quest/Progress.lua')
S=read('Logres/HUD/StatusAuras.lua')
PH=read('Logres/HUD/PlayerHelpfulAuras.lua')
N=read('Logres/HUD/NativeDebuffs.lua')
legacy=read('tools/check_action_feedback_contract.py')
boot=read('Logres/Core/Bootstrap.lua')
toc=read('Logres/Logres.toc')
issues=read('docs/memory/investigations/ISSUE_REGISTER.md')
current=read('docs/memory/CURRENT.md')
handoff=read('docs/memory/handoffs/CURRENT_HANDOFF.md')

def need(ok,label):
    if not ok: raise AssertionError(label)
for path,src,token in (
    ('action cluster',B,'cluster:SetFrameStrata("BACKGROUND")'),
    ('action feedback',B,'feedbackFrame:SetFrameStrata("BACKGROUND")'),
    ('HUD',H,'root:SetFrameStrata("BACKGROUND")'),
    ('compass',C,'frame:SetFrameStrata("BACKGROUND")'),
    ('active quest',Q,'root:SetFrameStrata("BACKGROUND")'),
    ('XP',XP,'root:SetFrameStrata("BACKGROUND")'),
    ('objective',PR,'root:SetFrameStrata("BACKGROUND")'),
    ('status auras',S,'root:SetFrameStrata("BACKGROUND")'),
    ('player helpful',PH,'root:SetFrameStrata("BACKGROUND")'),
    ('native aura container',N,'frame:SetFrameStrata("BACKGROUND")'),
):
    need(src.count(token)==1, path+' must be in game-only BACKGROUND stratum exactly once')
need('feedbackFrame:SetFrameLevel(10)' in B and 'root:SetFrameLevel(20)' in H,
     'HUD tunnel must layer above feedback/keybind UIParent sibling')
need('feedbackFrame:SetAllPoints(button)' in B and
     'feedbackFrame:EnableMouse(false)' in B and
     'CreateFrame("Frame", nil, UIParent)' in B and
     'button.hotkeyText = hotkeyText' in B,
     'action feedback/binding surface changed ownership/input')
need('feedbackFrame:SetFrameStrata("BACKGROUND")' in legacy and
     'feedbackFrame:SetFrameStrata("HIGH")' not in legacy,
     'P0040 feedback static checker not migrated to new source policy')
for p in ('Logres/Quest/Dialogue.lua','Logres/Immersion/NativeAccess.lua'):
    need('SetFrameStrata("HIGH")' in read(p),
         'native fallback/dialogue presentation must remain unchanged: '+p)
need('UnitHealthPercent("player", true, band.curve)' in H and
     'band.texture:SetAlpha(alpha)' in H and
     'if self.deathTravelMode then' in H,
     'living secret-safe health and P0330 corpse travel lost')
for bad in ('SetScript("OnUpdate"','C_Timer.NewTicker','SetAttribute(','HideUIPanel(','hooksecurefunc('):
    # The new patch must not introduce these patterns into its dedicated contract;
    # existing module behavior is separately guarded by historic checkers.
    need(bad not in read('docs/memory/evidence/P0331_GAMEPLAY_LAYERS.md'),
         'unsafe layer workaround described')
v=re.search(r'(?m)^## Version: (\S+)\s*$',toc)
b=re.search(r'(?m)^Logres.VERSION = "([^"]+)"\s*$',boot)
need(v and b and v.group(1)==b.group(1), 'runtime metadata parity')
need(len([line for line in toc.splitlines() if line.endswith('.lua')])==94,'TOC source inventory drift')
for key in ('L-025','L-029','L-026'):
    need(key in issues, 'issue continuity missing '+key)
for key in ('P0317','P0318','P0319','P0320','P0321','P0322','P0323',
            'P0324','P0325','P0326','P0327','P0328','P0329','P0330','P0331'):
    need(key in current,'CURRENT historical continuity missing '+key)
for key in ('CURRENT.md','P0326','P0327','P0330','P0331'):
    need(key in handoff,'handoff historical compatibility missing '+key)
print('P0331 passive gameplay stratum / tunnel-keybind ordering contract')
print('PASS: all ten scoped roots, separate feedback, native controls, static history')
