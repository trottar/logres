# P0481: L-035 one-NPC probable3/4yd lock; UNVERIFIED.
# P0480: passive proof; P0479 FAIL.
# P0479: L-035 P0478 VISUAL FAIL; no tildes.
# P0478: map-only FAIL; P0477 hide FAIL.
# P0477: #16399 false-floor 2yd.
# P0476: NPC snap FAIL; L-002 flash OPEN.
# P0475: L-037 PARTIAL; P0474 PASS.
# P0474: P0473 #16018 FAIL.
# P0468: L-051 auras; runtime UNVERIFIED.
# P0466: names/defaults scoped PASS.
# P0465: Sheet04 accepted.
# P0464: per-unit transaction retained.

# P0463: `b849955` session 134 #13743/#13745/#13748 regression.
Unprotected native aura layout; cached plate replay/prebuilt ON;
tracker secure OOC gate + safe refold. P0460 HP retained; client UNVERIFIED.

# P0462: pending ON implemented, aura layout deferred; latest user FAIL.
Native tracker visible #13745; actual NPC QuestFrame not shown.

# P0461: prior main `edf37197`, session 132 #13580 P0460 HP PASS.
Native nameplate aura fallback VISUAL FAIL in #13659; keep selected/
secondary geometry and identity. P0449 icons PASS, P0450 duplicate FAIL.

# P0460: P0459 `0cbc8cc`/tree `64af7ead` verified. Forever
#13499 0.0.328-dev VISUAL FAIL after brief success: selected 4/4
and secondary 3/3 restores, last selected `unknown-attached-unit`.
P0459 target-query owner lost nameplate identity, so any other REMOVE
hid selected. P0460 caches ADD epochs; ignores unrelated REMOVE; restores
matching/unknown/unsafe/reused/OFF owners. Selected 100%, 50% hostile secondary,
native cast/aura/click unchanged. L-011/L-028 OPEN; WoW UNVERIFIED.

# P0459: P0458 #13250 VISUAL FAIL on threat 0/1; P0459 skins
hostile nonselected independent of threat. #13499 regression P0460.
Prior P0454/P0455/P0458 failures preserved; no blanket suppression.

# P0458: 40-owner trial; #13250 VISUAL FAIL on threat loss.
# P0457: selected continuity; not secondary repair.
# P0456: P0455 visual FAIL; secondary suspended.
# P0455: secondary flicker visual FAIL.
# P0454: secondary 50/50 visual FAIL.

# P0453: #12124 14 threat samples, 12 secret; read-only,
no render. P0450 selected PASS scoped; OFF/taint open.

# P0451: history.

# P0450: selected world health/native aura visual PASS scoped; OFF/taint
unverified. Preserve restore, click/cast/CC. L-011/L-028 OPEN.

# P0449: P0448 aura FAIL; P0449 world icons PASS.

# P0448: Ledger first: docs/memory/investigations/ISSUE_LEDGER.md

P0447 HP PASS, auras missing. P0448 source scan Forever FAIL;
L-011/L-028 OPEN; details in P0448 evidence.

**P0428 Chat workflow in CURRENT; P0412/P0411/R0 refusals, P0410,
P0409/P0408/P0407/P0406/P0405/P0404 PASS, P0403 L-001, P0402;
P0401 PASS, P0400/P0399 FAIL; P0396–P0392 merchant; P0391 trainer;
P0390, P0389, P0388 L-027, P0387, P0384 `c1c77e2` 254 STATIC;
P0383 `cc783a0` quest18 PASS scoped; P0382 Continue; L-040:**
P0379 `285be528` 249 STATIC; #2399 no input dispatch;
L-005 PARTIAL, L-002 native OPEN; L-039 UNKNOWN.
P0381 R0 PREWRITE REFUSED P0241 (77/251) on protected quest handoff;
P0380 R0–R4 history retained; P0379 R0, P0379 R1 PREWRITE REFUSED;
no writes. See CURRENT/P0379 evidence for precise negative results.

P0385 2/0; P0386 stale accept FAIL; P0387 guard; L-002 OPEN.
P0379 R2 completion input provenance; P0378 `4ffbe3b` verified,
12 screenshot inferences. R0/R1 PREWRITE REFUSED at 129/249 and
191/249 (CURRENT/HANDOFF budgets), no writes. L-005 input unknown,
L-002 native Continue-only OPEN. R2 addon geometry diagnostics only,
249 STATIC, WoW UNVERIFIED; see P0379 evidence.

P0372 `39f404c` PASS. P0373 v0.0.260-dev, checker #243: trainer purchase FAIL; Trainer denial shows cause and restores native stock; guards intact. Quest popup L-002/L-005 FAIL: keep safe Blizzard fallback; record QUEST_COMPLETE ownership/fallback. L-001 FAIL, L-021 PASS, L-019 BLOCKED. P0378 ZIP; P0377 R0-R3 REFUSED, choice; L-035/L-038; P0376, P0375, P0374; P0373 claim unconfirmed; L-034 OPEN. P0372 R0–R3 and P0373 R0/R1 checker REFUSED; P0371 R0/R1 REFUSED; P0362 P0363 P0367 P0368 P0370; P0369 R0/R1, P0366 R0, P0365 R0, P0364 R0; P0337 `cfdc07af`; P0354 R0 P0354 R1 P0354 R2 check_memory_health.py; P0355 R0 P0355 R1, P0358 R0, P0361 R0 handoff. D-046/D-047/D-048 and L-022/L-027/L-028/L-031/L-033 OPEN/DEFERRED. No polling/secret inspection.

