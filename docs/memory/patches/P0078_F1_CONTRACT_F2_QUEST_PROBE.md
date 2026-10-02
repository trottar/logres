# P0078 — F.1 Contract / F.2 Quest-XP Probe

Date: 2026-10-02
Result: INSTALLED / PUSHED — CAPABILITY EVIDENCE; RESTORATION CHECK FAILED (`8b38fe64`)

## Baseline

P0077 verified pushed:
`bf73fcf49e31177e9305652e509fd46a4aad12dc`

## F.1

D-031 accepted.

## F.2 runtime result

Proven:
- current/max/rested XP normal scalar inputs;
- XP/update exhaustion events;
- quest-detail passive reads;
- quest-detail/accept events;
- super-tracked quest identity.

Unproven:
- populated objective rows.

Negative:
- quest 436 destination remained unavailable.

## Integrated validation

Run All hit:
**Restoration Check FAIL — opposite preference state did not settle.**

Cleanup succeeded and final state reconverged.

P0079 adds targeted diagnostic detail before any behavioral fix.

## Delivery note

The first apply attempt had a memory-heading delivery failure, repaired before
the final P0078 commit.

Production runtime remained:
`0.0.30-dev`.
