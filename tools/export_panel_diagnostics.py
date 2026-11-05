#!/usr/bin/env python3
"""Export *live Forever* saved diagnostic runs; refuse stale beta fallback.

The WoW client writes Logres.lua on /reload or logout. This read-only source
exporter never initiates probes or reads gameplay/protected state.
"""
from __future__ import annotations

import argparse
from datetime import datetime
import os
from pathlib import Path
import sys
import tempfile

DEFAULT_WOW_ROOT = Path('/mnt/c/Program Files (x86)/World of Warcraft')
LIVE_PATTERN = '_forever_/WTF/Account/*/SavedVariables/Logres.lua'
DEFAULT_OUTPUT = 'LOGRES_DIAGNOSTICS_LATEST.lua'


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
    modified = datetime.fromtimestamp(source.stat().st_mtime).isoformat(timespec='seconds')
    print(output)
    print(f'source={source}')
    print(f'source_modified={modified} bytes={len(data)}')
    print('LIVE Forever SavedVariables copied; recorded diagnostic runs only. '
          'No probes execute during export.')
    return source


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--wow-root', type=Path, default=DEFAULT_WOW_ROOT,
                        help='World of Warcraft installation root (WSL path)')
    parser.add_argument('--output', type=Path,
                        default=Path.cwd() / DEFAULT_OUTPUT,
                        help='Local diagnostics copy, default in current directory')
    args = parser.parse_args()
    try:
        export(args.wow_root, args.output)
    except (OSError, ValueError) as exc:
        print(f'Logres live diagnostics export REFUSED: {exc}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
