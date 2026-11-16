# P0462 — P0461 visual aura failure and combat-deferred World Enemy ON (2026-11-16)

## Authority and runtime provenance

GitHub `main` `56861f56919f45f43499a6726f31f074d6c2a744`,
version `0.0.330-dev` P0461. Report Bug ZIP generation 2026-11-16
15:35 EST, latest session 133, source/deployed/capture versions match.
Standalone `LOGRES_DIAGNOSTICS_LATEST.lua` matches ZIP member SHA-256
`d887d9412bb76131196819bf5b3c1d1c2a2e7192e07e7455c327c6b5bdd8fa4c`.
Screenshot associations are timestamp-inferred (not native client-attested).

- #13659 / `WoWScrnShot_111626_153412.jpg`: **VISUAL FAIL**.
  Native buff/debuff icons crowd the small enemy name and accepted
  Logres world health bar. Ordinary target helpful/harmful rows are 0/0;
  40 restricted index probes were skipped (not 40 aura instances).
  P0461 native lists are visible, but addon world lanes are inactive.
- #13661 / `...153419.jpg`: World Enemy OFF restores stock name/HP.
  This is scoped restoration proof, not all-case combat safety.
- #13663 / `...153423.jpg`: after OFF, ON during combat returns
  `enable-requires-ooc`; no pending intent or automatic activation in P0461.
  Native information remains available.

Selected full-size/opacity name/HP and eligible secondary 50%/50% style
from P0460 are user accepted and must not be changed. P0460 event-token
identity, unknown removal fallback, target changes and restoration unchanged.
P0456/P0457 secondary suspension/selected continuity investigations are
historical, not active repair targets.

## Actual renderer / safety blocker

`HUD:ClaimNativeEnemyDecor` in P0461 captures/restores only native
name/health/level alpha. Blizzard `UnitFrame.AurasFrame.DebuffListFrame`
and `BuffListFrame` remain at their stock nameplate coordinates, which
collide with the Logres world name/HP. P0461 `StatusAuras` deliberately
hides both addon world lanes; P0449 `Native.CreateWorldEnemyLanes` is not
invoked. The independent screen target aura copy is alpha-handed off
only when stock lists are structurally present, NOT visually verified.
The screen copy restores on detach; source/ownership counters cannot prove
correct world layout. No native list placement or icon-visibility capability
is measured safely in the supplied session. `SetPoint`/reparent/scale of
potentially protected stock lists and suppression with unproven addon icons
would be speculative and risk loss of required aura information. **Thus
P0462 does not declare aura visual repair complete.** Preserve readable
stock aura fallback; L-028 remains OPEN / P0461 visual FAIL. A later
narrow layout capability and actual visual acceptance are required.

## Combat request source correction

`HUD:SetLiveWorldEnemy(true)` previously returned before setting requested
intent while locked. A single addon-owned pending flag now records ON
without protected setup in combat. The already registered
`PLAYER_REGEN_ENABLED` path attempts setup once only when ordinary
out-of-combat proof is present; no timer, polling or new callback.
Repeated ON while active is idempotent; OFF clears pending before any
attempt. For active OFF during combat, defer native alpha restoration until
safe, cancel new ownership, and keep native click/cast/CC untouched.
Requested, pending, active, off-restore-pending and refusal are separate
status values; capability refusal reports reason and does not requeue a
hidden retry. Existing HP, pool, nameplate identity and aura owner code
are unchanged.

## Release status / verification boundary

P0462's complete author kit matches exact P0461 Git tree. Initial R0
static author check REFUSED at **307/325** due to removed historical
CURRENT markers, an outdated P0456 build-order assumption and a
pinned runtime string in the newly added checker. R1 corrects those
without weakening selected/secondary source behavior; actual-source
P0459/P0460 source tests and P0461/P0462 aura/pending mocks remain
required. Author receipt, ZIP checksum and one-time applier manifest
are separate from this evidence narrative. No WoW runtime proof yet.
P0461 crowding FAIL and #13663 combat deferral remain historical facts;
P0462 client activation and aura visual acceptance UNVERIFIED. If the
native lists still crowd name/HP, L-028 remains OPEN, not resolved.
