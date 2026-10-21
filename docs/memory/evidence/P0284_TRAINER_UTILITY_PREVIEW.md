# P0284 — Trainer utility completeness after P0283 visual acceptance

Date: 2026-10-21. Verified remote `main` baseline `b6d818b4720d00fd0d27c1ab6d5bd6504993f444` (P0283).

## Observed result and remaining gap

User screenshots compare an in-game P0283 landscape mock and the native Enchanting trainer. The user says **"Looks good"**, accepts the parchment, row selection hierarchy and portrait-free Logres identity. **P0283 P-only appearance VISUAL PASS within the tested fixture; missing utility presentation remains OPEN.** The native trainer screenshot has a filter popover with a Categorize option, money denomination display and **Train all** affordance; the P fixture instead has only a search field, per-row prices and an inert Train control. This is a scoped visual/completeness gap, not evidence that native trainer transactions can be taken over. Prior P0281 failures and P0282 yellow-row failure remain historical evidence.

## P0284 narrow capability policy

D-046 fixture-first and D-047 native-transaction ownership still apply. P0284 extends the same plain `Landscape.Fixture()` / `Landscape.Build(model)` / `Landscape.Render(owner, model)` path with deterministic *synthetic* filter state (`Filters`, `Categorize` checked), player-funds-style money (`1g 20s 58c`) and a disabled `Train All (1, 1s)` control. These are fixture strings, **not** real client values, account balances, purchase eligibility, or claims that Blizzard exposes these APIs safely. A new filter chip and checkbox presentation fit above the existing category list. Funds occupy the utility footer above the existing Train area; Train All uses the same preview-only button recipe as Train, with a separate synthetic `trainer.trainAll` ID. UI remains mouse-inert: no clicks, purchases, filter mutation, hooks, or session automation.

The P0283 selected/ordinary/disabled palette, list geometry, sidebar, parchment treatment, header, reagent count and no-portrait design remain intact. No native frame control, `NativeTrainerSkin`, `TrainerMotif`, Quest, camera or saved data is altered. In native H mode, the existing four-control painter and native Blizzard filter, price, money, Train and Train All continue unchanged. Numeric wording remains authored fixture data only, not a reliable live cost aggregation. Additional reagent rows can occupy the footer area; overflow placement is **DEFERRED** to a separate layout capability/preview state and must not be called accepted by this one-reagent screenshot.

## Validation and next gate

Guarded applier pins the pushed P0283 exact Git baseline and changed blobs, checks prewrite candidate source/contract parity, runs the full static checker suite in a `git archive` shadow before tracked writes and again postwrite, checks git whitespace, emits a manifest and rolls back tracked patch-owned files on postwrite failure. The assistant's targeted checks are source-oriented; **full WSL checker suite and WoW results remain UNVERIFIED** until executed. Expected P preview: subtle Filters chip and Categorize indicator, denominated Funds and muted Train All control, with no loss of text legibility or new black rectangle. Toggle preview OFF. Native H capability and authenticated monetary values remain outside P0284; do not travel to NPC solely for this fixture.
