# P0232 — Commit-verified P0231 runtime evidence checkpoint

Docs-only checkpoint, prepared 2026-10-17 on verified GitHub `main` `968675a`.

Positive: QuestieDB v1.0.6 compatible, zone 1432 -> area 38, 13,392 scanned, 38 cached spawn positions, 5 within 50 yards, four source candidates, two addon-owned compass markers shown. The map trace has 54 provider entries and no resolution error.

Limitation: existing panel action explicitly retried map resolution; **autonomous discovery at login is still unverified**. No visible-minimap fallback, no NPC eligibility inference, no full retail tracking blip mirroring. Prior P0230 failure remains recorded. This patch changes only repository memory, not runtime Lua.

Next narrow verification: after `/reload`, run Phase E **Compass Check first**, without clicking QuestieDB Location Probe. Observe provider ready/candidates/shown before any manual retry. If auto-ready, retain as proof; otherwise investigate actual event ordering. Avoid travel or blanket polling.
