# P0263 — N3 shared decision-button visual factory

2026-10-18. Baseline `main` `36d43f6` verified. P0262 R1 received user visual acceptance for 5 P-tab previews and pagination; `0.0.160-dev` diagnostics report scoped PASS, with no live claim. This patch relocates the actual common button factory and cosmetic hover/pressed presentation to `UI/DecisionVisual.lua`. The original two button instances, click closure, protected/native controllers, offer/completion positions, previews and camera remain unchanged. See `docs/memory/evidence/P0263_N3_DECISION_VISUAL_EXTRACTION.md`.

**Candidate only** until the one-time applier reports complete prewrite and postwrite static PASS, followed by user visual acceptance. Future N3 generic inert decision fixture states and N4 gossip options remain explicitly pending. P0262 R0 prewrite failure and the historical live claim flash/choice-unverified statuses remain preserved.

## R0 package failure and R1 correction

R0 omitted `P0263_PAYLOAD/DecisionVisual.lua` despite requiring it, so the user received `ERROR REFUSE payload missing DecisionVisual.lua` at the prewrite baseline gate. No tracked mutation and no static or runtime PASS resulted. R1 adds the file and an equality check between packaged and generated view before the shadow suite. P0263 implementation and gameplay ownership otherwise unchanged. Do not count R0 as a successful application.
