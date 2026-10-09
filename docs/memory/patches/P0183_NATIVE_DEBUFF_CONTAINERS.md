# P0183 — Native Logres debuff lanes through Blizzard CustomAuraContainer

Date: 2026-10-09. Source-locked to verified `main` `2adce36688ee1d3fdddd75e373598a0e9d6f04e8` (`0.0.96-dev`), with an exact P0182 uncommitted working-tree compatibility branch. Candidate `0.0.98-dev`. Runtime PENDING.

## Cause and change

P0175–P0182 created/read player and target harmful icons only for *ordinary* indexed aura payloads. Hostile target harmful scans were restricted, so no icons reached the Logres renderer. P0182 nameplate-only filter addition did not fix the user-observed absence of Logres debuffs; that negative observation is preserved. This is a read/render boundary problem, not solved by more filters.

The pinned `Gethe/wow-ui-source@e3ecc27` (`forever`, 1.60.1.70205) exposes `Blizzard_AuraContainer/Blizzard_CustomAuraContainer` and `CustomAuraButton` secure rendering. Forever-compatible Musca-Auras (`WeakAuras/BlizzardAuraDisplay.lua`) creates addon-owned `AuraContainer` with `CustomAuraContainerTemplate`, calls `AddAuraGroup`, uses native `AuraButton:SetIcon`, binds a unit, enables and updates the container. P0183 independently applies that source-backed interface to the **Logres player and target HARMFUL** rows. The native renderer owns restricted icon data; Logres Lua neither reads nor branches on it. Existing player `HELPFUL|PLAYER` and target HELPFUL rendering remain unchanged.

Use `HARMFUL` canonical native filter so more specific urgency filters do not hide otherwise-visible harmful status. Native rows use existing semantic anchors and 30px icon/5px spacing. When native setup fails, Logres keeps the original secret-first ordinary reader as fallback, and Blizzard stock aura displays remain untouched throughout. Preview continues through original deterministic Logres icons; Native is disabled during preview and Immersion OFF. Native work defers protected mutations during combat. The existing 35-surface UI ownership inventory remains additive/stock for auras.

## Acceptance / limitations

On Forever client, visually confirm Logres player and hostile-target debuffs in ordinary gameplay, independent of visible Blizzard debuffs. Native container readiness is a setup claim, **not** a claim that an aura appeared. Use Phase H developer panel **Status Aura Preview ON**, **Preview OFF**, **Status Aura Check** and Phase 0 **Run All**, **UI Ownership Check**. No slash-based checks when panel action exists. Zero harmful aura observations, unsupported container API, protected-action errors, or missing icons are OPEN/FAIL/DEFERRED according to observed cause, never automatically PASS. No player/global/native aura suppression or hostile world-attachment promotion. Maintain stock/native fallback and preserve earlier diagnostic failures and intermittent loot ObjectiveTracker flash. User commits/pushes; verify afterwards.

## P0183 R1 — prewrite packaging failure, corrected

The first P0183 delivery failed before reading the Git baseline or writing tracked files: `P0183 PAYLOAD missing/corrupt __pycache__/P0182_APPLY.cpython-313.pyc`. The packaging manifest had included a development-only Python bytecode cache that was not shipped. This is an artifact-delivery FAIL, not a WoW runtime test and not a gameplay result. P0183 R1 rebuilds the payload hash list from an explicit allowlist of shipped source files, disables bytecode creation during its internal P0182 candidate import, and includes an archive/hash integrity smoke test. Source, native debuff design, candidate version and runtime acceptance gate are unchanged. The corrected archive must still pass its prewrite complete checker suite before any tracked change; actual Logres debuff visibility remains unproven until the in-game panel/visual gate.

## P0184 — observed acceptance after P0183 R1 push (2026-10-09)

GitHub `main` verified at `11a342b`; user reports that **Logres debuffs appear** (only appearance polish remains). Uploaded `0.0.98-dev`, loadCount 234 diagnostics record native HARMFUL containers `ready=true active=true`, Phase 0 Run All completed and UI Ownership 17 PASS / 18 STOCK / 0 FAIL with no reported command errors. P0183 R1 runtime/visual **PASS for observed display and checks**, not for unobserved player-vs-hostile-target coverage or native child membership. The initial P0183 prewrite manifest packaging FAIL and P0182 nameplate-filter-only ineffective attempt stay historical. No Blizzard aura suppression. Defer icon polish to Phase H full visual pass; P0184 records docs-only acceptance.
