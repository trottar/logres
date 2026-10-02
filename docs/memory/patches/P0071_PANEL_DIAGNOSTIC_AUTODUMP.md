# P0071 — Developer-Panel Diagnostic Autodump

Date: 2026-10-01
Result: INSTALLED / PUSHED — VERSION METADATA DEFECT (`7976d34e`)

## Baseline

P0070 verified pushed:
`f99afa9b`

## Purpose

Persist developer-panel diagnostic output through WoW SavedVariables.

## Runtime result

The persistence workflow works and produced reviewable E.3 evidence.

## Defect

P0071 changed `Logres.toc` to `0.0.29-dev` but did not update
`Logres.VERSION` in `Core/Bootstrap.lua`, which remained `0.0.28-dev`.

This is a real delivery defect, not a runtime navigation defect.

P0072 corrects it and adds a version-equality static contract.
