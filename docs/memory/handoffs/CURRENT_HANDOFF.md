# Current Handoff

Authority: `../CURRENT.md`. Verified `main` remains P0195 `9097f43` (`0.0.104-dev`). P0196 R1/R2/R3 are unpushed; R4 is an untested corrective candidate. R1 native 18px player buff takeover and target aura OnShow hook failed; R2 failed memory-health prewrite; R3 restored authored Logres player and target buffs (user screenshot confirms), but small native target aura remained left of target. R3 runtime `0.0.106-dev` loadCount 250 reports `native-surfaces ... targetAuras:stock`, secure harmful renderer available, other 3 native folds present.

R4 narrowly uses native `TargetFrame:ConfigureAuraContainer` with temporary 0/0 target aura limits outside combat, preserving original limits as opaque restoration tokens for TARGET and Immersion OFF. No OnShow hook on forbidden AuraContainer; no alpha-zero invisible click region or periodic reassertion. Native and Logres target aura coverage is capability-gated; failure restores stock. Damage Meter, Issue Reporter and approved geometry untouched. See `../patches/P0196_R4_TARGET_AURA_NATIVE_CONFIG.md` and `../evidence/P0196_R4_TARGET_AURA_RUNTIME_EVIDENCE.md`.

Apply R4 only from exact R3 manifest state; deploy and verify TARGET manual toggle, target retarget, Immersion OFF/ON, pet interactions, Phase H and Run All. Record all failures and deferrals. Do not commit/push before runtime acceptance.
