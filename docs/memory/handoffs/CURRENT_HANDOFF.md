# Current Handoff — P0222 functional compass candidate

Authority: `docs/memory/CURRENT.md`.

GitHub main P0220 `09175bc`. Local unpushed P0221 0.0.130-dev loadCount 293: user still saw only waypoint markers, with zero quest-line/AreaPOI positions after one request/event. Negative runtime evidence preserved; do not call that PASS.

P0222 uses new optional native quest-map/vignette position feeds plus existing AreaPOI/quest-line fallback and existing waypoint-bearing projection. It separates real quest destinations, local POIs and typed vignette detections. No protected pin reads, source mutation, constant retry, fake position, or stock minimap removal. Some treasure vignettes may provide tracking glyphs; generic selected resource filters are NOT positions.

Apply in same uncommitted P0221 worktree; panel Phase H Navigation Source Probe, Phase E Compass Check, Phase H Layout Check and Phase 0 Run All after deploying/reload. Require a visually confirmed non-waypoint marker for capability PASS; empty source is OPEN/DEFERRED. No WoW redeploy is needed for memory-only edits, but this checkpoint changes runtime Lua and DOES require deploy.
