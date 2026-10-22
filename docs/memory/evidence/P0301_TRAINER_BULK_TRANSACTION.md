# P0301 — guarded Train All runtime gate

Date: 2026-10-22. Baseline verified `main` P0300 `73e3396c15c3131c2a31c7d1297f50951a92047f` (`0.0.201-dev`). **PREPARED; WSL full static and WoW runtime unverified.**

## Observed and negative history

User confirms P0300 Goodbye is present and functioning; previous user screenshots establish P0299 case-insensitive local search, filter composition, selected skill details, P0298 icon restoration and one P0296 single-service purchase. Assistant deferred bulk Train All repeatedly instead of implementing a gate; user rejects closing a trial with an unfinished visible control. Those previous deferrals did not establish an API impossibility and must not be misrepresented as one. The separate P0300 R0 memory-health failure was caught before tracked writes and corrected by R1. Existing P0294 click, P0295 scrollbar, P0296 intermittent gold icon and P0297 black icon regressions remain recorded by original evidence.

## Source/reference investigation

`cjber/tweaks-forever` `UI/TrainAll.lua` on GitHub currently implements user-clicked class-only Train All via `GetNumTrainerServices`, six-field `GetTrainerServiceInfo`, `GetTrainerServiceCost`, `GetMoney`, `BuyTrainerService`. This is **external feasibility evidence**, not a copy of source and not proof of Logres behavior. The Logres P0296 `TrainerPurchaseTrial.lua` already executes one guarded `BuyTrainerService` request in client; the user reported one successful purchase. Native multi-buy ordering, async server updates, stock frame protection, and profession behavior are not comprehensively proven. P0301 independently implements full-list eligibility and fresh quote gates, per-service identity and cost before each request, early stop, no retries, no polling and stock fallback. For a successful Lua `pcall` record only request sent, never confirmed learning.

## Runtime procedure and limits

At trainer after deploy `/reload`, use `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Compare Logres quote/count/cost to native Train All, verify button unavailable when quote/affordability fails; search/filter should not modify the underlying full native quote. Only if the user wishes to train every currently available class service, click Logres Train All once and verify learned services and net currency with Blizzard UI. The action may genuinely spend funds. If status/price/list changes mid-batch, Logres must stop and preserve native usability; do not manufacture environmental scenarios solely for proof. P preview remains inert, no profession training, no native UI suppression. Failure/partial evidence must be retained and repaired before production replacement.

## Next gate

Native trainer view/interaction ownership must be independently capability-gated and restore stock before dropping Logres interaction, including combat/teardown and full category/aura/transaction completeness where applicable. P0301 does not hide or reparent Blizzard frames; the final trainer trial cannot be claimed a complete native replacement merely from this patch.
