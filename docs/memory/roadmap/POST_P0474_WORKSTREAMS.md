# Post-P0474 workstreams — stabilization, options, feedback, tooltips

**Status:** 2026-11-17 user intake, planning only. GitHub `main` P0474
`e476b90` verified. **No runtime authorization or client PASS** comes from
this record. `docs/memory/investigations/ISSUE_LEDGER.md` remains the sole
stable-ID authority for bugs; this file is the ordered feature/backlog map.

## Observed checkpoint and preserved failures

- The user reported P0474 quest cycling **"Works great"** after the P0473
  failure and P0474 correction. Record this as **scoped user-observed PASS**
  for the general corrected quest-cycle experience, without claiming separate
  proof for every chevron, binding UI, wrap, compass, single-quest, combat,
  preview or restoration variant. L-037 remains **PARTIAL** until recorded
  tests establish those scopes. P0473 Forever #16018 FAIL is still evidence.
- The earlier gameplay bug list is already represented by L-021–L-032 and
  later reports through L-053. Existing OPEN/PARTIAL/BLOCKED statuses and
  negative results must survive this intake; do not create duplicate IDs.
- Preserve accepted world enemy health, aura/50-50 visuals, immersive naming,
  default Chat SHOW, quest focus, native fallback, and protected-state rules.

## Workstream 1 — Bugs and stabilization (first)

Triage the existing issue ledger by impact and evidence rather than patch
order. Gameplay and fallback risks lead: L-001/L-002/L-005 native NPC and
quest handoffs, L-007/L-008/L-011 nameplate/pet ownership, L-028 target aura,
L-033 trainer purchase, L-034 unsolicited quest window, L-048 native objective
tracker. Visual/functionality items include L-022/L-025/L-027/L-030,
L-035/L-038/L-039/L-041/L-043/L-051–L-053. This is prioritization, not a
claim that any issue has reappeared or was solved. Keep every historical
negative result. Add new player reports to an existing L-ID when the symptom
matches; otherwise allocate the next ID with evidence/repro/owner/status.

**Next engineering action after this checkpoint is pushed:** an issue-ledger
triage pass grouping confirmed client FAIL, intermittent/open, partial,
and deferred/unreproduced states; identify one evidence-backed, bounded
stabilization batch without forcing gameplay/travel to recreate old bugs.

## Workstream 2 — Native AddOns options and independent ownership

User requests a real options AddOns menu for action-bar, nameplate/status,
and related Logres/Blizzard choices. Current `Logres/Settings/Panel.lua`
exposes only Immersion, Active Quest, and Screen-space Enemy Frame; the
runtime `Preferences.lua` also knows World Enemy. These are **not** the
D-048 independent NAV/ACT/NPC/STATUS/CAM selectors. L-014 remains DEFERRED,
L-018 tracks settings accessibility, and L-009 remains separate live action
editing. Do not relabel the global `immersionEnabled` as five functional
switches or expose a switch that cannot safely restore native controls.

Sequence: (a) inventory requested/effective ownership, saved schema and
Blizzard fallback per surface; (b) inert native Settings/AddOns shell and
accessible descriptions with real supported preferences only; (c) explicit
save migration and pure policy/32-configuration tests; (d) capability-gated
independent NAV/ACT/NPC/STATUS/CAM routing one domain at a time, starting
low-risk, with combat defer/restoration and native controls preserved;
(e) in-client tests across ON/OFF, reload, combat and unsupported variants.
No hidden dependence on Immersion ON; no untested protected action toggles.

## Workstream 3 — Ephemeral presentation feedback

Proposed shared visual family for **loot acquired**, **profession skill
increase**, existing XP, and quest-objective progress, using Logres text,
icons and a brief hold (initial design target ~1 second) then fade. Consider
batching simultaneous loot/skill events and keeping overlays behind menus.
This is **not** auto-loot, inventory interaction, skill purchasing, or
replacement of Blizzard-owned transaction controls. Source event identity,
capabilities and secret-safe handling need a client/API investigation before
runtime hooks. Keep existing XP/objective presentations intact. L-027 tracks
Blizzard duplicate quest/XP/recipe toasts: do not suppress them until exact
owners are verified and a safe Logres replacement/fallback is accepted.
Profession skill splash is a new design proposal, not evidence L-033 trainer
purchase is fixed.

## Workstream 4 — Tooltip presentation

Design consistent Logres tooltip presentation for loot, inventory, quest
rewards, profession skills and spells. Preserve native item identities,
stats, equipped comparison, modifier handling and any unimplemented tooltip
content. L-038 already tracks missing reward stats/Shift comparison, with
prior runtime verification still required. Prefer an owned presentation
adapter or selective cosmetic skin over replacing protected/native tooltip
interaction, and fail open where metadata is unavailable or secret.

## Stage gates and non-goals

For each workstream: narrow design/owner map -> fixture/previews -> explicit
user acceptance where visual -> guarded live adapter -> scoped Forever test
-> durable evidence/issue status. No broad Blizzard surface suppression,
no source-secret inspection, no forced travel to manufacture proof, no lost
native click surfaces, and no changes to camera without D-047 evidence.
The roadmap is a prioritized queue, not a simultaneous implementation or a
public release commitment. L-019 licensing still blocks public release.
