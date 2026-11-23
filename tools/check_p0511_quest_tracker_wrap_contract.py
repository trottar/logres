#!/usr/bin/env python3
"""P0511: plain quest divider + five-line dynamic objective-row contract."""
from pathlib import Path
import hashlib, re, subprocess, shutil, os
R=Path(__file__).resolve().parents[1]
a=(R/'Logres/Quest/ActiveQuest.lua').read_text()
t=(R/'Logres/Media/Theme.lua').read_text()
blob=(R/'Logres/Media/Quest/active_quest_divider.tga').read_bytes()
plain=(R/'Logres/Media/Quest/active_quest_divider_plain.tga').read_bytes()
assert hashlib.sha256(blob).hexdigest()=='c2f44face9c4c0fada6c50d29f4d98f94435005d8bf0f7dd519fc92ec710d9f1'
def tga_pixel(data,x,y):
 assert data[0]==0 and data[1]==0 and data[2]==2 and data[16]==32
 assert (int.from_bytes(data[12:14],"little"), int.from_bytes(data[14:16],"little"))==(256,16)
 return data[18+4*(y*256+x):18+4*(y*256+x+1)]
for yy in range(16):
 for xx in range(256):
  if xx<119 or xx>137:
   assert tga_pixel(blob,xx,yy)==tga_pixel(plain,xx,yy), (xx,yy)
  else:
   assert tga_pixel(plain,xx,yy)==tga_pixel(blob,115,yy), (xx,yy)
assert tga_pixel(blob,128,8)!=tga_pixel(plain,128,8)
assert r'Quest\\active_quest_divider.tga' in t
assert 'dividerPlain = MEDIA_ROOT' in t and r'Quest\\active_quest_divider_plain.tga' in t
assert 'activeAssets.dividerPlain' in a
assert 'local MAX_OBJECTIVE_LINES = 5' in a
assert 'local MAX_OBJECTIVE_TEXT_HEIGHT = MAX_OBJECTIVE_LINES * OBJECTIVE_LINE_HEIGHT + 2' in a
assert 'label:SetWordWrap(true)' in a
assert 'label:SetMaxLines(MAX_OBJECTIVE_LINES)' in a
assert 'if type(label.SetMaxLines) == "function" then' in a
assert 'visual.label:SetHeight(maxTextHeight)' in a
assert 'math.ceil(MAX_OBJECTIVE_LINES * lineHeight + 2)' in a
assert 'visual.label:GetStringHeight()' in a
assert 'if not isSecret(measured) and type(measured) == "number"' in a
assert 'local actualRowHeight = math.max(minRowHeight, textHeight + 24)' in a
assert 'visual.hit:ClearAllPoints()' in a
assert 'rowOffset = rowOffset + actualRowHeight + rowGap' in a
assert 'local rowsHeight = visibleCount > 0 and rowOffset - rowGap or 0' in a
assert 'local rowHeight = styleValue("rowHeight")' in a # initial frame contract preserved
assert 'label:SetWordWrap(false)' not in a
boot=(R/'Logres/Core/Bootstrap.lua').read_text();toc=(R/'Logres/Logres.toc').read_text()
assert re.search(r'Logres.VERSION = "([^"]+)"',boot)[1]==re.search(r'## Version: (\S+)',toc)[1]
led=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
for key in ('| L-022 |','| L-039 |','| L-030 |'): assert key in led
engine=os.environ.get('LOGRES_LUA') or shutil.which('lua5.4') or shutil.which('lua')
if engine: subprocess.run([engine,str(R/'tools/test_p0511_tracker_wrap.lua'),str(R)],check=True,cwd=R)
print('P0511 PASS: original art retained, center ornament removed, objective wrap up to five lines with dynamic rows')
