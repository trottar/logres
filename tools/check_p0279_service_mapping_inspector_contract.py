#!/usr/bin/env python3
"""P0279: service map registry / mouse-inert native highlight inspector, independent P gallery."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
errors=[]
def need(cond,why):
    if not cond: errors.append(why)
I=read('Logres/Quest/ServiceElementIndex.lua')
M=read('Logres/Dev/MappingInspector.lua')
P=read('Logres/Dev/Panel.lua')
TOC=read('Logres/Logres.toc')
C=read('Logres/Core/Commands.lua')
entries=re.findall(r'^add\("([^"]+)",\s*"([^"]+)",\s*"([^"]+)"',I,re.M)
need(len(entries)>=30,'registry must index real trainer, merchant, flight and future roots')
need(len({x[0] for x in entries})==len(entries),'mapping ids must be unique')
for service in ('trainer','merchant','flight','gossip','bank','auction','stable','tabard'):
    need(any(x[1]==service for x in entries),'missing service family '+service)
for role in ('surface','title','portrait','search','category','filter','list','scrollbar',
             'row','selection','status','detail.icon','reagents','price',
             'action.train','action.all','action.close'):
    need(any(x[2]==role for x in entries),'missing approved trainer layout role '+role)
for token in ('SOURCE_CANDIDATE','UNMAPPED','nativePath','Logres.ServiceElementIndex =',
              'byId = byId','overlay = overlay','ElvUI Forever','ElvUI Classic','design-only'):
    need(token in I,'registry missing '+token)
for token in ('Logres.MappingInspector = Inspector','function Inspector.Entries()',
              'function Inspector.Highlight(id)','function Inspector.Hide()',
              'function Inspector.Active()','ordinary(value)','issecretvalue',
              'InCombatLockdown','IsProtected','IsShown','GetWidth','GetHeight',
              'native-region-unverified-or-protected',
              'dynamic-row-identity-unverified','overlay-anchor-deferred',
              'frame:EnableMouse(false)','frame:SetFrameStrata(Index.overlay.strata)',
              'frame:SetParent(region)','frame:SetAllPoints(region)'):
    need(token in M,'inspector safety/capability missing '+token)
for forbidden in ('BuyTrainerService(', 'BuyMerchantItem(', 'TakeTaxiNode(',
                  'RepairAllItems(', 'C_GossipInfo.', 'SetScript("OnUpdate"',
                  'region:Hide(', 'region:SetAlpha(', 'region:SetPoint(',
                  'region:SetTexture(', 'region:EnableMouse(', 'region:SetParent('):
    need(forbidden not in M and forbidden not in I,
         'inspector/index may not mutate native object or transact '+forbidden)
for token in ('{ id = "M", title = "UI Mapping — Element Index" }',
              'local TAB_WIDTH = 52', 'local TAB_GAP = 0',
              'function Panel:RefreshMappingButtons()',
              'Logres.MappingInspector.Entries()',
              'Logres.MappingInspector.Highlight(entry.id)',
              'Logres.MappingInspector.Hide()',
              'self.activePhase == "M"','self.mappingHideButton',
              'self:BeginDiagnosticRun("mapping " .. entry.id)',
              'self:UpdatePreviewPager(#entries)',
              'self.previewPage = 1'):
    need(token in P,'mapping tab/paging/report missing '+token)
need('Logres:RegisterDevPanelAction(' not in M and
     'Logres:RegisterDevPanelAction(' not in I,'map should not add gameplay/test actions')
for order in [('Quest\\ServiceElementIndex.lua','Dev\\MappingInspector.lua'),
              ('Dev\\MappingInspector.lua','Dev\\Panel.lua')]:
    need(all(x in TOC for x in order) and TOC.index(order[0]) < TOC.index(order[1]),
         'mapping TOC must load index/inspector before panel')
need('P = true,' in C,'preserve original action gallery')
need((R/'docs/ui/SERVICE_ELEMENT_MAPPING_INDEX.md').exists(), 'durable mapping index missing')
need((R/'docs/memory/evidence/P0279_SERVICE_MAPPING_INDEX_AND_INSPECTOR.md').exists(),
     'durable P0279 evidence missing')
print('P0279 service mapping index and dedicated M verification tab')
for e in errors: print('ERROR:',e)
if errors: raise SystemExit(1)
print('PASS: %d indexed roles; zero native gameplay/control mutations; runtime UNVERIFIED'%len(entries))
