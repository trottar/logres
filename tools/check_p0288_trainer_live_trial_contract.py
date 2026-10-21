#!/usr/bin/env python3
"""P0288: a live read-only trainer snapshot uses the approved shared renderer."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
trial=read('Logres/Quest/TrainerLiveTrial.lua')
land=read('Logres/Quest/TrainerLandscape.lua')
commands=read('Logres/Core/Commands.lua')
native=read('Logres/Quest/NativeTrainerSkin.lua')
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')
evidence=read('docs/memory/evidence/P0288_TRAINER_LIVE_READONLY_TRIAL.md')
errors=[]
def need(x,why):
    if not x:errors.append(why)
for token in ('function Trial.FromSnapshot(report)','function Trial.Toggle(mode)',
    'function Trial.Disable(why)', 'Logres.NPCTrainerLiveTrial = Trial',
    'Logres.NPCNativeTrainerServiceProbe.Read()',
    'Logres.NPCTrainerLandscape.Build(model)',
    'Logres.NPCTrainerLandscape.Render(root, model)',
    'Logres.PanelSurface.Paint(root, panel.surface, visual.width, visual.height)',
    'root:EnableMouse(false)', 'PLAYER_INTERACTION_MANAGER_FRAME_HIDE',
    'PLAYER_REGEN_DISABLED','PLAYER_ENTERING_WORLD',
    'native.state ~= "numeric-category-unclassified"',
    'native.state ~= "source-observed"',
    'requirement="Availability not classified"',
    'trainAll={label="Train All unavailable", enabled=false}',
    'trainLabel="Stock Train", trainEnabled=false',
    'purchases=0, filterWrites=0, selectionWrites=0, nativeGeometryWrites=0',
    'serviceIndex=native.index', 'footnote="LIVE READ-ONLY'):
    need(token in trial,'missing live read-only adapter contract: '+token)
for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
    'SetTrainerServiceTypeFilter(', 'ClearAllPoints(', 'SetParent(',
    'ClassTrainerFrame', 'hooksecurefunc(', 'SetScript("OnUpdate"',
    'GetTrainerServiceInfo(', 'GetTrainerServiceCost(',
    'CreateFrame("Button"', 'DynamicCam'):
    need(forbidden not in trial,'trial must not mutate native state: '+forbidden)
need('if command == "nativetrainerlive" then' in commands, 'missing explicit CLI action')
need('Logres.NPCTrainerLiveTrial.Toggle(argument)' in commands, 'missing explicit toggle call')
need('Quest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua' in toc,
     'trial must load after existing skin without changing existing adjacency')
need('function Landscape.Preview(owner)' in land and
     'return Landscape.Render(owner, Landscape.Fixture())' in land,
     'must preserve accepted synthetic preview')
need('pcall(item.set, item.region, item.token)' in native and
     'Skin.Disable("trainer-closed")' in native,
     'stock-skin restoration preserved')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(bool(a and b and a.group(1)==b.group(1)), 'TOC/Bootstrap mismatch')
for word in ('P0287','P0288','D-046','D-047','numeric', 'DEFERRED',
             'VISUAL PASS','Blizzard', 'PREWRITE FAIL', 'read-only'):
    need(word.lower() in evidence.lower(), 'missing durable evidence: '+word)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff missing authority')
for msg in errors: print('ERROR:',msg)
print('P0288 trainer live read-only snapshot shared-renderer contract')
if errors:raise SystemExit(1)
print('PASS: addon-owned inert live snapshot; Blizzard controls and stock fallback preserved')
