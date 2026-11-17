# P0469 — Panel chat access

2026-11-16. Baseline verified GitHub main P0468
24790ed2fdbd8a8434f03f49d505f753e92f345c; tree
1f4ff9677c5d4ee6425c76caf4e8d8bff7606ca3. User requests chat toggle in panel.
Feature request, not an inferred gameplay failure; no new L-ID.

N Native UI appends Chat [AUTO]/[SHOW] after the original nine controls.
SHOW restores the Quiet Mode snapshot; AUTO resumes existing suppression
only when immersion is enabled in world context. Instance/immersion OFF
retain native chat. Session-only override resets on reload like stock access;
Stock-all retains its original five domains. No saved preference/schema change.
Command chat on/off/auto/toggle/status routes to the same controller seam.
Only Quiet Mode is reconciled on click; no world/nameplate/aura churn.
Labels report addon intent, not inspected native visibility or guaranteed success.
Failed restoration remains visible in command/panel results and Quiet Check.

D-025 no ChatFrame Hide/Show, saved-window mutation or communication changes.
Existing snapshot/restoration, outbound edit box and event-driven reconcile are
unchanged. A queued reconcile checks requested state after SHOW and cannot
resuppress chat. All independent diagnostics include the manual override.
P0468 aura grid and accepted enemy presentation remain unchanged.

Historical quiet/context/restoration and P0358/P0361/P0409 contracts inspected.
P0409 exact-nine assertion migrated to preserve exact original nine plus one
explicit Chat entry, without weakening other stock/Report Bug gates.
Mandatory exact-candidate full suite, Lua syntax/source fixtures, ZIP refusal,
rollback, manifest and diff hygiene run before delivery; see audit receipt.
No WoW client available: toggle visibility, restoration, outbound entry,
reload/context/combat/taint acceptance remain UNVERIFIED. No gameplay PASS.

Validate: /logres panel > N > Chat [AUTO] -> [SHOW] -> [AUTO] in world.
SHOW restores prior native presentation; AUTO suppresses passive chat only.
Press Enter and cancel to verify outbound edit box remains usable in AUTO.
Phase D > Quiet Check and Immersion Check; inspect PASS or reported errors.
Report Bug captures failures; /reload flushes diagnostics, then export locally.

Additional user steering: L-052 player helpful rows grow UP (positive stride),
first row and four-column/40-slot/source safety unchanged. Native BuffFrame
fallback unchanged. L-053 Status Aura Preview respects explicit screen enemy
OFF: synthetic target rows become empty with reason preview-target-frame-disabled;
player harmful preview remains at its own anchor. No live/native/world aura gate
changed. Supplied screenshots inspected individually in conversation. Client
UNVERIFIED. P0468 capacity request stays OPEN pending client coverage evidence.

Construction negative results: first isolated transform refused an ambiguous
two-status anchor (no real checkout writes); both status snapshots now explicitly
gain manualOpen. P0468 checker pinned0.0.336-dev contrary to version policy;
migrated to dynamic TOC/Bootstrap parity, preserving all aura/source gates.

P0469 R0 author preflight REFUSED CURRENT=9828 bytes before full suite;
isolated memory note compacted, no user tracked writes or ZIP release.
P0469 R1 preflight also REFUSED handoff=8053 bytes; compacted repeated
owner summary while retaining failure/history markers. No user writes.

First full candidate:331/332 PASS, P0175 disabled-snapshot shape check
REFUSED because new preview block separated its end from self.last assignment.
Moved preview policy after snapshot caching; same table, no live behavior change;
original disabled snapshot contract retained unchanged. No user writes.

Corrected exact candidate:332/332 STATIC PASS, actual-source chat transition
and P0468 grid/preview fixtures PASS, version-policy PASS. Canonical final
package PREWRITE/POSTWRITE, rollback, refusal and Lua syntax audited separately
in the delivered package receipt; client UNVERIFIED.
