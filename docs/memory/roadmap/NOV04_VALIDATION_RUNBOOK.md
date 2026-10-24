# P0328 — November 4 Forever runtime acceptance runbook

**Status:** PREPARED, WoW **UNVERIFIED / DEFERRED until November 4, 2026** (client access contingent). This runbook is a test plan, not PASS evidence, a launch announcement, or permission to modify secure/Blizzard surfaces. `docs/memory/CURRENT.md` and `docs/memory/investigations/ISSUE_REGISTER.md` remain authoritative.

## Preconditions and capture

1. On an actual available Forever client, confirm the development addon loaded with matching version from `Logres/Logres.toc`; keep the user's known-good install/backup intact. The repo uses `_classic_beta_` in the deploy example; validate the actual target folder rather than guessing from a failed path.
2. Development deployment, if required by a **future runtime patch**, follows the project `deploy_logres.sh` workflow; P0328 does not require a deploy. Reload after changing deployed addon files, not to conceal a defect.
3. Open the developer panel using `/logres panel` (or `/logres`); select phase **H**. Developer H actions listed below are already registered by `Core/Commands.lua`. Run **read-only status** before mutation/trial. Capture developer diagnostic export where available and `LOGRES_DIAGNOSTICS_LATEST.lua` (not committed to Git), screenshots, exact action sequence, client build, and combat/context.
4. A result is **PASS** only for what happened visibly and without Lua/taint/protected/secret failure; **FAIL** for real errors or broken controls; **DEFERRED** when the necessary NPC, source or client is unavailable; **UNREPRODUCED** for an intermittent problem not repeated. Never record a one-off absence as a fix. Record on source issue ID; save negative evidence before patching.

## Ordered high-risk checks

| Order | Action and evidence to capture | Gate / disposition |
| --- | --- | --- |
| 1 — P0321 baseline | H **Gossip Stock Status (READ-ONLY)**; inspect addon-owned parked/pending/restores/deferrals counters and normal native accessibility. Slash fallback `/logres gossipstockstatus`. | Read-only, no visible mutation expected. Verify pre-toggle state. |
| 2 — P0321 controlled toggle | H **Gossip Stock Toggle** with naturally open ordinary gossip; observe Logres single window, native non-overlap, reappearance on OFF, Goodbye, native quest link/choice handoff and return. Slash `/logres gossipstocktoggle`. | Mutating test; abort further replacement changes after Lua/secret/taint, invisible click region or failed restore. P0321 remains UNVERIFIED until recorded. |
| 3 — quest/ordinary gossip | Exercise a naturally available branching gossip, guarded quest link, native detail/complete/reward fallback and client close. Do not intentionally claim reserved **Quest 237**; do not force contrived quest states. | Separate P0317–P0320 known scopes from newly observed P0321 restoration; record Blizzard-frame flash L-002 if repeated. |
| 4 — merchant/flight source | H **Native Service Frame Audit** (`/logres nativeframeaudit`) and H **Native NPC Services Check** (`/logres nativeservicepolicycheck`) with a naturally accessible merchant or flight master. Observe `MerchantFrame`, `FlightMapFrame`/`TaxiFrame` source availability and stock controls without assuming candidate frames are real. | BOTH READ-ONLY; no native geometry, purchasing, selling, repair spending or travel required. Flight root disagreement stays UNRESOLVED until proved. |
| 5 — stock transaction/travel fallback | Verify the existing native merchant buyback/repair/close and flight route map/close remain visible/usable while NPC context transitions. Avoid doing financial or travel actions merely for a proof. | Keep native ownership; L-003/L-004 FEATURE GAP unless a real defect is reproduced. |
| 6 — trainer regression | Use naturally available class/profession trainer, inspect known Logres visual/filter parity and stock usable purchase fallback/close restoration; record exact family. | Existing trainer-only session/parking must remain stable; do not generalize parking. |
| 7 — ACT / STATUS | Run existing phase H and earlier dev panel action/pet/status diagnostics applicable to available context. Check action routing/bindings, pet secure fallback, Immersion ON/OFF, resource/target auras, combat/reload restoration. | Critical secure/protected/taint/Lua or missing native control = FAIL and alpha blocker. Pet/spec unavailable = DEFERRED, not PASS. |
| 8 — NAV / CAM | Verify compass heading/manual waypoint and stock minimap access, missing QuestieDB provider gracefully, accepted camera/DynamicCam behavior, taxi/mounted context only if naturally encountered. | Camera frozen D-047; no profile/CVar change or forced taxi ride. Preserve world-first sparse HUD and stock fallback. |
| 9 — full-state recovery | Use legitimate reload, immersion and NPC-close transitions; confirm native controls remain usable and diagnostics export works. | Record each specific observed test; no blanket 'all passed' without execution. |

**Do not start with H — Native Auto Position (TEST)**: it moves native service windows and is not an initial read-only audit. Do not use timers, polling, generic Show/Hide hooks, secret-value introspection or hidden stock click regions to "fix" a defect without narrowly reproduced evidence.

## Evidence and release disposition

For each tested row record date/build, required environment, action, addon-owned observed fields, UI state, screenshot/diagnostic file, result **PASS / FAIL / DEFERRED / UNREPRODUCED**, and next narrow hypothesis. Preserve P0321 WoW **UNVERIFIED** until actually observed. The 5-domain D-048 user switches are not implemented and cannot be tested or advertised as working; no alpha date is promised. Public alpha A0/A1/A2/A3/A4 additionally requires clean installation, documented dependency and copyright/Logres project license, stable secure/native controls, release notes and user recovery. Current release **NOT APPROVED** before those gates.
