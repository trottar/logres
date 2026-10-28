## P0368 — November 4 candidate freeze GO/NO-GO (2026-10-27)

Verified pushed P0367 main `1f58cb641af0d04d35cf847d521faece7863a6b4` 238/238 STATIC. November 4 is a **contingent internal alpha client validation opportunity, not a release date**. P0368 updates the stale version in the regression matrix to require TOC/Bootstrap/current verified main and actual installed build parity. Before internal candidate GO: full static checker suite, `tools/alpha_prefreeze_audit.py`, `tools/stage_alpha_candidate.py --check`, safe installation and P0321 FIRST gossip restoration client gate; individual gameplay results recorded PASS/FAIL/DEFERRED, with no claim from unperformed checks. Public release **PUBLIC RELEASE NOT APPROVED** while L-019 root license/redistribution terms are unresolved, runtime A0–A4 acceptance incomplete or D-048/L-014 five live independent switches remain NOT IMPLEMENTED. Do not infer release approval from static staging or calendar. No WoW deployment for P0368.

## P0340 — internal alpha prefreeze and README reconciliation (2026-10-25)

Verified GitHub `main` P0339 `8a5d3f86c557745de6b2e61bf7a5f0273930c129` pushed with manifest 210/210 PREWRITE/POSTWRITE static checks, WoW UNVERIFIED. Internal source review found `README.md` still inaccurately calling the QuestieDB integration diagnostic-only despite P0230–P0231 historical compass locations and P0337 native-offer eligibility gate. P0340 corrects installation guidance; adds offline read-only `tools/alpha_prefreeze_audit.py` to verify deterministic in-memory internal staged ZIP members and byte parity, CRC, 94 loaded Lua, bundled media, optional QuestieDB exclusion and LibCamera attribution. No runtime Lua, TOC/version, stage tool, saved preferences, camera, native UI or actual WoW deployment changes. Full 211 PREWRITE shadow and POSTWRITE static checks must run in WSL; client installation/P0321/P0330–P0338 remains UNVERIFIED until contingent November 4. L-019 project license is MISSING/public release NOT APPROVED. November 3 static freeze is a *proposed gate*, not a demonstrated WoW PASS or automatic public ZIP. See `docs/memory/evidence/P0340_ALPHA_PREFREEZE_AUDIT.md` and `docs/memory/patches/P0340_ALPHA_PREFREEZE_AUDIT.md`.
## Nov 3 candidate prefreeze — read-only source checks (P0340)

Before using `dist/` for *internal-only* staging, on the exact committed candidate run `python3 tools/alpha_prefreeze_audit.py` and `python3 tools/stage_alpha_candidate.py --check`, followed by the complete `tools/check_*.py` static suite and `git diff --check`. P0340's audit reconstructs a ZIP **in memory** and prints a reproducible SHA-256 but creates no file, changes no addon/installation, and does not award A0/A3 runtime PASS. Inspect the current README and dependency instructions, re-review L-019 license/attributions, and retain the P0321-first November 4 client runbook. **PUBLIC RELEASE NOT APPROVED.** No public packaging by default.

## P0328 — alpha installation A0/A3 readiness and November 4 test order (2026-10-24)

P0327 `67c5818` is pushed. P0328 adds an **internal-only, reproducible source staging ZIP preflight** under `tools/` plus a runbook for the existing November 4 runtime gate; it changes no addon-loaded source or native control. Runtime manifest/media/LibCamera notice are retained; external optional QuestieDB is never bundled. **Root-level Logres licensing/redistribution terms unresolved (L-019)**, and client clean-install, WoW native restoration, game compatibility, five live domain selectors and public alpha release remain **UNVERIFIED / NOT APPROVED**. Run `python3 tools/stage_alpha_candidate.py --check` before the proposed Nov 3 freeze, full static tests, issue review and deliberate install QA; generated `dist/*.zip` is INTERNAL ONLY. November 4 runbook starts with P0321 Gossip Stock Status/Toggle, merchant/flight H read-only audits, then native/action/status/compass/camera regressions; no forced transactions/travel. See `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md` and P0328 architecture/evidence. No WoW redeploy for P0328.

## P0327 — merchant/flight inert service presentation models (2026-10-24)

P0326 `7949d7c` is pushed. P0327 prepares **eight synthetic, non-transactional merchant/flight states** in offline Python only. It makes no claims of client source, enabled controls, actual fares, route connectivity, buyback stock or Blizzard root identity. The D-046 fixture-to-model step is prepared but **same-renderer in-game P — Previews remains UNVERIFIED**. Native merchant transactions and flight map/travel stay Blizzard-owned; L-003/L-004 remain FEATURE GAP. Five independent D-048 toggles are not live; camera frozen D-047. On November 4: P0321 gossip restoration first, then read-only H native service diagnostics for naturally accessible merchant/flight; no H native positioning test or forced purchases/travel. No WoW redeploy for P0327.

