# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Current phase:
**Phase A — Core State Engine**

Current work:
**A.2 — Additional Context Sensors**

Source review is complete.

Accepted implementation fields:
- mounted;
- resting;
- onTaxi;
- interacting;
- interactionType.

Key semantic rules:
- mounted excludes taxi;
- resting means literal `IsResting()`;
- taxi derives from `UnitOnTaxi("player")`;
- interaction type comes from PlayerInteractionManager SHOW/HIDE payload;
- no generic `traveling` mega-state.

Next patch modifies `Core/State.lua` and adds travel-free diagnostics.

Do not require a dedicated taxi trip.

User performs all commits/pushes.
