# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Project Logres is in **Phase 0 — Foundation**, work item **0.2 WoW Forever API capability audit**.

The source/documentation pass is complete. Current task: run the temporary diagnostic addon under `tools/probes/LogresAPIAudit` and preserve its sanitized SavedVariables evidence.

Important source-pass findings:
- Forever currently appears as MAINLINE through Blizzard `WOW_PROJECT_ID`; do not use that constant alone to identify Retail.
- Modern secret values apply; health/power UI must be secret-safe.
- Health vignette may be feasible through native curves + secret-capable bar/alpha/color aspects.
- map position/facing are unavailable in instances, matching the compass suspension design.
- secure action cluster reconfiguration is constrained in combat.

Operating boundaries:
- Windows 11 + WSL;
- user performs all commits/pushes;
- failures and rejected approaches are durable evidence.
