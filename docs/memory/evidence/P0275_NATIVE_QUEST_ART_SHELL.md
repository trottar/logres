# P0275 — Real quest artwork around Blizzard-owned native services

Date: 2026-10-19. Pushed baseline: `ac3f199769988cfc08002f8a31f635aac04874d4` (P0274). Authority: accepted D-047, implemented quest renderer (`Logres/Quest/Dialogue.lua`) and theme (`Logres/Media/Theme.lua`), user screenshot of actual 0.0.172-dev quest panel, and native merchant/trainer opt-in placement evidence.

## Observed P0274 negative result — NOT visually accepted

The 0.0.172-dev screenshot shows the native trainer unchanged to the user. Initial diagnostics `accent=stock`, `accentShows=0` were taken before placement; later saved diagnostics show `accent=additive`, `accentShows=3`, `accentHides=2`, `accentFailures=0`, so addon-owned accent activation was observed. **Its 105x2 gold line and 6x6 seal were visually insufficient**. This is a visual fidelity failure/insufficiency, not proof of a texture API failure, native UI failure, or runtime PASS for Logres styling. The user rejected invented green/parchment ornaments and supplied an actual screenshot; the approved goal is the quest panel's dark translucent silhouette, thin gold corners, centered title, gold divider, restrained actions, and general wide composition.

## Source-derived feasibility boundary

`theme.questDialogue` defines a 640x320 frame, title/body gold-cream colors, and exact assets `Quest/quest_narrative_panel.tga`, `Quest/quest_narrative_divider.tga`; `Logres/Quest/Dialogue.lua` creates the panel texture on an addon-owned frame. The P0271–P0274 controller already centers and restores Blizzard's native merchant, trainer, and gossip frames. It does **not** own the inner native frame background, spell list, buttons, filters, repair controls, or transactions. There is no client evidence authorizing moving/reparenting/resizing native child controls or hiding their opaque backgrounds. A pixel-faithful version of the approved wide trainer mockup is **not** achievable with this purely additive stage; native stock interior remains visible.

## Narrow P0275 implementation

Replace the nearly invisible P0274 accent with one visible 640x540 mouse-disabled **addon-owned quest-art shell** behind the same native merchant/trainer frames while the existing opt-in controller owns them. Reuse exact quest-panel and divider asset paths; render the panel with nine texture slices so original border/corner geometry is not stretched when taller. A small `TRAINER`/`MERCHANT` category label occupies the extended top margin. No native texture/child/input/geometry is inspected or mutated by the shell. Set the addon art to `BACKGROUND` strata, not the native frame hierarchy. Current native frame's opaque interior remains intact, deliberately. No new panel action or onboarding complexity; H `Native Auto Position (TEST)` remains the sole toggle. Existing restore path hides shell BEFORE native anchor restoration; creation/art errors fail open to Blizzard; no combat polling or camera changes. Gossip stays stock visually for planned D-046 live adapter; bank/auction/flight untouched.

## Gates and next action

Static WSL shadow PREWRITE and postwrite **142 checker** suite and `git diff --check` are required; source/contract validation is not WoW visual evidence. Runtime H `Native Auto Position (TEST)` ON -> naturally accessible merchant/trainer -> CLOSE DEVELOPER PANEL to evaluate quest shell; verify shell outside Blizzard frame and native inputs/quantity/filter/repairs unobstructed; OFF with service open -> art hidden and stock native anchors restored. Reopen with OFF -> no shell. H `Native NPC Services Check` then 0 `Run All`. Screenshot and saved diagnostics required. If `accent=quest-shell` increments but art is still not visibly adequate, log result as **visual redesign still OPEN**, and do not claim accepted appearance. If taint/protected action, inaccessible controls or native restoration failure -> FAIL and stop. Next layout stage requires **separate evidence** before manipulating Blizzard child controls, never rebuild native transaction systems; planned live gossip adapter remains separate.

## Not tested/accepted at preparation

No WoW runtime test, frame-resizing authorization, native texture ownership, extra trainer search/filter implementation, transaction execution, custom service controller, or camera changes. Do not infer these from the concept image.
