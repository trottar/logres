# P0193 — Accepted P0192 R1 read-only geometry observation

Date: 2026-10-11. Verified remote `main`: `377762049d11baa55904fb5f38d920f775345a1b` (`feat: audit approved H2 screen geometry in client`). Tested addon `0.0.102-dev`, `loadCount=242`. Source: user-supplied `LOGRES_DIAGNOSTICS_LATEST.lua`. Exact normalized measurements: [`P0193_H2_GEOMETRY_RUNTIME_2026-10-11.json`](P0193_H2_GEOMETRY_RUNTIME_2026-10-11.json). Approved design still governed by `docs/design/layout/SCREEN_MAP_V4.json` / D-045; no design coordinates changed.

## What passed

- Phase H Layout Check: `PASS (anchors=16 binds=23 failures=0 missing=0 mismatched=0 error=nil)`.
- Read-only H2 geometry audit: `measured=13/13 missing=0 deferred=0 reason=read-only-addon-geometry; layout unchanged`; all rows reported MEASURED.
- Phase 0 Run All in the uploaded final `checkall` record **completed**. Existing state, sensor, preferences, lifecycle, HUD, layout, native access, quest, aura, action and ownership checks reported PASS within their tested scope. Action check shows Primary/Secondary/Utility 12/12 with routing true in the sampled ordinary mode. Main secure normal-mode diagnostic reported `CANDIDATE armed=true auto=true optOut=false applied=true pending=false driver=true parentCaptured=true route=true edit=false activations=4 restores=3 ... error=nil`; this is not special-state proof.
- UI Ownership policy `35 total / 17 PASS / 18 STOCK / 0 FAIL`, explicitly `stock=policy-not-native-visibility`. Its Main STOCK classification does not override independently measured normal Main CANDIDATE state or prove pixel-level visibility.
- Secure native HARMFUL path `ready=true active=true` in the sample; aura membership not inspected. Harmful actual populated aura categories and secure-native AuraContainer bounds were not measured in this test.

## All 13 measured named Logres proxies versus approved planning envelopes

X/Y/W/H represent normalized percentages of UIParent. **A measured widget's visible frame bounds are not supposed to equal its larger design envelope automatically.** Do not classify differences alone as runtime failures or demand exact stretching.

| Component | Actual X/Y/W/H % | Approved X/Y/W/H % |
| --- | --- | --- |
| `compass` | 37.0/5.0/26.0/5.6 | 31.4/4.8/37.4/6.9 |
| `quest` | 55.7/15.6/20.8/14.2 | 80.0/5.0/19.6/19.2 |
| `enemy-debuff` | 56.5/55.8/11.1/3.1 | 65.2/40.0/6.0/9.0 |
| `enemy` | 41.5/52.8/16.9/5.6 | 72.0/40.0/13.0/9.0 |
| `enemy-buff` | 56.5/59.8/11.1/3.1 | 85.8/40.0/6.0/9.0 |
| `group` | 22.3/48.4/12.4/12.3 | 21.0/32.7/9.0/25.9 |
| `class` | 12.6/65.2/15.0/9.3 | 5.1/53.5/12.0/5.0 |
| `secondary` | 33.2/76.9/8.9/19.1 | 5.1/60.4/12.0/38.0 |
| `main` | 44.0/79.4/11.9/14.2 | 18.2/60.4/12.0/38.0 |
| `player-debuff` | 32.4/59.0/11.1/3.1 | 39.5/81.0/22.5/5.8 |
| `resource` | 43.7/61.4/12.6/1.9 | 39.5/88.3/22.5/6.0 |
| `player-buff` | 57.7/60.4/10.7/3.7 | 76.0/80.5/23.4/6.2 |
| `utility` | 57.9/76.9/8.9/19.1 | 76.0/88.2/23.4/9.3 |

## Interpretation and unresolved geometry constraints

- Current Primary is **4 columns × 3 rows**, measured `11.9% × 14.2%`, while Main plan is a tall `12% × 38%` territory. Current Secondary is **3×4**, measured `8.9% × 19.1%`. They can be repositioned and Primary reflowed deliberately; the envelopes do not require stretched buttons or full region filling.
- Current Utility is **3×4**, measured `8.9% × 19.1%`, but plan is **23.4% × 9.3%** at lower-right. Moving without reflow risks intrusion/cutoff. A discrete width-oriented action layout needs separate implementation and runtime proof.
- Actual enemy fallback `16.9%` wide exceeds the approved target envelope `13.0%`; each Lua target aura lane is `11.1%` wide versus planned `6.0%`. Naively centering all three frames in the intended boxes **would overlap actual target and aura surfaces**. Preserve left-debuff/right-buff intent, but require a measured collision-safe geometry solution and separately assess anonymous secure-native harmful containers.
- Active Quest measured `20.8% × 14.2%` in an idle state; its actual height varies with up to eight objectives. The preserved top-right native-access dock is not among the 13 named probes and its own access buttons must remain usable. There is no screenshot proving the Quest Tracker could safely be placed at (80%,5%) without overlap.
- Class planning box maps only to a **pet-action execution proxy**, not full class/totem/stance/control replacement. The Group/Pet box maps to addon ally hints, not replacement of stock secure Party/CompactPartyFrame. Extra Bar4/Bar5 remain separately owned; they were not among the 13 design boxes.
- Player debuffs and resource are different surfaces. The canonical stack remains bottom-center with debuffs above resources; observed old positions near center do not supersede v4. Native secure player harmful may require its own out-of-combat anchor translation, never payload inspection.
- `13/13 MEASURED` is a **measurement PASS**, **NOT** collision, scaling, native fallback, action hit region or whole-screen visual acceptance. No screenshot was attached. Special protected combat, vehicle, override, possess, form or petbattle remain ENVIRONMENTALLY DEFERRED.

## Prior failure and sequencing

P0192 R0 failed **pre-write** on stale P0191 patch-index text (`expected unique anchor, got 0`); user status showed no modified tracked paths. R1 repaired that delivery anchor and is the version verified/runtime-observed above. Do not erase that failure. Historical runtime/action/aura deferrals and intermittent post-loot ObjectiveTracker flash remain recorded.

## Next: P0194 bounded position/shape translation

Use the approved v4 coordinates as stable **planning envelopes**, determine per-surface actual anchor placement and required action reflows, and implement a narrow subset out of combat with fail-open behavior and no stock UI suppression. Start with independently owned action clusters and player reaction zones; preserve separate class/pet, native aura and native-access fallback. Target aura collision resolution and Quest/native dock spacing are explicit blockers for literal placement until modeled and visually checked. P0194 must be run in WoW and recorded before H.2 layout acceptance. H.3 styling remains future work.
