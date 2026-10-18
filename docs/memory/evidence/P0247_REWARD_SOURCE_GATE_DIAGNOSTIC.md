# P0247 — Completion reward source-gate failure after P0246

Date: 2026-10-18. Verified P0246 GitHub `main` `9eb711fc18b279d1fdd77fa19f39e2d5b99861a3`.

## Observed runtime — failure preserved

User screenshot on the same quest 237 shows the native reward **Lesser Healing Potion x3** and Blizzard **Complete Quest** while Logres reads `Review rewards in Blizzard quest window | 1050 XP | 7s`. Diagnostic `0.0.146-dev`, loadCount **321**; post-interaction `/logres questdialoguecheck` run at epoch `1792342106`: quest completion event=1, shown=1, active=true, reason=shown, reward source=`guaranteed-item-unavailable`, itemIdentified=false, moneyCopper=700 ordinary. P0246 itemcache `eventRegistered=true/true pending=false signals=0 resolved=0 requests=0 state=not-observed`. These observations **prove the new item-data request branch did not execute**; no event-based name recovery was actually tested. Quest Dialogue Check reports PASS for registration/presentation only, not item parity. No separate full Lua/taint log was furnished.

Earlier independent `QuestInteractionProbe` captures from the same NPC quest returned ordinary reward itemID=858, quantity=3 with missing name and nil link, and another capture resolved the name. Those probes were in earlier loads; they cannot prove every P0246 `GetQuestItemInfo` return at the completion presentation timestamp. The exact gate blocking P0246 is still UNKNOWN. Candidate causes: missing/secret/invalid quantity or item ID, unavailable `GetItemInfo`, or a failed metadata call. **Do not infer that the item request ran, nor that item-data events failed.**

## Narrow diagnostic P0247 (runtime behavior unchanged)

Add one string-only, addon-owned reason `lastCompletionItemGate` evaluated from the **same existing** `GetQuestItemInfo` result and single `GetItemInfo` call. Guard name, quantity, itemID and cache result against secret-capable values before any type/comparison. Report gate through F — Quest Experience -> Quest Dialogue Check: e.g. `quantity-invalid`, `item-id-invalid`, `cache-api-unavailable`, `cache-empty`, `cache-name-secret`, `cache-eligible`. Distinguish the no-request path before changing loading policy. No extra native reads, no polling, no mutation, no claim, no suppression. Preserve native quest controls and fallback.

## Acceptance

P0247 is a **diagnostic candidate**, not a claimed item-name fix. After deployment, inspect the new `gate=` field on the same naturally available complete/reward interaction, run F Quest Dialogue Check while NPC still open, and export the diagnostics. The gate, alongside requests/signals/resolved, will identify the narrow next correction. Do not require new quest travel or invented completion. Preserve the P0246 failure as OPEN until source evidence supports the next repair.