## P0326 — merchant and flight native-source audit (2026-10-24)

P0325 `c596fe2` is pushed. P0326 documents *existing* merchant and flight-master stock UI integration points without new Lua, transactions, native frame ownership or camera changes. Merchant `MerchantFrame` is a policy/source candidate; flight `FlightMapFrame` and `TaxiFrame` candidates remain **UNRESOLVED** in Forever. The trainer-only `NPCServiceSession` and separate gossip/trainer parking paths must not be expanded without service-specific proof. L-003/L-004 remain **FEATURE GAP / runtime untested**. November 4 remains a proposed client-access opportunity: P0321 gossip restore first, then read-only H Native Service Frame Audit and Native NPC Services Check for naturally accessible merchant/flight, then native fallback usability. Blizzard-owned merchant and flight controls suffice for alpha if safely usable; feature claims must stay evidence-bounded. No WoW redeploy for P0326.

## P0325 — staged save-migration proposal, no runtime wiring (2026-10-24)

Verified pushed P0324 `bc56185`; P0325 keeps schema-3 saves and all five live system behaviors untouched while testing a pure, staged optional domain migration proposal. Unknown CAM ownership is not inferred from legacy Immersion. Four existing preference combinations and 32 explicit five-domain draft choices are covered offline; client restoration and saved-variable upgrade remain UNVERIFIED. Next: read-only merchant/flight service handoff audit and November 4 native gossip restoration. No WoW redeploy for this docs/tools checkpoint. See `docs/memory/architecture/P0325_MIGRATION_DRY_RUN.md`.

## P0324 — inert five-domain policy specification (2026-10-24)

P0323 audit is pushed at `386a7ef`; P0324 is test-only preparation of the D-048 five-domain selection model, **32** requested-mode combinations, capability/fallback and pending-restore fixtures and untouched legacy-save behavior. `tools/p0324_domain_policy.py` is **not addon-loaded**; no live preference migration or native ownership occurs. Next: separate migration and Lua-equivalence gates, bounded merchant/flight source assessment and November 4 P0321 client-validation priority. P0321 gossip parking remains **WoW UNVERIFIED**; release gates unchanged.

## P0323 modularity-audit checkpoint (2026-10-23)

P0322 `272130e` is pushed and durable; P0323 is a docs/static-checker-only audit mapping **all 94 loaded Lua files** into five intended D-048 systems or shared infrastructure. Existing Immersion state coupling, two distinct native NPC parking ownership paths and high-risk secure/camera regions are recorded without refactoring. The next implementation candidate is a **pure** 32-combination requested/effective/fallback policy fixture, not live five-toggle controls. November 4 runtime verification remains necessary for P0321 gossip parking and merchant/flight native handoffs; alpha/1.0 quality gates are unchanged. Full static checks must pass before this audit can be committed. See `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md`.

# Logres — Alpha-to-1.0 launch roadmap

**Planning baseline:** 2026-10-23; `main` P0321 `9a180c878279d24e60cd819428fe6dad3a599fc8` verified pushed. This is an internal readiness plan, **not** a public release date or runtime acceptance. Forever launch date is not established by this repository plan. The next stated beta opportunity is **November 4, 2026**, subject to actual access. P0321 gossip parking is **WoW runtime UNVERIFIED / DEFERRED**, not PASS.

**Product scope:** D-048 defines five independently selectable systems: NAV (compass/minimap), ACT (action bars), NPC (interactions), STATUS (player/enemy health/resources/buffs/debuffs), and CAM (camera). Immersion may become an optional preset; no cross-system master gate. D-047 camera baseline and D-046 preview-first source/control separation remain binding.

## Work leading to November 4

| Milestone | Checkpoint | Work and completion evidence | Risk policy |
| --- | --- | --- | --- |
| 1. Reconcile (Oct 23–25, proposed) | P0322 | Verify pushed P0321, capture D-048, write launch plan and canonical issue register, preserve negative evidence, define static contract; docs and checks only | No runtime Lua or preference migration |
| 2. Repository-wide audit (Oct 25–28, proposed) | P0323 | Map every production file to shared infrastructure or NAV/ACT/NPC/STATUS/CAM; record cross-domain dependencies, event ownership, saved data, native fallback, protected mutations and test coverage | Read-only, no speculative rewrite |
| 3. Isolated modularization (Oct 28–Nov 2, proposed) | P0324+ as earned | Extract only proven duplicate pure model/preview/test utilities; preserve production behavior byte-for-byte where possible, add equivalence contracts and manifest/evidence | Defer any uncertain runtime/secure/native rewrite to Forever testing |
| 4. Service preparation (parallel) | Bounded research | Merchant and flight-master native API/source capability, model/preview, camera/session handoff, safe stock controls and failure cases. No purchases/flight mutations | Vendor/flight Blizzard transaction ownership retained |
| 5. Static freeze (Nov 3, proposed) | Candidate gate | Full checker suite, diff hygiene, patch ZIP self-tests, current release issue matrix, prepared in-game H-panel commands, no broad feature merge | Do not imply WoW runtime PASS |
| 6. Forever re-entry (Nov 4, contingent) | Runtime gate | Prioritize P0321 Gossip Stock Status/Toggle, options, quest links, native quest detail, Goodbye, immersion restoration and no Lua/taint/secret errors; then class/profession trainer baseline, merchant and flight-master native handoffs; then high-priority action/HUD/navigation/camera regression checks | Stop on a real failure; preserve diagnostics; no forced gameplay travel solely for proof |

