# P0160 R2 — Source-Backed LibCamera Zoom Driver

Date: 2026-10-07
Baseline: `8ddcf09844961adec7bc90621f0f5ca294f15aef`
Candidate runtime: `0.0.79-dev`
Result: **INSTALLED / PUSHED — RUNTIME PASS FOR BASE + NORMAL TAXI OUTBOUND/LANDING** (`ae75989b`)

## Trigger

P0159 R1 passes profile/context baseline and Taxi entry, then fails the post-Taxi City transition with:
- start about 49.756;
- target 5;
- final 0;
- 97 samples;
- 80 direction switches;
- max absolute easing-position error about 49.471.

## Correction

The bespoke Logres transition algorithm is replaced by an adaptation of the ordinary zoom path from:

`mpstark/LibCamera@c0b23135a0b24fbca24b41cb53dd7afc9114e352`

Ported semantics:
- InOutQuad easing;
- source finite-difference easing velocity;
- source position/time rebase, threshold 0.5;
- rebase precision 0.005;
- max 100 rebase iterations;
- source final two-frame linear correction;
- source final 0.1-second CameraZoom correction;
- temporary cameraZoomSpeed ownership;
- exact previous cameraZoomSpeed restoration.

Logres retains stop-before-reverse and secret/fail-open guards.

## CVar boundary

P0160 R2 explicitly narrows the prior blanket no-SetCVar rule.

Allowed:
- temporary `cameraZoomSpeed` change for the source final correction;
- exact restoration of the captured previous value.

Still forbidden:
- `cameraDistanceMaxZoomFactor` mutation;
- arbitrary persistent camera-setting writes;
- periodic reassertion.

## Initial P0160 delivery failure

The first P0160 artifact never touched tracked files.

Its shadow candidate failed because the applier attempted to replace an obsolete exact P0154 diagnostic-output string in the historical checker. This was a delivery/schema defect, not runtime evidence.

R1 replaced affected camera checker files as complete candidate files rather than rewriting brittle old output strings.

## P0160 R1 delivery failure

R1 also refused before tracked writes. Its shadow candidate reached `docs/memory/roadmap/STATUS.md`, where the applier expected the stale Phase H row `| H — Integration and Polish | QUEUED — NEXT AFTER G.5; approved visual translation underway in parallel |`. The verified `8ddcf098` baseline instead contains `| H — Integration and Polish | QUEUED — approved visual translation underway in parallel |`.

The user's resulting status showed only untracked diagnostics and the unpacked `P0160_R1_PAYLOAD/` transport directory; no tracked file was changed.

R2 corrects that exact baseline anchor. The runtime design is otherwise unchanged from R1.

## Validation

After deployment:
1. `/reload`;
2. Phase G -> Camera Profile Check;
3. Phase 0 -> Run All;
4. normal Taxi;
5. Camera Profile Check in flight;
6. Camera Profile Check after landing/settle;
7. refreshed diagnostics.

PASS requires destination convergence near 5 with failures=0 and no recurrence of the 0/50 oscillation.

## Durable runtime result

Verified main:
`ae75989bc0acadf550bd26e39c9bc70acee3e46c`.

Runtime:
`0.0.79-dev`, loadCount `191`, client `1.60.1.70245`.

Base:
- Camera Profile Check PASS;
- separate Run All PASS.

Taxi outbound:
- start about `4.0096`;
- target/final `50`;
- 347 samples;
- 346 toward / 0 away;
- 0 switches;
- 2 rebases;
- failures=0.

Landing:
- start `50`;
- target `5`;
- final about `4.9806`;
- 158 samples;
- 156 toward / 1 away;
- 0 switches;
- 2 rebases;
- failures=0.

The user visually confirmed the camera zoomed out and returned close after landing.

Classification:
**P0160 R2 RUNTIME PASS.**

The source rebase branch is runtime-exercised in both directions. The final 0.1-second correction remained installed but was not needed in this accepted sample (`corrections=0`).

G.5 Taxi zoom convergence is closed for observed scope.

Next:
P0161 captured rotations + camera-setting ownership/restoration.
