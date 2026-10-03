# G.1 — Current DynamicCam Profile Capture

Status: ACTIVE — FRESH EXPORT REQUIRED
Opened: 2026-10-02

Architecture:
`../architecture/CAMERA.md`

Phase roadmap:
`../roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Question

What exact DynamicCam behavior is the user currently running, and which of those
behaviors should become the first evidence-backed Logres camera slice?

## Why this is required

Repository camera architecture explicitly rejects reconstructing detailed camera
values from conversational memory or old uploads.

Phase G has now begun, so the prerequisite is active.

## Required artifact

A current DynamicCam export/profile supplied by the user.

Accept:
- raw export text;
- exported SavedVariables/profile file;
- another faithful current export format that preserves exact settings.

Do not substitute:
- old conversation files;
- remembered values;
- default DynamicCam presets;
- guessed context settings.

## Analysis after capture

Preserve:
- enabled situations;
- situation priority/activation rules;
- zoom;
- shoulder offset;
- pitch;
- view/targeting behavior;
- transition timing;
- delay/easing behavior;
- reactive zoom or other global camera behavior;
- condition scripts or context predicates;
- any relevant CVars/settings.

Map those to the user's actual contexts:
- world;
- combat;
- NPC interaction;
- gathering;
- fishing;
- taxi;
- hearth/teleport;
- instance;
- rest/AFK/travel where present.

## Result States

PASS:
current export captured and mapped sufficiently to select the first narrow
implementation/capability slice.

BLOCKED:
no current export is available.

Do not implement camera behavior while G.1 is BLOCKED.

## Next Action

Request the user's current DynamicCam export/profile.
