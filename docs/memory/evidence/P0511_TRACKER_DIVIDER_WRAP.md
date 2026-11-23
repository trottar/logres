# P0511 — Focused quest tracker plain rule and five-line objectives (2026-11-23)

Verified GitHub main P0510 R1 `5b4077079f86f106df01cb02255d61533e4c0670`. User screenshot of `Harlan Needs a Resupply` shows an unwanted orange diamond at the middle of the divider and the first objective truncated with `...`. User requests unchanged styling except removal of the dot, word wrapping up to five lines, and automatic tracker expansion.

## Owner and diagnosis

The `Logres/Media/Quest/active_quest_divider.tga` 256x16 source contains a center diamond. `ActiveQuest` maps it to the 292x16 divider; this dot is authored artwork, not quest state. The objective label was explicitly `SetWordWrap(false)`, `SetHeight(16)`, while rows were pinned to 42px fixed pitch. Changing word-wrap alone would overlap progress bars and successive objectives. The original approved art asset and its historical hash contracts must remain unchanged.

## Implementation

New `active_quest_divider_plain.tga` uses the original horizontal border pixels sampled from a quiet run of the approved texture, replacing only the 19-pixel center region. The approved original remains on disk and referenced by the theme registry; the ActiveQuest owner selects its addon-owned `dividerPlain` variant. No new art outside the center, no change to frame position, fonts, quest source or protected state.

Objective labels get a five-line bound, ordinary `GetStringHeight` measurement after restoring their full height on every render, and actual per-row height plus a 24px progress/footer reserve. All eight objective hit regions move by the accumulated measured row heights; root height grows accordingly. The optional `SetMaxLines` capability is gated; available `GetLineHeight` also bounds the text box to five actual line-heights if that setter is absent. Both methods are addon-owned font queries, with conservative fixed geometry only if unavailable. Unknown/invalid measurement conservatively allocates the maximum bound. No new polling or quest mutation. Preview and OFF/current-quest controls unchanged.

## Additional L-030 observation

During the same discussion the user reports two further compass `[quest]` markers with no apparent quest giver; quest/NPC IDs, coordinates, native offer evidence, and event status were not supplied. These are OPEN / UNREPRODUCED as distinct cases within L-030; do not invent a broad "no nearby NPC" filter. QuestieDB map coords are not live-spawn proof; possible reasons include unverified NPC, phased/layered NPC, conditional offer, or false positive. Ask for a focused Report Bug snapshot if they recur. No navigation eligibility change in P0511.

## Validation and open gates

Targeted stdlib-only source checker plus actual-source Lua fixture verify revised text and layout owners, MAX_OBJECTIVE_LINES=5, original approved asset SHA, new divider pixels elsewhere identical to source, centered ornament absent, version parity, and L-030/L-022/L-039 evidence. Full historical `tools/check_*.py` suite, diff/syntax/readback and transactional applier checks are required before release. In-game objective wrapping, max-five behavior, binary/no-bar rows, hover, multi-objective stacking and centered ornament are **UNVERIFIED**. Keep L-022 and L-039 OPEN, L-030 PARTIAL.

## Assistant build and negative results

The first candidate builder refused a stale CURRENT.md literal from an earlier pre-P0510 summary; no repository writes were made. The first new checker rejected its own `Quest\` literal due to Python backslash escaping; corrected checker then passed. One prior complete 371/371 historical run passed before the exact five-line-height refinement, and the refined candidate passed a second 371/371 run in bounded batches with zero failures. The actual-source fixture covers 4/5-line rows, binary/no-bar rows, compact return, hidden stale rows, and empty tracker. Final audit-bearing candidate passed 371/371 historical checks in four bounded batches after the checker removed its non-stdlib image dependency; Lua syntax, original approved asset, archive readback and isolated tamper/rollback checks passed. Installation PREWRITE/POSTWRITE and WoW client visual validation remain separate obligations.
