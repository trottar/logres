# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Project Logres is in **Phase 0 / 0.2 — WoW Forever API capability audit**.

Runtime pass 01 is complete.

Key verified findings:
- Forever 1.60.1 build 70124 / interface 16001 reports `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE == 1`;
- player health/power percentages are secret even outside combat;
- secret health can drive status-bar value and texture alpha directly;
- secret percentage text formatting/display works;
- ordinary target level/classification are readable in the tested world context;
- open-world position/facing works;
- SavedVariables persisted through `/reload`;
- combat event and restriction/lockdown timing are not synchronous.

Negative result:
- initial probe failed because `table.pack` is unavailable; fixed with a compatibility helper.

Next:
targeted runtime pass 02 for custom health curve, valid target in combat, real cast/channel, elite target, instance navigation restriction, quest waypoint, and optional PvP transition.

User performs all commits/pushes.
