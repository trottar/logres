#!/usr/bin/env python3
"""P0279 R2 — diagnostic narrowing only, previous rejection preserved."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
L=(ROOT/'Logres/Dev/MappingInspector.lua').read_text(encoding='utf-8')
A=(ROOT/'Logres/Dev/Panel.lua').read_text(encoding='utf-8')
I=(ROOT/'Logres/Quest/ServiceElementIndex.lua').read_text(encoding='utf-8')
E=(ROOT/'docs/memory/evidence/P0279_R2_PORTRAIT_OWNER_GATE.md').read_text(encoding='utf-8')
checks=[
('reason taxonomy', 'local function ownerGateFailure(owner)' in L),
('existing gate retained', 'if not eligible(owner) then return nil, ownerGateFailure(owner) end' in L),
('parent lookup remains guarded', 'local owner, hasOwner = plain(region, "GetParent")' in L),
('no parent hierarchy traversal', 'owner:GetParent(' not in L and 'owner["GetParent"]' not in L),
('no accidental parent to region', 'frame:SetParent(region)' not in L),
('addon overlay retains verified native frame owner', 'frame:SetParent(owner)' in L),
('safe anchored presentation remains', 'frame:SetAllPoints(region)' in L),
('existing M tab diagnostics preserved', 'Logres.MappingInspector.Highlight(entry.id)' in A and '"HIGHLIGHTED"' in A),
('index not removed', '"trainer.portrait"' in I and '"trainer.detailIcon"' in I),
('runtime result evidence retained', 'native-owner-unverified-or-protected' in E and 'P0279 R1' in E),
('no new polling', 'SetScript("OnUpdate"' not in L),
('no native mutations', all(tok not in L for tok in ('region:SetParent(', 'region:Hide(', 'region:SetAlpha(', 'region:SetPoint(', 'region:SetTexture(', 'owner:Hide(', 'owner:SetAlpha(', 'owner:SetParent(', 'BuyTrainerService('))),
('no secret values formatted', 'tostring(owner)' not in L and 'tostring(protected)' not in L and 'tostring(width)' not in L and 'tostring(height)' not in L),
('only guarded native methods', all(f'plain(owner, "{name}")' in L for name in ('GetObjectType','IsProtected','IsShown','GetWidth','GetHeight'))),
('coherent statuses', all('"'+x+'"' in L for x in (
 'native-owner-parent-unavailable','native-owner-reference-unavailable','native-owner-kind-unavailable',
 'native-owner-not-frame','native-owner-protection-unavailable','native-owner-protected',
 'native-owner-visibility-unavailable','native-owner-not-shown',
 'native-owner-dimensions-unavailable','native-owner-outside-size-gate'))),
]
for label,ok in checks:
    if not ok: print('ERROR:',label)
if not all(ok for _,ok in checks): raise SystemExit(1)
print('P0279 R2 portrait owner gate diagnostic: PASS; WoW UNVERIFIED')
