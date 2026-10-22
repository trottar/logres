# P0305 — NPC session trainer-ready event repair

Baseline pinned GitHub P0304 `a493b9f7208898103146d5f4605c0debdb6fa71f`. Candidate `0.0.206-dev`.

Observed failure: no automatic Logres trainer on normal NPC interaction; manual H Live Trainer works. P0305 adds `TRAINER_SHOW`/`TRAINER_UPDATE` event-driven readiness, maintains all P0304 source/protection and per-visit dismissal gates, adds addon-owned readiness audit; never auto-hides Blizzard or alters transactions. Full static suite and WoW runtime UNVERIFIED until WSL/in-game evidence. Revert/fail open on errors; preserve P0304 failure.

Files: `Logres/UI/NPCServiceSession.lua`, `Logres/Logres.toc`, `Logres/Core/Bootstrap.lua`, `docs/memory/CURRENT.md`, `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`, evidence, patch record, static contract, manifest.
