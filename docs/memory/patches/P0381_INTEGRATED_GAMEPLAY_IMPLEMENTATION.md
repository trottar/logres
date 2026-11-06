# P0381 — Forever quest Continue, Complete Quest input and gossip ownership

GitHub baseline P0380 R4 main `ed11249f4ae798a812c8964bd008dca0016820fe`. Runtime candidate `0.0.265-dev`; full static suite expected 251. Implements guarded ordinary QUEST_PROGRESS transition using the original Logres Accept control and stock adapter with restoration before Blizzard's native progress handler; raises the shared completion action input priority without changing native choice/claim; hides Logres gossip immediately when parking is unavailable. Prevents duplicate gossip read-only/native windows without blanket suppression. All other reported issues remain tracked and not silently resolved. Evidence `docs/memory/evidence/P0381_INTEGRATED_GAMEPLAY_IMPLEMENTATION.md`. No WoW runtime PASS; L-002 OPEN, L-005 PARTIAL, L-001 OPEN, other issues remain OPEN/PARTIAL.

The transactional one-time applier checks the exact HEAD, clean tracked state and modified baseline blobs, prepares all patch-owned source and records, runs complete static suite before writes, audits changed-line whitespace, writes changes, reruns suite and `git diff --check`, creates a local manifest only on success. A refusal is not a commit, not a fix, and not runtime acceptance. User alone commits and pushes; verify remote main before advancing.

## P0381 R0 refusal and R2 contract reconciliation

The original P0381 R0 **REFUSED PREWRITE at 77/251** on P0241 due to a direct
`pcall(CompleteQuest)` call in the dialogue source; zero tracked writes. R2
removes this direct quest mutation. Its guarded Continue uses the Blizzard
progress handler and restores native UI first. The historical P0379 checker
expected a completely stock-owned progress presentation; P0380
explicitly authorized a Logres Continue replacement. R2 changes that checker
to require the guarded native handoff without removing its direct-mutation
ban. Full static candidate validation is REQUIRED and not claimed here.

## R2 REFUSED / R3 scoped checker repair

R2 refused at its own checker, 217/251 PREWRITE, with no tracked writes.
The checker matched the global `active = true` module declaration rather
than `Live.TryShow`'s post-parking success assignment. R3 preserves the
entire runtime candidate while fixing only the scoped P0381 checker and
updating durable refusal evidence and active roadmap text. This is static
contract repair; no independent WoW runtime PASS or claim is implied.

## R3 PREWRITE refusal / R4 exact-payload checker repair

P0381 R3 **REFUSED PREWRITE at 217/251** on its own new checker:
`missing candidate negative evidence: docs/memory/patches/P0381_INTEGRATED_GAMEPLAY_IMPLEMENTATION.md`.
Its generated patch record lacked the literal `UNVERIFIED` marker that the checker
required, even though it described the WoW gameplay as not yet tested and
retained L-005 PARTIAL. No tracked writes or manifest occurred. This was
assistant-authored payload/checker self-inconsistency, not a WSL or gameplay error.
R4 repairs the record explicitly; **WoW runtime remains UNVERIFIED** and
**L-005 remains PARTIAL/FAIL**. The other unresolved issues remain OPEN/PARTIAL.
The checker is executed against the R4 **actual packaged record**, not a
substitute fixture record. Full 251 PREWRITE and POSTWRITE runs remain required.
