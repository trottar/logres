---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.4 — Implement the resolved City/resting zoom slice.**

P0105 is verified pushed at:
`6956008033b3f86c5b70d68c50486a4bed0ecdf1`.

Current pushed runtime:
`0.0.43-dev`.

G.3 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.4 status:
**IMPLEMENTATION PUSHED — RUNTIME PROOF PENDING.**

## Verified State

- Phase F is complete.
- G.1 is complete; the current DynamicCam `RPG` profile is captured durably.
- G.2 is complete; the primary MoveView camera capability passed out of combat
  and in genuine live combat.
- G.3 is complete on runtime `0.0.42-dev` with World transition/no-op,
  live-combat transition/no-op, fresh combat-exit World evaluation, interruption,
  Run All, DynamicCam coexistence, and clean addon-owned diagnostics proven.
- P0103 is durable at `4adf400a`; it records the G.3 runtime pass and opens G.4.
- P0104 is durable at `0b676083`; it resolves the City/resting camera contract
  from captured profile + source evidence and authorizes the narrow runtime slice.
- P0105 is durable at `69560080`, runtime `0.0.43-dev`; City/resting ownership is
  implemented and awaits targeted G.4 runtime proof.
- D-035 accepts NPC quest interaction as a future Logres-owned experience:
  bounded/paged source text, accept/decline, continue/complete, reward selection,
  and required quest-related gossip transitions, all capability-gated with
  Blizzard fail-open fallback until proven.
- G.4 source/profile audit resolves City as DynamicCam situation `001`:
  - activation is `IsResting()` / existing Logres `state.resting`;
  - priority `1`, while World (Combat) priority `50` uses live
    `UnitAffectingCombat("player")`;
  - live combat therefore wins over City when both predicates are true;
  - City is conditional zoom-in target `5`;
  - ordinary City entry uses `2.5` seconds;
  - profile zoom restoration remains `never`.
- DynamicCam ordinary situation changes use the **entering** situation's
  `timeToEnter`. City -> World and City -> Combat therefore use the destination
  context's accepted 2.5-second transition, not a remembered City zoom restore.
- City reactive-zoom values are effectively the same as the captured standard
  settings and do not require City-specific ownership in G.4.
- City `cameraZoomSpeed = 15.5` also matches the captured standard setting.
- City explicitly stores `cameraDistanceMaxZoomFactor = 1`; this remains a known
  deferred CVar parity item because G.4 does not broaden into camera-CVar
  ownership.
- DynamicCam City UI hide/fade at opacity `0.65` remains separate presentation
  policy and is not part of the G.4 camera implementation.
- DynamicCam's first-situation-after-login transition-time `0` behavior is a
  global initialization special case and is not introduced through the City
  slice, which would otherwise alter already-proven G.3 behavior.
- G.4 reuses the proven G.3 movement/coexistence/fail-open architecture; no new
  resting poller or broad hook is required.

## Next Action

Deploy pushed P0105 runtime `0.0.43-dev` and collect G.4 runtime evidence.

P0105 extends the existing production controller only:
- `city` is selected from `state.resting` after live combat and before World;
- City target is conditional zoom `5` on the existing 2.5-second MoveView path;
- diagnostics expose `context=city` and resting state;
- a dedicated G.4 static checker enforces live-combat-before-City ordering;
- instance/taxi/interaction exclusions and DynamicCam/probe gates are unchanged;
- City UI fade, reactive zoom, startup snapping, and camera CVar ownership remain
  excluded.

Runtime proof should cover automatic City entry, City >5 transition, City <=5
no-op, City exit fresh destination evaluation, Run All, and DynamicCam
coexistence. Do not manufacture live-combat + resting overlap solely for proof.

## Success Criteria

G.4 implementation completes only after:
- City context is selected automatically from the proven resting sensor;
- live combat remains higher priority than City;
- City >5 conditionally reaches target 5 through the accepted transition path;
- City <=5 does not zoom outward;
- City exit performs fresh destination evaluation with no remembered restore;
- existing G.3 fail-open/coexistence behavior remains intact;
- Run All remains clean;
- no Lua, taint, protected-action, or secret-value error is observed;
- unavailable overlap evidence is recorded as a deferral rather than guessed.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **G.2 World/Combat camera capability:** runtime + integration PASS.
- **G.3 production World/Combat ownership:** runtime + integration PASS on
  `0.0.42-dev`.
- **G.2/G.3 live combat classifier:** live `UnitAffectingCombat("player")`.
- **G.3 zoom semantics:** World 5 / Combat 15, conditional absolute targets,
  ordinary 2.5-second transition, restore never.
- **G.4 City source contract:** resting -> City 5, live combat precedence,
  ordinary 2.5-second entry, restore never.
- **City UI hide/fade:** presentation-policy question, not silently part of G.4.
- **City `cameraDistanceMaxZoomFactor`:** known deferred CVar parity item.
- **Temporary camera CVar fallback:** unproven and not accepted.
- **P0100 first resting observation:** expected environmental deferral, retained
  as historical evidence.
- **D-032/D-033/D-034 visual direction:** accepted future Phase H+ direction.
- **D-035 quest interaction ownership:** accepted future endpoint; existing Phase F
  additive runtime remains valid until replacement capabilities are proven.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`
- `docs/memory/evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`
- `docs/memory/investigations/G4_CITY_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0103_G3_RUNTIME_PASS_AND_G4_OPEN.md`
- `docs/memory/patches/P0104_G4_CITY_CAMERA_CONTRACT.md`
- `docs/memory/patches/P0105_G4_CITY_CAMERA_IMPLEMENTATION.md`
- `docs/memory/decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `docs/memory/architecture/QUESTING.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
