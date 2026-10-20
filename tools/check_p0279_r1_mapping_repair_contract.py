#!/usr/bin/env python3
"""P0279 R1: runtime observed mapping gaps, overlay owner, and explicit result states."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf8')
M=read('Logres/Dev/MappingInspector.lua')
I=read('Logres/Quest/ServiceElementIndex.lua')
P=read('Logres/Dev/Panel.lua')
C=read('tools/check_p0279_service_mapping_inspector_contract.py')
E=read('docs/memory/evidence/P0279_R1_MAPPING_RUNTIME_RECONCILIATION.md')
errors=[]
def need(ok,why):
    if not ok:errors.append(why)
for t in ('local function verifiedOverlayOwner(region)',
          'plain(region, "GetObjectType")',
          'kind ~= "Texture" and kind ~= "FontString"',
          'plain(region, "GetParent")',
          'eligible(owner)',
          'frame:SetParent(owner)',
          'frame:SetAllPoints(region)',
          'native-owner-unverified-or-protected',
          'return nil, "native-region-unverified-or-protected"'):
    need(t in M, 'owner/anchor guard missing: '+t)
need('frame:SetParent(region)' not in M,'must not parent Frame to Texture/FontString')
need('frame:SetParent(region)' not in C,'historical checker still demands invalid parenting')
need('frame:SetParent(owner)' in C,'historical checker must validate safe parenting')
need('"trainer.title"' in I and 'ClassTrainerFrameTitleText' in I,
     'source-backed title candidate missing')
need('"trainer.detailIcon"' in I and 'ClassTrainerFrameSkillStepButton.icon' in I,
     'source-backed detail icon candidate missing')
for t in ('"HIGHLIGHTED"','"UNMAPPED"','"DEFERRED"',
          'reason=', 'Logres.MappingInspector.Highlight(entry.id)'):
    need(t in P,'M result status/reason missing '+t)
for t in ('9 successful', 'portrait', 'Frame:SetParent(Texture)',
          'ClassTrainerFrameTitleText','ClassTrainerFrameSkillStepButton.icon',
          'client UNVERIFIED','recycled rows', 'Blizzard controls'):
    need(t in E,'negative evidence missing '+t)
for forbidden in ('BuyTrainerService(', 'BuyMerchantItem(', 'TakeTaxiNode(',
                  'SetScript("OnUpdate"', 'region:Hide(', 'region:SetAlpha(',
                  'region:SetPoint(', 'region:SetParent('):
    need(forbidden not in M and forbidden not in I,
         'inspector cannot mutate native gameplay/region: '+forbidden)
print('P0279 R1 mapping runtime reconciliation contract')
for x in errors:print('ERROR:',x)
if errors:raise SystemExit(1)
print('PASS: 0 errors; client runtime retest pending')
