#!/usr/bin/env python3
"""P0276 R1 visual trial: SAME renderer for P/live, gated restoration, H tests."""
import re
from pathlib import Path
R = Path(__file__).resolve().parents[1]
read = lambda p: (R/p).read_text(encoding='utf-8')
s = read('Logres/Quest/NativeTrainerSkin.lua')
a = read('Logres/Quest/NativeTrainerRegionAudit.lua')
c = read('Logres/Core/Commands.lua')
p = read('Logres/Dev/Panel.lua')
t = read('Logres/Logres.toc')
b = read('Logres/Core/Bootstrap.lua')
errors = []
def need(c, why):
    if not c: errors.append(why)
for token in (
 'Logres.NPCNativeTrainerSkin = Skin', 'function Skin.Enable()',
 'function Skin.Disable(reason)', 'function Skin.Preview()',
 'function Skin.GetAudit()',
 'local trainerConfig = Logres.PanelConfigs.trainer',
 'local function createPaint(owner, width, height)',
 'Logres.PanelSurface.Paint(owner, trainerConfig.surface, width, height)',
 'local painted = createPaint(surface, visual.width, visual.height)',
 'local pieces = createPaint(frame, width, height)',
 'local decorations, why = stockDecorations(frame)',
 'state.interactionType ~= 7', 'if not unlocked() then',
 'read(frame, "IsProtected")', 'read(frame, "IsShown")',
 'if ordinary(region) and region ~= nil and not assetPieces[region] then',
 'kind == "Texture"', 'layer == "BACKGROUND" or layer == "BORDER"',
 'pcall(getAlpha, region)', 'token=alpha',
 'pcall(item.set, item.region, item.token)',
 'if #snapshot < 1 or #snapshot > 24 then',
 'pcall(hook, frame, "OnHide"', 'Skin.Disable("trainer-closed")',
 'PLAYER_REGEN_ENABLED', 'retry:RegisterEvent("PLAYER_REGEN_ENABLED")',
 'active = {frame=frame, decorations=decorations, paint=pieces, pending=false}',
 'local restored = Skin.Disable("activation-rolled-back")',
 'nativeTransactions=0, geometryWrites=0',
 'surface:EnableMouse(visual.mouse)', 'trainerConfig.preview',
): need(token in s, 'skin prerequisite: ' + token)
for bad in (
 'BuyTrainerService(', 'BuyMerchantItem(', 'RepairAllItems(',
 'TrainAllButton:Click(', 'GetTrainerServiceInfo(', 'GetTrainerServiceCost(',
 'C_GossipInfo.', 'C_Timer.', 'SetScript("OnUpdate"',
 'frame:SetPoint(', 'frame:ClearAllPoints(', 'frame:SetSize(',
 'frame:Hide(', 'frame:EnableMouse(', 'frame:SetParent(',
 'DynamicCam', 'GetQuestReward(', 'AcceptQuest(',
): need(bad not in s, 'unsafe trainer gameplay or geometry API: '+bad)
need('Quest\\NativeTrainerRegionAudit.lua' in t and
     'Quest\\NativeTrainerSkin.lua' in t and
     t.index('Quest\\NativeTrainerRegionAudit.lua') <
     t.index('Quest\\NativeTrainerSkin.lua'),
     'trainer module ordering')
need('mode = "retired"' in read('Logres/Quest/NativeServiceAccent.lua'),
     'never reinstate failed decorative wrapper')
need('Logres.NPCNativeTrainerRegionAudit.Read()' in c,
     'retain H native-read diagnostic')
for fragment in ('if command == "nativetrainerskin" then',
                 'if command == "nativetrainerpreview" then',
                 'skin.Enable()', 'skin.Disable("explicit-off")',
                 'Logres.NPCNativeTrainerSkin.Preview()',
                 '"nativeTrainerSkinOn"', '"Trainer Skin ON (TEST)"',
                 '"nativeTrainerSkinOff"', '"Trainer Skin OFF"',
                 '"nativeTrainerSkinPreview"', '"Trainer Skin Art Preview"'):
    need(fragment in c, 'dedicated tester missing: '+fragment)
rg = re.compile(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([0A-HP])"\s*\)', re.S)
acts = rg.findall(c)
need(len(acts) >= 108 and sum(z[3]=='H' for z in acts)>=20 and
     sum(z[3]=='P' for z in acts)==36, 'action inventory must be total108/H20/P35')
need(len({z[0] for z in acts})==len(acts), 'no duplicate action IDs')
for name, phase, cmd in (
 ('nativeTrainerSkinOn','H','nativetrainerskin on'),
 ('nativeTrainerSkinOff','H','nativetrainerskin off'),
 ('nativeTrainerSkinPreview','P','nativetrainerpreview'),
):
    need(any(a[0]==name and a[2]==cmd and a[3]==phase for a in acts),
         'action missing or wrong phase: '+name)
for token in (
 'local show = self.activePhase == "P" or self.activePhase == "H"',
 'if self.activePhase == "P" or self.activePhase == "H" then',
 'local first = (self.previewPage - 1) * PREVIEW_PAGE_SIZE + 1',
 'self.previewPage = math.max(1, math.min(self.previewPage, pages))',
 'item.id == "nativeTrainerSkinOn" or item.id == "nativeTrainerSkinOff"',
 'self:UpdatePreviewPager(#visible)',
 'h2MapButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -264, -96)',
): need(token in p, 'H/P pagination or H2 clearance: '+token)
version = re.search(r'^## Version: (\S+)$', t, re.M)
boot = re.search(r'^Logres\.VERSION = "([^"]+)"$', b, re.M)
need(bool(version and boot and version.group(1)==boot.group(1)), 'version parity')
for path in ('Logres/Camera/ProfileContexts.lua', 'Logres/Camera/WorldCombat.lua',
             'Logres/Quest/Dialogue.lua',
             'docs/memory/evidence/P0275_NATIVE_QUEST_ART_SHELL.md',
             'docs/memory/evidence/P0276_R1_TRAINER_SKIN_VISUAL_TRIAL.md'):
    need((R/path).is_file(),'frozen/evidence file missing: '+path)
need('if ordinary(region) and region ~= nil and not assetPieces[region] then' in s, 'never compare secret region reference before ordinary gate')
for e in errors: print('ERROR:',e)
print('P0276 R1 native trainer visual trial / explicit panel controls')
if errors: raise SystemExit(1)
print('PASS: 0 static errors; in-game alpha/restoration/visual acceptance PENDING')
