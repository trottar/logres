#!/usr/bin/env python3
"""Sheet-12 gated compass-role artwork, preview isolation and version contract."""
from pathlib import Path
import hashlib,re
ROOT=Path(__file__).resolve().parents[1]
C=(ROOT/'Logres/Navigation/Compass.lua').read_text()
T=(ROOT/'Logres/Media/Theme.lua').read_text()
D=(ROOT/'Logres/Core/Commands.lua').read_text()
V=(ROOT/'Logres/Core/Bootstrap.lua').read_text()
TOC=(ROOT/'Logres/Logres.toc').read_text()
errors=[]
HASHES={'compass_local_poi.tga': '4fd5c2550e4003c1abd505f7cf8be6e39680ecd2b477095affdc7c148a2fb512', 'compass_tracking.tga': '338255bebd024822ca35943fae1323d3bf9bbebf01aac11143f724acb3e6f581', 'compass_quest_destination.tga': '283d209ad2da89bac9351783b81d3bb753f188b7543cdf32cd57899e74970037'}
for f,h in HASHES.items():
    path=ROOT/'Logres/Media/Compass'/f
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest()!=h: errors.append('missing/mismatched approved compass glyph '+f)
for v in ('questDestination','localPOI','tracking'):
    if v+' = {' not in T:errors.append('Theme lacks role '+v)
    if 'compass_'+({'questDestination':'quest_destination','localPOI':'local_poi','tracking':'tracking'}[v])+'.tga' not in T:errors.append('Theme lacks glyph path '+v)
for phrase in ('function Compass:SetArtworkPreview(enabled)','function Compass:UpdateArtworkPreview()','self:UpdateArtworkPreview()','self.artworkPreviewShown','artworkPreview = self.artworkPreview == true','artworkPreviewShown = self.artworkPreviewShown == true'):
    if phrase not in C:errors.append('Compass missing '+phrase)
for phrase in ('compassartpreview','Compass Art ON','Compass Art OFF','compassArtOn','compassArtOff'):
    if phrase not in D:errors.append('panel command missing '+phrase)
for forbid in ('C_QuestLog.','C_SuperTrack.','C_AreaPoiInfo.','C_Minimap.GetTrackingInfo','SetUserWaypoint','C_Timer.NewTicker('):
    if forbid in C:errors.append('unproven source/mutation in compass '+forbid)
a=re.search(r'Logres\.VERSION = "([^"]+)"',V)
b=re.search(r'^## Version: (.+)$',TOC,re.M)
if not a or not b or a.group(1)!=b.group(1).strip(): errors.append('version mismatch')
print('Logres H.3 compass sheet-12 role art')
print('=================================')
for x in errors:print('ERROR:',x)
print('PASS: 0 errors' if not errors else f'FAILED: {len(errors)} errors')
raise SystemExit(bool(errors))
