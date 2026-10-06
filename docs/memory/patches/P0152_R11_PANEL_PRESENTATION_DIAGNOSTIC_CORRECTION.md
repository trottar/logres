# P0152 R11 — Panel Presentation Diagnostic Correction

Date: 2026-10-06
Status: **PREPARED — PHASE H PANEL DIAGNOSTIC REQUIRED**

R9 remains a runtime/visual failure: the pet-action surface looked unchanged after deploy/reload. The first R10 diagnostic implementation was installed locally but exposed a standalone slash command, contrary to the project rule to prefer the in-game developer panel when a corresponding action exists. The corrected R10 panel artifact then refused pre-write because it asserted the wrong presentation baseline.

R11 targets the exact observed local R10 diagnostic baseline (`facf7eae...`). It does not change secure pet-action execution, pet-state rendering policy, Blizzard stock fallback, or default-on arm logic.

R11 removes the standalone `/logrespetstate` registration. The presentation module returns diagnostic lines to `Core/Commands.lua`, and Phase H gains **Pet State Diagnostic** through the existing developer-panel command dispatcher.

The diagnostic reports addon-owned state and sanitized ordinary pet-action booleans only: tracked/decorated button counts, pet/readable counts, active/autocast indicator counts, default-arm attempts/results, execution-probe configured/armed/visible state, and ordinary secure `type`/`action` attribute shape. Secret-capable values are checked before inspection; pet identity payload remains ignored.

Interpretation:
- `tracked=0`: shared-button interception/creation path is wrong.
- `tracked>0 pet=0`: secure pet attribute assumption is wrong.
- `pet>0 readable=0`: pet-state read/sanitization path is wrong.
- nonzero active/autocast indicators with no visible treatment: draw layer / geometry is wrong.
- probe `armed=false` or `visible=false` after a default-arm dispatch: default-on lifecycle path is wrong.

R11 is diagnostic only. P0152 remains open pending Phase H panel evidence and a subsequent runtime/visual correction.
