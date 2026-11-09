# Screen Map V8 — correct pet-actions placement, retain party-frame offset

Date: 2026-11-09. Parent baseline: verified GitHub main P0422
`b8428a36fd091a7b70ed413afdd3434e082f1767`.

The user observed that P0422 incorrectly moved the pet **action bar** when the
intended change was the pet/party **status frame**. P0422 shifted *both* owned
regions right by one viewport percentage point. V8 corrects the interpretation:

| Owned region | P0421 (V6) | P0422 (V7) | P0423 (V8) | Effect |
| --- | --- | --- | --- | --- |
| Pet actions (`classPet`) | (9%, 50%) | (10%, 50%) | (9%, 50%) | Restore prior bar position |
| Allies/party status (`allies`) | (23%, 50%) | (24%, 50%) | (24%, 50%) | Retain intended +1% shift |

Only the `classPet` live runtime X coordinate changes in P0423. All other
approved V7 positions and frame dimensions are unchanged. The historical
[`SCREEN_MAP_V7.json`](SCREEN_MAP_V7.json) and P0422 evidence are retained,
including the user-observed misinterpretation. V8 is authoritative for runtime
positions after P0423; see [`SCREEN_MAP_V8.json`](SCREEN_MAP_V8.json) and
[`SCREEN_MAP_V8_REFINEMENTS.json`](SCREEN_MAP_V8_REFINEMENTS.json).

Pet-action slots, grid, bindings, contextual alpha, native secure fallback and
visibility drivers, P0420 read-only H.2 overlay, and OOC geometry recovery are
unchanged. WoW Forever test is still necessary before declaring V8 complete.
