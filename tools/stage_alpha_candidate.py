#!/usr/bin/env python3
"""Internal-only, deterministic Logres AddOns staging preflight.

No production code, installations, saved data or upstream dependencies are changed.
A successful stage is NOT permission to distribute or evidence of WoW runtime PASS.
"""
from __future__ import annotations
import argparse
import hashlib
import pathlib
import re
import sys
import zipfile

ART_EXTENSIONS = {'.tga', '.blp', '.png', '.jpg', '.jpeg', '.ttf', '.otf'}
NOTICE = 'Logres/Camera/LIBCAMERA_NOTICE.txt'
STAMP = b'INTERNAL DEVELOPMENT STAGING ONLY - NOT A PUBLIC RELEASE\nWoW runtime, client compatibility, licensing and distribution gates remain unverified.\n'


def fail(message):
    raise ValueError(message)


def safe_file(addon: pathlib.Path, relative: pathlib.PurePosixPath):
    if relative.is_absolute() or not relative.parts or any(
            x in ('', '.', '..') for x in relative.parts):
        fail('unsafe TOC/media path: ' + str(relative))
    path = addon.joinpath(*relative.parts)
    if any(x.is_symlink() for x in (path, *path.parents) if x != addon.parent):
        fail('symlink path refused: ' + str(relative))
    if not path.is_file() or not path.resolve().is_relative_to(addon.resolve()):
        fail('missing or outside addon: ' + str(relative))
    if path.stat().st_size > 64 * 1024 * 1024:
        fail('oversized staged file: ' + str(relative))
    return path


def collect(root: pathlib.Path):
    root = root.resolve()
    addon = root / 'Logres'
    toc = safe_file(addon, pathlib.PurePosixPath('Logres.toc'))
    text = toc.read_text(encoding='utf-8')
    metadata = {}
    entries = []
    for raw in text.splitlines():
        line = raw.strip()
        if line.startswith('## '):
            match = re.fullmatch(r'## ([A-Za-z]+):\s*(.*)', line)
            if match:
                if match.group(1) in metadata: fail('duplicate TOC metadata ' + match.group(1))
                metadata[match.group(1)] = match.group(2)
        elif line and not line.startswith('#'):
            if '/' in line or re.search(r'(^|\\)\.\.?($|\\)', line):
                fail('unsafe or noncanonical TOC path: ' + line)
            relative = pathlib.PurePosixPath(line.replace('\\', '/'))
            if relative.suffix.lower() != '.lua': fail('unexpected TOC entry: ' + line)
            entries.append(relative)
    if not entries or len(entries) != len(set(entries)):
        fail('missing or duplicate TOC entries')
    if not re.fullmatch(r'[0-9]+', metadata.get('Interface', '')):
        fail('invalid interface metadata')
    version = metadata.get('Version', '')
    if not version or not re.fullmatch(r'[0-9A-Za-z][0-9A-Za-z._+-]*', version):
        fail('invalid or missing version metadata')
    if metadata.get('OptionalDeps') != 'QuestieDB':
        fail('optional QuestieDB declaration drift')
    bootstrap = safe_file(addon, pathlib.PurePosixPath('Core/Bootstrap.lua'))
    match = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', bootstrap.read_text(encoding='utf-8'))
    if not match or version != match.group(1): fail('TOC / Bootstrap runtime version mismatch')
    files = {pathlib.PurePosixPath('Logres.toc'): toc,
             pathlib.PurePosixPath(NOTICE).relative_to('Logres'): safe_file(addon, pathlib.PurePosixPath(NOTICE).relative_to('Logres'))}
    for name in entries:
        files[name] = safe_file(addon, name)
    media = addon / 'Media'
    if not media.is_dir() or media.is_symlink(): fail('missing or symlinked Media directory')
    for path in sorted(media.rglob('*')):
        if path.is_symlink(): fail('media symlink refused: ' + str(path))
        if path.is_file() and path.suffix.lower() in ART_EXTENSIONS:
            relative = pathlib.PurePosixPath(path.relative_to(addon).as_posix())
            files[relative] = safe_file(addon, relative)
    if not any(p.suffix.lower() in ART_EXTENSIONS for p in files):
        fail('no packaged media assets')
    rows = sorted((('Logres/' + p.as_posix(), path.read_bytes()) for p, path in files.items()),
                  key=lambda row: row[0])
    if len(rows) != len(files): fail('duplicate archive path')
    return metadata, rows, len(entries)


def build_bytes(metadata, rows):
    import io
    data = io.BytesIO()
    with zipfile.ZipFile(data, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name, content in [*rows, ('Logres/INTERNAL_STAGING_NOTICE.txt', STAMP)]:
            info = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            archive.writestr(info, content, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
    return data.getvalue()


def stage(root: pathlib.Path, output: pathlib.Path | None = None):
    root = root.resolve()
    metadata, rows, lua_count = collect(root)
    print(f'P0328 INTERNAL PREFLIGHT PASS: interface={metadata["Interface"]} '
          f'version={metadata["Version"]} lua={lua_count} staged_files={len(rows) + 1}')
    print('QuestieDB: optional / not bundled')
    print('LibCamera: attribution notice retained')
    if not any((root / x).is_file() for x in ('LICENSE', 'LICENSE.md', 'COPYING')):
        print('PUBLIC RELEASE BLOCKER: project redistribution/license decision unresolved')
    print('PUBLIC RELEASE BLOCKER: Forever runtime and alpha release gates not verified')
    if output is not None:
        if (root / 'dist').is_symlink(): fail('symlinked dist destination refused')
        parent = (root / 'dist').resolve()
        if not parent.is_relative_to(root): fail('dist cannot leave repository')
        destination = output.resolve()
        if destination.parent != parent or destination.suffix != '.zip':
            fail('output must be a .zip directly under ignored dist/')
        if destination.exists(): fail('output exists; refusing overwrite')
        parent.mkdir(parents=True, exist_ok=True)
        blob = build_bytes(metadata, rows)
        with zipfile.ZipFile(__import__('io').BytesIO(blob)) as archive:
            expect = {name for name, _ in rows} | {'Logres/INTERNAL_STAGING_NOTICE.txt'}
            if set(archive.namelist()) != expect or archive.testzip() is not None:
                fail('internal archive verification failed')
        destination.write_bytes(blob)
        print(f'INTERNAL ZIP: {destination} SHA-256 {hashlib.sha256(blob).hexdigest()}')
    return metadata, rows


def main():
    parser = argparse.ArgumentParser(description='Logres internal staging, NOT public release packaging')
    parser.add_argument('--root', type=pathlib.Path, default=pathlib.Path(__file__).resolve().parents[1])
    parser.add_argument('--check', action='store_true', help='read-only preflight (default)')
    parser.add_argument('--output', type=pathlib.Path, help='explicit ignored dist/*.zip destination; no overwrite')
    args = parser.parse_args()
    if args.check and args.output is not None:
        parser.error('--check and --output cannot be combined')
    try: stage(args.root, args.output)
    except (ValueError, OSError, UnicodeError, zipfile.BadZipFile) as exc:
        print('P0328 PRECHECK FAIL: ' + str(exc), file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
