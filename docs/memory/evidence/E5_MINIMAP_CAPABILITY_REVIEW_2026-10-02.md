# E.5 Minimap Capability Review — 2026-10-02

Status: COMPLETE — NEGATIVE SUPPRESSION RESULT
Date: 2026-10-02
Baseline: P0076 / `ebb4bbc7084987e78b2fb9789d712a7e9d81e239`

## Inputs

Repository authority:
- D-029 requires a deliberate safe replacement/fallback before minimap
  suppression.
- Blizzard UI suppression architecture requires:
  - replacement;
  - runtime proof;
  - restoration definition;
  - understood security/control constraints.
- E.4 runtime + visual evidence proves only the accepted Logres compass and
  manual user-waypoint marker scope.

## Proven Logres replacement scope

Logres replaces:
- heading direction;
- manual user-waypoint direction;
- related world/Immersion presentation gating.

Logres does not replace:
- quest/objective navigation;
- route/path guidance;
- local POI/tracking information;
- minimap ping/click interaction;
- zoom controls;
- zone/territory context;
- other stock minimap utility not separately proven.

## Source review note

Classic FrameXML minimap source exposes multiple responsibilities beyond
heading:
- zone/territory text/context;
- minimap ping;
- zoom state and zoom controls;
- click interaction.

The exact tested Forever surface may differ in detail.

That uncertainty strengthens rather than weakens the fail-open result:
unproven stock responsibilities must not be removed.

## Runtime navigation limitation

E.3 runtime evidence found:
- super-tracked quest ID `436`: no usable next waypoint;
- super-tracked quest ID `237`: no usable next waypoint.

Therefore quest direction remains unsupported for production presentation.

## Capability-gate evaluation

| Gate | Result |
| --- | --- |
| Logres replacement exists for complete minimap surface | FAIL |
| Complete replacement runtime-proven | FAIL |
| Missing stock interactions deliberately replaced | FAIL |
| Safe full restoration contract needed for suppression | NOT REACHED |
| Suppression justified | NO |

## Negative result

No minimap suppression probe is performed.

Reason:
testing suppression after the replacement gate already fails would
unnecessarily remove known required Blizzard information/control surfaces and
would violate the project's fail-open method.

## Result

Accept:
**minimap remains Blizzard-owned / stock.**

Canonical decision:
`../decisions/D-030_MINIMAP_REMAINS_BLIZZARD_OWNED.md`

This closes E.5 and allows Phase E to close.
