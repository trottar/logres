# P0304 — reusable NPC session; trainer opens automatically

Baseline `4f7f9b5` (P0303, 0.0.204-dev). User reports P0303 no-regression in game. P0304 adds source-neutral session registration/open/dismissal infrastructure and enables automatic trainer presentation on a native trainer show event or normalized interaction state. Native source/transactions and Blizzard UI stay untouched; this is an intermediate lifecycle gate, NOT a claim that stock suppression works. No images or visual redesign.

Runtime changes: new `UI/NPCServiceSession.lua` after existing lifecycle load to preserve static ancestry; `TrainerLiveTrial.Disable` informs the session about deliberate Goodbye/OFF or post-purchase dismissal. P0304 checker preserves legacy P0303 data extraction, P029x sample, P0301 purchase, P0302 hover and quest fixture contracts. Requires full check suite PREWRITE/POSTWRITE, version/memory/whitespace, native Blizzard fallback and in-client test.

Upon runtime PASS, next is a capability-gated native stock visual suppression and restoration design/test. Once trainer is finalized: native gossip, merchant and flight master. Prior P0303 R0 2/174 PREWRITE failure remains recorded in P0303 evidence.
