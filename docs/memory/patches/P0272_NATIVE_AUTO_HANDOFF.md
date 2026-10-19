# P0272 — Opt-in automatic merchant/trainer positioning

**Baseline:** `993d9fb` P0271 pushed main, verified read-only. **Status:** PREPARED, static gates and WoW runtime pending.

**Runtime scope:** one existing native placement controller; opt-in automatic mode backed by addon-owned normalized interaction events and narrowly gated native OnShow hooks. Same P0271 opaque full-anchor snapshot, native OnHide/manual/regen restoration. No new H actions, transactions, child suppression, flight/bank/auction mutation or camera changes. 0.0.170-dev version parity.

**Historical scope:** P0271 runtime accepted for three successful manual starts/restores, two native auto-restores, zero failures; automatic placement is separate and NOT YET PROVEN. Exact P0271 runtime evidence: `docs/memory/evidence/P0272_NATIVE_AUTO_HANDOFF.md`.

**Static contract:** new `tools/check_p0272_native_auto_handoff_contract.py`, migrated P0271 legacy label/OnShow constraint, all 139+ `check_*.py` run against prepared shadow and after write; git diff --check and manifest. User owns commit/push.

**Validation:** Explicit H Auto ON/OFF (TEST), live merchant auto center/reopen/restore, trainer if natural, OFF while window visible, 0 Run All, diagnostics. Stop on any protected/taint/Lua/restoration error.


## P0273 post hoc repository reconciliation
`main` c5ef384 contains the runtime but lacks this record, P0272 static checker and generated manifest. P0273 adds this historical record and the migrated P0272 checker; it does not claim the original full WSL suite ran or reconstruct an unverified P0272 manifest. Functional P0272 WoW evidence is scoped in its evidence record.
