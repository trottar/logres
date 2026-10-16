# P0216 — H.3 whole-screen corrections: in-client evidence request

Date: 2026-10-16. Baseline **GitHub main P0215 `8386e91` verified**. Candidate runtime version `0.0.125-dev`. Status: **CANDIDATE — STATIC TRANSFORM / RUNTIME UNTESTED**.

## Source evidence / visual problem

User reports after P0215 push: shared texture art and one-focus parchment look good; action rows now sit on a black cluster-wide rectangle they preferred absent; player resource fill/endcap looks better but scale is still too small; completed and incomplete Active Quest panels look too similar. User's screenshots show one ongoing quest and another ready-to-return quest, with current header and parchment not separating state decisively. Latest uploaded diagnostics for 0.0.124-dev loadCount 285 contain final out-of-combat Run All with `activequestcheck` `complete=true ready=true`, H.2 layout 13/13 measured and Action/stock PASS within tested scope. These do not establish all click states or complete-candidate runtime PASS.

Repo source identifies exact action cluster texture in `ActionButton.CreateCluster()` (`BACKGROUND`, offset ±7px, RGBA black alpha .78), independent of individual button background. Removing only that texture preserves native WoW icons, approved sheet-03 state art and secure hitboxes. Shared normal bar width=142 is used by enemy and quest; changing it globally risks overflow into their fixed envelopes. Resource-only variant extends player track to 210 (12px high), 12px diamonds and 38px text, total 268px, versus old normal total 194px; remains below v4 22.5%-wide player-resource screen territory at user screenshot scale, without changing existing normal or compact consumers. Live frame fit at varied UI scales still unproven.

ActiveQuest currently computes `completeVisual` from existing already-read `ready`/`complete` booleans and uses only small color shifts plus a quiet phrase. P0216 retains source semantics, gives these two states explicit uppercase words, strengthens title/divider tint and shows a 2px header rule and 20px heraldic asset-derived seal only in complete/ready states. No extra read from Blizzard and no hidden progress counts.

## Acceptance gate

1. Verify full prewrite shadow checker suite, manifest and WSL deployment; then `/reload`.
2. In developer panel **Phase C → Action Check / Feedback Test** and **Phase F → Active Quest Preview / Active Quest Complete**, **Phase H → H.2 Map / Layout Check**, then **Phase 0 → Run All**.
3. Capture uncropped normal 16:9 gameplay screenshots, preview normal/complete if naturally needed: five role action clusters should not have a common black box, bronze buttons remain individually readable and click/hover respond, resource bar scales without colliding with casts/debuffs/native dock, and complete quest header/seal/rail are obviously distinct while text and rows remain clear.
4. Test Immersion OFF/ON and optional pet clicks, no taint/Lua/protected/secret errors. Never infer live checkout/control proof from static checks or previews; absent naturally occurring quests/status => DEFERRED.

## Boundaries and negative history

P0215 R0 candidate failed before tracked writes due to omitted CURRENT headings; R1 corrected and was pushed. No new error from that delivery should be erased. P0209 pet duplicate failures retained although tested P0211 closure is accepted. P0200 native restricted aura presentation continues as designed; no payload inspection. Older combat-time checkall can report pending/restricted states; do not count as static failure for this presentation-only patch.
