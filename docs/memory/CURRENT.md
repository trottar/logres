---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.5 — Allies and Pets.**

P0027 prepares compact ally/pet condition rows for:
- `pet`;
- `party1`–`party4`.

Each existing unit shows only:
- name;
- health percentage.

## Verified State

- Phase A complete.
- B.1 health vignette complete.
- B.2 primary resource percentage complete.
- B.3 target presentation complete.
- B.4 cast confirmation complete with target-caster true-path environmental deferral.
- P0026 B.4 closure pushed at `8a89a35`.
- current runtime baseline before P0027: `0.0.11-dev`.
- group/pet source review supports `GROUP_ROSTER_UPDATE`, `UNIT_PET`, unit name, and per-unit health update signals.
- P0027 static checks pass; runtime proof pending.

## Next Action

Install/review/commit/push P0027.

Because runtime code changes, deploy explicitly:

```bash
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then:

```text
/reload
/logres status
/logres statecheck
/logres preferencecheck
/logres lifecyclecheck
/logres hudcheck
```

Confirm version:
`0.0.12-dev`

B.5 runtime:
1. absent pet/party units must not leave empty rows;
2. if a pet exists, verify its name + health percentage and health updates;
3. if party members are available, verify visible rows and health updates;
4. join/leave changes should add/remove rows if practical;
5. immersion off/on should hide/restore available rows;
6. report any Lua/secret-value error.

If pet or party true paths are unavailable, report that directly; environmental deferral is allowed.

## Success Criteria

B.5 succeeds when:
- five candidate slots exist structurally;
- only existing units are shown;
- available pet/party name + health paths work;
- available health/roster updates work;
- immersion root behavior remains correct;
- unavailable pet/party paths are explicitly deferred;
- no conventional party frame is introduced;
- no secret-value/Lua errors occur.

## Do Not Reopen Without New Evidence

- **B.1:** complete.
- **B.2:** complete.
- **B.3:** complete.
- **B.4:** complete with target-caster deferral.
- **Ally/pet default:** sparse name + health percentage.
- **Initial units:** pet + party1–party4 only.
- **Raid/healer/click-cast UI:** outside initial B.5.
- **Deployment:** full deploy block required.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-015_ALLY_AND_PET_PRESENTATION_CONTRACT.md`
- `docs/memory/investigations/B5_ALLIES_AND_PETS.md`
- `docs/memory/architecture/HUD.md`
- `Logres/HUD/HUD.lua`
- `tools/check_hud_contract.py`
