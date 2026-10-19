# P0270 — Native frame capability evidence gate

Baseline: pushed P0269 `1588fb9`, verified. Date 2026-10-19.

- New shared on-demand read-only metadata inspector for eight native stock-frame candidates and one H developer-panel action.
- Native Blizzard transactions, quantities, repairs, selling/Sell Junk, training/filters, travel, bank, auction, protected controls remain Blizzard-owned. No mock service catalogues.
- P0269 native policy, accepted NPC choices/rewards and Back/Goodbye, native restoration, and all camera files frozen.
- Exact secret-capable values never branch/compare/stringify; restricted metadata remains unknown. `GetPoint`/`SetPoint` never invoked, even when method present.
- Full repository static suite gated prewrite and postwrite, whitespace/manifest/rollback. WoW test pending.
- Source: `docs/memory/evidence/P0270_NATIVE_FRAME_CAPABILITY_AUDIT.md`. Next: client evidence before considering any reversible visual overlay or safe positioning.

R0 failed prewrite at `check_p0256_preview_hub_contract.py` (104 registered
actions vs historical 103 expected). R1 synchronizes P0256,
P0261 and P0269 counts to 104, guards these source files and adds static parity
assertions before the full 137-checker suite. Failure retained in P0270
evidence; R0 wrote no tracked source.
