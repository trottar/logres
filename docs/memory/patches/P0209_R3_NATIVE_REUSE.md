# P0209 R3 — Native pet button reuse (source-comparison corrective candidate)

Date: 2026-10-14
Status: PREPARED / NOT PUSHED / RUNTIME UNVERIFIED
Baseline: remote `main` `f6b9a3a58bfc9081043455038df33b706c6e9e6f` plus locally applied, uncommitted P0209 R2 `0.0.114-dev`.

P0209 R0/R1 prewrite failures are preserved; R2 actually ran in-game and failed the intended combat behavior because its reciprocal drivers swap to Blizzard's native bar during combat. This was source-designed, not an incidental Blizzard glitch. The user's request is one Logres-integrated pet bar that works *in* combat; no commit/push authorized.

Existing addon references: Dominos (reuses native Blizzard pet action buttons) and Bartender4 (stable ten-button pet bar, no combat swap); see linked exact upstream files and distinctions in `docs/memory/evidence/P0209_R3_NATIVE_REUSE_EVIDENCE.md`. The R3 opt-in **reanchors the existing native PetActionBar** rather than reparenting its secure buttons or hiding its parent. It turns off the existing Logres duplicate cluster while active, and fences that cluster's auto-arm. Blizzard owns native events/clicks/drag/autocast. No state driver, hidden parent, stock visibility inspection, protected combat mutation or periodic reassertion. Original native anchor is an opaque restoration token; Edit Mode enter, Immersion OFF and PET STOCK request release. PetFrame remains stock-owned. Existing 18 Phase H buttons unchanged and driver slash labels retained as legacy commands, with status mode identifying R3 semantics.

Static checkers and extracted-applier prewrite gating do not assert runtime safety. Validate in-game; any protected/Lua/taint error or anchor restore failure is a new OPEN failure and requires corrective R4 before acceptance. No WoW deployment happened at patch preparation. P0197 duplication and full pet UI replacement still OPEN.

## P0209 R3 actual runtime outcome (2026-10-14)

**P0209 R4 local corrective / UNVERIFIED (2026-10-14):** P0209 R3 (`0.0.115-dev`, loadCounts 270–271) **RUNTIME FAIL — activation never armed**. Repeated `/logres petbardriver on` rejected `editmode-unavailable-or-active`, `requested=false armed=false activations=0`, including after `/reload` and outside combat. The guard required an initialized `EditModeManagerFrame`; that Blizzard_EditMode frame can be absent when the manager is not loaded, which also means its Edit Mode is not active. R4 treats ONLY an absent manager as inactive; a loaded manager still must explicitly and ordinarily report inactive. No native pet move has yet been runtime proven. Evidence: `docs/memory/evidence/P0209_R4_EDITMODE_GATE_EVIDENCE.md`. Keep P0209 R0/R1 static failures, R2 swap failure and P0206/P0197 failures OPEN. No push.
