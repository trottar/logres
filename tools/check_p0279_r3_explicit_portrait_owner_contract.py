#!/usr/bin/env python3
"""P0279 R3: exact evidence-based owner mapping, no generic size bypass."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
L=(R/'Logres/Dev/MappingInspector.lua').read_text(encoding='utf-8')
I=(R/'Logres/Quest/ServiceElementIndex.lua').read_text(encoding='utf-8')
U=(R/'docs/ui/SERVICE_ELEMENT_MAPPING_INDEX.md').read_text(encoding='utf-8')
E=(R/'docs/memory/evidence/P0279_R3_EXPLICIT_PORTRAIT_OWNER.md').read_text(encoding='utf-8')
errors=[]
def need(ok,msg):
    if not ok: errors.append(msg)
for token in ('overlayOwnerPath = overlayOwnerPath','"ClassTrainerFramePortrait",           "ElvUI Forever", "ClassTrainerFrame"'):
    need(token in I,'index owner missing '+token)
for token in ('local owner, ownerReason = verifiedOverlayOwner(region)',
              'ownerReason == "native-owner-outside-size-gate"',
              'type(entry.overlayOwnerPath) == "string"',
              'resolve({nativePath = entry.overlayOwnerPath})',
              'if mappedOwner and eligible(mappedOwner) then',
              'plain(mappedOwner, "GetObjectType")',
              'mappedKind ~= "Texture" and mappedKind ~= "FontString"',
              'frame:SetParent(owner)', 'frame:SetAllPoints(region)',
              'highlight-visible-mapped-owner',
              'if not eligible(owner) then return nil, ownerGateFailure(owner) end',
              'if not owner then return false, ownerReason end',
              'frame:EnableMouse(false)', 'InCombatLockdown'):
    need(token in L,'owner fallback/guard missing '+token)
need(L.count('ownerReason == "native-owner-outside-size-gate"')==1,'size fallback must be unique')
need(L.count('eligible(mappedOwner)')==1,'explicit owner requires independent gate')
need('frame:SetParent(region)' not in L,'illegal parenting to texture')
for forbidden in ('region:Hide(', 'region:SetAlpha(', 'region:SetPoint(', 'region:SetParent(',
                  'owner:Hide(', 'owner:SetAlpha(', 'owner:SetParent(',
                  'SetScript("OnUpdate"', 'BuyTrainerService(', 'BuyMerchantItem('):
    need(forbidden not in L,'cannot modify native UI or transact '+forbidden)
for marker in ('native-owner-outside-size-gate',
               'two subsequent','ClassTrainerFrame','No native setters'):
    need(marker in E,'missing durable failure evidence '+marker)
need('overlayOwnerPath' in U and 'R3 runtime highlight' in U,'UI mapping index not revised')
need((R/'docs/memory/patches/P0279_R3_EXPLICIT_PORTRAIT_OWNER.md').exists(),'patch history missing')
F=(R/'docs/memory/evidence/P0279_R3_R1_PREWRITE_VERSION_POLICY_FAILURE.md').read_text(encoding='utf-8')
for token in ('PREWRITE', '1/150', 'check_checker_version_policy.py',
              'check_p0279_r3_explicit_portrait_owner_contract.py',
              'no tracked files', 'R3 R1'):
    need(token in F,'R3 R0 refusal evidence missing '+token)
need((R/'docs/memory/patches/P0279_R3_R1_VERSION_POLICY_REPAIR.md').exists(),
     'R3 R1 patch history missing')
print('P0279 R3 explicitly indexed portrait owner contract')
for e in errors: print('ERROR:',e)
if errors: raise SystemExit(1)
print('PASS: owner fallback only on narrow size deferral; no stock state changed; WoW UNVERIFIED')
