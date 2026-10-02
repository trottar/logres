# F.3 — Contextual XP Pulse

Status: ACTIVE — P0080 IMPLEMENTATION PREPARED
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

F.2 evidence:
`../evidence/F2_P0078_QUEST_XP_RUNTIME_EVIDENCE_2026-10-02.md`

## Product contract

Show XP as a brief contextual confirmation, not a permanent conventional bar.

Presentation:
- centered below the existing core HUD;
- `+N XP · progress%`;
- visible for approximately two seconds;
- no persistent XP frame after the pulse.

## Input contract

Use:
- `UnitXP("player")`;
- `UnitXPMax("player")`;
- `PLAYER_XP_UPDATE`.

Support events:
- `PLAYER_LEVEL_UP`;
- `PLAYER_ENTERING_WORLD`.

Every XP sample is secret-checked before:
- type inspection;
- comparison;
- arithmetic;
- formatting.

## Delta contract

On module enable / world entry:
- establish baseline only.

On positive XP update with unchanged max-XP range:
- compute delta;
- present pulse;
- update baseline.

On level/range change or non-positive delta:
- rebaseline;
- do not fabricate an XP gain.

On absent, secret, invalid, failed, or level-cap/no-XP input:
- clear baseline/pulse;
- fail open.

## Immersion contract

Immersion ON:
- positive XP gains may present.

Immersion OFF:
- no pulse presentation;
- XP events may still advance the safe baseline so later re-enable does not
  display stale accumulated XP.

## Stock ownership

P0080 does not suppress or mutate:
- Blizzard XP bars;
- quest log;
- objective tracker;
- minimap;
- quest interaction UI.

This slice is additive only.

## Diagnostics

Developer panel:
- **XP Check** — addon-owned structural/runtime state;
- **XP Preview** — synthetic visual-only preview.

Run All includes XP Check.

## Runtime proof

Required:
1. XP Check PASS after reload;
2. XP Preview visual acceptance;
3. one ordinary real XP gain produces a pulse;
4. pulse auto-hides;
5. post-gain XP Check shows XP event and pulse count;
6. Immersion OFF suppresses XP Preview;
7. Immersion ON restores XP Preview;
8. Run All PASS;
9. no Lua/taint/secret-value errors;
10. stock XP/quest UI unchanged.

## Exit

Close F.3 only after runtime + visual proof.

Then choose the next Phase F slice from remaining proven capabilities rather
than assuming objective or quest-destination support.
