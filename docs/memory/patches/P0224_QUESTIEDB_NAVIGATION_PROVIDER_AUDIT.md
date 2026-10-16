# P0224 — QuestieDB external compass-location source audit (docs only)

Baseline: P0223 GitHub main `27505f1e4ffb3057bef7277ab3c6c249589114b1`, verified 2026-10-16. The user visually accepted focused-only quest markers, correct orientation and responsive distance scale, deferring close-range art. The completed 0.0.132-dev runtime still has zero available-quest, AreaPOI and vignette rows. Existing accepted quest `GetQuestsOnMap` source is retained.

Research-only checkpoint: QuestieDB's public `QuestDB.startedBy`, `NpcDB.spawns`, `GetAllIds`, `RequireContract` and documented Forever flavor sources offer a plausible external coordinate candidate, but no proved current quest eligibility or full tracking blip enumeration. Map keys differ (AreaID versus UiMapID), coordinates are percentages versus normalized fractions, Forever release/client support must be tested, and broad scans would violate event/budget discipline. A documentation-only source audit records gating and the one-positive/one-negative bounded experiment. No addon files, TOC dependency, Lua code, visuals, licensed data, or runtime version changed. Native minimap remains fail-open.

Detail: `docs/memory/evidence/P0224_QUESTIEDB_NAVIGATION_PROVIDER_AUDIT.md`.
