#!/usr/bin/env python3
"""P0507 color-only source contracts for quest-giver and service POI hierarchy."""
from pathlib import Path
import re, colorsys
root = Path(__file__).resolve().parents[1]
source = (root/'Logres/Navigation/Compass.lua').read_text()
theme = (root/'Logres/Media/Theme.lua').read_text()
assert 'poiPalette = {' in theme
match = re.search(r'questGiver = \{ (\d+\.\d+), (\d+\.\d+), (\d+\.\d+) \}', theme)
assert match, 'missing theme quest-giver tint'
gold = tuple(float(v) for v in match.groups())
assert gold == (1.00, 0.86, 0.42), gold
neutral = tuple(float(v) for v in re.search(r'other = \{ (\d+\.\d+), (\d+\.\d+), (\d+\.\d+) \}', theme).groups())
assert max(neutral)-min(neutral) < .08, neutral
block = source.split('local SERVICE_MARKER_STYLE = {',1)[1].split('\n}',1)[0]
colors = re.findall(r'^    (\w+) = \{ role = "([^"]+)", r = (\d+\.\d+), g = (\d+\.\d+), b = (\d+\.\d+) \},$', block, re.M)
assert len(colors) == 16, len(colors)
for kind, role, r, g, b in colors:
    values = tuple(map(float,(r,g,b)))
    assert max(values) <= .74 and min(values) >= .46, (kind,values)
    # Each muted service still retains a restrained recognizable hue.
    assert max(values)-min(values) >= .07, (kind,values)
    assert sum(gold)/3 > sum(values)/3 + .10, (kind,values)
assert 'questGiver=role=="poi" and questLinked' in source
assert 'local tint = candidate.questGiver and questGiverTint or otherPoiTint' in source
assert 'glyph:SetVertexColor(tint[1], tint[2], tint[3], 1)' in source
assert 'glyph:SetVertexColor(style.r, style.g, style.b, 1)' in source
assert 'paint(localPOIs,self.availableQuestPoiMarkers,poiStyle,"poi")' in source
assert 'paint(services,self.serviceMarkers,poiStyle,"service")' in source
assert 'paint(majorQuests,self.questDestinationMarkers,questStyle,"quest")' in source
for token in ('glyph:SetSize((roleStyle.width or 9)*scale,',
              'glyph:SetPoint("CENTER", self.frame, "CENTER", candidate.x, TAPE_Y)',
              'glyph:SetAlpha((roleStyle.alpha or 0.90)',
              'glyph:SetTexture(compassAssets.localPOI)',
              'reserveMarkerBearing(candidate.x, markerWidth, occupied)',
              'self.dbHistoricalQuestExcluded = self.dbHistoricalQuestExcluded + 1'):
    assert token in source, token
assert 'localPOI = { width = 9, height = 9, alpha = 0.90 }' in theme
assert 'questDestination = { width = 10, height = 18, alpha = 0.96 }' in theme
import re
boot = (root/'Logres/Core/Bootstrap.lua').read_text()
toc = (root/'Logres/Logres.toc').read_text()
assert re.search(r'Logres\.VERSION = "([^"]+)"',boot)[1] == re.search(r'## Version: (\S+)',toc)[1]
assert '| L-060 |' in (root/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
print('P0507 PASS: stronger quest-giver gold, muted service hues, neutral POIs, geometry/source preserved')
