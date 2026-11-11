# P0448 — Selected enemy world aura attachment refresh

Date: 2026-11-11. Verified GitHub `main` P0447 `dca2b0a971a3f91f2e9ee528783b38407e7667de` from read-only GitHub. Reconstructed P0447 tracked baseline from previously author-verified P0446 and P0447 patch payload, with current source hashes checked against main. L-011 PARTIAL; L-028 OPEN.

## Observed Forever outcome

User reports P0447 selected enemy world health bar visually works, with native duplicate decoration removed; **buff/debuff icons are not yet present beside the world bar**. Report Bug screenshots `WoWScrnShot_111126_133425.jpg` and `WoWScrnShot_111126_133454.jpg` show selected enemy world health/name. Session 110, `0.0.317-dev`, records 3 world attachments, 2 detaches, 3 native decorative transfers, 2 restores, zero reported attachment/restore failures. This is a scoped visual PASS for the health bar only; target click, cast, alpha restoration and taint have not all been exhaustively exercised. No nameplate's native aura container was modified.

The exported status-aura history reports target harmful/helpful `max=0`, `positiveReads=0`, target aura event samples zero, and the final target source `unit-absent`. This **does not prove that combat auras were empty** during the screenshot, nor that the renderer failed: the capture was after target loss. Source availability is reported true. Missing icons remain an observed failure; keep both L-011 PARTIAL and L-028 OPEN.

## Narrow hypothesis and implementation

`HUD:RefreshLiveWorldEnemy` previously called `StatusAuras:RefreshWorldEnemyLiveLanes()` immediately after setting the owner visible, which only reused `self.last.target`. The last ordinary source scan could precede nameplate/target acquisition. On a world attach, P0448 calls `StatusAuras:RefreshWorldEnemyLiveSource` to scan ordinary `target` aura indices once in that event, update the existing target cache, record ordinary-source counts, then render the existing owned lanes. Subsequent `UNIT_AURA`/`PLAYER_TARGET_CHANGED` continue through the established event route. The scan is not a timer/poll; `C_Secrets.ShouldUnitAuraIndexBeSecret` and per-field `issecretvalue` remain the established gates. No attempt is made to reconstruct secret values or inspect native aura frames.

P0448 adds bounded source counts/reasons and owned-lane render/visibility counts to H World Enemy Status and Report Bug (`worldEnemyAuras`). This separates a source-empty/secret/restricted result from an owned render refusal. An unsuccessful source or icon render may leave the name/health bar usable with Blizzard's original aura owner preserved; it must not trigger a black matte or native click/cast/aura mutation. Keeps 100% selected frame, transparent background, original +/-25px lanes, P0447 native decorative alpha transfer/restoration, fallback, and disabled 50% secondary aggro. P0443 matte and P0446 hostile runtime failure remain historical negative evidence.

## Validation and acceptance boundaries

After guarded apply, user deploys P0448 to Forever and `/reload`, Report Bug > H > World Enemy ON. During a natural targeted enemy buff/debuff, verify H World Enemy Status reports attach scan, nonzero ordinary harmful/helpful source rows (when accessible), corresponding visible owned icon slots at the existing 25px gap, and no regression to the health bar/native interactions. If scans return `empty` or secret without ordinary rows, do **not** claim icon rendering fixed; retain safe stock auras and use Report Bug evidence to diagnose the source. If ordinary rows are positive but icon slots are absent, treat render as FAILED and investigate the owned lanes. Confirm target switch, World Enemy OFF, original Blizzard name/health restoration and no Lua/taint/protected errors. A source restriction is DEFERRED, not PASS. Secondary aggro remains gated. The user owns commit/push; do not declare P0448 runtime accepted from static checks.

## Release audit

Exact P0448 candidate author-check/receipt, complete repository checker count, ZIP integrity, transactional apply/reverse and deliberate baseline drift refusal are release gates; record actual outcomes before handoff. Do not mark unrun tests PASS.

## R0 author-check refusal (preserved)

P0448 R0 exact candidate author-check **REFUSED at 309/311** in an isolated candidate, before user application. The P0442 historical contract required the literal `P0442` lifecycle marker in CURRENT, which the first memory condensation removed. The P0444 transparency contract required the still-supported `RefreshWorldEnemyLiveLanes()` call in HUD; R0 only invoked the new source method. R1 restores the short P0442 marker and adds a capability-gated fallback to the historical renderer if the new source method is absent. Neither correction changes protected/native aura ownership. A new full author-check and matching receipt remain mandatory; 309/311 is not a release PASS.
