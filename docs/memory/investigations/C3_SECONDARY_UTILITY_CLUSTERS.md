# C.3 — Secondary / Utility Clusters

Status: ACTIVE
Opened: 2026-10-01

## Goal

Extend the proven secure action architecture into Logres' broader action
constellation without prematurely suppressing Blizzard's stock bars.

## Product model

The action constellation has:
- Primary Cluster;
- Secondary/Tertiary Cluster;
- Utility Cluster(s).

Primary remains the most legible.

Secondary/tertiary:
- nearby;
- visually related;
- subdued outside combat;
- stronger in PvP;
- more available in combat.

Utility:
- peripheral;
- normally faded or absent;
- intentionally revealed.

C.3 establishes the secure cluster structure.

C.4 will own broader contextual visibility policy.

## Proven base from C.2

Reuse:
- SecureActionButtonTemplate;
- secure action attributes;
- action presentation APIs;
- secret-safe cooldown/count paths;
- native action-button registration;
- combat-lockdown defer rules;
- developer-panel diagnostics.

Do not fork a second action-button implementation unless evidence requires it.

## Initial C.3 design questions

1. Which action-slot domains should map to Secondary and Utility?
2. How should stock multi-bar/action-page semantics map into stable Logres groups?
3. Which clusters can be built as static secure buttons with presentation-only
   fading?
4. Which visibility changes require secure drivers because they must happen in
   combat?
5. What geometry leaves adequate space for the Phase B HUD?
6. How should the existing primary cluster be refactored so all clusters share
   reusable button/presentation code?
7. How should Action Keys routing expand without stealing unrelated bindings?
8. Which stock bars must remain visible until all corresponding Logres actions
   are proven?

## Architecture direction

Prefer shared action-button primitives:
- one secure button construction path;
- cluster-specific slot mapping;
- common presentation update functions;
- common diagnostics.

Avoid copying `Primary.lua` wholesale for every cluster.

## Suppression

No new stock-bar suppression in the initial C.3 implementation.

D-017 remains authoritative.

## C.3 exit

C.3 completes when:
- secondary/utility secure clusters exist;
- their slot/binding semantics are proven;
- mouse/key execution is reliable;
- they coexist with Phase B HUD and Primary Cluster;
- no critical input path is taken over before proof;
- stock bars remain available.
