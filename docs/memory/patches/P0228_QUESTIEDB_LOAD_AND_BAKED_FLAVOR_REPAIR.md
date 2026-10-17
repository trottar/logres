# P0228 — QuestieDB optional load ordering and baked-flavor source repair

Baseline verified: GitHub main P0227 `7c6850b`. Prepared `0.0.135-dev` corrective runtime patch. Only integration diagnostic and optional TOC load order change; no compass glyph/provider producer. Related evidence: `docs/memory/evidence/P0228_QUESTIEDB_LOAD_FLAVOR_REPAIR.md`.

One-time applier checks exact baseline Git commit and blob hashes, creates a shadow candidate, runs the complete `tools/check_*.py` suite, hygiene checks and builds manifest; it does not commit/push. Test with `/logres questiedbprobe`, distinct provider and world-source interpretations. If runtime tests are unavailable, record DEFERRED rather than PASS.

R1 package correction: original P0228 applier failed pre-write CURRENT.md EOF blank-line diff hygiene; R1 normalizes terminal newlines before any tracked writes and documents the negative result. No runtime behavior changes relative to original prepared candidate.
