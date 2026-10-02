# P0062 Delivery / Workflow Failure — 2026-10-01

Status: CLOSED BY REALIGNMENT; TECHNICAL CONTRACT REPAIR FOLDED INTO P0063
Date: 2026-10-01

## What happened

The first P0062 documentation applier wrote its intended files and then ran a
broader static-check sequence.

It stopped at:

`tools/check_player_frame_replacement_contract.py`

because that legacy checker still required:

`targetFrameSuppressionDesired = false`

while current D-028 policy correctly requires:

`targetFrameSuppressionDesired = immersionEnabled`.

This checker drift predated P0062. P0062 did not change runtime code and did not
cause the inconsistency.

## Assistant workflow failures after the check result

The assistant then deviated from the established repository-native procedure:

1. it initially invented the wrong local ZIP destination;
2. it expanded the user handoff into unnecessary review/staging stages;
3. it treated P0062's own `PREPARED` patch-record state as evidence that the
   pushed checkpoint was incomplete;
4. it proposed a standalone `P0062R` repair checkpoint without first
   reconciling that proposal against `AGENTS.md`, `CURRENT.md`, and the normal
   patch-history pattern.

The user rejected the standalone repair and required a full realignment.

`P0062R` was not accepted as project history and must not be treated as an
installed checkpoint.

## Audit result

Repository memory is authoritative.

P0062 was successfully pushed as:

`13c53390be13edbaf23a495b9bf006b2147c8bc8`

Its purpose remains the D.6 source/design resolution.

A patch record describing itself as `PREPARED` is normal: the patch cannot know
its eventual commit SHA. The following checkpoint records the prior patch as
pushed.

## Correct technical handling

The stale PlayerFrame checker belongs to the same recovery/diagnostic ownership
surface that P0063 must change anyway.

Therefore P0063:
- removes the obsolete D.4-era Target-disabled assertion;
- adds addon-owned Player recovery state;
- removes Player protected interaction readback from command diagnostics;
- adds the integrated D.6 Restoration Check;
- records this failure without creating a separate repair phase.

## P0063 packaging note

The first two local P0063 artifact-generator attempts failed before producing
a deliverable ZIP or touching repository state:

1. the first hit a Python quoting/indentation error in the generated applier;
2. the second hit a remaining triple-quote collision in the artifact generator.

Both generator failures were corrected before delivery and are not installed
project checkpoints.

## Durable lesson

Do not invent workflow or patch boundaries from incidental diagnostics.

Use repository authority first, preserve one coherent patch boundary, and record
negative results without turning every discovered inconsistency into a separate
checkpoint.
