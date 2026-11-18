# P0474 — L-037 quest cycle source header and keybinding category repair

2026-11-17. Authoritative GitHub main `0679b097417a2dc851da233675baa7bf0f1015b5`
tree `ab73a72679ca8d8831bb70680bb0d0883c52fcff`, P0473.
Source reconstructed byte-for-byte from pinned P0471 handoff and verified
P0472/P0473 payloads/manifest blobs; candidate HEAD/tree verified read-only.

## Real client negative result (NOT PASS)

User: "Almost nothing you describe was there." Attached Forever exporter
`2026-11-17T18:45:34-05:00` source/deployed/latest capture all
`0.0.341-dev`, no warnings. Incident #16018 session155 screenshot at
18:45:22 EST visibly shows focused quest "The Jasperlode Mine" but no Next
button. Incident addon-owned `activeQuest` has buttonReady=true,
cycleCandidateCount=0, cycleAttempts=16, lastCycleResult=cycle-quest-invalid,
lastQuestID=76, presentationShown=true. Directly observed is rejection of
some ordinary quest-log row; exact invalid value itself was not logged.
The source rejects numeric0. P0473 actual-source fixture converted 0 to
nil, masking the Forever header sentinel scenario. Hypothesis: a header
row returns0, not nil. Test under native0 fixture; do not claim that exact
client returned0 without row-specific instrumentation.

User also reports not seeing the expected keybind; P0473 Bindings.xml lacks
`category="ADDONS"`, so "Key Bindings > AddOns > Logres" was not grounded.
User's 16 invocation attempts do not establish a binding UI category.
WoW community source documents AddOns category assignment; binding now
uses category ADDONS and existing LOGRES header/name, no default key.

## Coherent correction

ReadCycleQuestIDs skips nil and numeric0 as non-quest sentinels, counts
skipped-zero rows for diagnostics; all secret/invalid/nonpositive-other,
failed API, cap and duplicate policies remain fail-open. No quest watches,
native quest selection or saved state written. Existing user-click-only
supertrack API remains the only native focus write. ActiveQuest exposes
last list reason and zero skip count via addon-owned Report Bug snapshot.
P0473 fixture returns0 unmodified and must pass after change; additionally
verify nil, negative, secret, malformed and count API refusal. No polling.
No world enemy, UI fallback, player/target aura, health, 50/50 or chat edits.

## Validation and limitations

P0473 was STATIC 336/336 PASS but Forever FAILED; static tests were
nonrepresentative. P0474 exact candidate/source, normal and forced-failure
canonical installer, manifest/hash and GitHub ownership audit required
before release. Test in Forever with 2+ quests (including header), confirm
chevron visually and clickable, bind AddOns category/actual execution, wrap,
compass, and one-quest absent behavior. Runtime P0474 UNVERIFIED.
See docs/memory/investigations/ISSUE_LEDGER.md L-037 and P0473 evidence.

## Assistant-side negative result

R0 candidate independently ran 337 static checkers: 335 PASS and P0448,
P0449 REFUSED because compact handoff used `# P0474 L-037:` instead of
required `# P0474:`. Corrected handoff; source behavior unchanged. This
failure predates release and was not applied to user files. Retest required.

R1 independent full source suite: 337/337 STATIC PASS after handoff repair;
new actual-source regression fails on the unchanged P0473 source and passes
on P0474. Changed Lua files parse in texlua (Lua5.3), Lua5.1 interpreter
not available. Canonical release ZIP/rollback tests remain required before
handoff. No WoW runtime claim.
