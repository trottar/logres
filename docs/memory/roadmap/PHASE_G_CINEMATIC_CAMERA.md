# Phase G — Cinematic Camera

Status: ACTIVE — G.2
Opened: 2026-10-02

## Product Objective

Translate the user's established contextual DynamicCam behavior into Logres.

## G.1 — Current DynamicCam profile capture

**COMPLETE — PASS.**

## G.2 — World/Combat camera zoom capability

**ACTIVE — PRIMARY PATH OOC PASS; COMBAT CLASSIFICATION RETEST PENDING.**

Correct profile behavior:
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transitions 2.5 seconds;
- zoom restore never.

DynamicCam situation 006 uses live:
`UnitAffectingCombat("player")`.

P0095 proved the primary camera movement/restoration path twice but recorded
combat from cached Logres state, so no in-combat classification is accepted.

P0096 separates:
- live DynamicCam-equivalent combat;
- live lockdown;
- cached Logres combat.

One live-combat probe remains before G.2 can close.

## Later Phase G Work

Production World/Combat camera ownership follows only after G.2 runtime proof.
More complex City/NPC/taxi/teleport/fishing/gathering/global settings remain
later slices.
