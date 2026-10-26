# P0345 — Additive cached aura-activation provenance

- **Expected baseline:** pushed `main` P0344 `e44f66ba0838045ad6d44f1afe3e4afdb4a473ec`; `0.0.235-dev`, 215 source-only checkers.
- **Scope:** `StatusAuras:Refresh/GetDebugStatus` with `nativeEnabledCached` / `nativeActivationReason` and one extra read-only Gameplay Snapshot line; historical source report preserved. Exact `NativeDebuffs.SetActive` mutation and combat lockdown behavior unchanged. Current/roadmap/handoff, regression matrix, issue register and static contracts updated atomically.
- **Version:** `0.0.236-dev`, Lua load inventory 94; new #216 static checker. Guard exact clean baseline and Git blobs; candidate 216 PREWRITE shadow and 216 POSTWRITE checkers, diff hygiene and manifest; rollback patch-owned tracked files on postwrite failures. Applier neither commits nor pushes.
- **Evidence:** P0342 `nativeActive` means selected presentation route, while `NativeDebuffs.state.active` is a separate addon-owned cached activation token. A combat-deferred request can leave the token unchanged. Both are diagnostic state, **NOT native frame visibility proof**.
- **Classification:** source patch only; **WoW UNVERIFIED** and L-028 OPEN; P0321 first contingent client gate. L-019 release BLOCKED. P0342 and P0343 R0/R1 historical candidate failures remain in their respective evidence.