# P0361 — ImmersionController diagnostic owner; CURRENT.md authoritative

P0360 `8963fb1d` 231/231 STATIC; WoW UNVERIFIED. P0361 moves read-only immersioncheck to Immersion/Controller; Commands, Phase D, schema3/D-048 and camera unchanged; #232. P0321 GossipFrame FIRST client gate, L-022/L-027/L-028 OPEN, L-019 BLOCKED, L-031 deferred. Historical P0354 R0/R1/R2 check_memory_health.py, P0355 R0/R1 and P0358 R0 refusals preserved; P0337 `cfdc07af` retained. P0361 R0 handoff error (premature client deployment instructions) corrected in R1; no WSL result from R0 recorded. No WoW deployment or in-client validation in P0361.

# P0360 — D-026 TargetFrame diagnostic seam; CURRENT.md authoritative

P0359 `6ec4b5a` 230/230 STATIC, WoW UNVERIFIED. Read-only D-026 TargetFrame check moves to TargetFrameReplacement; Commands, target auras and native target-of-target/focus/boss/party unchanged. Historical target checker rehomes diagnostic-only assertions; P0359 #230 ceiling becomes floor. Candidate `0.0.249-dev`, #231, 94 Lua, 120 actions/38 previews; schema3, D-046, D-047 camera and D-048 selectors unchanged. No runtime frame mutation, secret inspection, event or polling. P0321 GossipFrame restore FIRST contingent client gate; L-022/L-027/L-028 OPEN, L-019 BLOCKED, L-031 deferred. P0354 R0/R1/R2 check_memory_health.py, P0355 R0/R1 and P0358 R0 refused with zero writes and remain preserved. P0337 `cfdc07af` retained. WoW unverified.

# P0359 — D-026 PlayerFrame diagnostic seam; CURRENT.md authoritative

P0359 moved read-only PlayerFrame diagnostics; native unchanged. P0358 R1 229 STATIC, WoW UNVERIFIED; P0321 gate, L-019/L-022/L-027/L-028/L-031 unresolved; see evidence.

# P0358 — D.3 Quiet Mode diagnostic; CURRENT.md authoritative

P0358 moved only Quiet Mode diagnostics while retaining chat restoration and outbound chat. P0358 R0 REFUSED; R1 STATIC, WoW UNVERIFIED. Original negative evidence in P0358 records; P0321 and L-019 remain blocked.

# P0357 — F.6 read-only objective-progress diagnostic; CURRENT.md authoritative

P0357 moved only objective-progress diagnostics to the quest module; P0356 227 STATIC, WoW UNVERIFIED. No quest/native/camera mutation; P0321/L-019/L-022/L-027/L-028 still unresolved. See evidence.

# P0356/P0355 diagnostic seam history (archived)

P0356 XP diagnostic ownership and P0355 primary stock ownership
remain documented in evidence and historical handoffs. P0321/L-019
BLOCKED, L-022/L-027/L-028 OPEN; refusals preserved below.

## Safety gates and negative evidence

P0321 GossipFrame restoration FIRST contingent in-client gate; L-022 focused-quest artifact, L-027 native popup, L-028 target debuffs OPEN; L-019 public distribution BLOCKED; L-031 natural compass validation DEFERRED. WoW runtime remains UNVERIFIED. P0354 R0 Git SHA guard, P0354 R1 check_checker_version_policy.py, P0354 R2 check_memory_health.py: REFUSED with zero tracked writes; P0354 R3 passed. P0355 R0 handoff assertion REFUSED before shadow checks, zero tracked writes. P0355 R1 historical P0354 checker REFUSED at 191/226 because check_memory_health.py marker missing; zero tracked writes. P0353 R0 checker refusal preserved. See `docs/memory/evidence/P0354_HUD_DIAGNOSTIC_SEAM.md`, `docs/memory/handoffs/P0353_FULL_HANDOFF_ARCHIVE.md`, and P0355 evidence. P0337 `cfdc07af` and D-046 preview-first, D-047 frozen camera, D-048 offline only preserved.

## Next action and historical continuity

Require 226/226 PREWRITE/POSTWRITE STATIC, `git diff --check`, manifest; user commits and pushes, then verify GitHub main.

P0317 P0318 P0319 P0320 P0321 P0322 P0323 P0324 P0325 P0326 P0327 P0328 P0329 P0330 P0331 P0332 P0333 P0334 P0335 P0336 P0337 P0338 P0339 P0340 P0341 P0342 P0343 P0344 P0345 P0346 P0347 P0348 P0349 P0350 P0351 P0352 P0353 P0354 P0355
