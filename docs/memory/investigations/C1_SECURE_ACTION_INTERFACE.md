# C.1 — Secure Action Interface

Status: ACTIVE
Opened: 2026-10-01

## Goal

Resolve the secure-action architecture for Logres action clusters before writing the first Phase C runtime implementation.

## Required source questions

1. Which secure action-button template/API is present on Forever?
2. How should standard action slots be represented?
3. Which attributes can be assigned out of combat?
4. Which button/layout/visibility operations are protected during combat?
5. Can secure state drivers control cluster visibility safely?
6. How should action icons/cooldowns/count/range/usability updates be sourced?
7. How should keybinds be represented and updated?
8. What drag/drop/edit behavior is feasible?
9. What Blizzard action-bar frames can be safely hidden, and under what restoration constraints?
10. Which operations must be deferred until `PLAYER_REGEN_ENABLED`?

## Architecture constraints

- no insecure replacement for protected actions;
- no combat-time protected mutation;
- no monolithic state mode;
- primary cluster must remain usable;
- suppression of Blizzard bars comes only after Logres secure controls are proven;
- user must never lose access to required actions because suppression happened too early.

## Runtime strategy

Use the developer/control panel for diagnostics as Phase C checks are added.

Future Phase C diagnostics should register into the existing panel action registry rather than requiring manual slash-command workflows.

## Exit

C.1 completes when secure-action constraints and the first implementable cluster contract are documented strongly enough to write C.2 without guessing.
