# P0476 — L-035 source-identified NPC near-center and L-002 flash provenance

2026-11-17. Verified GitHub `main` P0475 `6447b501ecfc6ca20a75f1655732e3bf3f7ca494`, tree `2c21f42affb66d7e06f1f3122cdf109a992cd5e7`.
User reports two current issues: (1) a Blizzard popup visible for about one
second apparently randomly during NPC interactions; (2) service/NPC compass
markers drastically offset or pointing behind the character when very close.
User believes most older bug reports fixed or not recently observed. This is
not sufficient to close them: retain statuses and triage them as dormant.

## Source observations, bounded intervention

The Compass add() path already centered `questLinked` markers <=3 yards and
retained center below 4 yards if previously centered (P0376; L-035 OPEN).
Source-identified QuestieDB `service` markers with ordinary `npcID` used raw
relative bearing and were filtered outside the visible half-angle. This
explains a possible near-zero-distance flip; it does NOT prove every user
misalignment was caused by the bearing, nor that QuestieDB coordinates are
correct. P0476 applies identical hysteresis only to service/NPC candidates.
A secret/unavailable/unknown NPC ID does not qualify; POIs, tracking and
manual waypoints retain existing logic. Existing source cap, priority,
collision handling, range and fallback remain unchanged. A new addon-owned
`serviceNearCenteredCandidates` counter supports scoped client validation,
and Report Bug records only this addon-owned compass candidate state.

Quest Dialogue already traces `native-handoff-held` and `native-handoff-restored`
and addon root OnShow/OnHide. It restores protected Blizzard quest interaction
when native fallback is necessary. This evidence does not identify the frame
responsible for the newly reported brief popup. P0476 records last Logres
handoff reason/result, held/restore counts, pending state, and Logres-owned
stock/quest presentation state in the Report Bug snapshot. No Blizzard frame
readback, HookScript, broad Hide, protected mutation, or new timer is added.
The flash remains **OPEN / INTERMITTENT / owner UNKNOWN**; a captured natural
recurrence is required before a targeted suppression or transition repair.

## Validation

P0476 candidate must pass full static historical checks, a source-backed
3/4yd Lua fixture, syntax, exact payload/applier/rollback and git diff check
before handoff. Static PASS never means in-client PASS.
WoW Forever runtime acceptance is UNVERIFIED.

After deployment: at a nearby known service NPC (repair/vendor/inn/etc),
move within <=3yd (marker centers), across 3–4yd (holds), then >=4yd
(marker resumes normal direction). Existing focused quest marker behavior
should be unchanged. Phase E Compass status / Report Bug exposes the addon
counter. No travel is required solely to manufacture proof.

If the transient NPC popup occurs in normal play: click Report Bug as soon
as practical, export `python3 tools/export_panel_diagnostics.py`. Inspect
`questPresentation.nativeHandoffPending`, held/restored counters, last
reason/result, suppression state and retained bounded quest event journal,
plus screenshot. Do not infer native frame ownership from counters alone.
Do not mark L-002 resolved on a static check or a session without recurrence.

## Assistant static-audit negative result

R0 independent full run passed 336/338, but historical P0456 and P0473
memory contracts refused: the first P0476 CURRENT summary omitted their
required exact historical markers. R1 restores the strings without
changing runtime behavior. The failure was isolated to the assistant
candidate, never deployed and not evidence that WoW behavior changed.
Full R1 audit and ZIP installer gates must be completed before release.

R1 parallel full suite then passed 335/338; P0436, P0437 and P0438
historical contracts refused because the compact CURRENT omitted the
literal `P0425 visual PASS`. R2 restores this exact marker without
changing the Compass/Dialogue/Report Bug implementation. Client result
remains UNVERIFIED. Final exact candidate needs a complete rerun.

R2 independent full audit **338/338 STATIC PASS** (six checker processes);
changed Lua parses, source-backed near-centering fixture and version parity
PASS. Four negative installer guards and byte-for-byte rollback PASS in
isolated reconstructed P0475 checkout. Canonical applier PREWRITE/POSTWRITE
on final packaged bytes remains a separate release gate; WoW UNVERIFIED.
