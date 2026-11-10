#!/usr/bin/env python3
"""P0427 focused source-backed identity and role formatting; no provider changes."""
from pathlib import Path
import re, math
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text()
C=read('Logres/Navigation/Compass.lua')
N=read('Logres/Navigation/QuestieDBNearby.lua')
S=read('Logres/Navigation/NavigationSourceProbe.lua')
B=read('Logres/Core/Bootstrap.lua')
T=read('Logres/Logres.toc')
assert 'local function focusedIdentity(name, role)' in C
assert 'if isSecret(name) or isSecret(role)' in C
assert 'type(name) ~= "string"' in C and 'not string.find(name, "%S")' in C
assert 'return name .. " [" .. role .. "]"' in C
assert 'label:SetText(name .. " - " .. text)' in C
assert 'name=focusedIdentity(row.name, identityRole)' in C
assert '"Quest destination [quest]", 125, 0' in C
assert 'name = "Waypoint [waypoint]", kind = "waypoint"' in C
assert 'role = "profession"' in C and 'role = "repair"' in C
assert '"distance unavailable"' in C and 'math.floor(yards + 0.5)' in C
assert 'Possible repair:' not in C and 'Possible quest giver:' not in C
assert 'nativeCurrentQuestOffers[row.questID] == true' in C
assert 'self.dbHistoricalQuestExcluded = self.dbHistoricalQuestExcluded + 1' in C
assert 'local cap=row.potential == true and 50' in C
assert 'reserveMarkerBearing(candidate.x, markerWidth, occupied)' in C
assert 'glyph:SetVertexColor(style.r, style.g, style.b, 1)' in C
assert 'distanceYards = dist, potential = true' in N
assert 'self:ReadNativeOfferFeeds()' in S
assert re.search(r'(?m)^## Version: (\S+)$',T).group(1)==re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B).group(1)
for role in ('quest','repair','profession','point of interest','waypoint'):
    def demo(name,distance):
        if not isinstance(name,str) or not name.strip():return None
        display=(f'{math.floor(distance+0.5)} yd' if isinstance(distance,(float,int)) and not isinstance(distance,bool) and math.isfinite(distance) and distance>=0 else 'distance unavailable')
        return f'{name} [{role}] - {display}'
    assert demo('Example',13.5)==f'Example [{role}] - 14 yd'
    assert demo('Example',None)==f'Example [{role}] - distance unavailable'
    assert demo('',25) is None
assert len(read('docs/memory/CURRENT.md').encode())<9800
assert 'P0427' in read('docs/memory/CURRENT.md')
for p in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
    assert any(line.startswith("## P0427 —") for line in read(p).splitlines()),p
assert '| L-043 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
print('P0427 PASS: label roles, secret-safe name, distance fallback and existing provider/eligibility seams preserved')
