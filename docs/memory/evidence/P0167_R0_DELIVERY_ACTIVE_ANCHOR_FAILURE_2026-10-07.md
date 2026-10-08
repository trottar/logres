# P0167 R0 — delivery failure: nonexistent ACTIVE.md anchor

Date: 2026-10-07
Baseline: `a67e0cce85e054eddfdd8f75cd17c9f450d66b3b`
Classification: **DELIVERY FAILURE — CLOSED BY P0167 R2**

## Attempt

The first P0167 artifact attempted to register Layout Check in Phase H and reclassify the two legacy quest-offer TEST actions to Phase F.

## Observed result

The applier verified the exact pushed baseline and entered candidate construction, then stopped with:

`docs/memory/investigations/ACTIVE.md P0166 section: expected exactly one anchor, found 0`

The authoritative pushed `ACTIVE.md` did not contain the assumed `## P0166 — H.2 integration-owned anchors` section. No tracked file had been written; only `LOGRES_DIAGNOSTICS_LATEST.lua` and the extracted `P0167_PAYLOAD/` remained untracked.

## Cause

The delivery generator used a stale/brittle memory transform instead of validating the exact pushed baseline shape.

A second static conflict was found during the R1 audit before redelivery: the durable P0131 checker still required the quest-offer Accept/Decline panel probes to be in Phase H. Since P0167 deliberately moves those TEST probes to Phase F to make room for Layout Check, that checker must be synchronized or the complete checker suite will correctly fail.

## Correction history

P0167 R1 replaced the nonexistent-section rewrite with an absence-gated append and updated the P0131 checker, but R1 then failed separately on a malformed generated evidence `write()` call before checker execution or tracked writes.

P0167 R2 preserves the R0 fix, corrects the R1 delivery defect, keeps the existing 15-action panel limit, and changes no layout geometry, suppression policy, secure routing, camera behavior, or capability ownership.
