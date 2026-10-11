# P0199 — Approved-sheet-to-runtime visual fidelity audit

Date: 2026-10-11. Baseline: verified `main` `ed6ca7b2cb309a593f255f0bce071101ceaa4fd5` (P0198). Type: documentation/audit checkpoint. No Lua/TGA/assets, runtime version bump, or WoW redeployment.

**Authority:** `docs/design/approved/README.md` (12 detailed sheets), D-039, D-040, D-045, `Logres/Media/Theme.lua`, and `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md` (historical implementation-status baseline). The current user screenshot is ordinary-play visual evidence for the displayed states only.

**Audit:** `docs/design/H3_APPROVED_ART_RUNTIME_FIDELITY.md` maps every sheet to its current module/assets, distinguishes completed translation from art/state/source gaps, and establishes the next bounded integrated implementation. Highest-fidelity discrepancy is the native harmful aura family (18px / 2px / native quickslot border) versus 25px target-status and 36px restored authored player buffs. This is not an instruction to apply one icon size indiscriminately or to inspect native restricted aura members. Preserve secure native renderer, stock fallback, and approved v4 geometry.

**Next:** After P0199 push verification, prepare one coordinated H.3 runtime candidate for native harmful aura art/fit, percentage text/contrast, and action/native-dock hierarchy; validate the whole screen before accepting. Existing historical visual PASS and negative results remain authoritative in their tested scope. No H.3 runtime result is claimed by P0199.

**Open:** PetActionBar duplicate OPEN / INTERMITTENT / UNREPRODUCED, P0197 post-combat deferred branch untested; ObjectiveTracker flash unreplicated; special/pet/auras interaction environmental deferrals retained. Do not suppress other Blizzard controls or alter combat/protected code as an art fix.

## Delivery correction — R0 to R1

P0199 R0 failed **before any tracked writes**: its expected Git blob SHA for
`docs/memory/patches/PATCH_INDEX.md` was truncated to 39 hexadecimal
characters (`5f3d411069842bbf694d45dabe954c49a0430a9`), whereas the
actual baseline blob is `5f3d411069842bbf694d45dabe954c49a0430a9a`.
The user's reported `git status --short` contains no tracked modifications.
R1 corrects only that pin and validates the length and syntax of every pinned
Git SHA before modification. This is an artifact-delivery failure, **not** a
WoW runtime failure or H.3 visual test. No other scope change.
