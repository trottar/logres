# P0354 R3 — HUD diagnostic seam; CURRENT.md is authoritative

GitHub main P0353 R1 `bac01ad18554157265e292fbf0c8982e3c3473d8`: 224/224 PREWRITE/POSTWRITE STATIC, `0.0.242-dev`, WoW UNVERIFIED. The original HUD-only diagnostic moves into preloaded HUD/HUD.lua; Commands keeps the exact wrapper, Run All ordering, slash and Phase B panel. Candidate `0.0.243-dev`: 94 Lua, 120 actions (38 previews), checker #225. No schema 3, D-048 live selector, camera/D-047, Blizzard native suppression, secret-value inspection, events or polling. D-046 remains preview-first.

## Failed candidates — retained evidence

P0353 R0: native-access ownership assertion REFUSED 57/224, zero writes; R1 passed. P0354 R0: truncated Bootstrap blob SHA REFUSED before PREWRITE, zero writes. P0354 R1: exact version pin REFUSED 27/225 at check_checker_version_policy.py, zero writes. P0354 R2: overlong CURRENT_HANDOFF.md REFUSED 55/225 at check_memory_health.py, zero writes. R3 fixes memory budget without weakening checker policy. See `docs/memory/evidence/P0354_HUD_DIAGNOSTIC_SEAM.md`, `docs/memory/patches/P0354_HUD_DIAGNOSTIC_SEAM.md` and `docs/memory/handoffs/P0353_FULL_HANDOFF_ARCHIVE.md` (unaltered full earlier handoff).

## Safety gates and next action

Require 225/225 PREWRITE and POSTWRITE STATIC plus diff hygiene and manifest; user commits/pushes, verify main before advancing. WoW remains UNVERIFIED. P0321 GossipFrame stock restoration is the FIRST contingent client safety gate. L-022 focused quest artifact, L-027 transient popup and L-028 target debuffs OPEN; L-019 license public distribution BLOCKED. L-031 compass natural validation deferred. P0337 quest-giver evidence `cfdc07af` preserved. Do not imply runtime PASS.

## Historical continuity (full context in archived handoff and evidence)

P0317 P0318 P0319 P0320 P0321 P0322 P0323 P0324 P0325 P0326 P0327 P0328 P0329 P0330 P0331 P0332 P0333 P0334 P0335 P0336 P0337 P0338 P0339 P0340 P0341 P0342 P0343 P0344 P0345 P0346 P0347 P0348 P0349 P0350 P0351 P0352 P0353
