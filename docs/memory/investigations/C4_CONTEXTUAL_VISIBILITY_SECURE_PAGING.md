# C.4 — Contextual Visibility / Secure Paging

Status: SOURCE-RESOLVED; IMPLEMENTATION NEXT
Opened: 2026-10-01

## Goal

Make the proven Logres action constellation respond to gameplay context without
violating combat-lockdown rules.

Resolve the known Primary combat-time page-remapping limitation before stock
action-bar suppression is considered.

## Canonical source evidence

`../evidence/C4_CONTEXT_VISIBILITY_SECURE_PAGING_SOURCE_REVIEW_2026-10-01.md`

## Canonical decision

`../decisions/D-021_ACTION_CONTEXT_AND_SECURE_PAGING_CONTRACT.md`

## Resolved context approach

Initial C.4 uses presentation alpha, not protected Show/Hide.

Role policy:

| State | Primary | Secondary | Utility |
| --- | ---: | ---: | ---: |
| world/default idle | 1.00 | 0.45 | 0.20 |
| PvP flagged idle | 1.00 | 0.75 | 0.40 |
| instance idle | 1.00 | 0.70 | 0.45 |
| combat | 1.00 | 1.00 | 0.75 |

No alpha-zero state.

All buttons stay interactable.

## Resolved paging direction

Primary secure execution should use:
- button IDs 1–12;
- `actionpage`;
- AttributeDriver / SecureStateDriver macro conditions.

This removes the need for insecure combat-time protected attribute remapping
for supported states.

## Implementation split

P0039 should be narrow.

### Part A — contextual alpha

Add role-policy application from existing State subscription.

Prove:
- world idle;
- PvP flag modifier;
- combat;
- instance if naturally available.

### Part B — secure primary paging foundation

Move Primary execution to ID/actionpage driver.

Prove at minimum:
- ordinary page 1;
- out-of-combat page switching;
- combat page switching if practical;
- presentation follows execution.

Special vehicle/override/form states remain explicit capability gates until
tested.

## Diagnostics

Extend Action Check with:
- current context-policy alpha values;
- secure paging driver ready;
- active presentation page/slots;
- stock fallback still enabled.

Consider a focused `Action Context Check` only if Action Check becomes too
dense.

## Runtime proof

Context:
1. world idle weighting;
2. PvP flagged weighting if convenient;
3. combat weighting;
4. no protected-action error;
5. faded buttons remain clickable/key-usable.

Paging:
1. Primary page 1 correct;
2. change normal primary page and verify execution + icon/cooldown presentation;
3. if a safe combat-time page change is naturally available, verify it;
4. otherwise record combat page-change true path as pending rather than
   manufacturing a class/form scenario.

Special states:
- do not force vehicle/override/form travel solely for C.4;
- retain stock fallback and explicit retry conditions.

## Exit

C.4 completes when:
- contextual role emphasis is runtime-proven;
- no alpha-zero invisible click zones exist;
- normal Primary secure paging is proven;
- supported combat-time page changes no longer depend on post-combat attribute
  mutation;
- unsupported special paging states retain safe stock fallback.