The calendar bands above are planning windows; quality gates determine actual progression. Audit results can defer extraction work without jeopardizing the accepted runtime baseline.

## User-facing systems: version-one scope

| System | Alpha viability gate | 1.0 functionality target |
| --- | --- | --- |
| NAV | Reliable heading/manual waypoint and usable native minimap fallback; no invented quest/POI/tracking coordinates | Independently selectable navigation; additional markers only if proven; minimap retained when information incomplete |
| ACT | Secure primary and supported secondary/utility controls usable, bindings/recovery and pet/native fallback verified in tested contexts | Independent Logres/Blizzard action ownership with stable secure transitions and intended role assignment |
| NPC | Existing quest/gossip narrative and choices intact; P0321 restoration validated before claiming single-window; merchant/flight native usable | Independent NPC mode with consistent quest/gossip/trainer experience, merchant/flight hybrid or custom only when proven |
| STATUS | Accepted health tunnel, target/resource and selective aura presentation preserved; retained Blizzard critical information reachable | Independent status ownership across health/resources/casts/auras without reintroducing exact player HP or suppressing unreplaced status |
| CAM | Existing working camera/DynamicCam behavior unchanged until gated independent release control is proven | Independent camera toggle which restores previous/stock configuration safely |

**Five switches are the intended public interface, not an assertion about the present `Settings/Panel.lua`**. Alpha may publish a clearly described limited scope only if the critical controls and native fallback are stable; do not advertise a working five-switch experience before runtime proof.

## Alpha candidate release gates

- **A0 / install:** Clean install on targeted Forever client; manifest/interface version and dependency guidance current; QuestieDB optional with documented compatible install and no-provider behavior (`README.md`, `docs/DEPENDENCIES.md`); no machine paths; license/third-party credits/packaging readiness reviewed.
- **A1 / survive:** No known critical Lua, secret, taint, secure-action, stuck camera, disappeared controls or stranded native UI; native controls remain accessible on unsupported state, combat or incomplete Logres source.
- **A2 / coherent:** Five-domain requested/effective/fallback policy and defaults are accurately described; accessible ON/OFF and preserved user preferences for supported toggles. No public claims about unimplemented controls. Existing Active Quest and Quiet Mode choices remain intentional.
- **A3 / verified:** Full static regression suite and candidate diff hygiene pass; representative combat and noncombat, reload, immersion, native interaction and restoration checks pass within their actually tested scope; explicit deferrals documented.
- **A4 / use:** Clear first-run settings and recovery path, installation instructions, supported features, known issues, user feedback/diagnostic export method. A public-alpha candidate is not automatically a public release or Reddit post.

## 1.0 exit gates

- Five genuinely independent Logres/Blizzard selectors and persistence/migration verified; effective-state diagnostics identify partial native fallback and pending restore.
- Initial documented product functionality stable and visually coherent, with validated secure/transaction control boundaries. Merchant and flight-master integration may deliberately remain hybrid/native if source/control complexity warrants it; do not promise custom transaction UIs without a decision.
- No open release-blocking defects; high-priority reproducible regressions addressed; each accepted feature has representative runtime evidence. World-target positioning, complete compass markers, live action-edit UI, replacement of all Blizzard services and speculative special-state ownership are **future** unless specifically promoted through evidence.
- Change log, supported client/dependency matrix, recoverability and platform distribution requirements ready; version 1.0 awarded by criteria, not an arbitrary launch offset.

## Issue triage policy

Use `docs/memory/investigations/ISSUE_REGISTER.md` as a consolidated **index**, not a rewrite of canonical raw evidence. Entries have owner, observed/not observed, severity, runtime status, fallback, next check and release target. A blocked source capability is not a reproduced runtime bug; an environmental deferral is neither PASS nor FAIL. Unexpected critical native/secure regression blocks release and is corrected before additional suppression.

## Next actionable work

**P0323 repository-wide modularity/ownership audit**: map exact source modules and preferences to D-048 domains, identify isolated seams and reversible migrations, recommend low-risk extraction order, and keep all runtime code unchanged. P0322 commits durable scope and baseline only. After P0323, prepare deterministic five-switch policy fixtures before attempting any new live toggle.
