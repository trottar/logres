# P0293 — bounded local trainer browse

Prepared against verified pushed main P0292 `a58cf78`, 2026-10-21. Adds locally controlled filter (All sampled / Available only), mousewheel and rail step navigation to the existing Logres-owned read-only trainer display; no native Blizzard filter, selection or transactions. A one-shot sample cap expands 12→64, with the 384 total service guard preserved. The same seven-row landscape creates reusable bindings; scroll/filter updates no native calls and no new panel frames. Preserve historical P0285 checks with adjusted explicit 64-sample bound. The prior visual-only P fixture and all native trainer controls remain intact.

P0293 static/WoW outcome is **UNVERIFIED** until user WSL and client validation. A source filtered by Blizzard before the sample cannot be reconstructed by the local All sampled display; this limitation is intentional. See evidence and CURRENT for the exact next action.
