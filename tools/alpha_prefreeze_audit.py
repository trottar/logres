#!/usr/bin/env python3
"""Read-only P0340 A0/A3 alpha candidate inventory audit (NOT release approval).

No ZIP output, source mutation, WoW interaction, or network calls.
The separately required full static checker suite and client tests are NOT run here.
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
from pathlib import Path
import sys
import zipfile


def need(ok: bool, message: str) -> None:
    if not ok:
        raise ValueError(message)


def load_stager(root: Path):
    module_path = root / 'tools' / 'stage_alpha_candidate.py'
    spec = importlib.util.spec_from_file_location('p0340_stage_source', module_path)
    need(bool(spec and spec.loader), 'cannot load internal staging preflight')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def audit(root: Path):
    root = root.resolve()
    stage = load_stager(root)
    metadata, rows, lua_count = stage.collect(root)
    need(lua_count > 0, 'empty TOC Lua inventory')
    need(metadata.get('OptionalDeps') == 'QuestieDB', 'QuestieDB must remain optional')
    need(metadata.get('Version'), 'TOC version missing')
    media_count = sum(name.startswith('Logres/Media/') and
                      Path(name).suffix.lower() in stage.ART_EXTENSIONS for name, _ in rows)
    expected = {name for name, _ in rows} | {'Logres/INTERNAL_STAGING_NOTICE.txt'}
    need(len(expected) == len(rows) + 1, 'duplicate internal ZIP member / notice collision')
    need('Logres/Camera/LIBCAMERA_NOTICE.txt' in expected, 'LibCamera attribution lost')
    need(not any(path.startswith(('QuestieDB/', 'Logres/QuestieDB/', 'tools/', 'docs/'))
                 for path in expected), 'external QuestieDB or internal tools bundled')
    need((root / '.gitignore').is_file() and 'dist/' in (root / '.gitignore').read_text(encoding='utf-8'),
         'dist/ not excluded from Git')
    for name, content in rows:
        need(name.startswith('Logres/') and isinstance(content, bytes),
             'unsafe or nonbinary stage member: ' + str(name))

    blob = stage.build_bytes(metadata, rows)
    need(blob == stage.build_bytes(metadata, rows), 'internal ZIP not deterministic')
    with zipfile.ZipFile(io.BytesIO(blob)) as archive:
        members = archive.namelist()
        need(len(members) == len(expected) and set(members) == expected,
             'internal ZIP manifest missing or containing extra files')
        need(archive.testzip() is None, 'internal ZIP CRC check failed')
        for name, content in rows:
            need(archive.read(name) == content, 'staged source bytes differ: ' + name)
        need(archive.read('Logres/INTERNAL_STAGING_NOTICE.txt') == stage.STAMP,
             'internal-only staging notice missing or modified')

    readme = (root / 'README.md').read_text(encoding='utf-8')
    deps = (root / 'docs/DEPENDENCIES.md').read_text(encoding='utf-8')
    need('does not yet add database compass icons' not in readme,
         'README erroneously claims QuestieDB is diagnostic-only')
    for item in ('QuestieDB', 'optional', 'docs/DEPENDENCIES.md', 'INTERNAL', 'not approved'):
        need(item in readme, 'README installation/release disclosure missing: ' + item)
    for item in ('QuestieDB-Forever.zip', 'sha256sum -c -', 'optional'):
        need(item in deps.lower() if item == 'optional' else item in deps,
             'dependency install policy missing: ' + item)

    # Report release readiness honestly. Absence of a root LICENSE cannot be
    # converted into a passing public-distribution gate by a build artifact.
    license_present = any((root / p).is_file() for p in ('LICENSE', 'LICENSE.md', 'COPYING'))
    result = {
        'version': metadata['Version'],
        'lua_count': lua_count,
        'media_count': media_count,
        'stage_members': len(expected),
        'stage_sha256': hashlib.sha256(blob).hexdigest(),
        'license_present': license_present,
        'client_tested': False,
        'public_approved': False,
    }
    return result


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    try:
        result = audit(root)
    except (ValueError, OSError, UnicodeError, zipfile.BadZipFile) as exc:
        print('P0340 PREFREEZE INVENTORY FAIL: ' + str(exc), file=sys.stderr)
        return 1
    print('P0340 INTERNAL INVENTORY PASS (read-only; no ZIP written)')
    print(f'  version={result["version"]} lua={result["lua_count"]} '
          f'media={result["media_count"]} internal_members={result["stage_members"]}')
    print(f'  deterministic_internal_sha256={result["stage_sha256"]}')
    print('  optional QuestieDB excluded; LibCamera notice retained; staging bytes verified')
    print('  SOURCE CHECK ONLY: full tools/check_*.py suite must pass separately')
    print('  WoW installation, behavior, P0321 restoration and beta access: UNVERIFIED')
    print('  L-019 project redistribution license: ' +
          ('PRESENT / human approval still required' if result['license_present'] else 'MISSING / BLOCKER'))
    print('  PUBLIC RELEASE: NOT APPROVED')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
