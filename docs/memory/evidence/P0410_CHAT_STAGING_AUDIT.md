# P0410 — Verify exact Chat package staging

GitHub main P0409 at 9c9ec52403997ab63d659ad3d4d6ac12572941c9 verified. The user reports that the HUD cleanup requested in ordinary Chat worked on the second attempt. This is a scoped user runtime report. Individual panel toggles, protected fallbacks and the saved incident export were not separately attested in that report.

Both local JSON files use P0408 9a2df3ba8d8576ef87adbfd3bfe9e4a5aa39c074 as baseline. Exact R0 SHA-256 is 0a3f83845f1f73f0b0f35fe207d5ff09d70f87470f79afa7d4b50bf42c532386. Exact R1 SHA-256 is 5a19e9b0356abdf81862d488d8bb2e8f6ae7ac661790abea34851ebc4799b057. Both were reconstructed with the committed runner in isolated candidates. R0 refused at 276/278. The H.3 visual checker required HUD dock styling and clicks, and the interaction checker required the old uppercase CAST label in NativeAccess. The requested relocation removed those presentation details. The check gate stopped R0 before apply.

R1 passed 278/278 with the two legacy contracts migrated. The manifest includes both changed checkers. The first pushed commit d26a98e667f2f4872026bb55f4128eae43671c5a omitted those exact two files. Follow-up 9c9ec52 restored them. Every R1 payload file matches final main byte for byte. The local package succeeded, while the first commit did not capture all the verified files.

P0410 preserves all prewrite and postwrite guards. Review lists literal runtime-path references in checker sources, and the guide asks Chat to inspect those plus action identifiers before drafting. Apply prints a shell-quoted, package-derived staging command. Its trailing verify-staged step compares staged paths, exact staged file bytes and the manifest against the same JSON, and checks staged whitespace. Git reads and the stage command are separate. The user decides when to run staging, commit and push.

No runtime files changed. The historical P0409 payload and evidence remain available.
