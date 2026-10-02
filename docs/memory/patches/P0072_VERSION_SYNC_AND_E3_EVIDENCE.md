# P0072 — Version Sync / Record E.3 Evidence

Date: 2026-10-01
Result: PREPARED

## Baseline

P0071 verified pushed:
`7976d34ede66336cf6e564117800b1ec7277c793`

## Purpose

Correct the P0071 TOC/Bootstrap version mismatch and preserve the captured E.3
runtime evidence.

## Changes

- `Logres.VERSION`: `0.0.28-dev -> 0.0.29-dev`;
- strengthen `check_addon_structure.py` to require TOC/Bootstrap equality;
- record user-waypoint retrieval/conversion/event proof;
- record quest IDs 436/237 next-waypoint negative evidence;
- narrow E.3 remaining work to bearing-axis orientation proof.

## Runtime

No navigation behavior changes.

A redeploy is required because `Bootstrap.lua` changes.

## Next

Resolve only bearing-axis orientation.

Do not repeat the already-proven waypoint/event matrix.
