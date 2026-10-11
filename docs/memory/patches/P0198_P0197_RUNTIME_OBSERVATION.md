# P0198 — P0197 ordinary runtime observation and monitoring disposition

Date: 2026-10-11. Baseline: verified GitHub `main` `0a20eef1de3b77fa26d03d6b1c1ccfd23cde0a7b` (P0197). Documentation only: no Lua, no WoW redeployment.

## Observed runtime evidence

User: “pushed, pet bar was not appearing. Something to monitor I guess.” Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, `0.0.108-dev`, loadCount 253, client 1.60.1.70338, records normal session:

- First Phase H Native Access Check: petbar-reshow `onShow=0 combatDeferred=0 immediateRefolds=0 recovered=0 awaiting=false`.
- After Immersion OFF/ON and Run All: `onShow=4 combatDeferred=0 immediateRefolds=4 recovered=0 awaiting=false lastReconcile=PET_BAR_UPDATE`. Same values survive follow-up Native Access and second Run All.
- Native surface snapshot: `desired=true folded=4 petInteraction=true pending=false`, `petFrame:folded petActions:folded playerBuffs:folded targetAuras:folded`, `error=nil`.
- Phase H native access PASS; two Phase 0 Run All commands complete, no reported failures in their observed scope. Latest Layout Check: 19 anchors, 34 binds, zero failures, missing or mismatched.
- The native-source counters capture four event-driven ordinary re-hides, **not native stock frame visibility monitoring**. They provide bounded evidence consistent with the user's visual observation, without proving universal suppression.

## Negative evidence / deferrals

Prior P0196 R4 screenshot showed redundant Blizzard PetActionBar next to Logres pet controls; onset and underlying cause were not captured. Current session does **not** reproduce it. Therefore issue remains **OPEN / INTERMITTENT / UNREPRODUCED** and the conditional post-combat recovery code is **UNTESTED** (`combatDeferred=0 recovered=0`). No additional speculative polling, OnUpdate or blanket native hide is authorized.

Native PET open/close and actual pet attack / autocast clicks were not independently evidenced in this upload; special / override / vehicle / possession / combat and private/group aura coverage remain unobserved or deferred. This is not a claim that all source classified STOCK surfaces are absent. Historic R1/R2 failures and ObjectiveTracker flash remain recorded.

## Next work item

Monitor natural recurrence of duplicate stock pet controls through addon-owned Phase H Native Access Check when visible and again after combat, plus the visible screenshot/triggering activity. A recurrence with `combatDeferred=0` requires a new source-targeted diagnosis. Otherwise continue coherent Phase H.3 visual-polish planning, including smaller target debuff icons and screen-wide consistency, with separate runtime implementation/acceptance later. Do not silently mark all of H.2 or protected fallbacks complete.
