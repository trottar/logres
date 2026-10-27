# P0360 — D-026 TargetFrame read-only diagnostic ownership

**Baseline:** verified pushed P0359 main `6ec4b5ac3db1626c7273b8a2590d4492679b0c0c`, committed manifest 230/230 PREWRITE/POSTWRITE STATIC, `0.0.248-dev`, WoW runtime UNVERIFIED. This baseline is repository authority, not in-client confirmation.

## Scope and rationale

The command-invoked `runTargetFrameCheck` diagnostic in `Logres/Core/Commands.lua` contains a status-only report. Its `Logres:GetModuleStatus`, module `GetDebugStatus`, immersion preference and combat-lockdown reads inspect addon-owned control state; no protected frame is mutated and no new Blizzard state is sampled. The original PASS/FAIL report verifies preserved target auras/context (four preserved and nine suppressed context slots), secure target interaction, stock fallback, and that target-of-target, focus, boss, and party surfaces remain Blizzard-owned.

Extract that entire original body unchanged except its declaration to earlier-loaded `Logres/Immersion/TargetFrameReplacement.lua` as `TargetFrameReplacement:RunDevTargetFrameCheck(emit, boolText)`. `Commands.lua` keeps the exact wrapper, Run All order, `/logres targetframecheck` and Phase D developer action. D-026 live replacement, suppression, restoration, protected-action and secret-value policies are unchanged.

The historical target static checker moves ONLY report-specific required strings and its obsolete/protected diagnostic-field exclusion to the new module-owned report, while maintaining existing stock preservation and secure interaction rules. P0359's exact #230 checker count becomes a >=230 floor to allow new P0360 checker #231, without weakening its original PlayerFrame contract. Candidate `0.0.249-dev`, 94 Lua entries, 120 developer panel actions (38 previews), saved schema 3 unchanged. No camera/D-047 or D-048 live selectors, events, timers, or polling.

## Gates and negative evidence

P0360 applier verifies exact main SHA, clean tracked baseline, 13 complete source blob guards, generator source/path coverage and version-policy/memory checks before a 231/231 PREWRITE shadow check, then 231/231 POSTWRITE checks and diff hygiene. These check outcomes must be recorded in generated `P0360_MANIFEST.txt`; no PASS may be claimed without actual WSL execution. On refusal preserve errors and zero tracked writes (or roll back tracked writes after postwrite error).

P0321 GossipFrame native restore remains FIRST contingent client safety gate; WoW runtime UNVERIFIED. L-022 focused quest artifact, L-027 native popup and L-028 target aura inconsistency OPEN. L-019 public release BLOCKED. L-031 environmental validation deferred. P0354 R0/R1/R2, P0355 R0/R1, P0358 R0 failures remain in earlier evidence unchanged. Historical P0337 `cfdc07af` retained.
