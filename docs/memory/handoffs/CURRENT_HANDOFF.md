# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.3.**

P0101 is verified pushed at:
`86660959`.

Current pushed runtime:
`0.0.41-dev`.

P0102 runtime target:
`0.0.42-dev`.

G.2:
**CLOSED — RUNTIME + INTEGRATION PASS.**

P0100 production camera ownership is durable at `31a2a7f6`, but its first
observed movement attempt occurred while addon-owned state reported
`outside-slice:resting`. The controller correctly relinquished ownership and no
World transition was exercised. Classification: **ENVIRONMENTAL DEFERRAL**, not
PASS/FAIL.

The same screenshot exposed a separate developer-panel defect: the flat action
grid overflowed its fixed button region and obscured diagnostics.

P0102 correction:
- roadmap tabs `0/A/B/C/D/E/F/G/H`;
- every developer-panel action declares one phase;
- only the selected phase renders;
- Phase G is the default tab for current work;
- Run All / Status live under Phase 0;
- diagnostics persistence remains unchanged;
- the G.3 camera checker no longer pins the whole addon to an exact runtime;
  `check_addon_structure.py` remains the canonical TOC/Bootstrap version-sync
  contract.

P0101 D-034 Selective Hybrid E / visual-component work remains durable and is
preserved unchanged by P0102.

After P0102 is verified pushed, deploy `0.0.42-dev`, verify the tabbed panel,
then leave resting/City and resume G.3 World movement validation.

User performs all commits/pushes.
