# P0412 — Accept exact Chat fragments and prevent stale author checks

## Reproduction

Verified GitHub main P0410 at 7f702f668e61f7b881972f131149d23333f2f010. The exact P0411 JSON SHA-256 is ab6f6dab649939b9cc33693f7701933618acef746b8d57c1395c9defc8739fe8. Its edits in Dev/Panel.lua and CURRENT.md begin at unique line boundaries but omit a final LF in the edited fragment. The previous runner refused the first fragment during review. Neither package installed on the verified checkout.

The format-only R1 from the user's checkout passed review. Its exact isolated candidate failed four of 280 checks. The version policy rejected a literal runtime version in its new checker. P0374 capped the issue ledger at L-041 despite the valid L-042 proposal. P0393 and P0394 originally counted all click handlers after the merchant preview declaration, including an unrelated registrar section. Narrowing both checks to the merchant preview builder still finds four handlers, because P0411 inserts the registrar launcher inside that builder. The existing three-handler merchant contract therefore still refuses the draft.

## Prevention

The trusted runner accepts exact line-start fragments and validates LF on the complete file. Match uniqueness, baseline, path, UTF-8 and final-source checks still apply. Review warns about known pinned checker versions with the existing policy and excludes pure version bumps from the noisy checker-reference list. The policy continues rejecting pinned versions in the full suite. The ledger contract preserves L-001 through L-041 and admits valid sequential additions. P0380 now checks those historical rows directly rather than requiring a frozen range literal in a different checker. The merchant contracts count handlers inside the named merchant preview builder. Existing merchant safety checks remain.

This is a tools and memory patch. P0411 remains an uninstalled registrar draft. The next registrar package needs a fresh baseline, dynamic TOC/Bootstrap version parity in its checker, and a registrar preview route that preserves the merchant preview's existing controls. Client behavior is unverified.
