# P0164 — Blizzard Surface Ownership / Suppression Audit

Date: 2026-10-07
Baseline: `23c2b964ef4fcad385cf9d1bb4c5dc952d46bacb`
Phase: H.1
Classification: **DOCS / EVIDENCE AUDIT — NO RUNTIME MUTATION**

## Question

Which Blizzard surfaces may Logres suppress now, which must remain stock, and what is the first new suppression slice justified by existing replacement/restoration evidence?

The gate is D-017: replacement capability, interaction coverage where applicable, restoration/fail-open behavior, and runtime proof must exist before a stock surface is removed.

## External hiding-addon guidance

The user explicitly requested guidance from addons such as **Hide Anything**.

The public Hide Anything - Forever product is useful as a broad UI-hider reference: it exposes many frame/CVar hide controls and describes safe hooks/combat protection. Its public product page was used only as behavioral guidance; no source implementation was treated as authority without an inspectable source tree.

For source-level mechanics, P0164 audited public **MoveAny** source at commit:
`d4kir92/MoveAny@a313a5cb05c83ea5dd35e5366e6de209ff6505a4`.

Relevant generic patterns in that source:
- a hidden parent is available for surfaces where reparenting is safe;
- original parent/shown state is captured before hidden-parent mutation;
- alternative hide paths use alpha `0` together with mouse suppression;
- protected-frame mutation is gated by `InCombatLockdown()` / frame protection;
- `hooksecurefunc` may reassert hidden state when Blizzard/another addon changes presentation;
- restoration explicitly removes hidden ownership and restores the prior parent/shown state.

### Logres adaptation rule

Borrow the mechanics, not the broad ownership model.

Logres will:
- snapshot before mutation;
- choose the least invasive technique per owned surface;
- remove invisible click regions whenever presentation is suppressed;
- defer protected mutations when required;
- restore stock state before removing replacement interaction;
- fail open to usable Blizzard UI.

Logres will **not** adopt generic blanket hidden-parent ownership, global CreateFrame interception, timer retry loops, global Show/SetShown forcing, or Lock-Parent-style reassertion merely because a generic UI-hider supports it. Event/source-specific reconciliation remains acceptable only when the affected Blizzard lifecycle is established. The existing unreproduced TargetFrame reappearance does not justify new periodic/broad forcing.

## Ownership matrix

