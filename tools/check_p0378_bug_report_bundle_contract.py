#!/usr/bin/env python3
"""P0378: local Forever diagnostic ZIP, screenshot and ID correlation fixtures."""
from pathlib import Path
import importlib.util
import json
import os
import re
import tempfile
import zipfile

R = Path(__file__).resolve().parents[1]
source = (R/'tools/export_panel_diagnostics.py').read_text(encoding='utf-8')
assert "LIVE_PATTERN = '_forever_/WTF/Account/*/SavedVariables/Logres.lua'" in source
for marker in ('def export(', 'def read_incidents(', 'def build_bundle(',
               "DEFAULT_BUNDLE = 'LOGRES_BUG_REPORT_LATEST.zip'",
               'BUG_REPORT.json', 'screenshots/', '--bundle-output',
               'SCREENSHOT_WINDOW_SECONDS = 90',
               'LIVE Forever SavedVariables copied', 'os.replace(',
               'No LIVE Forever Logres SavedVariables'):
    assert marker in source, marker
assert not re.search(r'\b0\.0\.\d+-dev\b', source)
assert '_classic_beta_/WTF/Account' not in source
spec=importlib.util.spec_from_file_location('p0378_exporter', R/'tools/export_panel_diagnostics.py')
module=importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

# Snapshot fields may include 'id', 'time' and many nested tables; only outer
# incident scalar fields may be interpreted. No evaluation of SavedVariables.
fixture = b'''LogresDiagnosticsDB = {
["journal"] = {
["incidents"] = {
{
["time"] = 1700000000,
["version"] = "future-dev",
["screenshot"] = "succeeded",
["id"] = 101,
["snapshot"] = { ["nested"] = { ["id"] = 999, ["time"] = 42 } },
["session"] = 7,
},
{
["id"] = 102,
["time"] = 1700000030,
["session"] = 7,
["context"] = { { ["fields"] = { ["time"] = 0 } } },
["screenshot"] = "succeeded",
},
{
["id"] = 103,
["time"] = 1700000100,
["session"] = 7,
["screenshot"] = "failed",
},
},
},
}
'''
parsed=module.read_incidents(fixture)
assert [v['id'] for v in parsed] == [101,102,103], parsed
assert [v['time'] for v in parsed] == [1700000000,1700000030,1700000100], parsed
assert module.read_incidents(b'LogresDiagnosticsDB = {}') == []
try:
    module.read_incidents(b'LogresDiagnosticsDB = {\n["incidents"] = {\n{ ["id"] = 3,')
except ValueError:
    pass
else:
    raise AssertionError('Truncated incident table should refuse')

with tempfile.TemporaryDirectory(prefix='p0378-bundle-fixture-') as temp:
    root=Path(temp)
    live=root/'_forever_'/'WTF'/'Account'/'Synthetic'/'SavedVariables'/'Logres.lua'
    live.parent.mkdir(parents=True)
    live.write_bytes(fixture)
    photos=root/'_forever_'/'Screenshots'
    photos.mkdir(parents=True)
    def screenshot(name, when, data):
        path=photos/name
        path.write_bytes(data)
        os.utime(path, (when,when))
        return path
    screenshot('WoWScrnShot_111423_000000.jpg',1700000002,b'JPEG-A')
    screenshot('WoWScrnShot_111423_000001.png',1700000031,b'PNG-B')
    screenshot('WoWScrnShot_UNRELATED.jpg',1700002000,b'UNRELATED')
    screenshot('OtherGame_111423.png',1700000003,b'UNRELATED-NAME')
    legacy=root/'LOGRES_DIAGNOSTICS_LATEST.lua'
    bundle=root/'LOGRES_BUG_REPORT_LATEST.zip'
    assert module.export(root,legacy)==live
    assert legacy.read_bytes()==fixture
    report=module.build_bundle(root,legacy,bundle,live)
    assert report['client']=='World of Warcraft Forever'
    assert not report['unmatched_successful_incident_ids']
    assert len(report['screenshots'])==2, report
    assert [s['incident_id'] for s in report['screenshots']]==[101,102]
    assert all(not s['exact_client_correlation'] for s in report['screenshots'])
    with zipfile.ZipFile(bundle) as z:
        assert z.testzip() is None
        assert set(z.namelist()) == {
            'LOGRES_DIAGNOSTICS_LATEST.lua','BUG_REPORT.json','README.txt',
            'screenshots/WoWScrnShot_111423_000000.jpg',
            'screenshots/WoWScrnShot_111423_000001.png',
        }, z.namelist()
        assert z.read('LOGRES_DIAGNOSTICS_LATEST.lua')==fixture
        assert z.read('screenshots/WoWScrnShot_111423_000000.jpg')==b'JPEG-A'
        assert json.loads(z.read('BUG_REPORT.json'))['schema']==1
    # A stale/absent image must not be fabricated or attributed as a match.
    for image in photos.iterdir():
        if image.name.startswith('WoWScrnShot_'):
            image.unlink()
    another=root/'without-images.zip'
    missing=module.build_bundle(root,legacy,another,live)
    assert missing['unmatched_successful_incident_ids']==[101,102]
    assert 'screenshots' not in zipfile.ZipFile(another).namelist()
    # No live source: stale legacy export is preserved and no new report created.
    live.unlink()
    before=legacy.read_bytes()
    try:
        module.export(root,legacy)
    except ValueError as e:
        assert 'No LIVE Forever' in str(e)
    else:
        raise AssertionError('beta/no-source fallback must refuse')
    assert legacy.read_bytes()==before

ledger=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text(encoding='utf-8')
for ident in ('L-002','L-005','L-020'):
    row=[line for line in ledger.splitlines() if line.startswith('| '+ident+' |')]
    assert len(row)==1 and 'P0378' in row[0], (ident,row)
for path in ('docs/memory/CURRENT.md','docs/memory/handoffs/CURRENT_HANDOFF.md',
             'docs/memory/investigations/ISSUE_REGISTER.md',
             'docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md',
             'docs/memory/evidence/P0378_BUG_REPORT_BUNDLE.md',
             'docs/memory/patches/P0378_BUG_REPORT_BUNDLE.md'):
    assert 'P0378' in (R/path).read_text(encoding='utf-8'), path
assert len((R/'docs/memory/CURRENT.md').read_bytes())<9800
assert len((R/'docs/memory/handoffs/CURRENT_HANDOFF.md').read_bytes())<8000
print('P0378 bug bundle: PASS (LOCAL FIXTURES; LIVE SCREENSHOT MATCH UNVERIFIED)')
