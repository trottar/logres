#!/usr/bin/env python3
"""Read-only Logres source-health inventory. Never imports/executes addon Lua."""
from __future__ import annotations
import argparse
import json
import re
from pathlib import Path

ACTION = re.compile(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([0A-HP])"\s*\)', re.S)
MODULE = re.compile(r'Logres:RegisterModule\(\s*"([^"]+)"')
LOOKUP = re.compile(r'Logres:GetModule\(\s*"([^"]+)"')


def inspect(root: Path) -> dict:
    """Return deterministic source metrics and explicit risks; no WoW/UI calls."""
    toc = (root / 'Logres/Logres.toc').read_text(encoding='utf-8')
    commands = (root / 'Logres/Core/Commands.lua').read_text(encoding='utf-8')
    boot = (root / 'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
    entry_lines = [x.strip() for x in toc.splitlines() if x.strip().endswith('.lua')]
    paths = ['Logres/' + x.replace('\\', '/') for x in entry_lines]
    loaded = set(paths)
    all_lua = {p.relative_to(root).as_posix() for p in (root / 'Logres').rglob('*.lua')}
    missing = sorted(loaded - all_lua)
    orphaned = sorted(all_lua - loaded)
    duplicate_loads = sorted({x for x in paths if paths.count(x) > 1})
    version_toc = re.search(r'(?m)^## Version: (\S+)$', toc)
    version_boot = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', boot)
    actions = ACTION.findall(commands)
    ids = [entry[0] for entry in actions]
    duplicate_actions = sorted({x for x in ids if ids.count(x) > 1})
    phases = {phase: sum(1 for entry in actions if entry[3] == phase) for phase in '0ABCDEFGHP'}
    sizes = sorted(((len((root / p).read_bytes()), p) for p in sorted(loaded) if (root / p).is_file()), reverse=True)
    source_tokens = '\n'.join((root / p).read_text(encoding='utf-8') for p in sorted(loaded) if (root / p).is_file())
    modules = MODULE.findall(source_tokens)
    registered = set(modules)
    referenced = set(LOOKUP.findall(source_tokens))
    commands_bytes = len(commands.encode('utf-8'))
    total_bytes = sum(size for size, _ in sizes)
    warnings = []
    if commands_bytes > 200_000:
        warnings.append('Commands.lua large cross-domain orchestration; split only after historical contract migration plan')
    if 'immersionEnabled' in (root / 'Logres/Core/Preferences.lua').read_text(encoding='utf-8') and not all(
        x in (root / 'Logres/Core/Preferences.lua').read_text(encoding='utf-8')
        for x in ('navigationMode', 'actionMode', 'npcMode', 'statusMode', 'cameraMode')
    ):
        warnings.append('D-048 five independent live selectors not established by preferences source')
    if missing or orphaned or duplicate_loads or duplicate_actions:
        warnings.append('source inventory / command registry inconsistency requires inspection')
    return {
        'loaded_lua_count': len(paths), 'unique_loaded_lua': len(loaded),
        'missing_loaded_paths': missing, 'orphan_lua_paths': orphaned,
        'duplicate_loaded_paths': duplicate_loads,
        'toc_version': version_toc.group(1) if version_toc else None,
        'bootstrap_version': version_boot.group(1) if version_boot else None,
        'dev_panel_actions': len(actions), 'dev_panel_unique_ids': len(set(ids)),
        'dev_panel_duplicate_ids': duplicate_actions,
        'dev_panel_phases': phases,
        'registered_module_names': len(registered),
        'unresolved_constant_module_lookups': sorted(referenced - registered),
        'total_loaded_lua_bytes': total_bytes,
        'commands_bytes': commands_bytes,
        'commands_lines': len(commands.splitlines()),
        'commands_percent_loaded_source': round(commands_bytes * 100 / total_bytes, 2) if total_bytes else 0,
        'largest_loaded_files': [{'path': path, 'bytes': size} for size, path in sizes[:10]],
        'review_warnings': warnings,
        'meaning': 'static source inventory, not runtime capability, security or performance evidence',
    }


def verify(report: dict) -> list[str]:
    faults = []
    for key in ('missing_loaded_paths', 'orphan_lua_paths', 'duplicate_loaded_paths', 'dev_panel_duplicate_ids'):
        if report[key]: faults.append(f'{key}: {report[key]}')
    if report['loaded_lua_count'] != 94 or report['unique_loaded_lua'] != 94:
        faults.append('94 unique loaded Lua files baseline changed: review the TOC and P0323 audit')
    if report['toc_version'] is None or report['toc_version'] != report['bootstrap_version']:
        faults.append('TOC and Bootstrap version parity mismatch')
    if report['dev_panel_phases']['P'] != 38:
        faults.append('P preview gallery inventory changed: review the P0256 contract')
    if report['dev_panel_actions'] < 120:
        faults.append('developer-panel actions unexpectedly removed')
    # Dynamic module lookup and file growth are AUDIT warnings, not hard blockers.
    return faults


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--json', action='store_true', help='machine-readable source inventory')
    parser.add_argument('--strict', action='store_true', help='nonzero on source or gallery drift')
    args = parser.parse_args()
    report = inspect(args.root.resolve())
    faults = verify(report)
    if args.json:
        print(json.dumps({'report': report, 'failures': faults}, indent=2, sort_keys=True))
    else:
        print(f'Logres architecture audit: loaded={report["loaded_lua_count"]} unique={report["unique_loaded_lua"]} '
              f'actions={report["dev_panel_actions"]} previews={report["dev_panel_phases"]["P"]} '
              f'modules={report["registered_module_names"]}')
        print(f'Commands.lua: {report["commands_lines"]} lines, {report["commands_bytes"]} bytes '
              f'({report["commands_percent_loaded_source"]}% of loaded Lua)')
        for item in report['largest_loaded_files'][:5]: print(f'  {item["bytes"]:>7} {item["path"]}')
        for x in report['unresolved_constant_module_lookups']: print('REVIEW unresolved GetModule literal:', x)
        for x in report['review_warnings']: print('REVIEW:', x)
        for x in faults: print('ERROR:', x)
        print('STATIC PASS' if not faults else 'STATIC REFUSED')
    if args.strict and faults:
        raise SystemExit(1)

if __name__ == '__main__':
    main()
