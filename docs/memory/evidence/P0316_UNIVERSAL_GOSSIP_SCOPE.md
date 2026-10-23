# P0316 — universal gossip source scope repair following pushed P0315

2026-10-22. **PREPARED / WSL FULL STATIC AND WOW RUNTIME UNVERIFIED**. Verified pushed main P0315 `878235b9b652ac478168a737df6bc14850486dd7` follows P0314 `f40a8e0`.

## User requirement and observed P0315 design defect

The user rejected treating ordinary gossip as something available only at a small set of nonquest NPCs. Guards with directions, trainer preambles, NPCs offering quests and dialogue, innkeepers and future service NPCs all require a general *conversation stage*. A later trainer/merchant/flight service is a transition, not an NPC-wide ban on gossip. The pushed P0315 source returned `mixed-quest-gossip-stock-retained` whenever an ordinary quest entry existed. That was a **SOURCE-DESIGN FAIL for universal coverage** (not a reported WoW Lua error). P0315 source and old static checker codified the restriction; D-046/D-047 require a shared stage-aware experience.

## Failed handoff — preserve negative result

The first assistant P0315 R1 universal correction ZIP pinned P0314 `f40a8e0`. The user verified its SHA-256 and attempted the applier, but GitHub `main` had already advanced to pushed P0315 `878235b`. The user's console reported `P0315: FAIL: unexpected commit baseline; no writes`. **R1 did not apply**. This was an assistant stale-baseline artifact defect, not a runtime failure. Do not reuse the R1 archive, reset, force-push or weaken the baseline guard. P0316 is a forward corrective patch from P0315 main.

## P0316 narrow correction

Replace only `Quest/NPCGossipSource.lua` source-to-model policy (and corresponding static contract). For separately ordinary valid source data, produce an inert `NPCOptionModel.FromValidated` for `gossip-only`, `mixed-quest-gossip`, `quest-only-gossip` and `empty-gossip` states, regardless of NPC family. Preserve the native quest **counts only** via `model.questSummary`; quest rows are not synthesized into choices. Copy only individually screened native option labels/identities, and keep `enabled=false` for every live option. Known source `GetText` remains required; absent APIs, secret, invalid or truncated returns still explicitly defer. `NPCOptionSession` remains preview-only and cannot render/choose a live source model. No live visual replacement, native option selection, quest acceptance, trainer transactions, Blizzard stock suppression, input hook, timer, or DynamicCam change. Flight maps remain Blizzard-owned; their gossip prelude may still be sampled.

## Validation and scope

Apply only to exact clean pushed P0315 main, require 187 static checkers in candidate PREWRITE and POSTWRITE, plus Git diff hygiene and generated manifest. Then deploy and `/reload`. While in naturally encountered dialogue, run **H — Integration and Polish → Gossip Source Check (READ-ONLY)**; inspect `status`, `kind`, options, quests, text and modelReady. A mixed quest/gossip result with usable text and ordinary data should no longer defer **solely** for the quest count. Missing API/text or source ambiguity remains DEFERRED and safe. No visible UI change is expected, and no gameplay selections should be executed. Lua, secret, protected-action errors are FAIL requiring investigation. Retain all P0315 original PREPARED evidence and previously observed P0311/P0313/P0314 failures.

## Next phase

After real source evidence, design explicit fail-open live read-only gossip presentation through the approved shared Quest narrative/option renderer. Later native gossip selection and stage-to-trainer/service handoffs require their own separate guarded proofs, including mixed quest options and stock restoration. Quest 237 remains reserved. No native control removal without deliberate safe replacement.
