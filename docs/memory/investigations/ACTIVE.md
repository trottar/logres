# Active Investigations

## E.5 — Navigation sufficiency / minimap capability

Status:
**ACTIVE — SOURCE/CAPABILITY REVIEW**

Canonical:
`E5_NAVIGATION_SUFFICIENCY_MINIMAP_CAPABILITY.md`

Question:
Does Logres replace enough of the Blizzard minimap/navigation information and
control surface to justify any reversible minimap suppression?

No minimap mutation is authorized during this investigation.

## Tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred navigation evidence

- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire in tested E.3 runs.
- super-tracked quest IDs `436` and `237` returned no usable next waypoint.
- quest waypoint presentation remains capability-gated until new runtime
  evidence proves a usable destination path.
