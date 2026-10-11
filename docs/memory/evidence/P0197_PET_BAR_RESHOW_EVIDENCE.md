# P0197 — PetActionBar re-show evidence

Status: OPEN / INTERMITTENT / UNREPRODUCED trigger; candidate source-backed recovery, runtime untested.

Observed before P0197:
- P0196 R4 user committed and pushed as `c89692b`; user confirms target buff/debuff correct, small debuff icons deferred to polish.
- User screenshot shows two sets of pet action buttons; lower stock PetActionBar intermittently visible. No known triggering time or transition.
- Uploaded `0.0.107-dev` loadCount 251 native-surfaces audit reports desired=true, 4 folded, petActions:folded, pending=false, error=nil. This is snapshot state; no exact native visibility measurement.
- Source inspection: `PetActionBarMixin:OnEvent` can Show on PET_BAR_UPDATE, UNIT_PET, PET_UI_UPDATE, UPDATE_VEHICLE_ACTIONBAR. Existing Logres HookScript returns without Hide in combat and leaves stale snapshot; post-combat Fold early-return omits deferred refold. This source path is a narrow hypothesis, not observed proof of combat causation.

P0197 runtime observation PENDING:
- `petbar-reshow` AUDIT shows:
- Native Access Check while issue present:
- Native Access Check after combat:
- PET manual open/close:
- Immersion OFF/ON:
- Phase 0 Run All / Lua-taint-protected errors:

If combat not naturally encountered, record environmental deferral. If bar persists with `combatDeferred=0`, new evidence disproves this mechanism as the sole cause and a new narrow diagnostic is required, not polling.

## P0198 follow-up: verified pushed P0197, ordinary session observed (2026-10-11)

- GitHub main verified `0a20eef1de3b77fa26d03d6b1c1ccfd23cde0a7b` (`fix: recover deferred pet action bar folds after combat`), deployed `0.0.108-dev` according to uploaded SavedVariables; loadCount 253, client 1.60.1.70338.
- User reports that the duplicate Blizzard pet bar **did not appear** during this session. Normal screen observation only, not a test of every combat/special lifecycle.
- Initial Native Access Check: `petbar-reshow onShow=0 combatDeferred=0 immediateRefolds=0 recovered=0 awaiting=false`.
- After Immersion OFF/ON and first Run All: `onShow=4 combatDeferred=0 immediateRefolds=4 recovered=0 awaiting=false lastReconcile=PET_BAR_UPDATE`. Subsequent Native Access Check and second Run All retained these counts; zero native-surface errors and all four native-surface snapshot domains folded, pet interaction ready.
- Two Phase 0 `checkall` commands completed; latest Layout Check `anchors=19 binds=34 failures=0 missing=0 mismatched=0`. `nativeuicheck` PASS; `targetframecheck` and `statusauracheck` PASS for diagnostic scopes, while populated harmful auras and certain secure pet interactions were not individually runtime-demonstrated here.
- Ordinary immediate OnShow refolding was exercised and returned without reported error. **No deferred combat show occurred** (`combatDeferred=0`); the new P0197 delayed recovery branch was **not exercised**, so never claim it passed. The original intermittent duplication remains OPEN / INTERMITTENT / UNREPRODUCED. The earlier source gap is corrected statically, but its causality to the screenshot is unknown.
- Manual PET open/close, actual secure pet click/right-click/autocast, combat/vehicle/petbattle and full aura coverage are **NOT RECORDED / ENVIRONMENTALLY DEFERRED** unless separately observed. No artificial travel/gameplay reproduction required. If a natural recurrence occurs, capture screen and Phase H Native Access Check *while visible* and again after combat ends; preserve these counters as new evidence.
