#!/usr/bin/env python3
"""Export live Forever diagnostics and an attachable Report Bug evidence ZIP.

The client saves diagnostics at /reload or logout and screenshots in Screenshots/.
This read-only exporter never probes in-game state or claims screenshots can be
read from Lua. File modification times provide *inferred*, not guaranteed,
correlation with saved Report Bug incident times.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
from zoneinfo import ZoneInfo
import hashlib
import json
import os
from pathlib import Path
import re
import sys
import tempfile
import zipfile

DEFAULT_WOW_ROOT = Path('/mnt/c/Program Files (x86)/World of Warcraft')
LIVE_PATTERN = '_forever_/WTF/Account/*/SavedVariables/Logres.lua'
DEFAULT_OUTPUT = 'LOGRES_DIAGNOSTICS_LATEST.lua'
DEFAULT_BUNDLE = 'LOGRES_BUG_REPORT_LATEST.zip'
EASTERN = ZoneInfo('America/New_York')  # handles EST and EDT automatically
SCREENSHOT_WINDOW_SECONDS = 90
SCREENSHOT_COUNT_LIMIT = 12
SCREENSHOT_SIZE_LIMIT = 64 * 1024 * 1024
SCREENSHOT_NAME = re.compile(r'^WoWScrnShot_.*\.(?:jpg|jpeg|png|tga)$', re.I)
SCALAR = re.compile(r'^\s*\["(id|session|time|version|screenshot)"\]\s*=\s*(\d+|"(?:\\.|[^"\\])*")\s*,?\s*$')


def export(wow_root: Path, output: Path) -> Path:
    sources = [p for p in wow_root.glob(LIVE_PATTERN)
               if p.is_file() and not p.is_symlink()]
    if not sources:
        raise ValueError(
            f'No LIVE Forever Logres SavedVariables file under {wow_root / "_forever_" / "WTF" / "Account"}. '
            'Run the desired diagnostics in the Logres developer panel (or registered /logres commands), '
            'then /reload or log out before exporting. '
            f'Existing {output} was NOT refreshed; do not treat it as new evidence.'
        )
    source = max(sources, key=lambda p: (p.stat().st_mtime_ns, str(p)))
    if source.resolve() == output.resolve():
        raise ValueError('Refusing to overwrite the source SavedVariables file')
    data = source.read_bytes()
    if not data or b'LogresDiagnosticsDB' not in data:
        raise ValueError(
            f'LIVE Logres SavedVariables exists but has no serialized LogresDiagnosticsDB: {source}. '
            'Open /logres panel, run a diagnostic, /reload, then export again. '
            f'Existing {output} was NOT refreshed.'
        )
    if not output.parent.is_dir():
        raise ValueError(f'Destination directory does not exist: {output.parent}')
    # Never leave a partially copied diagnostics file on a failed export.
    temp_name: str | None = None
    try:
        with tempfile.NamedTemporaryFile(mode='wb', dir=output.parent,
                                         prefix='.logres-diagnostics-',
                                         suffix='.tmp', delete=False) as stream:
            temp_name = stream.name
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temp_name, output)
    finally:
        if temp_name and os.path.exists(temp_name):
            os.unlink(temp_name)
    modified = datetime.fromtimestamp(source.stat().st_mtime, EASTERN).isoformat(timespec='seconds')
    print(output)
    print(f'source={source}')
    print(f'source_modified_eastern={modified} bytes={len(data)}')
    print('LIVE Forever SavedVariables copied; recorded diagnostic runs only. '
          'No probes execute during export.')
    return source


def _close_brace(data: str, opening: int) -> int:
    """Find matching Lua table close, without interpreting Lua as code."""
    depth = 0
    quoted = False
    escaped = False
    for pos in range(opening, len(data)):
        char = data[pos]
        if quoted:
            if escaped:
                escaped = False
            elif char == '\\':
                escaped = True
            elif char == '"':
                quoted = False
        elif char == '"':
            quoted = True
        elif char == '{':
            depth += 1
        elif char == '}':
            depth -= 1
            if depth == 0:
                return pos
    raise ValueError('Incomplete Lua incident table; /reload before exporting')


def _top_level_scalars(table: str) -> dict:
    """Only read incident-owned scalar fields; ignore snapshot/context children."""
    fields: dict = {}
    depth = 0
    quoted = False
    escaped = False
    for line in table.splitlines():
        if depth == 1:
            match = SCALAR.fullmatch(line)
            if match:
                key, value = match.groups()
                fields[key] = int(value) if value[0] != '"' else value[1:-1]
        for char in line + '\n':
            if quoted:
                if escaped:
                    escaped = False
                elif char == '\\':
                    escaped = True
                elif char == '"':
                    quoted = False
            elif char == '"':
                quoted = True
            elif char == '{':
                depth += 1
            elif char == '}':
                depth -= 1
    return fields


def read_incidents(saved_variables: bytes) -> list[dict]:
    """Extract the bounded incident list from SavedVariables, never execute Lua."""
    text = saved_variables.decode('utf-8', errors='replace')
    match = re.search(r'(?m)^\s*\["incidents"\]\s*=\s*\{', text)
    if not match:
        return []  # Older saved journal or P0369 legacy fixture.
    opening = text.find('{', match.start())
    closing = _close_brace(text, opening)
    section = text[opening + 1:closing]
    incidents = []
    pos = 0
    while pos < len(section):
        char = section[pos]
        if char == '{':
            end = _close_brace(section, pos)
            fields = _top_level_scalars(section[pos:end + 1])
            if (isinstance(fields.get('id'), int)
                    and isinstance(fields.get('time'), int)
                    and fields['time'] > 0):
                incidents.append({k: fields[k] for k in
                                  ('id', 'session', 'time', 'version', 'screenshot')
                                  if k in fields})
            pos = end + 1
        else:
            pos += 1
    return incidents[-SCREENSHOT_COUNT_LIMIT:]


def _screenshots(wow_root: Path) -> list[tuple[Path, int]]:
    directory = wow_root / '_forever_' / 'Screenshots'
    if not directory.is_dir() or directory.is_symlink():
        return []
    found = []
    for path in directory.iterdir():
        if not SCREENSHOT_NAME.fullmatch(path.name) or path.is_symlink():
            continue
        try:
            stat = path.stat()
            if not path.is_file() or not (0 < stat.st_size <= SCREENSHOT_SIZE_LIMIT):
                continue
        except OSError:
            continue
        found.append((path, stat.st_mtime_ns // 1_000_000_000))
    return found


def _matches(incidents: list[dict], candidates: list[tuple[Path, int]]) -> tuple[list[tuple[dict, Path, int]], list[int]]:
    """Globally closest one-to-one mtime matching; not an exact screenshot ID."""
    pairs = []
    for index, incident in enumerate(incidents):
        if incident.get('screenshot') != 'succeeded':
            continue
        for image_index, (_, mtime) in enumerate(candidates):
            delta = abs(mtime - incident['time'])
            if delta <= SCREENSHOT_WINDOW_SECONDS:
                pairs.append((delta, index, image_index))
    chosen = []
    used_incidents = set()
    used_images = set()
    for delta, index, image_index in sorted(pairs):
        if index in used_incidents or image_index in used_images:
            continue
        used_incidents.add(index)
        used_images.add(image_index)
        chosen.append((incidents[index], candidates[image_index][0], delta))
    chosen.sort(key=lambda entry: (entry[0]['time'], entry[0]['id']))
    missed = [incident['id'] for incident in incidents
              if incident.get('screenshot') == 'succeeded'
              and incident['id'] not in {entry['id'] for entry, _, _ in chosen}]
    return chosen, missed


def build_bundle(wow_root: Path, exported: Path, bundle: Path, source: Path) -> dict:
    """Atomically package diagnostics, metadata and matched screenshot bytes."""
    if not bundle.parent.is_dir():
        raise ValueError(f'Bundle destination directory does not exist: {bundle.parent}')
    if bundle.resolve() in (source.resolve(), exported.resolve()):
        raise ValueError('Refusing to overwrite diagnostic source or export with bundle')
    data = exported.read_bytes()
    incidents = read_incidents(data)
    matches, missed = _matches(incidents, _screenshots(wow_root))
    report = {
        'schema': 1,
        'client': 'World of Warcraft Forever',
        'generated_utc': datetime.now(timezone.utc).isoformat(timespec='seconds'),
        'generated_eastern': datetime.now(EASTERN).isoformat(timespec='seconds'),
        'display_timezone': 'America/New_York',
        'diagnostics_file': DEFAULT_OUTPUT,
        'diagnostics_sha256': hashlib.sha256(data).hexdigest(),
        'source_modified_utc': datetime.fromtimestamp(source.stat().st_mtime, timezone.utc).isoformat(timespec='seconds'),
        'source_modified_eastern': datetime.fromtimestamp(source.stat().st_mtime, EASTERN).isoformat(timespec='seconds'),
        'screenshot_correlation': 'INFERRED by image filesystem mtime within 90s of Report Bug timestamp; never verified by client filename or screenshot bytes in Lua',
        'incidents': [dict(incident, time_eastern=datetime.fromtimestamp(incident['time'], EASTERN).isoformat(timespec='seconds')) for incident in incidents],
        'screenshots': [{'incident_id': incident['id'],
                         'archive_path': 'screenshots/' + path.name,
                         'mtime_delta_seconds': delta,
                         'exact_client_correlation': False}
                        for incident, path, delta in matches],
        'unmatched_successful_incident_ids': missed,
        'warnings': [],
    }
    if not incidents:
        report['warnings'].append('No bounded Report Bug incidents found in SavedVariables; diagnostics still included.')
    if missed:
        report['warnings'].append('Some successful Report Bug screenshot requests have no nearby screenshot file; images are NOT included for those IDs.')
    if not matches:
        report['warnings'].append('No Report Bug screenshot images matched; attach client screenshots separately if needed.')
    if not (wow_root / '_forever_' / 'Screenshots').is_dir():
        report['warnings'].append('Forever Screenshots directory missing; check client installation or capture a screenshot.')

    temp_name = None
    try:
        with tempfile.NamedTemporaryFile(mode='wb', dir=bundle.parent,
                                         prefix='.logres-bug-report-', suffix='.tmp',
                                         delete=False) as stream:
            temp_name = stream.name
        with zipfile.ZipFile(temp_name, 'w', compression=zipfile.ZIP_DEFLATED,
                             compresslevel=6) as archive:
            archive.writestr(DEFAULT_OUTPUT, data)
            archive.writestr('BUG_REPORT.json', json.dumps(report, indent=2, sort_keys=True) + '\n')
            archive.writestr('README.txt',
                'Attach this ZIP to the Logres bug conversation. It contains actual screenshot images ONLY when matched by file time. '\
                'The incident ID association is inferred, not supplied by WoW. See BUG_REPORT.json for missing images and warnings.\n')
            for incident, path, _ in matches:
                # A screenshot stays on the local machine; the ZIP embeds a copy.
                archive.write(path, 'screenshots/' + path.name)
        os.replace(temp_name, bundle)
    finally:
        if temp_name and os.path.exists(temp_name):
            os.unlink(temp_name)
    print(f'UPLOAD_BUNDLE={bundle} screenshots={len(matches)} incidents={len(incidents)}')
    for warning in report['warnings']:
        print('WARNING: ' + warning, file=sys.stderr)
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--wow-root', type=Path, default=DEFAULT_WOW_ROOT,
                        help='World of Warcraft installation root (WSL path)')
    parser.add_argument('--output', type=Path,
                        default=Path.cwd() / DEFAULT_OUTPUT,
                        help='Local diagnostics copy, default in current directory')
    parser.add_argument('--bundle-output', type=Path, default=None,
                        help='Evidence ZIP, default LOGRES_BUG_REPORT_LATEST.zip next to --output')
    args = parser.parse_args()
    bundle = args.bundle_output or args.output.with_name(DEFAULT_BUNDLE)
    try:
        source = export(args.wow_root, args.output)
        build_bundle(args.wow_root, args.output, bundle, source)
    except (OSError, ValueError, zipfile.BadZipFile) as exc:
        print(f'Logres live diagnostics export REFUSED: {exc}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
