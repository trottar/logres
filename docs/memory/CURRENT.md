---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finish consistent Logres trainer presentation, safe source-backed transactions and recoverable Blizzard fallback for class, profession and empty-source NPC sessions. Preserve accepted artwork. Then proceed to gossip, merchants and flight masters.

## Current Work Item
**P0310 R2 — shared NPC empty-catalogue state and profession trainer empty-session shell; PREPARED / WSL and WoW UNVERIFIED.** GitHub main P0309 `5d27a06` independently verified. User confirmed one Logres-initiated Enchanting single purchase/learning and class trainer behavior remained correct; Cooking catalogue visible; Fishing at Grimnur returned an ordinary native service count of zero and previously showed Blizzard only. User requests the SAME Logres trainer interface even when all services are learned, unavailable, or a profession is not owned. R0 stopped with 9 static checker failures. R1 kept preview slash-only and was rejected as not following panel workflow; R2 explicitly registers the dedicated P action and migrates affected static inventory assertions. This change renders the exact existing landscape with an explicitly disabled informational empty-state row and lower details when a guarded profession trainer reports zero services. It does not infer why there are none or invent profession acquisition/purchase. Stock stays visible and usable.

## Verified State
- P0309 pushed main `5d27a06`. User screenshot and statement confirm one Enchanting skill was bought and learned from Logres, with class trainer still working. **Profession single purchase runtime PASS within exercised Enchanting scope**, not generalized profession bulk or offscreen purchases.
- P0308 class-only Logres visible with Goodbye native close and no stock popup USER PASS. Prior class single and Train All purchases, search, filtering, hover and scrolling remain scoped PASS; a purchase while native ClassTrainerFrame is parked is not separately proven.
- P0307 Fishing Grimnur with normalized trainer type 7, `IsTradeskillTrainer=yes`, native ClassTrainerFrame ordinary/shown, `GetNumTrainerServices=0`: **source-empty**, not evidence of whether Fishing is known or learnable. P0310 will show an informational Logres shell in that case without concealing Blizzard. Unowned profession sessions remain **UNTESTED**.

## Next Action
Apply guarded P0310 on clean exact P0309; require full PREWRITE/POSTWRITE static checker suites, diff/whitespace, manifest and source hashes. User commits/pushes; verify main. Deploy `/reload`. For synthetic visual proof use `/logres nativetraineremptypreview` (standalone inert alternate preview); original P — Previews → **Trainer Skin Art Preview** remains unchanged. Inspect the same parchment geometry, disabled row and lower explanation. At Grimnur Fishing trainer with zero native services, Logres should appear automatically showing the same empty state while Blizzard remains visible. Clicking row or training actions must do nothing. Goodbye dismisses Logres only for professions. Confirm Enchanting/Cooking and class trainer unchanged. No purchases required.

## Success Criteria
The same shared Landscape.Render handles preview and live zero-service profession snapshots. Source catalogue remains genuinely empty; placeholder row has no service index, no selection action, no costs, no transaction permissions. No profession acquisition inference or purchase from zero native services. Stock trainer remains visible; no native parking for empty, hidden click regions, polling, source spoofing, camera changes or unverified transaction calls. Synthetic P remains inert. Preserve existing class and nonempty profession behavior exactly.

## Do Not Reopen Without New Evidence
Do not call an empty service list proof a profession is already learned or not owned. Do not fabricate a Learn Profession offer. If a genuine acquisition service appears as an ordinary native available row, the existing profession single-service controller validates it; without an offer, Blizzard remains fallback. Never generalize one Enchanting purchase to bulk professions. Retain the P0303/P0307 checker failures and P0304 auto-entry failure as history.

## Relevant References
- `docs/memory/evidence/P0310_TRAINER_EMPTY_CATALOGUE.md`, `docs/memory/patches/P0310_TRAINER_EMPTY_CATALOGUE.md`
- `docs/memory/evidence/P0309_PROFESSION_SINGLE_TRANSACTION.md`, `docs/memory/evidence/P0307_TRAINER_FAMILY_DIAGNOSTIC.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
