# P0258 — Multiple preview completion-action parity

Baseline: `94635d3` / P0257; date 2026-10-18.

- Use P0257's existing synthetic model and production renderer/preview-only shared button for Multiple, exactly as for Single.
- Keep one guaranteed item and three CHOICE cards. Delete the unnecessary synthetic stock-instruction footer.
- Do not add fake selectable choice inputs or a native claim route. Production choice ownership and native fallback remain unchanged.
- Update original P0257 preview contract and add P0258 regression contract; both run against prepared source **before writing** and with the complete suite.
- Update CURRENT, handoff, phase/status/roadmap, index and evidence in the same checkpoint.

Status: **PREPARED / RUNTIME UNVERIFIED** until WSL checks, push verification, and WoW preview acceptance. The broader D-046 coverage requirement remains open.
