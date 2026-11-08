# Ledger first: docs/memory/investigations/ISSUE_LEDGER.md

**P0400 flight host; P0399 position FAIL; P0396 purchase PASS; P0395 labels PASS; P0394 sale/buyback PASS; P0393 quantity; P0392 visual FAIL; P0391 trainer PASS scoped; flash deferred; P0390 session 44; P0389 session 41 repair; P0388 L-027; P0387 CANDIDATE (P0384 `c1c77e2` 254 STATIC; P0383 `cc783a0` claim PASS scoped; P0382 Continue no-flash, L-040 EST; L-005/L-001/L-002 OPEN):** verified main P0379 `285be528` and manifest 249/249 STATIC. Forever 0.0.264-dev incident 2399: hover, no down/up/dispatch/claim; L-005 PARTIAL/FAIL. L-002 native Continue gap; L-039 tracker text/icon collision owner UNKNOWN (1321); L-001/L-025/L-029/L-033/L-034 remain open/partial. P0381 integration; see P0380 evidence. P0381 R0 PREWRITE REFUSED at P0241 (77/251): direct `pcall(CompleteQuest)` violated historical native-ownership contract; zero tracked writes. P0380 R3 REFUSED on policy format, zero writes; R4 fixed. Before code ZIP audit `docs/memory/PRE_HANDOFF_AUDIT.md`. P0379 R0 and P0379 R1 PREWRITE REFUSED, no tracked writes. P0380 R0 REFUSED on an unnecessary ActiveQuest.lua blob gate; no tracked writes. P0380 R1 PREWRITE REFUSED 27/250: new checker pinned runtime version; no tracked writes. R2 uses dynamic TOC/Bootstrap version parity. No runtime change in P0380.

P0385 2/0; P0386 stale accept FAIL; P0387 guard; L-002 OPEN. P0379 R2 completion input provenance; main P0378 `4ffbe3b` verified, 12 inferred screenshot matches. R0 REFUSED 129/249 PREWRITE (CURRENT bytes); R1 REFUSED 191/249 PREWRITE (HANDOFF bytes), both no tracked writes. L-005 Complete Quest input origin unknown; L-002 Continue native-only OPEN. R2 addon-owned event/geometry diagnostics only; 249 STATIC and WoW UNVERIFIED. See P0379 evidence and `CURRENT.md`.

P0372 `39f404c` PASS. P0373 v0.0.260-dev, checker #243: trainer purchase FAIL; Trainer denial shows cause and restores native stock; guards intact. Quest popup L-002/L-005 FAIL: keep safe Blizzard fallback; record QUEST_COMPLETE ownership/fallback. L-001 FAIL, L-021 PASS, L-019 BLOCKED. P0378 ZIP; P0377 R0-R3 REFUSED, choice; L-035/L-038; P0376, P0375, P0374; P0373 claim unconfirmed; L-034 OPEN. P0372 R0–R3 and P0373 R0/R1 checker REFUSED; P0371 R0/R1 REFUSED; P0362 P0363 P0367 P0368 P0370; P0369 R0/R1, P0366 R0, P0365 R0, P0364 R0; P0337 `cfdc07af`; P0354 R0 P0354 R1 P0354 R2 check_memory_health.py; P0355 R0 P0355 R1, P0358 R0, P0361 R0 handoff. D-046/D-047/D-048 and L-022/L-027/L-028/L-031/L-033 OPEN/DEFERRED. No polling or native-secret inspection.

# P0361 — ImmersionController diagnostic owner; CURRENT.md authoritative

Verified pushed P0360 main `8963fb1d5ffc32d71291292e9e1192e16b68cf3b` 231/231 PRE/POST STATIC, `0.0.249-dev`; WoW UNVERIFIED. Move only original read-only immersioncheck PASS/FAIL report to preloaded Immersion/Controller; Commands wrapper, Run All, slash and Phase D panel unchanged. Candidate `0.0.250-dev`, checker #232, Lua94/actions120/previews38, schema3/D-048 and camera unchanged. P0321 GossipFrame FIRST client gate, L-022/L-027/L-028 OPEN, L-019 BLOCKED, L-031 deferred. Historical P0354 R0/R1/R2 check_memory_health.py, P0355 R0/R1 and P0358 R0 refusals preserved; P0337 `cfdc07af` retained. P0361 R0 handoff error (premature client deployment instructions) corrected in R1; no WSL result from R0 recorded. No WoW deployment or in-client validation in P0361.

# P0360 — D-026 TargetFrame diagnostic seam; CURRENT.md authoritative

