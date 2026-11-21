#!/usr/bin/env python3
"""P0508: bold quest gold / subdued services via RGB art, exact original alpha."""
from pathlib import Path
import hashlib, re
R=Path(__file__).resolve().parents[1]
ART=R/'Logres/Media/Compass'

def tga(name):
    data=(ART/name).read_bytes()
    assert len(data)>=18, name
    assert data[1:3]==bytes((0,2)) and data[16]==32 and data[17]==8, name
    w=int.from_bytes(data[12:14],'little')
    h=int.from_bytes(data[14:16],'little')
    assert (w,h)==(36,36), (name,w,h)
    start=18+data[0]
    pixels=data[start:start+w*h*4]
    assert len(pixels)==w*h*4, name
    assert len(data)-(start+w*h*4) in (0,26), name
    return [pixels[i:i+4] for i in range(0,len(pixels),4)]
base=tga('compass_local_poi.tga')
quest=tga('compass_local_poi_quest.tga')
service=tga('compass_local_poi_service.tga')
assert [p[3] for p in base]==[p[3] for p in quest]==[p[3] for p in service]
# RGB has been genuinely replaced; a vertex-only tint on old brown art
# is not sufficient to pass this regression.
assert quest!=base and service!=base and quest!=service
visible=[i for i,p in enumerate(base) if p[3]>128]
q=sum((quest[i][2]+quest[i][1])/2 for i in visible)/len(visible)
s=sum((service[i][2]+service[i][1])/2 for i in visible)/len(visible)
assert q>s*1.20,(q,s)
assert sum(quest[i][2]>quest[i][0]*1.4 for i in visible)>len(visible)*.80
assert sum(max(service[i][0:3])-min(service[i][0:3])<8 for i in visible)>len(visible)*.95
source=(R/'Logres/Navigation/Compass.lua').read_text()
theme=(R/'Logres/Media/Theme.lua').read_text()
for name in ('questGiverPOI','servicePOI'):
    assert name+' = MEDIA_ROOT ..' in theme
    assert 'compassAssets.'+name+' or compassAssets.localPOI' in source
assert 'elseif role == "poi" and candidate.questGiver then' in source
assert 'elseif role == "poi" then' in source
for invariant in (
    'glyph:SetTexture(compassAssets.localPOI)',
    'glyph:SetSize((roleStyle.width or 9)*scale,',
    'glyph:SetPoint("CENTER", self.frame, "CENTER", candidate.x, TAPE_Y)',
    'glyph:SetAlpha((roleStyle.alpha or 0.90)',
    'glyph:SetVertexColor(style.r, style.g, style.b, 1)',
    'glyph:SetVertexColor(tint[1], tint[2], tint[3], 1)',
    'questGiver=role=="poi" and questLinked',
    'paint(localPOIs,self.availableQuestPoiMarkers,poiStyle,"poi")',
    'paint(services,self.serviceMarkers,poiStyle,"service")',
): assert invariant in source,invariant
boot=(R/'Logres/Core/Bootstrap.lua').read_text()
toc=(R/'Logres/Logres.toc').read_text()
assert re.search(r'Logres\.VERSION = "([^"]+)"',boot)[1]==re.search(r'## Version: (\S+)',toc)[1]
assert '| L-060 |' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
print('P0508 PASS: exact alpha/geometry, stronger gold over neutral art, muted service, no source change')
