# P0324 handoff — inert independent-domain policy fixtures

**Authority:** `docs/memory/CURRENT.md`, D-048, `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md` and `docs/memory/architecture/P0324_POLICY_FIXTURE.md`.

P0323 pushed `386a7ef` on main, 94 TOC Lua entries inventoried. P0324 **PREPARED**, test/specification-only: `tools/p0324_domain_policy.py` is standalone pure Python and `tools/check_p0324_five_domain_policy_contract.py` checks 32 requested Logres/Blizzard combinations, independent bit flips, capability none/partial, deferred native restore and untouched schema-3 legacy preferences. It is **not** addon-loaded Lua, and no settings migration, five live switches, native action, secure operation or camera change is being made. The simulated `effective`/`fallback`/`pending` fields do not reflect actual WoW UI state.

Apply P0324 only to exact clean pushed P0323 `386a7ef` with 195 PREWRITE/POSTWRITE checks, diff hygiene and manifest; user commits/pushes then main verified. No WoW redeploy required. The next separately gated work is safe migration-policy proposal and fixtures or read-only merchant/flight source assessment, **not** live independent restoration without November 4 client evidence.

P0321 gossip parking remains **WoW UNVERIFIED / DEFERRED until November 4**; P0317–P0320 observed dialogue working scopes remain accepted. Quest 237 reserved; trainer/gossip stock parking separate; native merchant/flight transactions preserved; camera/DynamicCam frozen D-047. L-001–L-018 issue register classifications unchanged.
