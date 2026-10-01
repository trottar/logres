# C.4 — Contextual Visibility / Secure Paging

Status: P0039 IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Make the proven Logres action constellation respond to gameplay context without
violating combat-lockdown rules.

Resolve the normal Primary combat-time page-remapping limitation before stock
action-bar suppression is considered.

## Canonical contract

- source evidence:
  `../evidence/C4_CONTEXT_VISIBILITY_SECURE_PAGING_SOURCE_REVIEW_2026-10-01.md`
- decision:
  `../decisions/D-021_ACTION_CONTEXT_AND_SECURE_PAGING_CONTRACT.md`

## P0039 Part A — contextual emphasis

Adds `Actions/Context.lua`.

It subscribes to the existing orthogonal state contract:
- combat;
- pvpFlagged;
- context.

Precedence:

```text
combat > pvpFlagged > instance > world/default
```

First-pass policy:

| State | Primary | Secondary | Utility |
| --- | ---: | ---: | ---: |
| world/default | 1.00 | 0.45 | 0.20 |
| PvP flagged | 1.00 | 0.75 | 0.40 |
| instance | 1.00 | 0.70 | 0.45 |
| combat | 1.00 | 1.00 | 0.75 |

No alpha-zero state exists.

All secure action buttons remain interactable.

## P0039 Part B — normal secure Primary paging

Primary buttons now receive IDs 1–12.

Execution page is driven by:

```text
[bar:2]2;
[bar:3]3;
[bar:4]4;
[bar:5]5;
[bar:6]6;
1
```

through `RegisterAttributeDriver(..., "actionpage", ...)`.

The protected action no longer needs ordinary Lua to rewrite concrete `action`
attributes on normal page changes.

## Presentation synchronization

P0039 separates:
- secure execution selection;
- ordinary icon/cooldown/count/range registration.

`ActionButton.RegisterPresentation` updates presentation registration without
changing the protected `action` attribute.

Primary presentation resolves the same normal-page driver through:

```text
SecureCmdOptionParse(PRIMARY_PAGE_DRIVER)
```

and updates:
- action slot fields;
- native button registration;
- range registration;
- icon/cooldown/count/usability/range state.

## Special-state boundary

P0039 intentionally supports only normal primary pages 1–6.

Not yet claimed:
- bonus/form bars;
- temporary shapeshift;
- vehicle;
- override;
- possess.

Debug status reports:

```text
specialPagingCoverage = normal-pages-only
```

Stock Blizzard bars remain visible.

## Diagnostics

Action Check now includes:
- secure paging driver readiness;
- secure page attribute;
- current presentation page/slots;
- context policy;
- Primary/Secondary/Utility alpha;
- special paging coverage;
- stock fallback status.

## Runtime proof

After deployment:

### Baseline

1. confirm `0.0.17-dev`;
2. Run All / Action Check PASS;
3. confirm world-idle alpha:
   - Primary full;
   - Secondary noticeably subdued;
   - Utility strongly subdued;
4. faded clusters must remain clickable/key-usable.

### Combat

5. enter ordinary combat;
6. Secondary should rise to full;
7. Utility should rise but remain less dominant than Primary/Secondary;
8. actions remain clickable/key-usable;
9. no protected-action/taint error.

### PvP modifier

10. outside combat, use `/pvp` if convenient;
11. Secondary/Utility should rise above ordinary world idle;
12. combat should still override the PvP weighting.

### Instance

13. if naturally convenient, instance idle should use the intermediate
    conservative weighting;
14. otherwise instance alpha true path may remain environment-deferred.

### Primary paging

15. switch normal primary pages 1–6 if the current UI permits;
16. Logres icon/presentation must follow the page;
17. clicking/keying Logres must execute the action shown;
18. page switching must not require waiting for combat to end.

A combat-time normal page switch is valuable if naturally practical.

Do not manufacture a special class/form/vehicle state solely for P0039.

## Exit

C.4 remains open until:
- context weighting is runtime-proven;
- normal secure paging execution/presentation is runtime-proven;
- unsupported special pages retain explicit safe fallback.
## P0039 runtime result / P0040 activation-feedback gate

P0039 context runtime passed:
- world/default weighting;
- combat weighting;
- PvP modifier.

Utility remains intentionally more subdued and is accepted as first-pass
tuning.

The user does not use normal primary page switching, so that compatibility
path is not a current workflow exit gate.

A separate missing action-interface capability was then identified:

- range feedback works;
- GCD/cooldown works;
- secure execution works;
- **using the action has no local per-button response**.

P0040 adds D-022 activation feedback:
- pressed state;
- short PostClick activation pulse.

C.4 remains active until P0040 runtime proof.

## P0040 runtime failure / P0041 correction

P0040 was deployed at the correct version but produced no perceptible action
feedback. Execution, range red, and GCD remained functional.

Classification: **visual activation-feedback failure**.

P0041 moves feedback onto an independent UIParent overlay and adds an explicit
Feedback Test diagnostic. C.4 remains open until P0041 is visually proven.
