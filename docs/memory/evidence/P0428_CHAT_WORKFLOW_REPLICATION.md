# P0428 — Audit of the successful ordinary Chat run

Date 2026-11-10. Verified GitHub main and local tracked HEAD at
`aef719b582c98ca60502734723287f64beaca0e6` (P0427). The user described the
latest Chat as successful over multiple updates.

## Evidence and coverage

The available transcript of “Handoff declined” covers P0425 refusal and
repair, user visual acceptance, P0426 memory and P0427 handoff. For the
earlier checkpoints, use the downloaded archives, author receipts, Git
parents, committed manifests and repository evidence. Those records establish
the delivery sequence. They do not establish what Chat said in earlier turns.

| Checkpoints | What was independently checked |
| --- | --- |
| P0415 `43efc89` | Committed manifest reports 283/283 PREWRITE and POSTWRITE. A separate R2 author receipt records its baseline archive and package digest. No downloaded release ZIP was available for parity testing. |
| P0416 `d11b76a`, P0417 `bc91448` | Reconstructed JSON changes against the exact Git parents. 21/21 and 14/14 paths match committed bytes. Embedded author receipts match the exact inner JSON SHA-256 and record 284/284 and 285/285. |
| P0418 R1 `e4fcc31`, P0419 `c1e23fc`, P0420 `bd55e34`, P0421 `ac37344` | Exact-parent JSON reconstruction matches 23/23, 14/14, 16/16 and 19/19. P0418 R1 embeds a JSON-bound static audit. P0419–P0421 embedded receipts omit an explicit package SHA-256 field. Committed manifests record full pre/post checker counts. |
| P0422 `b8428a3`, P0423 `f283202`, P0424 `80b46f4` | P0422 raw payload matches 19/19. P0423/P0424 exact-parent JSON reconstruction matches 18/18 and 17/17. P0422 manifest reports 13 focused checks. P0423/P0424 manifests report 291/291 and 292/292 pre/post. |
| P0425 R1 `5af8d14` | Replayed the plan against the exact P0424 parent, including five anchor-edited paths. All 22/22 final files match. The committed manifest reports 293 checks. The user accepted the two NPC layouts visually. |
| P0426 `32451c2`, P0427 `aef719b` | Raw payload matches 13/13 and 21/21. Manifests record 294/294 and 295/295 static checks. P0426 captures visual acceptance and compass intake. P0427 implements label formatting only. Client validation of P0427 is UNVERIFIED. |

The 12 successful ZIPs in the table account for 217 verified changed files,
excluding generated manifests. P0425 screenshots were described in the chat
and committed evidence. Their original pixels were unavailable in this
audit. The visual PASS is user-reported and scoped to Buyback alignment and
the compact trainer layout. Transactions, recovery and fallback remain
UNVERIFIED. See [P0426 evidence](P0426_NPC_VISUAL_AND_COMPASS_INTAKE.md).

## Practices to repeat

- The user gave a concrete goal, approved layout data, or a screenshot and
  Report Bug capture. Chat read source and chose a small, owned change.
  P0425 separated reversible native merchant geometry from the addon-owned
  trainer catalogue. P0427 separated label formatting from quest-provider
  freshness and eligibility. Reuse those scope boundaries.
- Most checkpoints used exact-parent JSON and the checked-in runner. The
  successful JSON results reconstruct to the bytes on main. P0416/P0417
  receipts are useful examples of binding author checks to the inner artifact.
- Chat diagnosed the P0425 refusal from the actual command output, corrected
  it against the same P0424 parent, and verified the push before continuing.
  It recorded user acceptance at its actual scope in P0426 and delivered
  P0427 separately. Keep the refusal, commit verification and client evidence
  as separate events.

## Gaps and corrections

- **P0418 R0 and P0425 R0 escaped author preflight.** User appliers refused
  before tracked writes, at 283/286 and 248/293 respectively. P0418 involved
  roadmap and Report Bug ownership contracts plus a dependent check. P0425
  involved a pinned runtime version, obsolete trainer geometry assertions and
  active-memory constraints. The completed revisions match their commits.
  Check the final artifact on an exact disposable candidate before handoff.
  The user's first apply should be independent confirmation of the author run.
- **P0422 was an intent error.** It moved both pet actions and party status
  when the user meant party/status. P0423 restored pet-actions X while
  keeping the intended status adjustment. Static parity could not detect the
  mistaken scope. Match the screenshot region to the authored layout key
  before editing and state the intended coordinate delta.
- **Installer guarantees drifted.** P0422 checked baseline file hashes but
  did not verify Git HEAD. It copied files before checking new hashes, ran
  only 13 focused post-write checks and had no rollback. P0425 R1 prechecked
  a complete candidate and restored written files on in-transaction failure.
  P0426 and P0427 ran full prewrite checks and checked installed bytes and
  diff hygiene, but their installers could exit after a write without
  rollback. Standardize on the committed runner or canonical builder, test
  their real refusal and rollback paths, and bind receipts to the final bytes.
- **Keep handoffs local and exact.** P0427 used a broad Windows users-directory
  search for the ZIP. Use a known Downloads path or a file already placed in
  the checkout. Match staged verification to the package format. P0425's
  Forever deployment example omitted the mandatory beta handoff block.
  Include the project block plus the actual Forever deployment target when
  runtime testing is required. For a capture, use Report Bug when it covers
  the needed fields. Request a specific panel action only when additional
  information is needed and explain what it supplies.

The [Chat workflow](../patches/CHAT_TO_ZIP_WORKFLOW.md) is the operational
checklist. This checkpoint records process only. P0427 runtime retest and
the separate QuestieDB freshness/missed-giver investigation remain pending.
