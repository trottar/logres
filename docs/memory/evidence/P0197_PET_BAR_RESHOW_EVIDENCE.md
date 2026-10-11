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
