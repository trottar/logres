#!/usr/bin/env python3
"""P0231: map ancestry diagnostics must stay ordinary/bounded and panel-visible."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
s=(R/'Logres/Navigation/QuestieDBNearby.lua').read_text()
c=(R/'Logres/Core/Commands.lua').read_text()
t=(R/'Logres/Logres.toc').read_text()
b=(R/'Logres/Core/Bootstrap.lua').read_text()
errors=[]
for term in ['MAX_MAP_PARENT_DEPTH = 12', 'local leaf, chain, seen = current, {}, {}',
 'table.concat(chain, ">")','self.requestedMap = leaf', 'self.mapTrace = chain',
 'self.mappingEntries = count or 0','self.resolutionFailure = failure',
 'requestedMap = self.requestedMap', 'mapTrace = self.mapTrace',
 'mappingEntries = self.mappingEntries', 'resolutionFailure = self.resolutionFailure',
 'self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")',
 'return nil, nil, "map-not-in-provider-zone-table", leaf',
 'if mapping[current] then','local parent = number(info.parentMapID)',
 'return count >= 40 and result or nil, count']:
 if term not in s:errors.append('module missing '+term)
for term in ['nearby:StartIndex("panel-map-diagnostic")', 'Logres questiedbmap: requested=%s chain=%s entries=%s failure=%s trigger=%s']:
 if term not in c: errors.append('panel missing '+term)
if any(x in s for x in ('loadstring','C_Timer','GetChildren','EnumeratePins')):
 errors.append('unsupported source path introduced')
if '## OptionalDeps: QuestieDB' not in t: errors.append('optional dependency missing')
a=re.search(r'(?m)^## Version: (\S+)$',t);z=re.search(r'Logres.VERSION = "([^"]+)"',b)
if not a or not z or a.group(1)!=z.group(1):errors.append('version mismatch')
print('P0231 map trace contract')
for err in errors: print('ERROR:',err)
print('PASS: 0 errors' if not errors else 'FAIL: '+str(len(errors)))
raise SystemExit(bool(errors))
