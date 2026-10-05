# P0126 — Active Quest One-Focus Presentation

Date: 2026-10-04
Result: **PREPARED — RUNTIME + VISUAL PROOF PENDING**
Baseline: `72d2f040d9a4b5a5a5fa125e22da58884c07cbeb`
Runtime: `0.0.54-dev -> 0.0.58-dev`

Initial candidate:
`0.0.55-dev` — core runtime/preview PASS; hover inspection FAIL.

R1:
`0.0.56-dev` — tooltip correction PASS; runtime/hover proof accepted.

## Purpose

Implement the approved D-032/D-039 optional Active Quest presentation using
already-proven passive quest/objective data.

Canonical source audit:
`../evidence/P0126_ACTIVE_QUEST_SOURCE_AUDIT_2026-10-04.md`.

## Product behavior

P0126 adds one upper-right current-focus panel:
- super-tracked quest first, selected quest fallback;
- quest title;
- restrained qualitative progress phrase derived only from safe state;
- one progress row per available objective, up to the producer's existing
  eight-objective production limit;
- shared D-039 percentage-bar language for measurable objective progress;
- exact source objective wording and counts only on deliberate hover;
- quiet complete/ready-for-turn-in treatment;
- independent persisted `activeQuestEnabled` preference;
- deterministic normal and complete preview modes plus Live restoration.

The panel is additive. It does not replace or suppress the Blizzard quest log or
Objective Tracker.

## Visual media

Production derivatives:
- `Media/Quest/active_quest_panel.tga`;
- `Media/Quest/active_quest_divider.tga`;
- `Media/Quest/active_quest_glyph.tga`.

`Theme.lua` owns paths, geometry, and colors.

Canonical art reference:
`docs/design/approved/10_active_quest_component.png`.

## Runtime ownership boundary

P0126 does not:
- mutate quest watch/selection/super-tracking;
- add quest waypoint or Compass inputs;
- own accept/decline/continue/complete/reward controls;
- suppress stock quest-management surfaces;
- poll with OnUpdate or recurring timers.

## Preference

Database schema advances `2 -> 3`.

New durable preference:
`activeQuestEnabled: boolean = true`.

Existing schema-2 users receive the default only when the setting is absent.

## Validation

Use the Phase-F developer panel:
1. Active Quest Check;
2. Active Quest Preview;
3. Active Quest Complete;
4. Active Quest Live;
5. Active Quest OFF;
6. Active Quest ON;
7. if a real selected/super-tracked quest is naturally available, confirm Live
   shows that one focus and hover exposes exact source objective detail;
8. confirm the Blizzard quest log / Objective Tracker remain available;
9. Immersion OFF hides the panel; ON restores it;
10. any Lua, secret-value, taint, protected-action, or stale-quest error is FAIL.

No quest travel or contrived completion is required because deterministic preview
states cover normal and complete presentation.

## R1 hover-tooltip correction

The initial `0.0.55-dev` candidate reached real Active Quest runtime successfully:
live quest `237` rendered, deterministic normal/complete previews passed, feature
and immersion toggles worked, and `checkall` recorded all checks PASS.

Hovering an objective row then produced a real Lua failure at
`ActiveQuest.lua:541` because the client rejected the legacy positional RGB/wrap
argument shape passed to `GameTooltip:SetText`. The same hover path used the same
style of positional arguments for `GameTooltip:AddLine`.

R1 changes only tooltip presentation calls to the minimal text-only signature,
adds a static regression contract, records the failure as durable evidence, and
bumps the corrective runtime to `0.0.56-dev`.

Canonical failure evidence:
`../evidence/P0126_ACTIVE_QUEST_HOVER_TOOLTIP_FAILURE_2026-10-04.md`.

No quest source, focus policy, progress arithmetic, event, ownership, or Blizzard
surface behavior changes.

## R2 bar-only objective refinement

R1 runtime `0.0.56-dev` passed the Active Quest check, normal/complete/live
previews, integrated checks, and deliberate row hover without repeating the
tooltip error. The user approved the component as looking and working well.

One minor visual refinement was requested:
remove persistent percentage text from objective progress rows.

R2:
- keeps the progress bars and their fill amount;
- removes the right-side `%` label widget and its reserved width;
- keeps exact objective wording/counts on deliberate hover;
- leaves every quest-data, source-selection, completion, preference, event,
  Blizzard fallback, and ownership boundary unchanged;
- advances the candidate runtime to `0.0.57-dev`.

Canonical R1 proof:
`../evidence/P0126_ACTIVE_QUEST_R1_RUNTIME_VISUAL_PASS_2026-10-04.md`.

## R3 objective-label refinement

R2 removed persistent percentage labels and the bar-only result was visually
preferred.

The user then requested enough persistent wording to understand what each quest
objective actually asks, while keeping exact mechanics out of the ambient UI.

R3:
- renders `QuestObjectiveProgress:NormalizeObjectiveLabel(row)` above each bar;
- therefore reuses the existing stable count-prefix removal instead of inventing
  or parsing new quest instructions;
- keeps persistent `N/M` and `%` values absent;
- keeps exact wording/counts on deliberate hover;
- increases row height/spacing so label + bar remains deliberate rather than
  cramped;
- uses realistic deterministic preview objective labels for visual calibration;
- advances the candidate runtime to `0.0.58-dev`.

Canonical R2 review:
`../evidence/P0126_ACTIVE_QUEST_R2_VISUAL_REVIEW_2026-10-04.md`.

No source, focus-policy, quest-control, navigation, Blizzard fallback, or Camera
ownership change.
