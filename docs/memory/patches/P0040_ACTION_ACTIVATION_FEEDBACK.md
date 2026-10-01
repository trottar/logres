# P0040 — Action activation feedback

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Trigger

P0039 context and execution worked, but using a Logres action produced no local
button response beyond GCD/range/cooldown state.

That is insufficient before stock action-bar suppression.

## Runtime

Version:
`0.0.17-dev -> 0.0.18-dev`

Shared ActionButton primitive now adds:
- pushed texture;
- 0.18 second additive activation pulse on PostClick.

All current clusters inherit it:
- Primary;
- Secondary;
- Utility.

## Secret/protected boundary

Feedback is presentation-only.

It does not:
- inspect spell IDs;
- inspect spellcast event payloads;
- rewrite protected action attributes;
- claim button-specific ongoing cast association.

## Diagnostics

Action Check requires feedback readiness on all 36 current Logres action
buttons.

## Runtime proof

Required:
- mouse press response;
- mouse activation pulse;
- routed-key activation pulse;
- Primary/Secondary/Utility coverage;
- combat-safe behavior;
- no protected/taint/Lua/secret regression.

## Generation failures

Two P0040 generation attempts stopped on incorrect patch-script assumptions
about the current working-copy/checker shape.

Classification:
- generation tooling only;
- no WoW runtime evidence;
- no user-repo commit produced.

The generator was corrected, the current workspace inspected directly, and the
full repository validation suite rerun before packaging.
