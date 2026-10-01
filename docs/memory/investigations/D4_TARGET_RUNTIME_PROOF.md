# D.4 — Target Selective Replacement Runtime Proof

Status: IMPLEMENTATION NEXT
Opened: 2026-10-01

## Goal

Prove D-027 on the global TargetFrame.

## Runtime target

Add a TargetFrameReplacement module that:
- creates/configures secure Logres target interaction;
- uses RegisterUnitWatch for target existence;
- snapshots selective stock presentation + interaction;
- suppresses TargetFrame container/main/contextual parent;
- preserves aura/raid/quest/ping children via IgnoreParentAlpha;
- disables stock TargetFrame mouse interaction;
- restores exact stock state on OFF;
- defers protected transitions during combat.

## Diagnostics

Add Target Frame Check reporting:
- requested/applied/pending;
- stock child paths found;
- container/main/context alpha;
- preserved child parent-alpha override readiness;
- stock mouse state;
- secure interaction readiness/watch state;
- whole TargetFrame suppressed=false;
- target-of-target suppressed=false;
- focus/boss/party suppressed=false.

## Proof

With a normal target under Immersion ON:
- conventional Blizzard TargetFrame shell is gone;
- no level/classification/threat metadata leaks;
- Logres target name/health/cast presentation remains;
- Logres target block supports left target/right menu interaction;
- old stock TargetFrame area is not an invisible click zone;
- target auras remain usable when present.

Immersion OFF restores stock TargetFrame exactly.

Combat-time ON/OFF requests defer.

Raid marker, quest icon, ping, and unusual aura/ToT paths may be natural-play
environmental proofs rather than manufactured tests.
