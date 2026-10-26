# P0345 — L-028 renderer-route versus native cached activation state

**Baseline:** verified pushed P0344 `e44f66ba0838045ad6d44f1afe3e4afdb4a473ec` on GitHub main; manifest 215/215 PREWRITE/POSTWRITE static checks. Source version `0.0.235-dev`. All affected Forever client runtime behavior remains **UNVERIFIED** pending contingent November 4 access.

## Source-proven diagnostic ambiguity

`StatusAuras:Refresh` sets `self.nativeActive = useNative` based on the **requested rendering route** (`nativeOK and active and not self.preview`), and the P0342 one-shot Gameplay Snapshot prints that value. Separately, `NativeDebuffs.SetActive` maintains Logres-owned `state.active` as its last successful enable/disable state. During combat, when the requested state differs from that cached state, `SetActive` returns `false, "combat-deferred"` without mutating native frames or `state.active`. Thus `nativeActive` can be false although the addon-owned native activation token remains true (for example, entering an inert status-aura preview during combat after previously enabling the native renderer). The existing one-shot P0342 output cannot distinguish this divergence. This is a **reproduced static source-path ambiguity**, not proof that such a context has occurred in the user's L-028 screenshot.

## Minimal change

- In `StatusAuras:Refresh`, retain the second return value of the **already executed** `NativeDebuffs.SetActive` call in `self.nativeActivationReason`. Preserve `useNative` and all rendering decisions byte-identically.
- `GetDebugStatus()` returns two additive **Logres-owned cached state** fields: `nativeEnabledCached` (the already maintained `self.nativeDebuffs.active == true` state), and `nativeActivationReason`. It never probes a Blizzard frame or infers visible icons.
- P0342's existing read-only Gameplay Snapshot aura summary and route line remain unchanged; append one extra cached activation line. No new `GetDebugStatus()` call, native API, secret value access, aura identity collection, secure mutation, event handler, frame stratum change, polling, preference or SavedVariable migration, and **no developer panel action**.
- Version `0.0.236-dev` in TOC/Bootstrap parity; loaded Lua inventory unchanged at 94. The new checker (#216) guards these exact source boundaries and tests the conceptual state-route divergence without claiming client execution.

## Client validation gate

On contingent November 4, P0321 native GossipFrame parking/restoration **first**. For a naturally present L-028 target debuff issue, collect screenshot and **0 — Gameplay Snapshot** / **H — Status Aura Check**. Distinguish `nativeActive` (selected route), `nativeEnabledCached` (addon-owned activation token), `nativeActivationReason` (last SetActive return), and fallback row visibility. If they disagree during combat/preview deferral, do not infer native frame visibility or deduplicate effects from that state alone. No manufactured combat or death is required. **L-028 remains OPEN**, native aura visibility unproven; L-022, L-027 remain OPEN, and L-019 blocks public release.
