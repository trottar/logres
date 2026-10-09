#!/usr/bin/env python3
from pathlib import Path
R=Path(__file__).resolve().parents[1]
s=(R/'Logres/HUD/StatusAuras.lua').read_text(encoding='utf-8')
n=(R/'Logres/HUD/NativeDebuffs.lua').read_text(encoding='utf-8')
errors=[]
if 'INCLUDE_NAME_PLATE_ONLY' in s:errors.append('failed P0182 filter still active')
if 'HARMFUL' not in s or 'frame:AddAuraGroup("LogresHarmful", "HARMFUL", {' not in n:
    errors.append('P0183 native harmful replacement missing')
if 'renderLane(self.lanes.target, snapshot.harmfulRows, active and not useNative)' not in s:
    errors.append('legacy harmful fallback not retained')
print('P0182 superseded nameplate-only filter regression')
if errors:
    for e in errors:print('ERROR:',e)
    raise SystemExit(1)
print('PASS: 0 errors')
