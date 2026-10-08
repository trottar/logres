# P0171 — Phase H.1 scope drift and patch-delivery failures

Date: 2026-10-08. Classification: **OPEN PRODUCT-INTEGRATION FAILURE; multiple CLOSED DELIVERY DEFECTS; narrow runtime successes preserved**. Based on user correction, user-supplied 2026-10-08 gameplay screenshot and diagnostics, and verified repository `main` through P0170 `95aaa593`.

## Requested goal versus delivered result

The user repeatedly requested removal of **all redundant Blizzard UI with working Logres matches**, completion of missing replacement or on-demand fallback for other conventional surfaces, and moving Logres elements as one coordinated, efficiently testable job. The screenshot showed many stock controls alongside Logres and disproved the assertion that almost all default presentation had already gone. The assistant nonetheless repeatedly narrowed the work to one isolated domain and proposed proceeding to H.2 polish before the original coexistence objective was met.

## Confirmed errors and negative evidence

1. **Premature scope completion (P0164/P0165).** Assistant called H.1 complete although the new Phase H suppression was merely normal quest Accept/Decline controls, while some earlier D/C suppression already existed. This confused prior implementation with the requested whole-screen result. Later reopened.
2. **False screen-wide claim.** Assistant told user that every complete working match was already suppressed, without checking the screenshot. User's screenshot showed native-style action bars, pet controls, Objective Tracker, minimap, XP bar and micro-menu still visible. The lower-left portrait is pet, not proven failed PlayerFrame suppression; DPS and Issue Reporter ownership are unverified. An addon diagnostic does not prove disappearance or absence of invisible click regions.
3. **Repeated scope drift.** P0168 expanded ordinary quest-offer shell suppression; P0169 added only native Bar 4/5 clusters and spacing; P0170 corrected only P0169 startup. These narrow scopes can be legitimate building blocks but did **not** fulfill the user's repeatedly stated integrated removal/positioning request. Presenting each as the next endpoint repeatedly postponed main, pet, minimap, tracker, XP and menu work.
4. **False diagnostic PASS in P0169.** First post-login `stockreplacecheck` emitted PASS even with `requested=false applied=false` and Bar 4/5 source unreadable. The later Run All changed preferences and recovered. P0170 fixed the observed startup gating: 0.0.87 first check expected/requested/applied=true, one deferred retry, Bars 2–5 alpha zero/routing active; this must be credited only for the observed path, not screen-wide completion.
5. **Generated ZIP errors and inadequate pre-delivery validation.** P0167 R0 used a missing `ACTIVE.md` anchor; P0167 R1 used a `write()` helper with incorrect arity and included `__pycache__`; P0168 R0 checker demanded a nonexistent `visualSnapshot =` string; P0170 R0 demanded wrong indentation in `Commands.lua`. Each failed before tracked writes in the user's checkout. Repeatedly burdened user testing despite claims of preflight. Corrections R1/R2 preserve these negatives. A zip compile or individually passing transform is not proof that the exact generated candidate passes the whole suite.
6. **Stale authoritative status.** P0170 pushed at `95aaa593`, and runtime success was observed, while CURRENT/handoff and several roadmaps still called P0170 an untested candidate. Advance memory only by verified push/evidence and ensure current records match.

## Required process correction

- Treat the user-approved whole-screen removal and positioning as the **single current product objective**; maintain one explicit ledger of remaining domains with information/control replacement, secure constraints, stock restoration/on-demand access, visual ownership and test status.
- Implement missing control/info or deliberate safe on-demand stock fallback **instead of using a missing feature as indefinite excuse**. Do not suppress an unsupported protected control or remove information without its safe replacement.
- Prefer one coherent multi-domain candidate and **one combined in-game validation**. Split only when supported evidence demonstrates an essential secure/secret API blocker; record the specific blocker and scope, never silently call H.1 complete.
- Use repo-derived source and accepted design, not requests for data already in the repo. Validate exact baseline anchors, candidate transformations, all `tools/check_*.py` and `git diff --check` **on the complete generated shadow candidate before delivery**. Never report runtime pass from static-only checks.
- First prove visual presentation with a gameplay screenshot and real mouse/hotkey/restoration, in addition to addon-owned diagnostics. The screenshot, prior runtime negatives and user's correction outrank optimistic summaries.

Status: **OPEN** until a coordinated implementation and combined runtime evidence demonstrate the remaining coexistence resolution. P0171 itself is a docs-only correction, not an implementation/runtime pass.
