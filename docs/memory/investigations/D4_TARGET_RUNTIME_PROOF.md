# D.4 — Target Selective Replacement Runtime Proof

Status: P0056 IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Prove D-027 on the global TargetFrame.

## P0056 implementation

Runtime version:
`0.0.24-dev`

Adds:
- secure unit-watched Logres target interaction;
- TargetFrameContainer suppression;
- TargetFrameContentMain suppression;
- contextual-parent suppression;
- IgnoreParentAlpha preservation for aura/raid/quest/ping;
- stock TargetFrame mouse removal;
- exact restoration;
- combat deferral;
- Target Frame Check.

## Proof

With a normal target under Immersion ON:
- conventional Blizzard TargetFrame shell is gone;
- no level/classification/threat metadata leaks;
- Logres target presentation remains;
- Logres target block supports left target/right menu;
- old stock target area is not an invisible click zone;
- target auras remain usable when present.

Immersion OFF restores stock TargetFrame exactly.

Combat-time ON/OFF requests defer.
