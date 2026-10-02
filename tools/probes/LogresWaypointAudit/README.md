# Logres Waypoint Audit

Temporary diagnostic addon for Project Logres Phase E.3.

It is not product code.

## Purpose

Runtime-prove:
- user waypoint retrieval;
- super-tracked quest selection;
- quest next-waypoint output;
- player/destination map-to-world conversion;
- Forever event registration/firing;
- candidate world-axis bearing conventions.

The probe deliberately records two bearing candidates. It does not assume which
world Y-axis convention is correct; in-game visual proof selects the valid one.

## Safety

The probe:
- performs no protected action;
- does not set/clear waypoints;
- does not change super-tracking;
- does not mutate the minimap;
- sends no chat;
- checks secret-capable values before inspecting or doing arithmetic on them;
- stores only non-secret scalar/vector data and secret/presence flags.

## Commands

```text
/lwpa status
/lwpa snapshot
/lwpa report
/lwpa clear
```

`/lwpa snapshot` records and prints the current player/user-waypoint/quest state.

The probe also snapshots when successfully registered navigation events fire.

## Runtime matrix

1. Open world with no user waypoint:
   - `/lwpa clear`
   - `/lwpa snapshot`

2. Set a user waypoint on the world map at a visibly known direction from the
   player:
   - `/lwpa snapshot`
   - preserve the printed `user` bearing candidates.

3. Change or clear the user waypoint:
   - `/lwpa snapshot`
   - inspect event counts.

4. Super-track a quest with a visible destination:
   - `/lwpa snapshot`
   - preserve quest ID/waypoint/world conversion/bearing candidates.

5. Change the super-tracked quest if convenient:
   - `/lwpa snapshot`
   - inspect `SUPER_TRACKING_CHANGED` and path event counts.

Do not travel or manufacture a quest solely to fill a missing case. Unsupported
or unavailable scenarios remain explicit UNKNOWN/DEFERRED evidence.
