# P0196 R1 failed user validation — corrected by R2 candidate

Observed on 2026-10-11; GitHub `main` remains `9097f43` (P0195). Both P0196 R0 docs-only and R1 runtime have **not been pushed**. The user explicitly reports "The buffs are broken this is not logres, it was fine before but you broke it" and provides a screenshot of two tiny, unframed icons where authored Logres framed player buffs previously appeared. The concurrent uploaded diagnostics at `0.0.105-dev`, loadCount 248, show:

- `Logres helpfulauracheck: PASS (... reason=native-replacement root=false ... slots=4 visible=0 shown=false ... presentation=native-full-helpful)` — PASS only meant internally consistent *suppression*, not user-approved appearance.
- `Logres native-surfaces: FAIL (desired=true folded=3 ... surfaces=petFrame:folded petActions:folded playerBuffs:folded targetAuras:stock error=onshow-hook-unavailable:targetAuras)` — a real runtime failure and an unsupported target fold.
- There is no evidence that full non-player helpful aura, target protected aura, pet right-click, or combat transition coverage passed.

Hypothesis verified statically against the exact P0196 R1 archive: its `change()` replaces `PlayerHelpfulAuras` behavior with `SetNativeOverride`; the custom `createAuraContainer` renders `HELPFUL` auras with 18px icon layout. R2 removes that native presentation takeover and restores the original P0195 Logres source and assets. This is a source-rooted correction; **R2 in-game outcome remains untested**.

Follow-up gaps: native player helpful coverage beyond original four authored slots (BU​FFS on-demand fallback remains), native contextual target Auras inability to accept `HookScript(OnShow)`, secure pet and stock restoration tests, any bottom-right overlap with user-owned Damage Meter. No blanket hooks/polling or stock click-region suppression justified by this evidence.
