---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.4 — City camera ownership contract review.**

P0102 is verified pushed at:
`20ad55ba9be6d04fbd8d1eeeaa4e5e8bdb53addc`.

Current pushed runtime:
`0.0.42-dev`.

P0103 is docs/evidence only and does not change runtime code or version.

G.3 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.4 status:
**ACTIVE — CONTRACT REVIEW; NO RUNTIME CODE YET.**

## Verified State

- Phase F is complete.
- G.1 is complete; the current DynamicCam `RPG` profile is captured durably.
- G.2 is complete; the primary MoveView camera capability passed out of combat
  and in genuine live combat.
- G.3 is complete on runtime `0.0.42-dev`.
- P0100 remains the production World/Combat controller implementation at
  `31a2a7f6`.
- P0102 is durable at `20ad55ba`; it supplies the phase-tabbed developer panel
  used for the final G.3 validation and removes stale cross-feature checker
  coupling without changing camera semantics.
- Final G.3 runtime evidence proves:
  - World from zoom `15` conditionally moved toward target `5`, completing near
    `5.236` with `targetReached=true`;
  - World at zoom `1.243` produced `action=noop` and did not zoom outward;
  - live combat automatically selected `context=combat` and moved from about
    `5.244` toward target `15`, completing near `14.770`;
  - combat at zoom `15` produced `action=noop`, including a run with
    `lockdown=true`;
  - `PLAYER_REGEN_ENABLED` selected World and moved from about `14.770` toward
    target `5`, proving fresh World evaluation rather than remembered restore;
  - disabling during an active World transition recorded `stop=module-disabled`;
    re-enable started a fresh transition from the then-current zoom;
  - Run All on `0.0.42-dev` completed and included Camera World/Combat Check;
  - with DynamicCam loaded, Logres reported `context=none`, `owns=false`,
    `transition=false`, and `blocked=dynamiccam-loaded`;
  - addon-owned diagnostics retained `failures=0`, `secret=false`, and
    `error=nil` throughout the accepted final sequence.
- No Lua, taint, protected-action, or secret-value failure was reported during
  the accepted G.3 sequence.
- P0096 remains authoritative for the live/cached combat distinction: production
  camera selection uses live `UnitAffectingCombat("player")`, not cached
  `State.combat`.
- G.3 profile semantics remain durable:
  - World conditionally targets zoom `5` only when farther than 5;
  - World (Combat) conditionally targets zoom `15` only when closer than 15;
  - ordinary transition duration is `2.5` seconds;
  - zoom restore is `never`.
- DynamicCam and Logres never intentionally own camera movement simultaneously.
- The first P0100 resting observation remains valid negative/environmental
  evidence and is not erased by the later pass.
- P0101 D-034 Selective Hybrid E / visual-component direction remains parallel
  future Phase H+ work and does not change camera acceptance.

## Next Action

Record P0103, then resolve the G.4 City camera contract from the already-captured
profile and current DynamicCam semantics before writing runtime code.

The next narrow question is City/resting ownership:
- use the already-proven resting predicate as the candidate City context;
- preserve World (Combat) priority over City while live combat is true;
- verify the exact City transition/zoom semantics from the captured profile;
- treat DynamicCam's City UI-hide/fade behavior as a separate presentation-policy
  question rather than silently importing it into camera ownership;
- keep zoom restoration `never` unless canonical profile/source evidence says
  otherwise.

Do not broaden G.4 into Taxi, NPC Interaction, fishing, gathering, hearth,
rotation, shoulder offsets, or global camera CVar ownership.

## Success Criteria

G.4 contract review completes only when repository evidence defines:
- exact City activation and precedence relative to live combat;
- exact conditional zoom target and transition semantics;
- exit behavior without invented restoration;
- explicit scope for or exclusion of DynamicCam City UI hide/fade behavior;
- fail-open/coexistence behavior consistent with the proven G.3 ownership model;
- the smallest runtime slice needed for a targeted City proof.

No G.4 runtime implementation is authorized until that contract is explicit.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **G.2 World/Combat camera capability:** runtime + integration PASS.
- **G.3 production World/Combat ownership:** runtime + integration PASS on
  `0.0.42-dev`.
- **G.2/G.3 live combat classifier:** live `UnitAffectingCombat("player")`.
- **G.3 zoom semantics:** World 5 / Combat 15, conditional absolute targets,
  ordinary 2.5-second transition, restore never.
- **Temporary camera CVar fallback:** unproven and not accepted.
- **P0100 first resting observation:** expected environmental deferral, retained
  as historical evidence.
- **D-032/D-033/D-034 visual direction:** accepted future Phase H+ direction.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/evidence/G3_P0100_RESTING_DEFERRAL_PANEL_OVERFLOW_2026-10-02.md`
- `docs/memory/evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`
- `docs/memory/investigations/G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`
- `docs/memory/investigations/G4_CITY_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/architecture/DEV_PANEL.md`
- `docs/memory/patches/P0100_G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`
- `docs/memory/patches/P0102_PHASE_TABBED_DEV_PANEL.md`
- `docs/memory/patches/P0103_G3_RUNTIME_PASS_AND_G4_OPEN.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
