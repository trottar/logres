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
            'Use Report Bug for a capture or right-click it for a named diagnostic, /reload, then export again. '
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


def read_version(path: Path) -> str | None:
    if not path.is_file():
        return None
    match = re.search(r"(?m)^## Version: (\S+)$", path.read_text(encoding="utf-8"))
    return match[1] if match else None


def capture_summary(data: bytes) -> dict:
    incidents = read_incidents(data)
    latest = max(incidents, key=lambda item: (item["time"], item["id"]), default=None)
    return {
        "diagnostics_sha256": hashlib.sha256(data).hexdigest(),
        "latest_incident": latest,
        "latest_capture_version": latest.get("version") if latest else None,
        "incident_count": len(incidents),
    }


def inspect_evidence(path: Path) -> dict:
    if not zipfile.is_zipfile(path):
        return capture_summary(path.read_bytes())
    with zipfile.ZipFile(path) as archive:
        if archive.namelist().count(DEFAULT_OUTPUT) != 1 or archive.namelist().count("BUG_REPORT.json") != 1:
            raise ValueError("Evidence ZIP must contain one diagnostics file and one BUG_REPORT.json")
        data = archive.read(DEFAULT_OUTPUT)
        report = json.loads(archive.read("BUG_REPORT.json"))
        if not isinstance(report, dict):
            raise ValueError("BUG_REPORT.json must be a metadata object")
        result = capture_summary(data)
        if report.get("diagnostics_sha256") != result["diagnostics_sha256"]:
            raise ValueError("Evidence ZIP diagnostics hash disagrees with BUG_REPORT.json")
        result["exported_eastern"] = report.get("generated_eastern")
        result["source_modified_eastern"] = report.get("source_modified_eastern")
        result["provenance"] = report.get("provenance")
        result["screenshots"] = [
            {"archive_path": item["archive_path"], "incident_id": item["incident_id"],
             "sha256": hashlib.sha256(archive.read(item["archive_path"])).hexdigest(),
             "correlation": "inferred"}
            for item in report.get("screenshots", [])
        ]
        return result


def compare_evidence(current: dict, previous: dict) -> dict:
    return {
        "diagnostics_identical": current["diagnostics_sha256"] == previous["diagnostics_sha256"],
        "latest_incident_identical": current["latest_incident"] == previous["latest_incident"],
    }


def evidence_provenance(wow_root: Path, source: Path, current: dict, previous: dict | None) -> dict:
    source_version = read_version(Path(__file__).resolve().parents[1] / "Logres/Logres.toc")
    deployed_version = read_version(wow_root / "_forever_/Interface/AddOns/Logres/Logres.toc")
    captured_version = current["latest_capture_version"]
    def comparison(left, right):
        if left is None or right is None:
            return "unknown"
        return "match" if left == right else "different"
    return {
        "savedvariables_source": str(source),
        "source_version": source_version,
        "deployed_forever_version": deployed_version,
        "latest_capture_version": captured_version,
        "source_vs_deployed": comparison(source_version, deployed_version),
        "deployed_vs_capture": comparison(deployed_version, captured_version),
        "source_vs_capture": comparison(source_version, captured_version),
        "previous_export": compare_evidence(current, previous) if previous is not None else None,
    }


def build_bundle(wow_root: Path, exported: Path, bundle: Path, source: Path) -> dict:
    """Atomically package diagnostics, metadata and matched screenshot bytes."""
    if not bundle.parent.is_dir():
        raise ValueError(f'Bundle destination directory does not exist: {bundle.parent}')
    if bundle.resolve() in (source.resolve(), exported.resolve()):
        raise ValueError('Refusing to overwrite diagnostic source or export with bundle')
    data = exported.read_bytes()
    current = capture_summary(data)
    previous = None
    previous_error = None
    if bundle.exists():
        try:
            previous = inspect_evidence(bundle)
        except (OSError, ValueError, KeyError, json.JSONDecodeError, zipfile.BadZipFile) as error:
            previous_error = str(error)
    incidents = read_incidents(data)
    matches, missed = _matches(incidents, _screenshots(wow_root))
    report = {
        'schema': 1,
        'provenance': evidence_provenance(wow_root, source, current, previous),
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
    if previous_error:
        report['warnings'].append('Previous bundle could not be compared: ' + previous_error)
    if previous is not None and compare_evidence(current, previous)["latest_incident_identical"]:
        report['warnings'].append('Latest Report Bug incident is unchanged from the previous export; independent diagnostic runs may still differ.')
    if report['provenance']['source_vs_capture'] == 'different':
        report['warnings'].append('Latest captured version differs from repository source. Compare deployed_forever_version and savedvariables_source before requesting another gameplay test.')
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
    parser.add_argument('--inspect', type=Path,
                        help='Read an existing ZIP or Lua export without exporting live files')
    parser.add_argument('--previous', type=Path,
                        help='Compare an inspection with an earlier ZIP or Lua export')
    parser.add_argument('--standalone', type=Path,
                        help='Verify an inspected ZIP and standalone diagnostics contain identical bytes')
    parser.add_argument('--expected-version',
                        help='Compare inspection capture version with this explicit release version')
    args = parser.parse_args()
    if args.inspect:
        try:
            result = inspect_evidence(args.inspect)
            if args.previous:
                result["previous"] = compare_evidence(result, inspect_evidence(args.previous))
            if args.standalone:
                result["standalone_matches"] = (
                    result["diagnostics_sha256"] == capture_summary(args.standalone.read_bytes())["diagnostics_sha256"]
                )
            if args.expected_version:
                result["expected_version"] = args.expected_version
                captured = result["latest_capture_version"]
                result["expected_vs_capture"] = (
                    "unknown" if captured is None else "match" if captured == args.expected_version else "different"
                )
            print(json.dumps(result, indent=2, sort_keys=True))
            return 1 if result.get("standalone_matches") is False else 0
        except (OSError, ValueError, KeyError, zipfile.BadZipFile) as error:
            print(f'Logres evidence inspection REFUSED: {error}', file=sys.stderr)
            return 1
    if args.previous or args.standalone or args.expected_version:
        parser.error('--previous, --standalone and --expected-version require --inspect')
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
