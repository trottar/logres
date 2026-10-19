# P0267 — NPC navigation header and direct Goodbye options

- Baseline: pushed P0266 main `2270e84` (verified read-only 2026-10-19).
- Scope: one combined UI/semantic correction: Back upper-left matches existing Goodbye upper-right, and authored Farewell/Leave the watch exit with one click. No extra UI abstraction, native adapter, service transaction or camera changes.
- Changes: `UI/OptionList.lua`, `Quest/OptionModel.lua`, `Quest/OptionSession.lua`, Bootstrap/TOC version parity, docs memory/roadmap/handoff, static checker, guarded manifest. Existing quest Dialogue, original Goodbye, narrative paginator, reward renderer, safe native restoration and camera modules frozen.
- Negative evidence: P0266 user image shows lower Back overlaps `1/2` narrative page indicator; Farewell branch requires duplicate Goodbye. Diagnostics otherwise show user functional acceptance for tested button actions and no native action. P0265 Services overlap and inaccessible Back were separately addressed by P0266 and should not be re-opened without new evidence.
- Tests required: guarded clean pushed baseline, full shadow checkers, postwrite checkers, diff hygiene, in-game P/F/H/0 ordered actions from README. Runtime result must be reported separately.
