# Current Handoff — P0216 H.3

Authority: `docs/memory/CURRENT.md`. GitHub main P0215 `8386e91` verified; user screenshots accept the parchment and shared bar art direction, but demand three narrow corrections: no black backing on action clusters, longer player resource bar, and clear incomplete-vs-complete Active Quest treatment.

P0216 `0.0.125-dev` visual candidate edits only the common cluster BACKGROUND rectangle in `Actions/Button.lua` (keeps local button fill and secure interaction), adds Theme `percentageBar.resource` and uses it only for `LogresHUDResourceBar` while leaving normal/compact consumers intact, and clarifies approved Active Quest ready/complete visuals with conditional text/crest/rail/divider. No pet/Blizzard/secret-routing mutation, no v4 anchor changes, no new production TGA. WoW unverified until panel action, layout and quest previews + real scene inspection. Record negative evidence without silently closing it. P0215 R0 prewrite failure preserved.
