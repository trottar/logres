# P0458 — Multi-secondary aggro ownership (2026-11-15)

## Baseline, negative evidence and exact defect

GitHub main `ff860151de8c95dab99d177e2d4180011fd6da55`, tree
`ddfca65ddf835b8451aaf5b1772c0206daa22064`, P0457 version
`0.0.326-dev` verified independently. P0454 first single-secondary
50%/50% trial flickered in Forever session 119 #12547/#12549. P0455
ignored unrelated event tokens, but 0.0.324-dev #12628/#12630 still
VISUAL FAIL with 2 attaches/2 detaches. P0456 suspended that feature;
P0457 modified the already-accepted selected owner and left 50% disabled.
The user's longstanding failure is ONLY the non-targeted enemy with aggro.

Direct P0457 source: `ObserveSecondaryAggroTrial` has one
`worldEnemySecondaryTrialUnit`, explicitly skips a different secondary,
and interprets `decision ~= eligible` (including a missing/no-table
observation) as mandatory hide/restore. A local execution of original
logic reproduced eligible → missing → eligible as attach→native
restore→attach; this was not a secure WoW runtime test. Original static
P0454/P0455 assertions demanded the broken teardown semantics. Their
historical failures are retained, but their checkers now enforce safe
restoration rather than requiring flicker by construction.

## Split observation from ownership

`WorldTargetProbe` is still read-only. Its independent ordinary basic
threat status 2/3 (P0453 Forever corroborated 11 primary samples) plus
same-event secondary role, safe anchor, hostile, attackable, in-combat,
enemy-in-combat and targeting-player observations authorize a new claim.
Detailed threat may remain secret without contaminating basic ordinary
qualification. Ordinary basic status 0/1 is *confirmed loss*. Ordinary
negative combat/targeting, unsafe role/anchor or friendly/neutral reaction
withdraw immediately. A missing, secret or failed basic threat datum
is only *inconclusive* after the remaining ordinary safety checks.
Unknown role or unsafe anchor is never a reason to retain an overlay.
No inference from a merely visible plate or targeting-player alone.

## Ownership lifecycle / limitations

40 UIParent, unprotected, input-disabled 50%-scale, 50%-alpha name/health
frames are precreated only when OOC. An independently eligible secondary
gets one slot, native name/health alpha restoration tokens, and no touched
cast/aura/click/raid/CC regions. Same-owner events update only health/name
native consumers; they never hide/reanchor/reclaim. An inconclusive source
may hold an existing, still-safe same-identity claim for 3 successive
nameplate events; event 4 restores stock. It never creates a new claim.
Unrelated non-nameplate events cannot affect claims. A fresh ADD after
GUID mismatch or absent GUID starts a new generation; REMOVE invalidates
it, only the matching unit restores. An ordinary GUID supports identity
on events missing ADD. Secret/missing GUID is never inspected or compared;
ADD generation may establish identity instead. GUID-only claims are
withdrawn if GUID becomes unreadable. If identity cannot be proven, leave
native stock. A client that silently reuses nameplate tokens without an
ADD event and with secret GUIDs cannot offer complete identity proof;
that exact environment must fail open when its event boundary is unknown.

Selected 100% source and aura-screen handoff unchanged. Target promotion
releases only promoted/unknown-role secondary before new selected claim;
previous selected token when ordinary can be event-time requalified as
demoted secondary. Other secondary owners are not torn down. Combat end,
World Enemy OFF, immersion OFF, nameplate removal and capability loss
restore every relevant claim. Any native SetAlpha restoration refusal
keeps the original opaque token and quarantines the slot, retries on the
next unit/regen/OFF event, never reuses it or declares success. A refused
Hide remains quarantined. Exceeding 40 simultaneously qualified secondaries
retains stock and increments `poolExhaustions`; no unbounded combat frame
creation or nameplate enumeration. Pool cap is an explicit fallback, not a
claim of guaranteed unlimited simultaneous owners.

## Tests and acceptance still needed

Static candidate and mocked-source behavioral runs cover multiple owners,
steady updates, eligible/no-table/eligible, unrelated events, bounded
unknown, loss, removal, target promotion/demotion, token reuse, refusal,
pending restore recovery, OFF, pool exhaustion, and refused mutation.
They cannot prove Blizzard restriction behavior or visual smoothness.
Only Report Bug during natural multi-enemy Forever play can establish
client acceptance: selected remains 100%, at least two independently
qualifying non-targeted enemies render 50/50 without oscillation, native
auras/casts/clicks work, confirmed loss/removal/OFF restore, zero taint.
P0454 and P0455 visual failures remain OPEN; L-011 PARTIAL/L-028 OPEN.
