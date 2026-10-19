# Current Handoff — P0260 modularity source audit

Authority: `docs/memory/CURRENT.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`, `docs/memory/evidence/P0260_MODULARITY_SOURCE_AUDIT.md`, `docs/memory/evidence/P0260_ALL_NPC_INTERACTION_ATLAS.md`.

Verified P0259 pushed: GitHub `main` `669ec77`. **P0260 is docs-only and pending user apply/push.** Source audit covers 56 tracked Lua modules by domain, 54 provisional NPC service/variant entries (not proof that all exist in Forever), current model/renderer split, preview coverage gaps, source/action coupling, NPC lifecycle and stock ownership. Quest Dialogue remains coupled; RewardModel/RewardVisual is the accepted first exemplar. Existing camera handling detects NPC frames and separately watches service events, but **camera is a frozen working baseline**: do not edit camera source, alter DynamicCam handling or add camera hooks during modularity.

After P0260 push verification: N1 pure narrative/decision model contract and inert P-tab fixture, followed by narrow extraction, regressions, and only then post-modularity all-NPC feasibility. No native merchant/bank/auction transactions. Quest237 reserved; real selectable claims, native claim flash, and user-noted other gameplay bugs remain OPEN. **No WoW redeploy for P0260.**
