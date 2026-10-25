# P0334 handoff — PvP status modifier badges

**Authority:** `docs/memory/CURRENT.md`, `docs/memory/investigations/ISSUE_REGISTER.md`, `docs/memory/evidence/P0334_PVP_BADGES.md`, `docs/memory/roadmap/LAUNCH_READINESS.md`, `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`.

P0333 push verified on GitHub `main` at `68c09555242ac11dcf8296531a51017f31c43174` (2026-10-25). Its manifest records 204/204 PREWRITE and POSTWRITE static checks; pet hotkey/outline presentation runtime remains UNVERIFIED. Earlier P0332 target aura fallback, P0331 menu layering, P0330 death travel, P0329 gameplay capture, and P0321 gossip parking remain independently runtime UNVERIFIED with November 4 client gate. Their scoped source/negative evidence is preserved.

**P0334 candidate:** Add two noninteractive gameplay-HUD PvP status badges tied to ordinary, independently secret-classified player/target `UnitIsPVP`, with event-driven changes on `PLAYER_FLAGS_CHANGED`, `PLAYER_TARGET_CHANGED`, `PLAYER_ENTERING_WORLD`, `UNIT_FACTION`, `UNIT_FLAGS`. A shared production renderer is accessible through `/logres pvppreview on|off` and the P tab for deterministic visual acceptance. Unknown/secret status hides *only* Logres badge, never stock. No player numeric HP, enemy level/classification, camera, secure action/pet attrs, native frame mutation, saved schema or D-048 switches. P0334 PREPARED and WoW UNVERIFIED; requires 205/205 PRE/POST static checks and user push verification.

**Historical continuity:** P0317 P0318 P0319 P0320 P0321 P0322 P0323 P0324 P0325 P0326 P0327 P0328 P0329 P0330 P0331 P0332 P0333 P0334. D-046 preview-first; D-047 camera frozen; D-048 five domain switches not yet live; Quest 237 reserved; licensing L-019 open. Preserve Blizzard aura/party, native fallback, protected state and all negative investigations.

After P0334 push, investigate remaining L-027 native XP/quest popups or L-030–L-032 compass correctness with narrow source evidence. L-022 visual artifact requires screenshot/repro before mutation. No `/reload`, deployment or runtime testing while Forever unavailable; at reentry validate P0321 first, then source-corrected L-023 and other issues with actual client data. Do not classify offline success as runtime PASS.

P0334 R0 PREWRITE REFUSED at checker 91/205, P0256 preview-gallery set not migrated. R1 adds this existing gallery contract to its exact 13-blob baseline and explicitly approves only the two new P-tab PvP preview actions (38 total reviewed), with no other PvP scope change. See P0334 evidence. Static suite and client remain UNVERIFIED pending actual validation.

P0334 R1 PREWRITE REFUSED at P0271 104/205 (`exact registry 108/34`). R2 explicitly migrates P0256 and seven historical P-tab inventory checkers to preserve 36 reviewed pre-P0334 previews plus only two named PvP additions (38 total). Requires exact 20 Git blobs, all 205 PREWRITE/POSTWRITE and diff hygiene. No tracked writes before PREWRITE PASS. WoW still UNVERIFIED.

P0334 R2 PREWRITE rejected exactly 1/205 at P0330 death tunnel initializer: PvP state inserted between `self.deathTravelMode = false` and `self.healthBands = {}`. R3 retains both adjacent lines and adds PvP state after `healthBands` initialization, with independent P0334 checker assertion. R0/R1/R2 failures remain evidence; no source PASS or client PASS is claimed without execution.
