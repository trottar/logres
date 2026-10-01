# D-007 — User owns Git checkpoints

Status: ACCEPTED  
Date: 2026-09-30

## Decision

The user performs all Git commits and pushes from WSL.

Assistants may prepare patches and inspect pushed state but do not push and do not assume a checkpoint exists until verified.

## Rationale

This preserves a clear review/control boundary and makes the user the final authority over repository history.
