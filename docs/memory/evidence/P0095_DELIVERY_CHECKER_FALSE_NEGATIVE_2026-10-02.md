# P0095 Delivery Checker False Negative — 2026-10-02

Status: DELIVERY FAILURE — NO TRACKED REPOSITORY MUTATION
Date: 2026-10-02
Baseline: P0094 `9db11d2b`

## Failure

The first P0095 artifact reached temporary-tree validation and stopped at:

```text
Logres G.2 camera zoom capability probe contract
================================================
ERROR: Commands.lua missing camera probe contract: "STARTED"
ERROR: Commands.lua missing camera probe contract: "click Camera Zoom Probe again after the movement finishes"

FAILED: 2 error(s)
P0095: command failed (1): python3 tools/check_camera_probe_contract.py
```

## Diagnosis

The runtime command implementation was present.

The checker incorrectly required two phrases as complete quote-delimited Lua
tokens:

- `"STARTED"`;
- `"click Camera Zoom Probe again after the movement finishes"`.

The generated command intentionally embeds both inside one longer format string:

`Logres camerazoomprobe: STARTED (...; click Camera Zoom Probe again after the movement finishes)`

The checker therefore produced a false negative.

## Repository effect

The failure occurred during temporary `git archive` validation, before the
tracked-file write phase.

Therefore:
- no P0095 tracked source or memory file was written by the failed apply;
- no P0095 manifest was created;
- remote `main` remained P0094 `9db11d2b`.

The extracted P0095 applier/readme/payload are delivery artifacts only.

## Correction

P0095 R2 requires semantic substrings that actually occur inside the generated
format string:

- `camerazoomprobe: STARTED`;
- `click Camera Zoom Probe again after the movement finishes`.

R2 also adds an artifact self-test tying those expectations to the generated
camera command function.

No runtime camera behavior changed between the failed P0095 artifact and R2.
