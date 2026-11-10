# P0426 — Memory synchronization and compass intake (DOCS ONLY)

Baseline: GitHub P0425 `5af8d14b496f4d96cedc3e09fc3f4dc51a2d64b5`.

- Record user screenshot-scoped P0425 merchant/trainer visual PASS; do not
  close L-003 or L-033 on presentation evidence.
- Record L-043 focus-label UX issue, L-030 reported missing quest-giver
  markers, and L-044 provider version/freshness observability.
- Update QuestieDB external installation guide from historical v1.0.6 to
  current upstream stable candidate v1.0.13 (Forever), official SHA-256,
  correct `_forever_` install path, and verified CurseForge file listing.
- Document source gate, competing causes and narrowly ordered P0427/P0428
  next work. Preserve earlier negative evidence, L-017 licensing limits,
  native map fallback, source gating and all P0425/V8 runtime files.

No Lua, TOC, or checker runtime source change; no WoW redeploy required.
Memory/staging checker run is static and does not claim quest-giver runtime PASS.
