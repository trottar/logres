---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.5 — Taxi camera ownership contract review.**

P0105 is verified pushed at:
`6956008033b3f86c5b70d68c50486a4bed0ecdf1`.

Current pushed runtime:
`0.0.43-dev`.

P0106 is verified pushed at:
`b2fce832ef689ebf70732bc8a9f1c07fa11faa35`.

G.4 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5 status:
**ACTIVE — CONTRACT REVIEW; NO RUNTIME CODE YET.**

## Verified State

- Phase F is complete.
- G.1 is complete; the current DynamicCam `RPG` profile is captured durably.
- G.2 is complete; the primary MoveView camera capability passed out of combat
  and in genuine live combat.
- G.3 is complete on runtime `0.0.42-dev` with World transition/no-op,
  live-combat transition/no-op, fresh combat-exit World evaluation, interruption,
  Run All, DynamicCam coexistence, and clean addon-owned diagnostics proven.
- P0104 at `0b676083` resolved the City/resting contract.
- P0105 at `69560080`, runtime `0.0.43-dev`, implements City/resting ownership.
- G.4 runtime acceptance on P0105 proves:
  - real resting state selects `context=city` automatically;
  - a clean targeted City transition moved from about `13.090` toward target `5`
    and completed near `5.178` with `targetReached=true`;
  - City at zoom `<=5` is a no-op and does not zoom outward;
  - leaving City fresh-evaluates World rather than restoring a remembered
    pre-City zoom;
  - Run All completes with camera diagnostics clean;
  - DynamicCam loaded blocks/relinquishes Logres ownership;
  - accepted diagnostics retained `failures=0`, `secret=false`, `error=nil`.
- The earlier City `18 -> 0`, `targetReached=false` observation is preserved as
  ambiguous environmental evidence; it was not accepted as PASS and was followed
  by the clean target proof above.
- Natural live-combat + resting overlap was unavailable and remains an
  environmental deferral. Static contract coverage enforces live combat before
  City, and the live-combat path is already runtime-proven.
- P0106 at `b2fce832` is docs-only and establishes D-035 NPC quest interaction as
  a future Logres-owned experience with Blizzard fail-open fallback until each
  replacement is capability-proven.
- City UI fade, City `cameraDistanceMaxZoomFactor`, reactive zoom, startup instant
  transition parity, rotation, and later contexts remain separately gated.

## Next Action

Resolve G.5 Taxi camera ownership from captured profile + DynamicCam source before
writing runtime code.

Known starting facts from the captured `RPG` profile:
- Taxi situation `160`;
- on-taxi activation;
- priority `1000`;
- enter/exit `5` seconds;
- conditional-out absolute target `50`;
- rotation speed `-20`;
- UI hide/fade stored;
- profile-wide zoom restore `never`.

The contract review must determine:
- exact Taxi precedence relative to live combat, City, World, and interaction;
- ordinary entry/destination transition semantics;
- whether target 50 is usable without taking unproven camera-distance CVar
  ownership;
- whether the first runtime slice is zoom-only or must separately capability-gate
  rotation;
- explicit exclusion or later treatment of Taxi UI hide/fade;
- the smallest safe runtime proof.

The existing Taxi fail-open exclusion remains in production until that contract is
explicit.

## Success Criteria

G.5 contract review completes only when repository evidence defines:
- exact Taxi activation and precedence;
- exact conditional zoom target and transition semantics;
- exit behavior under restore `never`;
- target-50 capability/CVar boundary;
- rotation scope;
- UI-hide/fade scope;
- fail-open/coexistence behavior;
- the smallest runtime slice and validation plan.

No G.5 runtime implementation is authorized until those points are explicit.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **G.2 World/Combat camera capability:** runtime + integration PASS.
- **G.3 production World/Combat ownership:** runtime + integration PASS.
- **G.4 City camera ownership:** runtime + integration PASS on `0.0.43-dev`.
- **G.2/G.3 live combat classifier:** live `UnitAffectingCombat("player")`.
- **World/City zoom semantics:** conditional-in target 5.
- **Combat zoom semantics:** conditional-out target 15.
- **Accepted ordinary World/City/Combat transition:** 2.5 seconds.
- **Zoom restoration:** `never`.
- **City UI hide/fade:** presentation-policy question, not silently camera-owned.
- **City `cameraDistanceMaxZoomFactor`:** known deferred CVar parity item.
- **Temporary camera CVar fallback:** unproven and not accepted.
- **D-032/D-033/D-034 visual direction:** accepted future Phase H+ direction.
- **D-035 quest interaction ownership:** accepted future endpoint; existing Phase F
  additive runtime remains valid until replacement capabilities are proven.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`
- `docs/memory/evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`
- `docs/memory/evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`
- `docs/memory/investigations/G4_CITY_CAMERA_OWNERSHIP.md`
- `docs/memory/investigations/G5_TAXI_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0105_G4_CITY_CAMERA_IMPLEMENTATION.md`
- `docs/memory/patches/P0106_QUEST_INTERACTION_OWNERSHIP.md`
- `docs/memory/patches/P0107_CLOSE_G4_OPEN_G5_TAXI.md`
- `docs/memory/decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `docs/memory/architecture/QUESTING.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