| Blizzard surface | Classification | Logres replacement / proof | Restoration / boundary |
| --- | --- | --- | --- |
| Passive ChatFrame presentation, tabs, safe social/chat auxiliary controls | **SUPPRESSIBLE NOW — EXISTING** | Quiet Mode P0050 runtime PASS; intentional outbound edit-box path preserved | Runtime alpha/mouse snapshots; exact restore; Blizzard chat updates reconciled by known events/hook |
| PlayerFrame conventional shell/main | **SUPPRESSIBLE NOW — EXISTING** | P0053 Player selective replacement runtime PASS; Logres secure player interaction | Selective alpha/mouse snapshot/restore; class/resource/PetFrame children remain stock |
| TargetFrame conventional shell/main + explicitly disallowed metadata | **SUPPRESSIBLE NOW — EXISTING** | P0057 target selective runtime PASS; secure Logres target interaction | Exact selective restoration; auras/raid marker/quest icon/ping preserved; ToT/Focus/boss excluded |
| MultiBarBottomLeft / Bar 2 and MultiBarBottomRight / Bar 3 presentation + mouse path | **SUPPRESSIBLE NOW — EXISTING / CONDITIONAL** | P0044 runtime PASS; matching Secondary/Utility secure routing + feedback | Exact bar/button mouse/alpha + routing restore. Stock restore remains the practical live-edit fallback because Logres edit/reorder is incomplete |
| MainActionBar / OverrideActionBar / Bars 4–5 | **KEEP STOCK** | Primary/special paging does not replace all bonus/vehicle/override/temp-shapeshift responsibilities | D-023/D-044 prohibit broad suppression |
| Vehicle / possess / override / extra-action / stance-special controls | **KEEP STOCK** | No complete Logres secure replacement | Dedicated capability required |
| PetActionBar | **KEEP STOCK** | P0152 proves bounded pet execution/state, but not edit/reorder/binding/full feedback/restoration ownership | D-044 keeps stock PetActionBar available |
| PetFrame | **KEEP STOCK** | No complete secure pet-unit replacement | Separate from pet action ownership |
| Player class resources, RuneFrame, TotemFrame, alternate power | **KEEP STOCK** | Partial/read-only sources do not constitute replacement | D-026/D-044 preserve these children/surfaces |
| Party / CompactPartyFrame | **KEEP STOCK** | Current Logres ally rows do not replace secure unit interaction + group/aura/pet context | D-026 strict gate remains false |
| Blizzard minimap and utilities | **KEEP STOCK** | Compass/manual waypoint are partial navigation replacement only | D-030/D-043 strict gate remains false |
| Player global aura/status completeness | **KEEP STOCK** | P0137 replaces only bounded `HELPFUL|PLAYER` passive presentation | Harmful/private/group categories incomplete |
| Target auras/status | **KEEP STOCK** | No complete target-status replacement; world-target anchor still deferred | Explicitly preserved by D-027/D-041 |
| Target-of-target / Focus / boss frames | **KEEP STOCK** | No deliberate replacement | Explicit exclusions |
| Nameplates | **KEEP STOCK** | P0140 positive accessible target attachment not observed; Logres screen-space target remains fallback | D-042 forbids nameplate mutation/suppression |
| Objective Tracker / full quest log/watch | **KEEP STOCK** | Active Quest is intentionally one-focus, not full tracker/log ownership | D-031/D-035 separate capability domain |
| Persistent Blizzard XP presentation | **KEEP STOCK** | Logres XP is contextual pulse, not permanent/full replacement | D-031 says suppression separately gated |
| Quest offer narrative | **COEXIST / REPLACEMENT PROVEN** | P0130 narrative paging runtime+visual PASS | Whole QuestFrame still required for unsupported controls/states |
| Quest offer Accept / Decline controls | **DEFERRED — NEXT NARROW SUPPRESSION SLICE** | P0131 capability PASS + P0132 production controls + P0133 runtime/visual PASS | Exact stock-control frame/lifecycle + suppression/restoration still needs source/runtime proof |
| Quest progress/Continue, completion/Complete, rewards, reward claim, quest-gossip transitions | **KEEP STOCK / DEFERRED** | Not fully production-owned | Preserve Blizzard controls until each separate gate passes |

## Existing suppression versus new Phase H work

P0164 does not reopen already-proven Phase C/D suppression. Quiet Mode, Player shell, Target selective suppression, and conditional Bar 2–3 replacement are already production capabilities for their tested scopes.

The fastest safe Phase H path is therefore not another generic hide framework. It is to leave those proven modules in place and advance one currently additive surface at a time.

## Selected next slice — P0165

The best narrow next candidate is **Blizzard quest-offer Accept/Decline controls only**.

Why this slice:
- Logres offer narrative/paging is production-proven;
- explicit Accept and Decline mutation paths are runtime-proven;
- production Logres controls and final-page gating are runtime/visual-proven;
- the remaining gap is specifically stock-control suppression/restoration, not core quest-offer capability.

P0165 must first resolve the exact Forever frame/control lifecycle. The implementation should then suppress only those stock offer buttons while Logres is ready for the exact offer state. It must not hide the QuestFrame root or infer ownership of progress, completion, rewards, or gossip.

## Closed / deferred conclusions

- Generic Hide Anything / MoveAny techniques do not authorize blanket suppression in Logres.
- No new runtime suppression is introduced by P0164.
- No additional broad audit is needed before P0165 unless current source evidence contradicts this matrix.
- The one-off TargetFrame reappearance remains OPEN / INTERMITTENT / UNREPRODUCED and does not justify polling or global reassertion.
