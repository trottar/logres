# P0250 — Accept P0249 synthetic reward preview runtime

- Type: documentation/evidence checkpoint only; no Lua/runtime changes, no WoW redeploy.
- Baseline: GitHub main `aaee2880d08389f2c9d5a41745832374195fd361` (P0249 pushed and verified).
- Evidence: uploaded `0.0.149-dev`, loadCount 328 diagnostics + single/multi screenshots. Both `questrewardpreview` modes returned PASS and rendered portrait cards; `questdialoguecheck` returned PASS within its scope.
- Decision: P0249 runtime accepted **for synthetic reward preview rendering and method dispatch only**; P0248's earlier runtime failure retained. The two-column screenshot is partly occluded by the open developer panel; intrinsic clipping not demonstrated.
- Outstanding: natural quest completion portrait parity, actual Blizzard multiple reward choice/claim interaction, earlier intermittent item name source, and fresh Phase 0 Run All. No gameplay fabrication or polling.
- Memory updates in this checkpoint: CURRENT, handoff, active investigation, phase H/status/roadmap, P0249 evidence and patch record, and patch index. Exact remote-baseline checks in applier; no Git operations that change branch or refs.
