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
