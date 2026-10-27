# P0360 — TargetFrame structural diagnostic ownership seam

**Verified baseline:** P0359 pushed GitHub main `6ec4b5ac3db1626c7273b8a2590d4492679b0c0c`, manifest 230/230 STATIC; `0.0.248-dev`, WoW UNVERIFIED. The original status-only `runTargetFrameCheck` body moves from Commands to preloaded `Immersion/TargetFrameReplacement.lua`, preserving PASS/FAIL, target aura/context counts, secure action status, stock restoration and native target-of-target/party fallback. Commands retains exact Run All/slash/developer-panel routes. No new runtime state mutation.

Historical target checker receives report ownership migration; P0359 exact #230 count is advanced to >=230 and new P0360 #231 checker verifies original behavior. Candidate `0.0.249-dev`; 94 Lua, 120 actions/38 previews, schema3/D-048 and camera unchanged. P0321 FIRST contingent client gate, L-022/L-027/L-028 OPEN; L-019 public release BLOCKED. Runtime remains UNVERIFIED.

P0354 R0/R1/R2, P0355 R0/R1, P0358 R0 negative evidence is preserved in its original files. See `docs/memory/evidence/P0360_TARGET_FRAME_DIAGNOSTIC_SEAM.md` for narrowed hypothesis, proposed checker gates and deferrals. No release/client claims from static checks.
