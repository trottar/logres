# P0196 R4 — runtime evidence pending

- Source of follow-up: user's `0.0.106-dev` screenshot and LOGRES_DIAGNOSTICS_LATEST.lua, loadCount 250. User confirms restored Logres player/target buff visuals, **but stock target aura icon remains** to the left of the target frame.
- R3 reported `native-surfaces: CANDIDATE (desired=true folded=3 ... targetAuras:stock error=nil)`. This is a reproducible R3 visual gap, not a test pass for the requested target removal.
- Earlier R1 target contextual `OnShow` hook unsupported and art regression FAIL; R2 memory check prewrite FAIL. Preserved.
- R4 source-backed zero-cap native ConfigureAuraContainer gate is an untested runtime candidate. Expected visual result is no tiny Blizzard contextual target aura during supported normal Immersion; full manual native access remains via TARGET.
- **Pending:** out-of-combat owner API result, re-target stability, TARGET open/close, combat deferral, Immersion OFF/ON, aura tooltips, secure pet controls, Phase H and Run All outputs. No claims of PASS for these tests.
