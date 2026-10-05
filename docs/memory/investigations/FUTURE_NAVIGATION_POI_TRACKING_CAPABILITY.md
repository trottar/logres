# Future Navigation — Local POI / Tracking Capability Audit

Status: **OPEN — P0142 SOURCE-CAPABILITY AUDIT NEXT**
Opened: 2026-10-03
Canonical direction: `../decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`

## Why this exists

D-037 accepts a future four-role navigation system:
- manual waypoint;
- quest destination;
- local radius POI;
- tracking.

Only the manual user-waypoint marker is currently runtime-proven.

The local POI and tracking roles are plausible product directions, but their
actual Forever addon capabilities have not yet been established. This record
prevents visual planning from being mistaken for runtime proof.

## Questions to answer

### Tracking

Determine from the current Forever client:
- all tracking types actually exposed;
- whether tracking selection is singular or can be simultaneous;
- update events / refresh semantics;
- whether addon code can enumerate individual matching tracked entities;
- whether usable map/world positions or bearings are available for each result;
- whether results are secret/protected in any context;
- how stale/disappearing results are signaled.

The desired presentation remains one generic Logres tracker glyph independent of
tracked category. That visual policy does not prove the source exists.

### Local radius POI

Determine:
- which service/location POIs the Forever minimap actually exposes;
- whether those POIs can be enumerated by addon code;
- whether individual usable positions/bearings are available;
- whether the client exposes a trustworthy local/minimap view radius;
- whether different maps/indoors/cities require different coordinate handling;
- whether POI identity/category is safely available for inspection;
- update/removal semantics.

Do not hard-code an assumed service list before the client is enumerated.

### Quest destination

Revisit quest destination only with new evidence.

Phase E runtime found no usable next waypoint for the accepted tested
super-tracked quests. D-037 does not convert that negative result into a success.

### Minimap completeness

Separately enumerate current Forever minimap responsibilities, including
information and interactions that are not marker bearings.

The capability audit must identify what Logres would need to replace, what the
product may deliberately omit, and what must remain Blizzard-owned.

## Method

Use the normal project method:

**narrow source question -> targeted diagnostic -> runtime evidence -> explicit
result -> coherent implementation/decision**

Prefer current Forever source/API evidence first, then the smallest in-game
probe needed to prove actual behavior.

Do not add production polling, broad hooks, or minimap suppression as a probe.

## Current result

**UNPROVEN / DEFERRED.**

No local POI, tracking-result, or quest-destination production marker is
authorized by this record.

D-030 remains the current minimap runtime boundary until the complete replacement
gate is deliberately satisfied.

## P0141 sequencing checkpoint

P0140 closed its observed runtime scope with safe fallback/reaction PASS but an
environmental positive-nameplate/attachment deferral. Project sequencing therefore
advances to this independent approved capability slice rather than forcing
nameplate state.

P0142 is source evidence only. It must audit the exact current Forever generation
before any new runtime code and determine:
- quest-destination source viability;
- tracking selection and individual-result enumerability;
- local POI/service enumerability and usable position/bearing data;
- safe player/map coordinate and comparable-distance inputs;
- update/removal/staleness and secret/protected behavior;
- stock minimap information/control responsibilities;
- the smallest justified read-only runtime probes, if any.

The stock minimap remains Blizzard-owned.
