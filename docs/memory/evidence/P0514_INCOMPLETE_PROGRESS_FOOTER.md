## P0514 — L-005 unfinished quest footer removal (2026-11-23)

Verified P0513 main `7f0812d9`, tree `6cb1366f`. User screenshot
Forever 0.0.378-dev build 71037 shows Testing the Wells NPC narrative,
not-ready text, three required items and Goodbye in Logres: P0513
scoped visual PASS. User requests removal of View in Blizzard.
P0514 hides the read-only footer and its mouse region on all pages,
rejects read-only Continue dispatch, retains normal pager, automatic
stock fallback and restore-before-Goodbye. Ready Continue unchanged.
L-005 PARTIAL; P0514 runtime UNVERIFIED. L-061 OPEN; P0510/11 pending.
Evidence: `docs/memory/evidence/P0514_INCOMPLETE_PROGRESS_FOOTER.md`.

P0513 prior failure #23224 retained in P0513 evidence. The new screenshot
shows the three item names and quantities, but no bag counts; those are
optional and not asserted. No new claim, purchase, Goodbye click, native
fallback, combat or reward transaction was demonstrated. P0514 changes
only the owned read-only footer and its dispatch guard. The P0513 source
fixture and checker now assert the superseding UI policy while retaining
all original source, safety, restoration and ready-Continue checks.
No change to camera, trainer, compass, protected state or stock gating.
Exact-candidate suite and transactional package audit are release gates;
client outcome remains UNVERIFIED until tested. Previous pending natural
occurrence tests and L-061 missing recipe coverage are unchanged.
