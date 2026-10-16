#!/usr/bin/env python3
"""Approved sheet-02 and sheet-10 asset-family fidelity/static safety contract."""
from pathlib import Path
import hashlib
ROOT=Path(__file__).resolve().parents[1]
EXPECTED={
    "Logres/Media/Bar/percentage_diamond.tga": "b26efb9bd3ba1633d2f625ffb2bf9123bf3686fe91898cf26ff87799d507f49c",
    "Logres/Media/Bar/percentage_fill.tga": "b7298d4e34a1ceb4a7dcb81308de4b8eff11bc24ffb6ff6a57c146380dfed8b4",
    "Logres/Media/Quest/active_quest_divider.tga": "c2f44face9c4c0fada6c50d29f4d98f94435005d8bf0f7dd519fc92ec710d9f1",
    "Logres/Media/Quest/active_quest_glyph.tga": "a01e82dde4ae8c176d0a7ade3ffa5af487bbdcb8918187d3ba01e05e88d48637",
    "Logres/Media/Quest/active_quest_panel.tga": "f414180c2bd354c1c879761b7c51cf91dd6210e6aea6acf086a910666c209bdc"
}
SHEETS={
    'docs/design/approved/02_resource_bar_primitive.png': '0b644dff55976f809396952d7474c22a9cd82709e17950210c3076616c895a44',
    'docs/design/approved/10_active_quest_component.png': '5083893ba708f71098a226987e7fa786d1f7756085b41971681f3574fadbef80',
}
errors=[]
for path,sha in {**EXPECTED,**SHEETS}.items():
    target=ROOT/path
    if not target.is_file(): errors.append('missing '+path); continue
    if hashlib.sha256(target.read_bytes()).hexdigest()!=sha: errors.append('asset digest mismatch '+path)
for path, (w,h) in {
    'Logres/Media/Bar/percentage_fill.tga':(64,16),
    'Logres/Media/Bar/percentage_diamond.tga':(16,16),
    'Logres/Media/Quest/active_quest_panel.tga':(512,256),
    'Logres/Media/Quest/active_quest_divider.tga':(256,16),
    'Logres/Media/Quest/active_quest_glyph.tga':(48,48),
}.items():
    target=ROOT/path
    if not target.is_file():continue
    data=target.read_bytes()
    if len(data)<18 or data[2]!=2 or data[16]!=32 or int.from_bytes(data[12:14],'little')!=w or int.from_bytes(data[14:16],'little')!=h:
        errors.append('incorrect uncompressed BGRA TGA geometry '+path)
text=(ROOT/'Logres/Media/Theme.lua').read_text(encoding='utf-8')
for term in ('theme.percentageBar = {','theme.activeQuest = {','Bar\\\\percentage_fill.tga','Bar\\\\percentage_diamond.tga','Quest\\\\active_quest_panel.tga'):
    if term not in text:errors.append('missing Theme production registry token '+term)
print('P0215 approved sheet 02/10 media contract')
if errors:
    print('\n'.join(errors))
    raise SystemExit(1)
print('PASS: 0 errors')
