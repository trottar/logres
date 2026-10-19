# Current Handoff — P0261 N1 narrative/live fixture model

Authority: `docs/memory/CURRENT.md`, D-046, D-047, `docs/memory/evidence/P0260_MODULARITY_SOURCE_AUDIT.md`, `docs/memory/evidence/P0261_N1_NARRATIVE_MODEL.md`.

Verified GitHub main `1251434` confirms P0260 pushed. User requires every preview to map **through the same model and actual renderer** to live functionality, without breaking working quest UI, native fallback, or working camera. P0261 is the first narrow N1 change: adds pure Quest/NarrativeModel with already-guarded live offer inputs and deterministic long/short/generic fixtures. All call existing `QuestDialogue:PresentText`; no frame clones or other live interaction behavior changes. Adds two P-tab previews. Generic gossip is visual narrative only, NOT real option selection. Version 0.0.159-dev prepared; runtime unverified.

P0261 candidate requires full shadow/postwrite checks, user commit/push verification, then visual/regression validation. Camera source frozen, live selection/claim and 20-minute-session bugs OPEN; quest 237 reserved. Only after N1 acceptance proceed to N2 view extraction.
