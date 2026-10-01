# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Project Logres is in **Phase 0 / 0.3 — Minimal addon skeleton/load proof**.

I-001 is complete.

Key runtime conclusions:
- Forever 1.60.1 build 70124 / interface 16001 reports MAINLINE project ID;
- health/power percentages are secret-capable;
- custom secret-safe health curves can drive bar value/alpha in combat and instances;
- player cast/channel confirmation is feasible;
- normal/elite level/classification metadata is readable even in tested combat/instance contexts but intentionally hidden by design;
- compass inputs work in world and disappear in instances, then restore after exit;
- combat state/restrictions settle asynchronously across events;
- SavedVariables persist through reload/instance transitions.

Negative result retained:
- `table.pack` unavailable in Forever Lua.

Next:
create the smallest real Logres addon skeleton and prove lifecycle/state/SavedVariables behavior.

User performs all commits/pushes.
