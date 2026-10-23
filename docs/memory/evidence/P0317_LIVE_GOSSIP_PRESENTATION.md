# P0317 — automatic additive live gossip presentation via accepted shared renderer

2026-10-23. **PREPARED / full WSL static + WoW live UI UNVERIFIED**. Pushed main P0316 `ae770b4` verified. Earlier user-provided P0316 runtime diagnostics (`0.0.217-dev`, load 413/414) recorded `Gerrig Bonegrip`, interaction type 3, zero option rows and one quest, `model-ready`, `C_GossipInfo.GetText`, nativeActions=0/nativeWrites=0. This is a genuine PASS for **quest-only source-model extraction**, not a PASS for ordinary options, mixed source, or native selection. The developer-panel Check All completed and did not show an explicit FAIL, but CANDIDATE/STOCK/DEFERRED results are not reclassified.

## User-directed correction to workflow

The user objected to further repeated source checks because branching/options/service/overflow/locked P preview artwork and shared Quest renderer were previously accepted. The assistant repeatedly asked for manually locating more NPCs rather than integrating the already working source and model. **PROCESS FAILURE: stalled after adequate first adapter evidence.** Existing diagnostic remains available but is not a prerequisite for an additive inert live presentation candidate. All routine runtime validation uses the in-game H developer panel, not a slash-command-first flow.

## Narrow implementation

On `GOSSIP_SHOW` (or one interaction-frame-show ordering retry) read the same P0316 guarded `NPCGossipSource.Sample()` and route only actual gossip choices through `NPCOptionSession:StartReadOnly` and `QuestDialogue:PresentText`; use the **same** `NPCOptionList`/narrative pages/typography/geometry as approved P fixtures. Mixed quest+gossip with choices is eligible. Quest-only/empty remains Quest/stock owned. Choices are visible but inert without the preview's misleading `[LOCKED]` wording; page navigation and Goodbye act only on addon presentation. Existing stock gossip stays usable and interactive. `GOSSIP_CLOSED`, interaction hide, quest transitions and world entry dismiss only Logres additive presentation. No native option selection, quest claim, trainer transaction, stock hiding, native setters, polling, timer or camera change. Capability failures leave Blizzard usable. An H toggle enables/disables the trial, and an H read-only status action provides evidence. Automatic additive integration is a **runtime trial**; do not claim full gameplay ownership.

## Validation

Apply against clean exact pushed P0316 `ae770b4` and require prewrite/postwrite full 188-checker static suite, `git diff --check`, manifest, then user push/verified main. Deploy with `tools/deploy_logres.sh`, `/reload`. With Immersion ON, visit a naturally available NPC with an ordinary gossip choice; observe the **Logres Quest-like narrative/options UI** shown automatically and the intact functioning Blizzard controls. In developer panel H use **Gossip Live Status (READ-ONLY)** and **Gossip Live Toggle** to disable and restore trial, verify close/transition and reload. Existing P choices previews, quest 237, profession trainer routes, and camera unchanged. A quest-only NPC is correctly stock/Quest-owned without a duplicate Logres gossip page. Any Lua, secret, taint, protected-action, inaccessible native choice or broken stock fallback = FAIL requiring correction before further ownership.

## Forward action

Native gossip selection and safe one-window stock parking require **separate guarded interaction/restore gates** after runtime presentation acceptance. Do not assert read-only presentation is a fully replaced functional gossip UI.

## R1 applier correction (2026-10-23)

User verified the original P0317 ZIP SHA and attempted apply on clean pushed P0316 `ae770b4`. Baseline PASS, but PREWRITE candidate refused with `Logres/UI/OptionList.lua: expected one, got 2, '    if button.optionEnabled then'`. **R0 APPLY FAIL / NO TRACKED WRITES.** The line legitimately exists in more than one function; R1 anchors specifically to `function Visual:Paint(button)` and also migrates the P0265 historical static checker to allow the production renderer's new optional `displayOnly` argument without weakening preview click-safety. WSL full suite and game runtime remain UNVERIFIED. Time-critical beta window ends October 23 at 10:00 PDT; prioritize functional visual check, document deferrals.

## P0317 R1 PREWRITE memory-authority failure and R2 repair (2026-10-23)

User-applied P0317 R1 ZIP passed SHA-256, exact pushed P0316 baseline, source blob checks, candidate construction, and whitespace hygiene. Its 188-checker PREWRITE shadow suite failed 16 checkers (`check_memory_health.py` and 15 P0278–P0293 trainer-family contracts): the P0317 replacement `docs/memory/handoffs/CURRENT_HANDOFF.md` omitted the mandatory literal `CURRENT.md` source-of-authority reference. This is **ASSISTANT PATCH GENERATION FAIL**, not a WoW runtime error, not 16 independent defects, and no tracked files were written. R2 restores the authority link and adds a direct candidate assertion. **R2 full static and WoW remain UNVERIFIED until actually executed.**
