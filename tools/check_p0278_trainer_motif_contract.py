#!/usr/bin/env python3
"""P0278 independently authored, capability-gated native trainer motif contract."""
from pathlib import Path
r = Path(__file__).resolve().parents[1]
read = lambda p: (r/p).read_text(encoding='utf-8')
m = read('Logres/Quest/TrainerMotif.lua')
s = read('Logres/Quest/NativeTrainerSkin.lua')
c = read('Logres/Quest/TrainerPanelConfig.lua')
t = read('Logres/Media/Theme.lua')
toc = read('Logres/Logres.toc')
e = read('docs/memory/evidence/P0278_FOREVER_TRAINER_MOTIF.md')
err=[]
def need(ok,why):
    if not ok: err.append(why)
for x in ('Logres.NPCTrainerMotif = Motif','function Motif.Enable(trainer)',
          'function Motif.Disable()', 'function Motif.Preview(owner)',
          'function Motif.GetAudit()', 'local function paintRow(owner, recipe, fixtureColors)',
          'local function paintScroll(scroll, recipe)',
          'trainer.ScrollBox', '"ForEachFrame"',
          'if not ordinary(row) or row == nil or not unprotected(row) then return end',
          'if not rowsOK or found < 1 then',
          'audit.result = "scrollbox-and-rows-themed"',
          'nativeMutations = 0, transactions = 0',
          'return ok and secret == false',
          'return ok and ordinary(protected) and protected == false',
          'session = trial', 'hidePieces(surface)',
          'sampleFrame:EnableMouse(false)', 'paintRow(row, recipe)'):
    need(x in m, 'motif capability/source contract '+x)
for forbidden in ('GetTrainerServiceInfo(', 'BuyTrainerService(',
                  'ClassTrainerTrainButton', 'SetScript("OnUpdate"',
                  'GetQuestReward(', 'C_GossipInfo.', 'hooksecurefunc(',
                  'SetParent(', 'ClearAllPoints(', 'DisableDrawLayer(',
                  'frame:SetPoint(', 'scroll:SetPoint(',
                  'SetNormalTexture(', 'SetHighlightTexture(',
                  'row:Hide()', 'row:SetSize(', 'scroll:Hide(',
                  'DynamicCam'):
    need(forbidden not in m,'motif must not mutate native control/geometry '+forbidden)
for x in ('Logres.NPCTrainerMotif.Disable()',
          'Logres.NPCTrainerMotif.Enable(frame)',
          'Skin.Disable("motif-deferred")',
          'Logres.NPCTrainerLandscape.Preview(surface)',
          'native-scroll-motif-active',
          'local pieces = createPaint(frame, width, height)',
          'pcall(item.set, item.region, item.token)'):
    need(x in s,'skin must connect safe motif and native rollback '+x)
need('Quest\\TrainerPanelConfig.lua' in toc and
     'Quest\\TrainerMotif.lua\nQuest\\TrainerLandscape.lua\nQuest\\NativeTrainerSkin.lua' in toc,
     'TOC motif load order')
for x in ('motif = {','rowRuleHeight', 'scrollAlpha',
          'art.motifs.rowWash', 'art.motifs.goldLine',
          'preview = {', 'solidTexture'):
    need(x in c,'trainer motif must remain configurable '+x)
for x in ('motifs = {','rowWash =','goldLine =','scrollRule ='):
    need(x in t,'shared Logres palette missing '+x)
for x in ('ElvUI', 'Aurora', 'VISUAL FAIL', 'ScrollBox',
          'not copied', 'UNVERIFIED', 'Blizzard-owned'):
    need(x in e,'source-informed evidence incomplete '+x)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'memory health must reference CURRENT.md')
print('P0278 source-guided Forever trainer motif contract')
for x in err: print('ERROR:',x)
if err: raise SystemExit(1)
print('PASS: 0 static errors; native appearance and restoration require WoW proof')
