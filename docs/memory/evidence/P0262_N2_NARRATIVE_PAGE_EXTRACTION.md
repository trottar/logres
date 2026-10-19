# P0262 N2 — Real narrative pagination view extraction

Date: 2026-10-18. Verified baseline `main` `b439d4f91c5eb4b8c491b976696bfd3451e36d0b` (P0261 pushed). The user confirmed N1 P-tab previews **work as expected**; this is scoped preview runtime visual acceptance, not proof of generic gossip actions or a natural live quest claim. **P0262 candidate is STATIC ONLY until the user's WSL and in-client results arrive.**

## Exact question

Can the real, accepted narrative page splitter, on-screen pagination rail and body text setter become a shared view component, consumed by the existing production renderer and N1 synthetic previews, without duplicating UI or modifying protected/native/camera behavior?

## Extraction and boundaries

- `Logres/UI/NarrativePages.lua` contains the *relocated* original `appendPage` and `addParagraphWords` algorithm plus exposed `Pages.Build(text, limit)`. QuestDialogue's old `buildPages(text)` remains as a compatibility wrapper calling `Pages.Build(text, PAGE_CHAR_LIMIT)` with the **same 420-character threshold**. Paragraph/word assembly logic and empty-text fallback remain the original algorithms. This is character pagination, **not** claim of width-aware typography fitting.
- `Pages.Paint(self, activeColor, inactiveColor)` is the original real frame painter from `Dialogue:UpdatePageControls`: same completion/offer page-indicator rail coordinates (`-115,17` and `-115,78`), same ordinary center (`0,17`), current/page-count indicator, chevron colors and visibility. Theme colors are passed from the existing owner rather than looked up inside the view.
- `Pages.ShowBody(self, index)` moves the original `self.bodyText:SetText(self.pages[index] or "")` into the shared view. The `Dialogue:SetPage` owner continues setting `currentPage` and calling `UpdatePageControls`, `UpdateOfferControls` and `UpdateCompletionPagePresentation` in the same order; action gating remains **owner-owned**.
- `QuestDialogue:PresentText` and `QuestDialogue:PresentNarrativeModel` continue serving both guarded live offer and three synthetic narrative previews. `Quest/RewardModel.lua`, `RewardVisual.lua`, completion controls and item recovery remain untouched. The original frame factory, material/art, sizes, anchors, preview actions and click callbacks are untouched.
- `UI/NarrativePages.lua` loads before existing quest modules. **Do not separate the `Quest/NarrativeModel.lua` → `Quest/RewardModel.lua` adjacency**: P0261's established checker requires it. `Core/Commands.lua` is untouched; no new local upvalue approaches Forever's 60-local limit.
- `tools/check_quest_dialogue_contract.py` and `tools/check_p0254_completion_panel_placement_contract.py` are updated only to verify the actual relocated painter/geometry rather than require the same lines to reside inside Dialogue.lua. The P0262 checker additionally requires live/preview delegation and forbids native APIs/hooks in the new view.

## Frozen ownership and non-goals

**No `Logres/Camera/*.lua` changes. No DynamicCam, zoom, camera events or profiles changed.** `Quest/OfferActionProbe.lua`, `OfferStockSuppression.lua` and `CompletionControl.lua` are byte-identical. No new events, timers, native UI suppression, quest mutation, dialog buttons or selectable gossip added. No bank, auction or merchant implementation. P0251/P0257 failures and native brief frame flash remain recorded and OPEN as applicable. Quest 237 must not be completed merely to validate N2.

## Explicit P — Previews acceptance sequence

After WSL full static PASS, deploy and `/reload`. Enter `/logres panel` → **P — Previews** → **page 1/2** (not page 2). Click exactly these existing controls, in order:

1. **Quest Dialogue Preview** — long *The Lost Standard* text; use the small **right-page chevron** to reach final page, then **left-page chevron** to return. Confirm page counter advances and Accept/Decline are in-panel **only on final page**. If already final, reverse once to test both directions. Clicking Accept/Decline in preview does **not** accept or decline a real quest.
2. **NPC Narrative: Short** — short *A Message for the Watch* offer, **no extra page controls**, in-panel Accept/Decline visible; clicks remain preview-only.
3. **NPC Dialogue: Generic** — *Travelers' Welcome*, a single page with **no Accept/Decline and no fabricated gossip options**.
4. **Reward Preview: Single** — guaranteed item/XP/money and identical in-panel **Complete Quest** sample; the button is inert.
5. **Reward Preview: Multiple** — original guaranteed + CHOICE sample cards, matching in-panel Complete Quest sample; options/claim are not real gameplay.

Optionally in `/logres panel`: **F — Quest Experience → Quest Dialogue Check** (`/logres questdialoguecheck`) and **H — Integration and Polish → Quest Offer Controls Check** (`/logres questoffercontrolscheck`). Both are diagnostic/read-only; do not use F-tab **Quest Offer Accept Probe** or **Quest Offer Decline Probe**. If they report environmental DEFERRED while no real NPC is open, do not call that FAIL; if Lua/taint/secret errors appear, report FAILURE. Check camera framing during routine NPC interaction only if naturally available; no contrived travel.

No new action was added to P: existing five buttons still reside on page 1/2. Exact slash equivalents: `/logres questdialoguepreview`, `/logres questnarrativepreview short`, `/logres questnarrativepreview generic`, `/logres questrewardpreview single`, `/logres questrewardpreview multi`.

## Evidence limitations

Source relocation and static suite PASS cannot establish no visual regression until the player inspects the actual WoW view. No new camera runtime proof is claimed; camera source equality is a strict patch invariant, with a normal-interaction check advised. Natural quest progress/completion validation remains environmentally deferred if not readily available. Any failure remains OPEN pending narrow diagnosis.

## P0262 R0 prewrite static failure (2026-10-18)

User ran the original P0262 applier against verified clean P0261 main. Baseline and 16-candidate preparation both PASS, but full shadow suite FAILS `tools/check_p0255_quest_action_page_contract.py`: it still looked for the exact historical pager positions `-115,78` and `-115,17` inside `Quest/Dialogue.lua`, although N2 moved those statements verbatim into `UI/NarrativePages.lua`. **Result: FAILED STATIC / NO TRACKED WRITE.** R1 updates that historical checker to load and inspect the real shared painter, including original completion/offer/final-page guards and coordinates. The existing P0255 native claim and final-page stock gates remain enforced. This failed attempt is not a WoW runtime finding and is not classified PASS.
