# P0310 — empty service catalogue and profession ownership ambiguity

Date 2026-10-22. Verified main P0309 `5d27a06942cf289f9208d99a384cd6e41a498fb8`. **R2 PREPARED / FULL WSL STATIC and WoW RUNTIME UNVERIFIED**.

## Observed in-client facts

User confirms: "I was able to buy and learn enchantment. Class trainer still works. Fishing unchanged"; screenshot of Enchanting lists remaining `unavailable` offerings and Blizzard's stock trainer. Thus P0309 Enchanting one skill purchase is USER RUNTIME PASS, not class purchase-while-parked proof, profession Train All, or all professions. Earlier user screenshot of Fishing Trainer Grimnur Stonebrand shows Journeyman Fishing already known; P0307 read-only diagnostic at that NPC reported type=7, profession=yes, shown/unprotected native root, **services=0**. That cannot distinguish no new learnable skills, native filters, profession not owned or server-specific source behavior. User requests Logres presentation consistently in these cases, including not-acquired professions.

## Design and safety

Use existing `TrainerLandscape.Render` and surface; no layout recreation. Add data-only `NPCServiceEmptyState.Build` returning `catalog={}` and a separate disabled visual row and selected info. `Trial.FromEmptySnapshot` runs ONLY when ordinary, shown trainer source reports `total=0`, `sample={}`, status `read-only-service-sample`, AND an independently ordinary IsTradeskillTrainer true. Do not turn zero into an invented trainer service; no service index, selection hit region, price, Train selected or Train All. Search, filtering and row scrolling remain local/inert for empty. Stock Blizzard stays visible, giving the player access to any native profession information that Logres cannot prove. The data-only builder can be reused by gossip and merchant empty-list states later.

D-046: provide a deterministic empty preview through **P — Previews → Trainer Empty Preview** using the EXACT landscape composition and empty model. Preserve the existing **P — Trainer Skin Art Preview** entry and existing 35 P preview entries plus the new reviewed 36th entry; register one additional P action and deliberately update legacy inventory contracts. Synthetic preview never opens an NPC or buys. Validate in WoW before claiming this is a complete visual experience. D-047: never suppress information/control until safe replacement. A genuine future `Learn Profession` transaction may only come from an ordinary native available service with verified cost/identity, using separate profession controller and deliberate click, not a guessed button.

## P0310 R0 PREWRITE failure (new evidence, 2026-10-22)

User ran the P0310 R0 applier against clean pinned P0309. Baseline, source blobs, generated candidate, memory headings, version parity and prewrite whitespace gates **PASS**. Full candidate suite reported **9/181 CHECK FAIL**: `check_p0256_preview_hub_contract.py`, `check_p0271_native_placement_trial_contract.py`, `check_p0272_native_auto_handoff_contract.py`, `check_p0273_native_gossip_continuity_contract.py`, `check_p0274_native_service_accent_contract.py`, `check_p0276_r1_native_trainer_skin_contract.py`, `check_p0289_trainer_live_panel_contract.py` (extra P gallery action: 36, expected 35), and `check_p0303_npc_service_catalogue_contract.py`, `check_p0304_npc_session_auto_trainer_contract.py` (broken source/probe/catalogue/trainer adjacency). The PREWRITE guard stopped before any tracked changes. This was a patch-generation incompatibility, **not a WoW Lua failure**.

R1 preserved the exact original P registry and required module adjacency, but exposed the empty fixture **only by slash command** rather than the established panel; the user rejected this workaround before reporting any R1 test. R2 preserves the module adjacency and deliberately adds a 36th P action, updating seven legacy exact-count checkers to 36. Original P actions remain registered and unchanged; static history is retained, not suppressed. R2 full 181-checker WSL and WoW results remain **UNVERIFIED**.

## Tests / negative results

R0 PREWRITE failure is documented above; R2 isolated local checks are not full static nor WoW PASS. P0310 is UNVERIFIED until WSL applier and WoW inspection. Earlier P0303/P0307 PREWRITE checker failures, P0304 first auto-entry failure, and P0306 profession stock fallback defect remain preserved. Testing a not-yet-acquired profession is not required solely to manufacture proof; this remains UNTESTED until natural encounter. Any Lua, secret, taint, protected action error is FAIL; do not hide it.

## P0310 R1 alternative rejected by user (design/workflow failure)

R1 prepared a synthetic preview only via a slash command in order to keep the
historical static inventory at 35. The user explicitly rejected that approach:
"Why is this not in panel? This is never how we do things". This is a workflow
and D-046 affordance failure, not a demonstrated WoW runtime error; R1 was not
reported applied or tested. R2 restores a dedicated inert P-tab action and
migrates the seven earlier static inventory assertions from 35 to 36 while
checking that the pre-existing 35 remain intact. Neither R0 nor R1 changed
tracked source after the reported R0 prewrite failure. P0310 R2 full suite and
WoW runtime remain UNVERIFIED until the guarded applier and in-game test.
