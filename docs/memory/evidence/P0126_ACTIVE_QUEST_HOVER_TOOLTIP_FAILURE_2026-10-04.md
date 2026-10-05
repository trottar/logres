# P0126 Active Quest Hover Tooltip Failure — 2026-10-04

Status: **RUNTIME FAIL — NARROW TOOLTIP API SIGNATURE DEFECT**
Runtime: `0.0.55-dev`
Baseline Git HEAD: P0125 `72d2f040`

## Observed result

The core Active Quest presentation was otherwise live and coherent:
- `activequestcheck`: PASS;
- real super-tracked quest `237`;
- two objective rows;
- normal preview: PASS;
- complete preview: PASS;
- live restore: PASS;
- feature OFF / ON: observed;
- Immersion OFF / ON: observed;
- full `checkall`: all recorded checks PASS.

Hovering an Active Quest objective row produced a Lua UI error:

`Interface/AddOns/Logres/Quest/ActiveQuest.lua:541: bad argument #5 to 'SetText'`

The client-reported usage is:

`self:SetText(text [, color, alpha, wrap])`

The failing implementation passed legacy positional RGB plus a boolean:

`GameTooltip:SetText(label, 0.94, 0.84, 0.62, true)`

The same hover path also used positional RGB/wrap arguments with
`GameTooltip:AddLine`.

## Narrow cause

This is not a quest-data, secret-value, ownership, or objective-state failure.

The Forever client tooltip API signature does not accept the positional argument
shape used by the initial P0126 candidate.

## Corrective action

P0126 R1:
- changes `GameTooltip:SetText` to the minimal compatible text-only call;
- changes both hover `GameTooltip:AddLine` calls to text-only calls;
- adds a static contract that forbids the rejected positional RGB/wrap tooltip
  signature;
- bumps the corrective runtime to `0.0.56-dev` so the failed `0.0.55-dev`
  candidate remains distinguishable in evidence.

No quest source, focus selection, objective arithmetic, event ownership, Blizzard
surface, or interaction policy changes.

## Retest gate

Required:
1. deploy `0.0.56-dev`;
2. Active Quest Check -> PASS;
3. Active Quest Preview -> hover every preview row without Lua error;
4. Active Quest Complete -> hover completed rows without Lua error;
5. Active Quest Live -> hover each real row naturally available;
6. `checkall`;
7. any Lua/secret/taint/protected-action error is FAIL.

The initial `0.0.55-dev` hover result remains a real recorded failure even if R1
passes.
