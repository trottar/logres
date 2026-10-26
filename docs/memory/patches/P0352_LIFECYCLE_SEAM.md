# P0352 — Extract lifecycle diagnostic to the module owner

**Baseline:** verified pushed GitHub `main` P0351 `e8b71bc59a04f3077925bb24f0d6850a71340841`, manifest 222/222 PRE/POST STATIC, version `0.0.240-dev`; runtime UNVERIFIED.

Transfer only the effectful `runLifecycleCheck()` body from Commands to earlier-loaded `Core/Modules.lua`. Keep `DevLifecycleProbe` registration and counters physically inside Commands, because moving that registration changes authoritative startup ordering; Commands wrapper passes `emit`, `lifecycleProbe` and `lifecycleProbeModule` unchanged. The original initial/enable/disable/cleanup and preference-change callbacks, diagnostic PASS/FAIL formatting, Run All, slash and phase-0 panel routes remain intact. No new events, timers, native/protected actions, saved-preference schema, D-048 live switches, camera changes or extra addon Lua files. Bump TOC/Bootstrap to `0.0.241-dev`; static checker #223; 94 Lua and 120 developer actions (38 previews) remain.

Exact-baseline guarded applier requires candidate PREWRITE shadow and POSTWRITE 223/223 STATIC PASS, diff hygiene and manifest; no remote Git mutation. WoW remains UNVERIFIED; P0321 native GossipFrame restoration FIRST contingent client safety gate; L-022/L-027/L-028 OPEN; L-019 public release BLOCKED. Historical prewrite refusals remain durable evidence.
