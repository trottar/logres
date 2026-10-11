# P0196 R1 — Capability-gated native pet and aura surface handoff

Baseline: verified GitHub `main` `9097f43` (P0195). Candidate: `0.0.105-dev`. **No runtime PASS yet.** Supersedes **unpushed** P0196 docs-only native-residual audit, which incorrectly advocated leaving Blizzard PetFrame visible as the intended final presentation.

## Request and design boundary

User explicitly requires removal of Blizzard PetFrame, PetActionBar, player buff strip and original target buff/debuff aura controls when Logres can safely present equivalent information and interaction. Damage Meter and Forever beta Issue Reporter remain untouched. User accepted P0195 full-screen placement for ordinary layout and requested a unified native cleanup, not repeated individual widget moves.

## Implemented candidate

- Dedicated `NativeSurfaceReplacement` module, enabled with default modules, handles exactly four stock roots: PetFrame, PetActionBar, BuffFrame, TargetFrame contextual Auras. Each has a separate capability gate and opaque restoration token. Opaque stock IsShown is only transported directly to native SetShown, never inspected or compared. OnShow hook is scoped to the actual stock source and folds only out of combat. Failure leaves stock available.
- A secure addon-owned pet unit interaction button overlays the already-present Logres pet name/health row. Left click targets pet; right click opens native context menu. Its initialization is out of combat. No native PetFrame click region is left behind when stock fold succeeds.
- Pet 10-button secure action cluster is auto-armed when available and can be re-armed from native pet events. Stock PetActionBar is folded only while the addon-owned pet cluster is configured, armed, visible and populated. Stock remains for absent/unavailable pet bar, editing and manual PET open.
- Native `CustomAuraContainerTemplate` HELPFUL groups for player and target, with up to 24 player and 16 target native-rendered aura buttons, are created without reading restricted aura payloads in Lua. They replace the four-icon `HELPFUL|PLAYER` preview path and target helpful sampled lane when active. Stock BuffFrame only folds if native player group activated. Stock target contextual Auras folds only if target replacement, native target harmful and new native helpful groups are active. Existing native harmful aura max increases to 20 (source-capped): long-duration overflow remains explicitly not proven by static checks.
- Three on-demand second-row controls beneath the existing native access dock: PET / BUFFS / TARGET, each restoring its stock controls before Logres withdrawals. The original six dock buttons and `nativeuicheck` five-domain contract remain untouched; the existing Phase H Native Access Check additionally prints the four new domain statuses.
- Immersion OFF restores stock before disabling Logres native aura renderer. Protected/combat changes defer. Disable-during-combat restoration is handled by a persistent regen event, not polling.

## Known limits and required runtime validation

The 24-player-helpful, 16-target-helpful, and 20-harmful icon group limits do **not** establish that every possible aura/dispellable state is covered. Exact aura population and flow geometry, pet casting, autocast right-click, native stock Edit Mode, combat transitions, secure tooltip interactions, and special vehicle/possess/pet battle remain runtime OPEN or ENVIRONMENTALLY DEFERRED. Do not claim full pet-bar editing replacement; PET on-demand restore is deliberately retained. The supplemental PET/BUFFS/TARGET buttons require visual/click validation to verify children outside the current dock's 26px root height remain hit-testable.

Use `/reload` out of combat. Normal Immersion ON: verify pet name/health row and pet secure clicks with stock PetFrame hidden; Logres pet buttons execute/auto-cast while stock PetActionBar is hidden; native helpful buffs appear in player/target v4 lanes while stock BuffFrame and contextual target Auras are hidden. Test PET/BUFFS/TARGET manual restore and re-fold, Immersion OFF restores original native controls, Phase H Native Access Check, Phase H Layout Check, Phase 0 Run All. Export diagnostics and one overlay-OFF screenshot with pet and target buffs/debuffs populated. Any Lua, taint, protected action, secret, lost interaction, hidden click region or missing critical aura is FAIL and must be corrected before push.

Native Damage Meter and Issue Reporter are user-retained and outside patch scope. P0196 original ZIP is superseded and **must not be applied**; no P0196 remote commit existed at preparation.