Verified pushed P0359 main `6ec4b5ac3db1626c7273b8a2590d4492679b0c0c`: 230/230 PREWRITE/POSTWRITE STATIC, `0.0.248-dev`, WoW UNVERIFIED. Move only D-026 read-only TargetFrame structural PASS/FAIL report into preloaded Immersion/TargetFrameReplacement. Commands wrapper, Run All, slash and panel keep exact behavior; target aura/context preserved, target-of-target/focus/boss/party remain Blizzard-owned. Historical target checker rehomes diagnostic-only assertions; P0359 #230 ceiling becomes floor. Candidate `0.0.249-dev`, #231, 94 Lua, 120 actions/38 previews; schema3, D-046, D-047 camera and D-048 selectors unchanged. No runtime frame mutation, secret inspection, event or polling. P0321 GossipFrame restore FIRST contingent client gate; L-022/L-027/L-028 OPEN, L-019 BLOCKED, L-031 deferred. P0354 R0/R1/R2 check_memory_health.py, P0355 R0/R1 and P0358 R0 refused with zero writes and remain preserved. P0337 `cfdc07af` retained. WoW runtime UNVERIFIED.

# P0359 — D-026 PlayerFrame diagnostic seam; CURRENT.md authoritative

P0359 moved only read-only PlayerFrame diagnostics to the controller; native/secure behavior unchanged. Baseline P0358 R1 229 STATIC, client UNVERIFIED. P0321 gate, L-019 and L-022/L-027/L-028/L-031 unresolved; full history in evidence.

# P0358 — D.3 Quiet Mode diagnostic; CURRENT.md authoritative

P0358 moved only Quiet Mode diagnostics while retaining chat restoration and outbound chat. P0358 R0 REFUSED; R1 STATIC, WoW UNVERIFIED. Original negative evidence in P0358 records; P0321 and L-019 remain blocked.

# P0357 — F.6 read-only objective-progress diagnostic; CURRENT.md authoritative

P0357 moved only objective-progress diagnostics to the quest module; P0356 227 STATIC, WoW UNVERIFIED. No quest/native/camera mutation; P0321/L-019/L-022/L-027/L-028 still unresolved. See evidence.

# P0356 — F.3 XP diagnostic ownership; CURRENT.md is authoritative

Verified pushed P0355 R2 `fac39a1e3960c7d9a238f76543027838647330ed`: 226/226 PREWRITE/POSTWRITE STATIC, `0.0.244-dev`. XP structural report moves to preloaded Quest/XP.lua; Commands preserves exact Run All, slash, Phase F developer panel. XP live sample policy untouched. Candidate `0.0.245-dev`, checker #227, Lua94/actions120/previews38; WoW UNVERIFIED. P0321 GossipFrame stock restoration FIRST client gate; L-022/L-027/L-028 OPEN, L-019 public release BLOCKED; L-031 deferred, D-046/047/048 unchanged.

# P0355 — read-only primary stock ownership report; CURRENT.md authoritative

Verified pushed P0354 R3 main `4254d0a80f2f8ffd98a708836482a093bed06e62`: 225/225 PREWRITE/POSTWRITE STATIC, version `0.0.243-dev`, WoW UNVERIFIED. Extract ONLY command-invoked P0173 primaryownershipcheck report into preloaded Actions/Primary.lua. Commands keeps local wrapper, Run All, slash and action panel; primary stock-action suppression remains UNAUTHORIZED, candidate-only and stock-preserved. P0173 original native gate remains unchanged. Candidate `0.0.244-dev`, #226, 94 Lua and 120 panel actions/38 previews, schema 3 unchanged. No native/protected mutation, secret inspection, polling, camera or D-048 live selector.

## Safety gates and negative evidence

P0321 GossipFrame restoration FIRST contingent in-client gate; L-022 focused-quest artifact, L-027 native popup, L-028 target debuffs OPEN; L-019 public distribution BLOCKED; L-031 natural compass validation DEFERRED. WoW runtime remains UNVERIFIED. P0354 R0 Git SHA guard, P0354 R1 check_checker_version_policy.py, P0354 R2 check_memory_health.py: REFUSED with zero tracked writes; P0354 R3 passed. P0355 R0 handoff assertion REFUSED before shadow checks, zero tracked writes. P0355 R1 historical P0354 checker REFUSED at 191/226 because check_memory_health.py marker missing; zero tracked writes. P0353 R0 checker refusal preserved. See `docs/memory/evidence/P0354_HUD_DIAGNOSTIC_SEAM.md`, `docs/memory/handoffs/P0353_FULL_HANDOFF_ARCHIVE.md`, and P0355 evidence. P0337 `cfdc07af` and D-046 preview-first, D-047 frozen camera, D-048 offline only preserved.

## Next action and historical continuity

Require 226/226 PREWRITE/POSTWRITE STATIC, `git diff --check`, manifest; user commits and pushes, then verify GitHub main. Historical milestones (full details in evidence, archived handoff and roadmap):

P0317 P0318 P0319 P0320 P0321 P0322 P0323 P0324 P0325 P0326 P0327 P0328 P0329 P0330 P0331 P0332 P0333 P0334 P0335 P0336 P0337 P0338 P0339 P0340 P0341 P0342 P0343 P0344 P0345 P0346 P0347 P0348 P0349 P0350 P0351 P0352 P0353 P0354 P0355
