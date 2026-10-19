#!/usr/bin/env python3
"""P0262 N2: real shared page-builder/renderer used by existing live and preview UI."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
D=(R/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
P=(R/'Logres/UI/NarrativePages.lua').read_text(encoding='utf-8')
T=(R/'Logres/Logres.toc').read_text(encoding='utf-8')
B=(R/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
M=(R/'Logres/Quest/NarrativeModel.lua').read_text(encoding='utf-8')
C=(R/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
e=[]
def req(cond,label):
 if not cond:e.append(label)
for token in (
 'Logres.NPCNarrativePages = Pages',
 'local function appendPage(pages, text)',
 'local function addParagraphWords(',
 'function Pages.Build(text, limit)',
 'if #candidate > limit',
 '                paragraph,\n                limit\n            )',
 'function Pages.Paint(self, activeColor, inactiveColor)',
 'self.pageIndicator:ClearAllPoints()',
 '"BOTTOMRIGHT", self.root, "BOTTOMRIGHT", -115, 17',
 '"BOTTOMRIGHT", self.root, "BOTTOMRIGHT", -115, 78',
 '"BOTTOM", self.root, "BOTTOM", 0, 17',
 'self.pageIndicator:SetFormattedText(',
 'self.previousButton:Hide()',
 'self.nextButton:Hide()',
 'self.previousTexture:SetVertexColor(',
 'self.nextTexture:SetVertexColor(',
 'function Pages.ShowBody(self, index)',
 'self.pages[index] or ""',
): req(token in P,'NarrativePages missing '+token)
for token in (
 'local PAGE_CHAR_LIMIT = 420',
 'local function buildPages(text)',
 'return Logres.NPCNarrativePages.Build(text, PAGE_CHAR_LIMIT)',
 'self.pages = buildPages(body)',
 'function Dialogue:UpdatePageControls()',
 'return Logres.NPCNarrativePages.Paint(',
 'colorValue("pageActive")',
 'colorValue("pageInactive")',
 'Logres.NPCNarrativePages.ShowBody(self, index)',
 'function Dialogue:SetPage(index)',
 'self:UpdatePageControls()',
 'self:UpdateOfferControls()',
 'self:UpdateCompletionPagePresentation()',
 'function Dialogue:PresentText(',
 'function Dialogue:PresentNarrativeModel(model)',
 'self:PresentText(',
 'Logres.NPCNarrativeModel.FromLive(',
 'self:PresentNarrativeModel(model)',
 'self.offerActionPreview =',
 'function Dialogue:ShowNarrativePreview(mode)',
):req(token in D,'Dialogue missing shared view/owned controller token '+token)
req('function Dialogue:UpdatePageControls()' in D and
     D.count('function Dialogue:UpdatePageControls()')==1,'page painter entry point changed')
req('function Pages.Paint(' not in D and 'self.pageIndicator:SetFormattedText(' not in D,
    'duplicated rather than extracted shared page rail')
req('local function appendPage(' not in D and 'local function addParagraphWords(' not in D,
    'duplicated original split algorithm')
req(D.count('Logres.NPCNarrativePages.ShowBody(self, index)')==1,
    'actual page body is not delegated exactly once')
req('bodyText:SetWordWrap(true)' in D and 'objectiveText:SetWordWrap(true)' in D,
    'original frame creation changed')
for q in ('AcceptQuest(', 'DeclineQuest(', 'GetQuestReward(', 'CompleteQuest(',
          'C_GossipInfo.', 'GetQuestID(', 'hooksecurefunc(', 'RegisterStateDriver(',
          'SetParent(', 'DynamicCam', ':SetScript(', 'C_Timer.', 'UIParent', 'issecretvalue'):
 req(q not in P,'page view illegally reads/acts on native, frame ownership or camera: '+q)
req('function Model.Preview(mode)' in M and 'function Model.FromLive(' in M,
    'live/preview narrative fixture contract missing')
req(C.count('"questDialoguePreview",')==1 and
    C.count('"questNarrativePreviewShort",')==1 and
    C.count('"questNarrativePreviewGeneric",')==1 and
    C.count('"questRewardPreviewSingle",')==1 and
    C.count('"questRewardPreviewMulti",')==1,
    'existing P-tab coverage changed')
for q in ('"questDialoguePreview",\n    "Quest Dialogue Preview",',
          '"questNarrativePreviewShort",\n    "NPC Narrative: Short",',
          '"questNarrativePreviewGeneric",\n    "NPC Dialogue: Generic",'):
 req(q in C,'original preview label changed: '+q)
start=T.find('Quest\\NarrativeModel.lua'); pages=T.find('UI\\NarrativePages.lua'); end=T.find('Quest\\Dialogue.lua');
req(pages>=0 and pages<start<end,'shared pages must load before narrative model and existing renderer')
v=re.search(r'^## Version: ([^\r\n]+)$',T,re.M);b=re.search(r'^Logres\.VERSION = "([^"]+)"$',B,re.M)
req(bool(v and b and v.group(1)==b.group(1)),'TOC and Bootstrap version parity')
print('Logres P0262 shared narrative pagination/presentation contract')
print('==========================================================')
for m in e:print('ERROR:',m)
if e:raise SystemExit(1)
print('PASS: 0 errors; production/preview shared view and native/camera boundaries')
