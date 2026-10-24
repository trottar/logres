"""P0325 offline migration *proposal* — not loaded by the WoW addon.

Schema-3 settings are immutable inputs. Domain overrides are draft user choices,
not SavedVariables writes or permission to touch native game surfaces.
"""
from copy import deepcopy
from p0324_domain_policy import DOMAINS, MODES, from_mask


def _validate_legacy(settings):
    if type(settings) is not dict:
        raise ValueError('settings must be a mapping')
    for key in ('immersionEnabled', 'activeQuestEnabled'):
        if type(settings.get(key)) is not bool:
            raise ValueError('missing or invalid legacy boolean '+key)


def _validate_overrides(overrides):
    if type(overrides) is not dict:
        raise ValueError('overrides must be a mapping')
    if any(key not in DOMAINS for key in overrides):
        raise ValueError('unknown five-domain key')
    if any(type(value) is not str or value not in MODES
           for value in overrides.values()):
        raise ValueError('invalid domain request')


def preview(settings, overrides=None):
    """Describe staged opt-in only. No migration, no state change, no IO.

    'legacy' means keep exactly the EXISTING runtime policy for this domain.
    It is intentionally NOT a sixth runtime mode in the P0324 evaluator.
    In particular CAM's observed behavior is not inferred from immersionEnabled.
    """
    _validate_legacy(settings)
    selected = {} if overrides is None else overrides
    _validate_overrides(selected)
    return {
        'status': 'dry-run-only',
        'schema': 3,
        'saved_settings': deepcopy(settings),
        'domain_requests': {d: selected.get(d, 'legacy') for d in DOMAINS},
        'explicit_overrides': tuple(d for d in DOMAINS if d in selected),
        'requires_runtime_validation': True,
        'writes_saved_variables': False,
        'camera_legacy_not_inferred': 'CAM' not in selected,
    }


def preview_mask(settings, mask):
    """Inspect all 32 *explicit* domain choices while not altering legacy saves."""
    return preview(settings, from_mask(mask))
