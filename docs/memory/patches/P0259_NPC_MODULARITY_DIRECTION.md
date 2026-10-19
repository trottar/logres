# P0259 — modularization-first NPC direction memory checkpoint

Date: 2026-10-18. Exact expected pushed baseline: `edec5eb6941706826e952d3776e6cec3cd2eb1c7` (P0258).

**Scope: DOCS-ONLY.** Accept D-047; record the precise four-stage order, all-NPC scope, preview-first reuse, DynamicCam/NPC-session continuity, and selective native-backed/hybrid/custom integration tiers. Preserve quest/native-control safety and existing failures/deferrals. Update CURRENT, concise handoff, roadmap/investigation entries and patch index.

**Implementation:** no Lua, TOC, runtime version, checker or Native UI mutation. **Validation:** applier must verify exact HEAD and clean tracked files, verify owned Git blobs, prepare all required text and new evidence files in memory, run full `tools/check_*.py` in a shadow tree and again after write, run `git diff --check`, write manifest, and roll back patch-owned paths if a postwrite check fails. Do not commit/push in the applier.

**Next:** P0260 source-level modularity audit AFTER P0259 push is verified. No WoW redeploy required.
