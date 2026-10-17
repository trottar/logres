# P0229 — Assistant failure record: QuestieDB diagnosis and panel handoff

Date: 2026-10-17. Scope: durable documentation of assistant errors only; no Logres runtime or UI changes.

## Observed sequence and failures

1. The user directly reported QuestieDB visible in WoW's AddOns list. The assistant continued to claim the addon was missing based on a failed WSL test against one assumed `Interface/AddOns/QuestieDB/QuestieDB_Forever.toc` path and an older P0226 diagnostic. These observations do not establish absence from the running game. The actual QuestieDB initialization state remains unverified until fresh in-game API evidence.
2. The diagnostic upload contained a P0226 QuestieDB attempt recorded at loadCount 300, although overall game loads subsequently reached 302. The assistant treated that old result as a current installation finding and repeatedly sent the user back to `/logres questiedbprobe` without any changed preconditions. This wasted user validation cycles.
3. The assistant ignored working patterns in other addons until explicitly directed to inspect them. Questie's `Modules/VersionCheckDB.lua` checks `LibQuestieDB.RequireContract` independently. PlateSmith's optional companion declares `## OptionalDeps: QuestieDB` and reads `LibQuestieDB` directly. The QuestieDB v1.0.6 Baked mode indicator intentionally reports no Source `expansion`; the baked artifact provides `X-Flavor` metadata. P0228 attempts to correct the Logres integration; runtime result still unverified.
4. The initial P0228 ZIP, SHA-256 `309582c2b37c054ab96b92fe9f390fe5ba25e3d1f05548042e2173adf9012282`, failed its own **pre-write** diff hygiene: `docs/memory/CURRENT.md` had a new blank line at EOF. The user provided the exact failure log. `git status --short` showed only unrelated pre-existing untracked PNG previews; no patch-owned tracked changes were reported. P0228 R1 corrected the candidate newline generator, but must not be called WoW PASS without runtime evidence.
5. The assistant gave a slash command without the existing panel workflow or an explanation of expected visual change. Direct source review of `Logres/Core/Commands.lua` confirms `Logres:RegisterDevPanelAction("questieDBLocationProbe", "QuestieDB Location Probe", "questiedbprobe", "E")`; `Logres/Dev/Panel.lua` places it under Phase E, and the panel defaults to Phase G. The correct instructions are `/logres panel` -> **E: Compass and Navigation** -> **QuestieDB Location Probe** (fifth action). P0228 is a provider diagnostic correction, so **no new compass glyph or visible UI change is expected**.

## Disposition and required next evidence

**OPEN / ASSISTANT PROCESS DEFECT DOCUMENTED.** No new QuestieDB load-state verdict is claimed by this document. The user must not be instructed to rerun an identical test without a changed condition or specific new information it will measure. After P0228 R1 is applied and deployed, the next **single** panel run should report `registered`, `loaded`, `tocFlavor`, `tocMode`, `provider`, `contract`, `mode`, `flavor`; a QuestieDB compatibility result is independent of any map/gossip location sample. The precise output (including any Lua/taint errors) determines the next hypothesis. Do not infer installed/uninstalled from a path mismatch, and do not infer compass markers from a provider-readiness diagnostic.

## Durable interaction rule

For every in-game validation handoff, first inspect the actual current registered developer-panel actions. If a panel action exists, give the exact command to open the panel, phase/tab name, button text and any necessary action sequence; list slash commands only as alternatives. State what changes on screen, what should **not** change, what exact diagnostic fields to read, how to export evidence, and what PASS/DEFERRED actually proves. Never call unobserved results PASS. Include negative and postponed evidence without erasure.

This checkpoint only records the error, the correct UI pathway and ongoing runtime uncertainty. It does not fix QuestieDB further, add markers, redeploy WoW, or modify GitHub.
