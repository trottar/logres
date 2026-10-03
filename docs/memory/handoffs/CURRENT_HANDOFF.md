# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.2.**

P0094 is verified pushed at:
`9db11d2b`.

Current pushed runtime:
`0.0.38-dev`.

P0095 runtime target:
`0.0.39-dev`.

G.1:
**CLOSED — PASS.**

G.2 source review:
**PASS.**

Important correction:
DynamicCam `zoomType=in/out` is a conditional absolute target, not a delta.

Current profile semantics:
- World: if farther than 5, target 5 over 2.5 seconds;
- World (Combat): if closer than 15, target 15 over 2.5 seconds;
- zoom restoration: never.

Primary source path:
`GetCameraZoom` + read-only `cameraZoomSpeed` + `MoveView*Start/Stop`.

P0095 adds only a manual reversible panel probe.
It refuses while DynamicCam is loaded and makes no automatic camera changes.

Runtime proof required:
- PASS out of combat;
- PASS in combat;
- start zoom restored each run.

P0095 changes runtime probe code; WoW redeploy is required after verified push.

User performs all commits/pushes.
