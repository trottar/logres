# P0408 — Prevent stale Chat patch checks and enforce runtime opt-in

## Reproduction

Verified P0406 main e093bed4e1454f63a18c488206855f28559b87fa. The two local copies of Chat's P0407 package match SHA-256 265eb793b64abd2bf90a033e5d696c6d04cf29901ccd776b9624cc524da9e498. It contains 12 changed paths, including an innkeeper preview, a new checker and a TOC/Bootstrap bump. It passed parsing, exact source anchors and diff review.

The original P0406 apply was replayed in an isolated checkout. PREWRITE reported 276/277 passing. The sole failure was check_p0381_integrated_gameplay_contract.py, which required every active roadmap to start with P0406 even though CURRENT and the roadmaps agreed on P0407. The isolated checkout had zero tracked changes after refusal. No ZIP or manifest remained. The complete suite independently reproduced the same sole failure.

The ordinary Chat request was an innkeeper investigation with a read-only boundary. P0407 was a preview implementation. That scope mismatch is separate from the failed checker. P0407 stays rejected and its runtime changes are outside this repair.

## Prevention

The historical checker now derives the active checkpoint from CURRENT and continues to require historical P0381 through P0406 entries. Future checkpoint promotions use the same checker. The check command validates the exact candidate and returns every failing checker. Review reports its diff-only scope. Normal apply retains its own prewrite and postwrite guards. Runtime changes require explicit caller opt-in. The workflow guide now separates investigation reports from implementation packages.

The candidate is tools and memory only. Innkeeper presentation and transactions remain unchanged and unverified.
