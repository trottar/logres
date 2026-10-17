#!/usr/bin/env python3
# P0228 stable structural contract; no historical hard-coded runtime versions.
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
toc=(R/'Logres/Logres.toc').read_text()
bootstrap=(R/'Logres/Core/Bootstrap.lua').read_text()
probe=(R/'Logres/Navigation/QuestieDBLocationProbe.lua').read_text()
cmd=(R/'Logres/Core/Commands.lua').read_text()
errors=[]
if toc.count('## OptionalDeps: QuestieDB')!=1: errors.append('missing optional dependency load ordering')
if '## RequiredDeps: QuestieDB' in toc or '## Dependencies: QuestieDB' in toc: errors.append('QuestieDB must not be a hard dependency')
meta=re.search(r'(?m)^## Version: (\S+)$',toc)
version=re.search(r'Logres\.VERSION = "([^"]+)"',bootstrap)
if not meta or not version or meta.group(1)!=version.group(1): errors.append('TOC and Bootstrap versions differ')
for token in ['addonFacts(self)', 'GetAddOnInfo', 'IsAddOnLoaded','GetAddOnMetadata', '"X-Flavor"', '"X-Mode"', 'db.RequireContract', 'self.mode == "baked"', 'self.mode == "source"', 'sourceExpansion', 'ordinary(self.addonFlavor, "string")', 'self.positive = "deferred"', 'self.negative = acceptedQuestNegative(nav)']:
    if token not in probe: errors.append('missing provider diagnostic: '+token)
if probe.index('if not db then',probe.index('function Probe:CaptureManual')) > probe.index('if uiMap ~= LOCH_MODAN_UI_MAP'): errors.append('provider compatibility still gated behind map/gossip')
if 'expansion:lower()' in probe: errors.append('Source-only expansion proof still used for Baked')
for token in ['registered=%s', 'loaded=%s', 'tocFlavor=%s', 'tocMode=%s', 'mode=%s']:
    if token not in cmd: errors.append('command does not report '+token)
print('P0228 QuestieDB optional/provider contract')
print('========================================')
for e in errors: print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAILED: {len(errors)} errors')
raise SystemExit(bool(errors))
