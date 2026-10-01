# Cast Cue Color Regression — 2026-10-01

Status: OPEN VISUAL DEBT
Observed during: P0033 / C.2 runtime proof

## Observation

Player cast and channel cues still appear.

However, the previously distinct cue colors are no longer visibly present.

Expected prior behavior:
- player cast: warm amber;
- player channel: cool blue;
- interruption/failure: red snap.

## What remains working

- cast cue appears;
- channel cue appears;
- cast/channel lifecycle remains observable.

The report did not indicate event loss or stale cue behavior.

## Source state

Current `HUD.lua` still includes the original color assignments through
`styleCastCue`.

P0033 did not intentionally change those assignments.

Therefore no specific cause is established yet.

## Classification

Non-blocking visual regression.

Do not silently mark it fixed.

## Retry conditions

Investigate when:
- cast cue visuals are redesigned;
- Phase H visual consistency work begins;
- the color loss spreads to other textures;
- the lack of differentiation becomes functionally ambiguous.

Until then:
retain as known visual debt rather than introducing speculative changes.
