# P0450 — World aura ownership and screen/native duplicate handoff

## Runtime evidence (2026-11-11, Forever 1.60.1 build 70888)

P0449 pushed on GitHub main `19050699cd474be0deb235777b678b3feec290dc`.
User: **"Cool, works. Blizz aura is still there and there is a second copy where frame use to be"**.
Latest Report Bug session 112, 0.0.319-dev, incident #11961 at 15:13:54 EST:
visible selected Forest Spider (42% HP) with a three-icon group at the
world-attached bar and an additional three-icon group at the old right-side
screen target position. Screenshot association is timestamp-inferred.
`worldEnemyNativeReady=true`, `worldEnemyNativeReason=native-delegated`,
`worldEnemyNativeVisibilityProof=unobserved`, one successful world attachment,
zero attachment/native-restore failures; screen-name/HP fallback hidden,
`screenSpaceEnemyFrameEnabled=false`. Native target harmful container remains
active (`nativeActive=true`), independent of that screen-frame preference.
The user confirms world icons visually; diagnostics alone do not count icons.
**P0449 world aura visibility PASS (selected target); duplication FAIL.**
No click/cast/restoration full-session acceptance follows from this screenshot.
L-011 PARTIAL and L-028 OPEN, now ownership overlap rather than source failure.

## Narrow ownership hypothesis and P0450 candidate

- The existing P0183 `Native.Create` adds an independent addon-owned native
  `target` AuraContainer at the screen anchor, which `Native.SetActive` keeps
  active despite the P0446 *name/health* screen handoff. Introduce a separate,
  strictly addon-owned, reversible alpha token on that frame **only after a
  successful world Show**, restore on detach/target switch/OFF/failure, and
  record refusal. No mutations of unit, secure controls or aura content.
- Blizzard's nameplate `UnitFrame.AurasFrame.DebuffListFrame` and
  `.BuffListFrame` are separate **decorative** aura-list surfaces. Only when
  both are ordinary, accessible and unprotected *and* the P0449 world-native
  engine is ready, capture their alpha as opaque restore tokens before any
  mutation; suppress these two lists alongside P0447 name/health decoration.
  If either region is unavailable/protected, leave both stock lists untouched.
  Preserve native cast, CC/loss-of-control, selection, click and unit frame.
- No hooks, polling, reparenting, CVar changes, secret payload reads,
  native-child enumeration or secondary aggro promotion. Preserve +/-25px
  world-native HARMFUL/HELPFUL lanes, P0444 clear backing and P0447 health.
- Record screen alpha handoff/refusal and native list claim/restoration in
  World Enemy Status and Report Bug. A successful `SetAlpha` call is not
  proof that native visuals are absent; Forever screenshot is required.

## Release and live acceptance

Use exact P0449 tracked baseline, verify user-owned main, author-check the
P0450 JSON, exact rollback and the guarded ZIP. Static PASS does not establish
Forever protected-state safety. Test selected enemy with known aura, world
attachment, same screen right-side absence, native overhead duplicate absence,
click/cast, target switch, detach, World Enemy OFF and stock aura restoration.
Lua/taint/protected/secret errors are FAIL. Refusal is a recorded fallback,
not a visual PASS. Previous P0443, P0446, P0448 and P0449 negative evidence
must remain intact. No commit or push is performed by the assistant.
