# I-001 — WoW Forever API Capability Audit

Status: COMPLETE WITH EXPLICIT DEFERRALS  
Phase: 0.2  
Opened: 2026-09-30  
Closed: 2026-09-30

## Question

What APIs, events, restrictions, and protected-state rules does the current WoW Forever client expose for the systems Logres intends to build?

## Result

The architecture-critical boundaries required before creating the Logres addon skeleton are sufficiently established.

Canonical source evidence:
`../evidence/I001_SOURCE_AUDIT_2026-09-30.md`

Runtime evidence:
- `../evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `../evidence/I001_RUNTIME_PASS_02_2026-09-30.md`

## Runtime-verified conclusions

### Client identity
- Forever version 1.60.1;
- build 70124;
- interface 16001;
- `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE == 1`.

### Health/resource
- player health percentage is secret even out of combat;
- player power percentage is secret even out of combat;
- target health/power percentages are secret in tested world/instance combat;
- secret-safe formatted text works;
- secret-safe normalized/custom-curve health drives status-bar value and alpha;
- custom Logres inverse/threshold curve succeeded during combat and instance combat.

### Enemy metadata
- ordinary target level/classification readable and non-secret;
- ordinary target metadata readable during active combat;
- elite classification/level readable and non-secret;
- elite metadata readable during active instance combat.

### Player casting
- active player cast-time metadata readable;
- active player channel metadata readable.

### Combat/restrictions
- combat lockdown is present;
- restriction state changes are observable;
- event ordering is transitional rather than instantaneous.

### Navigation
- open-world position/facing available;
- instance position/facing unavailable;
- world values restore after leaving instance.

### State/social/camera reads
- unflagged PvP state readable;
- chat messaging-lockdown state readable;
- camera zoom/CVar reads available.

### Persistence
- diagnostic SavedVariables survived `/reload`;
- instance entry did not erase prior audit snapshots.

## Negative results retained

### Probe compatibility failure
Initial probe used `table.pack`, unavailable in Forever Lua.

Result:
- first snapshot failed before API evidence was recorded;
- probe fixed with a local compatibility helper.

Status: CLOSED.

### Combat-event timing assumption falsified
`PLAYER_REGEN_DISABLED` did not guarantee `InCombatLockdown()` had already settled to true inside that snapshot.

Result:
- state engine must read current state and tolerate transitions.

Status: DURABLE ARCHITECTURE LESSON.

## Explicit deferrals

These are not Phase 0.2 blockers.

### Enemy casting
No hostile cast was captured.
Defer to HUD/combat work if/when hostile cast presentation is added.

### PvP flagged transition
Only unflagged state was captured.
Defer flagged transition verification to Phase A state engine.

### Quest waypoint semantics
API presence is established.
Defer actual waypoint behavior to Phase E/F.

### Secure action-button mutation
Combat lockdown/protected-action constraints are established.
Defer actual secure-frame tests to Phase C using the real action-cluster implementation.

### Automated outbound chat
No message automation was tested.
Defer to Phase D and require a separate decision before implementation.

### Camera mutation/restore
Read path is established.
Defer mutation ownership and restoration to Phase G.

## Architecture decisions resulting from I-001

- D-008 Secret-safe health and resource presentation path.
- Existing D-003 enemy disclosure remains intentional despite metadata being available.
- Existing D-005 compass instance suspension is now runtime-supported.

## Completion judgment

I-001 is complete because the unresolved items are phase-specific behaviors that can be tested safely with their actual implementation context. None blocks creation of the minimal Logres addon skeleton.

## Next

Proceed to **Phase 0.3 — Minimal addon skeleton/load proof**.
