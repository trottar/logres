# Blizzard UI Suppression and Restoration Architecture

## Goal

Move from additive development:

```text
Blizzard UI + Logres replacement components
```

to production presentation:

```text
Logres controls replaced surfaces
Blizzard surfaces hidden where replacement is proven
restoration available when required
```

without removing required player controls prematurely.

## Capability gate

A Blizzard surface is suppressible only when:
1. a Logres replacement exists;
2. its runtime behavior is proven;
3. restoration behavior is defined;
4. combat-lockdown/security constraints are understood.

## Phase ownership

| Surface | Replacement | Suppression owner |
| --- | --- | --- |
| player frame | vignette/resource | Phase D |
| target frame | sparse target presentation | Phase D |
| party frames | compact ally rows | Phase D |
| action bars | action clusters | Phase C implementation, Phase D orchestration |
| chat/tabs | Quiet Mode | Phase D |
| minimap | compass/navigation | Phase E with Phase D context policy |
| quest tracker/presentation | Logres quest experience | Phase F |
| XP bar | contextual XP | Phase F |

## Restoration

Restoration is not an afterthought.

Every suppression path must define:
- normal restore;
- immersion-off restore;
- addon disable/logout/reload behavior where relevant;
- combat-lockdown limitations;
- fallback when a Logres replacement is unavailable.

## Development state

Phase B intentionally did not suppress stock frames.

That allowed:
- independent replacement validation;
- direct comparison;
- safer debugging.

Phase C begins the first stock-control replacement domain: action bars.
