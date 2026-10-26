# P0347 — bounded subscription lifecycle optimization

Verified pushed P0346 baseline `26370095bd092d076868cd3d2e5e6a74f6b845d3`, version `0.0.236-dev`, 217/217 STATIC PREWRITE/POSTWRITE. The legacy State/Preferences listener arrays retained unsubscribed entries and their callbacks indefinitely across repeated module lifecycle toggles. Compact inactive records in original order outside active dispatch, clear handler references immediately, preserve nested dispatch and callback-failure propagation; no extra events, mutable state exposure, preference migration, native/secure changes, or live D-048 selectors. Bump version to `0.0.237-dev`, add #218 contract and evidence. WoW UNVERIFIED; P0321 first contingent November 4 client gate. L-022/L-027/L-028 OPEN; L-019 public release BLOCKED. WSL PREWRITE/POSTWRITE full checker suite and manifest required before user-owned commit/push.

## R1 historic P0346 checker gate repair

R0 PREWRITE shadow **REFUSED 1/218**, caused solely by P0346's `==217` checker inventory assertion; no tracked writes. Migrate P0346's count to `>=217` while preserving every other P0346 source and negative guard; P0347 still enforces 218/218. R0 is CLOSED / REFUSED; R1 is pending user WSL static checks. WoW UNVERIFIED; P0321 first native restoration gate.
