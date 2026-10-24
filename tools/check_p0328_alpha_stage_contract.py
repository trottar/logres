#!/usr/bin/env python3
"""P0328 guarded internal staging preflight and alpha preparation contract."""
from pathlib import Path
import hashlib
import importlib.util
import io
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / 'tools/stage_alpha_candidate.py'
spec = importlib.util.spec_from_file_location('p0328_alpha_stage', MODULE)
assert spec and spec.loader
stage = importlib.util.module_from_spec(spec)
spec.loader.exec_module(stage)


def need(value, msg):
    if not value: raise AssertionError(msg)


def fixture(root):
    addon = root / 'Logres'
    (addon / 'Core').mkdir(parents=True)
    (addon / 'Media' / 'Action').mkdir(parents=True)
    (addon / 'Camera').mkdir(parents=True)
    (addon / 'Logres.toc').write_text(
        '## Interface: 16001\n## Version: 1.2.3-local\n## OptionalDeps: QuestieDB\n'
        'Core\\Bootstrap.lua\nCore\\Example.lua\n', encoding='utf-8')
    (addon / 'Core' / 'Bootstrap.lua').write_text('Logres.VERSION = "1.2.3-local"\n', encoding='utf-8')
    (addon / 'Core' / 'Example.lua').write_text('return 1\n', encoding='utf-8')
    (addon / 'Media' / 'Action' / 'frame.tga').write_bytes(b'illustrative-binary')
    (addon / 'Camera' / 'LIBCAMERA_NOTICE.txt').write_text('LibCamera attribution\n', encoding='utf-8')
    (addon / 'QuestieDB').mkdir()
    (addon / 'QuestieDB' / 'provider.lua').write_text('must not ship\n', encoding='utf-8')
    (root / 'tools').mkdir()
    (root / 'tools' / 'developer.py').write_text('must not ship\n', encoding='utf-8')
    return addon


with tempfile.TemporaryDirectory(prefix='p0328-stage-contract-') as tmp:
    root = Path(tmp)
    addon = fixture(root)
    metadata, rows = stage.stage(root)
    need(metadata['OptionalDeps'] == 'QuestieDB' and len(rows) == 5,
         'staging inventory must contain TOC, both Lua, media, attribution')
    b1 = stage.build_bytes(metadata, rows)
    b2 = stage.build_bytes(metadata, rows)
    need(b1 == b2 and hashlib.sha256(b1).digest() == hashlib.sha256(b2).digest(),
         'archive not deterministic')
    with zipfile.ZipFile(io.BytesIO(b1)) as z:
        files = set(z.namelist())
        need(files == {n for n, _ in rows} | {'Logres/INTERNAL_STAGING_NOTICE.txt'},
             'incorrect staging membership')
        need('Logres/Camera/LIBCAMERA_NOTICE.txt' in files and
             'Logres/Logres.toc' in files and 'Logres/Media/Action/frame.tga' in files,
             'runtime resources or attribution missing')
        need(not any(x.startswith(('QuestieDB/', 'Logres/QuestieDB/', 'tools/', 'docs/'))
                     for x in files), 'upstream provider or repository tooling bundled')
        need(z.read('Logres/INTERNAL_STAGING_NOTICE.txt') == stage.STAMP,
             'internal-only distribution status omitted')
    output = root / 'dist' / 'internal.zip'
    stage.stage(root, output)
    need(output.read_bytes() == b1, 'written package differs from modeled bytes')
    try: stage.stage(root, output)
    except ValueError: pass
    else: raise AssertionError('overwriting existing staging ZIP accepted')
    toc = addon / 'Logres.toc'
    valid = toc.read_text(encoding='utf-8')
    for bad in (valid + 'Core\\Example.lua\n',
                valid.replace('Core\\Example.lua', '..\\secret.lua'),
                valid.replace('OptionalDeps: QuestieDB', 'Dependencies: QuestieDB'),
                valid.replace('Version: 1.2.3-local', 'Version: 1.2.4-local')):
        toc.write_text(bad, encoding='utf-8')
        try: stage.collect(root)
        except ValueError: pass
        else: raise AssertionError('unsafe or inconsistent TOC accepted')
    toc.write_text(valid, encoding='utf-8')
    (addon / 'Media' / 'Action' / 'frame.tga').unlink()
    (addon / 'Media' / 'Action' / 'frame.tga').symlink_to(addon / 'Core' / 'Example.lua')
    try: stage.collect(root)
    except ValueError: pass
    else: raise AssertionError('symlinked media accepted')

# Real repository source-level assertions; no ZIP is written here.
metadata, rows, count = stage.collect(ROOT)
need(count == 94, 'current 94-loaded-source ownership inventory drift')
need(metadata['OptionalDeps'] == 'QuestieDB', 'optional provider became mandatory')
need(any(name.endswith('LIBCAMERA_NOTICE.txt') for name, _ in rows),
     'third-party attribution omitted')
need(not any(name.startswith(('QuestieDB/', 'tools/', 'docs/')) for name, _ in rows),
     'source staging includes repository/provider')
need(not any((ROOT / p).is_file() for p in ('LICENSE', 'LICENSE.md', 'COPYING')),
     'project license readiness needs reassessment and memory update')
need('dist/' in (ROOT / '.gitignore').read_text(encoding='utf-8'),
     'staging destination is not git-ignored')

for path in ('docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md',
             'docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md',
             'docs/memory/evidence/P0328_ALPHA_STAGE_READINESS.md',
             'docs/memory/patches/P0328_ALPHA_STAGE_READINESS.md'):
    s = (ROOT / path).read_text(encoding='utf-8')
    need('P0328' in s and ('UNVERIFIED' in s or 'NOT APPROVED' in s),
         'runtime/release deferral absent: ' + path)
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'text hygiene: ' + path)
current = (ROOT / 'docs/memory/CURRENT.md').read_text(encoding='utf-8')
for name in ('## Active Objective', '## Current Work Item', '## Verified State',
             '## Next Action', '## Success Criteria',
             '## Do Not Reopen Without New Evidence', '## Relevant References'):
    need(current.splitlines().count(name) == 1, 'CURRENT headings drift: ' + name)
need('P0328' in current and 'P0327' in current and 'P0321' in current,
     'checkpoint continuity missing')
launch = (ROOT / 'docs/memory/roadmap/LAUNCH_READINESS.md').read_text(encoding='utf-8')
need('P0328' in launch and 'November 4' in launch,
     'launch road map missing A0/A3 checkpoint')
runbook = (ROOT / 'docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md').read_text(encoding='utf-8')
for token in ('Gossip Stock Status', 'Gossip Stock Toggle', 'Native Service Frame Audit',
              'Native NPC Services Check', 'Native Auto Position (TEST)', 'PASS',
              'FAIL', 'DEFERRED', 'UNREPRODUCED', 'Quest 237'):
    need(token in runbook, 'runbook missing validation contract: ' + token)
toc = (ROOT / 'Logres/Logres.toc').read_text(encoding='utf-8')
need('stage_alpha_candidate.py' not in toc and 'check_p0328_alpha_stage_contract.py' not in toc,
     'internal tools must never enter addon load path')
print('P0328 internal alpha staging and November 4 validation contract')
print('PASS: deterministic internal ZIP, optional dependency isolation, copyright notice,')
print('      unsafe-source rejection, release-blocker reporting, and scope continuity')
