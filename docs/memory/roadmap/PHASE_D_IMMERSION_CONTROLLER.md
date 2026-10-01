# Phase D — Immersion Controller

Status: ACTIVE

## Objective

Turn the individually proven Logres capabilities into a coherent immersion
controller that can suppress and restore Blizzard UI safely according to
preference and context.

D-017 is authoritative.

Core rule:

**A Blizzard surface is suppressed only when Logres has a proven replacement
or a deliberate safe exception.**

Restoration must remain reliable and fail-open.

## D.1 — Immersion orchestration contract / source review

**Status: ACTIVE — SOURCE / DESIGN RESOLUTION NEXT.**

Resolve before implementation:
- controller ownership and module boundaries;
- how persisted `immersionEnabled` drives orchestration without becoming
  observed state;
- exact Blizzard player / target / party frame ownership;
- suppression/restoration methods and combat restrictions;
- action replacement integration from Phase C;
- Quiet Mode chat/tab suppression APIs and restoration;
- instance/PvP exceptions;
- deferred transition handling during combat;
- reload/login initialization ordering;
- diagnostics and recovery path.

Do not implement broad suppression before this contract is source-resolved.

## D.2 — Core stock unit-frame suppression/restoration

Targets only where Logres replacement is already proven:
- Blizzard player frame;
- Blizzard target frame;
- Blizzard party frames while Logres party presentation is active.

Focus/related frames require separate justification before suppression.

Requirements:
- exact prior state restoration;
- combat-safe transitions;
- fail-open recovery;
- developer panel remains available.

## D.3 — Quiet Mode / social visual suppression

Implement visual silence where APIs permit:
- chat frame visibility;
- chat tabs;
- supported social notification surfaces.

Quiet Mode is presentation policy, not communication-status mutation.

Do not promise outbound auto-replies without a separate API capability decision.

## D.4 — Context / PvP / instance orchestration

Integrate existing orthogonal state:
- `context`;
- `combat`;
- `pvpFlagged`;
- related proven sensor flags.

PvP remains a modifier, not an immersion-off mode.

Instance policy may restore or suppress surfaces selectively based on proven
replacement capability.

## D.5 — Phase C action replacement integration

Integrate the proven selective action replacement into immersion orchestration.

Current supported automatic replacement scope:
- stock Bar 2;
- stock Bar 3.

Do not broaden suppression to:
- MainActionBar;
- Bars 4–5;
- special vehicle/override/form action surfaces;

until their independent capability gates are satisfied.

Primary Action Keys remain manual/session-only while Primary stock replacement
is unsupported.

## D.6 — Restoration / integration validation

Validate:
- immersion ON;
- immersion OFF;
- reload/login;
- combat-deferred changes;
- PvP;
- world/instance transitions where naturally available;
- module disable/restore;
- developer recovery controls;
- no required control or awareness surface is lost.

## Phase D exit

Phase D completes when:
- supported stock surfaces suppress coherently under immersion;
- Immersion OFF restores them reliably;
- context/PvP/instance policies are deterministic;
- Quiet Mode visual suppression is proven where supported;
- Phase C selective action replacement integrates without widening unsupported
  suppression;
- no protected/taint/Lua/secret regression occurs.
