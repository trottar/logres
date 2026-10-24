#!/usr/bin/env python3
"""P0325 pure migration dry-run test. No game APIs and no schema change."""
from pathlib import Path
import sys
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from p0324_domain_policy import DOMAINS, from_mask
import p0325_migration_dry_run as migration


def require(condition, text):
    if not condition:
        raise AssertionError(text)

for legacy_immersion in (False, True):
    for active_quest in (False, True):
        source = {'immersionEnabled': legacy_immersion,
                  'activeQuestEnabled': active_quest,
                  'debug': False, 'custom': {'preserve': ['one', 'two']}}
        copy = migration.preview(source)
        require(copy['schema'] == 3 and copy['status'] == 'dry-run-only',
                'must be inert schema-3 draft')
        require(all(copy['domain_requests'][d] == 'legacy' for d in DOMAINS),
                'legacy path must not alter any existing system')
        require(copy['camera_legacy_not_inferred'] is True,
                'camera ownership must not be guessed from immersion')
        require(copy['saved_settings'] == source and
                copy['saved_settings'] is not source, 'legacy save must be copied')
        copy['saved_settings']['custom']['preserve'].append('other')
        require(source['custom']['preserve'] == ['one', 'two'],
                'save copy unexpectedly aliases nested settings')
        require(copy['writes_saved_variables'] is False and
                copy['requires_runtime_validation'] is True,
                'migration must remain a dry-run')
        for mask in range(32):
            proposal = migration.preview_mask(source, mask)
            require(proposal['domain_requests'] == from_mask(mask),
                    'explicit five-domain mask differs from P0324 fixture')
            require(proposal['saved_settings'] == source and
                    proposal['explicit_overrides'] == DOMAINS,
                    'explicit choice accidentally modified legacy saves')
            for d in DOMAINS:
                single = migration.preview(source, {d: 'blizzard'})
                require(single['domain_requests'][d] == 'blizzard',
                        'explicit domain choice lost')
                require(all(single['domain_requests'][other] == 'legacy'
                            for other in DOMAINS if other != d),
                        'a domain request modified an unselected domain')
                require(single['camera_legacy_not_inferred'] == (d != 'CAM'),
                        'CAM explicitness not tracked')
        require(source['custom']['preserve'] == ['one', 'two'],
                'dry run unexpectedly changed legacy source')

sample = {'immersionEnabled': False, 'activeQuestEnabled': True}
for bad in (None, 'x', 42, {}, {'immersionEnabled': 1, 'activeQuestEnabled': True},
            {'immersionEnabled': True, 'activeQuestEnabled': 'no'}):
    try: migration.preview(bad)
    except ValueError: pass
    else: raise AssertionError('invalid legacy source accepted: '+str(bad))
for bad in ([], {'MISSING': 'logres'}, {'NAV': True},
            {'NPC': 'unknown'}, {'CAM': 1}):
    try: migration.preview(sample, bad)
    except ValueError: pass
    else: raise AssertionError('invalid domain override accepted: '+str(bad))

prefs=(ROOT/'Logres/Core/Preferences.lua').read_text(encoding='utf-8')
db=(ROOT/'Logres/Core/Database.lua').read_text(encoding='utf-8')
toc=(ROOT/'Logres/Logres.toc').read_text(encoding='utf-8')
require('immersionEnabled' in prefs and 'activeQuestEnabled' in prefs,
        'existing preference surface lost')
require('local CURRENT_SCHEMA = 3' in db,
        'live database schema was altered')
require('p0325_migration_dry_run' not in toc,
        'offline draft added to live load path')
for p in ('tools/p0325_migration_dry_run.py',):
    code=(ROOT/p).read_text(encoding='utf-8')
    require('SetPreference(' not in code and 'RegisterEvent(' not in code and
            'InCombatLockdown(' not in code and 'C_GossipInfo' not in code,
            'offline candidate imported game mutation')
for p in ('docs/memory/architecture/P0325_MIGRATION_DRY_RUN.md',
          'docs/memory/evidence/P0325_MIGRATION_DRY_RUN.md',
          'docs/memory/patches/P0325_MIGRATION_DRY_RUN.md'):
    doc=(ROOT/p).read_text(encoding='utf-8')
    require('P0325' in doc and 'UNVERIFIED' in doc and
            doc.endswith('\n') and not doc.endswith('\n\n'),
            'missing migration evidence/scope '+p)
current=(ROOT/'docs/memory/CURRENT.md').read_text(encoding='utf-8')
for patch in ('P0317','P0318','P0319','P0320','P0321',
              'P0322','P0323','P0324','P0325'):
    require(patch in current,'CURRENT continuity lost '+patch)
require('CURRENT.md' in (ROOT/'docs/memory/handoffs/CURRENT_HANDOFF.md').read_text(encoding='utf-8'),
        'handoff authority missing')
print('P0325 backward-compatible staged migration dry-run contract')
print('PASS: 4 legacy states x 32 choices, 5 independent opt-ins, invalid inputs, zero live writes')
