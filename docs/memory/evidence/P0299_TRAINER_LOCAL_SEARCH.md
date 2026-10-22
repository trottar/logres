# P0299 — Live local trainer search evidence and boundary

Date: 2026-10-22. Baseline: verified GitHub P0298 `be13ce1edf59bd00387467f4e72baea56bed2331`, `0.0.199-dev`. **P0299 PREPARED / WSL AND WOW UNVERIFIED**.

## Runtime and source evidence

User P0298 screenshot: multiple live trainer spell icons and selected detail icon render normally again. User reports "Looks good. Everything except search and train all work". Thus icon recovery **USER VISUAL PASS**, selection/filter/scroll supported by user report; no WSL code test or bulk purchase claim from that screenshot. Single-skill purchase had a prior user-reported and funds-correlated PASS in P0296 (6s). P0297 all-black icon FAIL remains preserved in its evidence; P0296 earlier yellow blocks were a distinct failure. The screenshot does not conclusively prove thumb dragging, stock teardown, or all transaction permutations.

Current source: `TrainerLandscape.Render` creates a `Search (stock)` FontString with no keyboard input; `TrainerLiveTrial.FromSnapshot` sets `categories={"Visible services"}` with only decorative category presentation. Live `trainAll={label="Train All unavailable",enabled=false}` has no owned purchase controller. Blizzard Train All is still a usable stock fallback.

## Hypothesis and scope

Install a narrow, high-priority addon-owned EditBox in the existing live search slot (left of filter), no Blizzard reads during text changes. Limit to 48 characters; independently gate EditBox text as ordinary before type/lowercase comparisons. A case-insensitive **plain substring** search of copied name/rank labels combines with local Available only and existing bounded 64-entry snapshot/7-row slider. Native `serviceIndex` is never recomputed from filtered slot order. Selection and detail survive a query that hides the selected row; any such hidden choice disables the Logres Train selected test until visible under the current filter/search. Empty/no-match rows and click hit regions follow existing safe hide path. Search EditBox clears focus on H OFF/trainer context teardown. Search P remains inert. The unimplemented category label becomes an honest `Sampled skills` summary (not a fake selectable taxonomy).

No native filter/selection setter, BuyTrainerService/Train All change, API probe, unbounded source search, secret inspection, polling, hook, stock reparent, or automatic action. This is search/navigation only. **Train All requires its own separately capability-gated design and test**, potentially with cost/eligibility changes across multiple buys; a single observed purchase is not sufficient evidence to automate a batch. Stock Blizzard Train All remains visible and user-controlled.

## Validation

Guard exact baseline main and edited Git blob IDs, clean tracked state, unique anchored transforms, candidate LF/EOF and git diff --no-index --check, candidate memory threshold, complete `tools/check_*.py` shadow PREWRITE and POSTWRITE, final `git diff --check`, manifest and rollback on failure. New static contract validates input, bounds and source separation, not runtime UI focus.

WoW `/reload` at an ordinary trainer; `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Type `curse`, `CURSE`, a missing string, clear and retype, toggle All/Available, scroll wheel and slider with search active, select a matching skill then hide it and restore its query; check detail and disabled/enabled Train selected TEST. H OFF with EditBox focused and trainer close must restore keyboard/stock UI. Verify Blizzard's own Train All still responds to native clicks if naturally used; **no additional purchases required for P0299 PASS**. A Lua/taint/protection/secret exception is FAIL; unknown behavior DEFERRED.
