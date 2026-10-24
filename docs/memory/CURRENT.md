---
memory_schema: 1
as_of: 2026-10-23
project: logres
---

# Current State

## Active Objective
Prepare a safe public-alpha-quality Logres near WoW Forever launch and a quality-gated 1.0 after launch, preserving the existing world-first behavior and Blizzard fallback. D-048 defines **five independent Logres / Blizzard selections**: navigation, action bars, NPC interactions, combined player/enemy health/resources/status, and camera. This is a design requirement, **not** currently implemented as five toggles.

## Current Work Item
**P0322 R1 — five-domain architecture and alpha-to-1.0 roadmap, DOCS + STATIC CONTRACT ONLY / PREPARED.** Verified GitHub `main` is pushed **P0321 `9a180c878279d24e60cd819428fe6dad3a599fc8`**, addon `0.0.222-dev`. `P0321` gossip offscreen/native restoration remains **WoW runtime UNVERIFIED / DEFERRED to November 4**. Next: P0323 repository-wide read-only module/ownership audit; then isolated regression-safe extraction and five-domain policy fixtures before any native ownership change.

## Verified State
- P0317 live gossip renderer, P0318 user-controlled gossip choices, P0319 no-choice dialogue stages and P0320 native quest-title links have positive user observations in their stated scopes. P0320 (`bcc3cfa`) showed “A Donation of Wool” in Logres and user reported interactions working. These are not exhaustive proofs of all quests/services.
- P0321 single-window parking **pushed** `9a180c8` with developer H Gossip Stock Status/Toggle; no in-game parking, quest handoff, combat deferral or native restoration PASS has been reported. P0321 R0/R1 malformed SHA and R2 evidence-EOF PREWRITE failures remain preserved; R3 was committed. Merchant and flight-master handoffs remain main NPC integration gaps; dense transactions continue Blizzard-owned.
- Current persistent settings contain only `immersionEnabled` and `activeQuestEnabled`; the global Immersion controller couples stock action replacement, selective player/target presentation and Quiet Mode, while compass also follows Immersion. No five independent runtime selectors or migration are claimed.
- P0322 R0 PREWRITE failed `check_checker_version_policy.py` because its new checker pinned a runtime version literal; no tracked writes. R1 checks runtime metadata parity without a literal pin. Full 193-checker validation remains pending.
- Camera/DynamicCam behavior is a frozen working baseline under D-047. Other bug/functionality gaps are indexed with evidence in `docs/memory/investigations/ISSUE_REGISTER.md`. Quest 237 reserved, party/CompactParty and other unreplaced native information/control remain stock.

## Next Action
Apply P0322 only on clean exact pushed P0321 `9a180c8`, require **193/193 PREWRITE and POSTWRITE** static checks plus diff hygiene and manifest. User commits/pushes; verify resulting `main`. No WoW redeploy for docs-only P0322. Then P0323 **read-only repository-wide modularity audit**: map all production modules, event/data/control dependencies, current Immersion coupling, source adapters, native fallback and preview/test coverage. Do not silently refactor currently working runtime paths. November 4 (access contingent): prioritize P0321 single-window native restoration, quest/gossip handoffs, merchant and flight-master native usability, then other high-priority regression tests. Launch date unconfirmed; release criteria control dates.

## Success Criteria
Durable D-048 five-switch contract, concise authoritative current state, alpha-to-1.0 readiness and milestone plan, evidence-linked classified issue register, reproducible docs/static-check patch. Each eventual selector operates independently, with separate requested/effective/fallback status and safe native restoration; **32 policy configurations** covered by deterministic fixtures and key in-client transitions proven before public claim. No known critical secure action, Lua/taint/secret, camera or native restoration regressions in released scope. Future settings/live code changes require their own guarded evidence-backed checkpoints.

## Do Not Reopen Without New Evidence
Do not change existing `Logres/Camera/*.lua`, DynamicCam/CVars, working quest/gossip controllers, protected action paths or Blizzard fallback merely to install a five-toggle UI. Do not reintroduce exact player HP/conventional bar, enemy exact level/classification, or silently hide party, minimap, target aura, target-of-target, unsupported class/pet/vehicle controls. No polling or broad native hooks for unreproduced bugs. PvP modifies rather than cancels Immersion. Preserve historical failures and environmental deferrals; do not mark P0321 PASS without actual Forever test.

## Relevant References
- `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`, `docs/memory/roadmap/LAUNCH_READINESS.md`, `docs/memory/investigations/ISSUE_REGISTER.md`
- `docs/memory/evidence/P0322_FIVE_SYSTEMS_LAUNCH_ROADMAP.md`, `docs/memory/patches/P0322_FIVE_SYSTEMS_LAUNCH_ROADMAP.md`
- `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`, `docs/memory/evidence/P0320_QUEST_GOSSIP_LINKS.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
