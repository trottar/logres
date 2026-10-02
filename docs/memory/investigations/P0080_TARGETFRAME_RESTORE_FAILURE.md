# P0080 — TargetFrame Restoration Failure

Status: CLOSED — ROOT CAUSE FIXED; P0084 RUNTIME PASS
Opened: 2026-10-02
Closed: 2026-10-02

## History

P0078 and P0080 showed the same TargetFrame restoration state shape.

P0081 added TargetFrame/controller reason/error fields.

P0083 reproduced the failure and captured the exact native error:

`SetIgnoreParentAlpha` rejected a secret-capable captured restoration token
outside untainted execution.

## Root cause

P0057 correctly stopped inspecting the secret-capable
`IsIgnoringParentAlpha()` value in Lua, but the native setter itself rejected
that secret token when the addon later passed it to `SetIgnoreParentAlpha`.

Thus opaque transport alone was insufficient for this Forever API path.

## P0084 correction

P0084 removed IgnoreParentAlpha mutation entirely.

Preserved without mutation:
- Auras;
- RaidTargetIcon;
- QuestIcon;
- PingIconFrame.

Individually alpha-suppressed/restored:
- HighLevelTexture;
- LeaderIcon;
- GuideIcon;
- BossIcon;
- PvpIcon;
- PrestigePortrait;
- PrestigeBadge;
- PetBattleIcon;
- NumericalThreat.

The contextual parent is no longer alpha-zeroed.

## P0084 runtime proof

Runtime:
`0.0.33-dev`.

Observed:
- Target Frame Check PASS with
  `contextualSuppressed=9`, `preserved=4`;
- two standalone Restoration Checks PASS;
- three consecutive Run All executions PASS;
- no recurrence of the previous secret setter error.

No retry, polling, periodic reassertion, or broad Blizzard hook was added.

## Result

**CLOSED — FIX RUNTIME-PROVEN.**

Historical P0078/P0080 failures remain valid historical evidence.

The separate TargetFrame reappearance issue remains independently tracked and
is not closed by this result.
