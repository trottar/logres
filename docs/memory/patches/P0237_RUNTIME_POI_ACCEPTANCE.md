# P0237 — Accept P0236 POI runtime and defer refinement

GitHub `main` P0236 `e6179b8` verified. Uploaded `0.0.139-dev` loadCount 311 records QuestieDB service capability ready (13 supported categories, 5 within 50 yards, 31 cached service spawns), 4/4 service glyphs and 2/2 historical quest-giver glyphs in final Compass Check. Six local glyphs have measured distance-sized scales 0.8366–1.1874; ordinary compasscheck PASS. User reports the broad POI presentation works nicely and requests that final refinement occur with the rest of the UI. The gossip probe remains DEFERRED and historical quest-giver false positives remain OPEN. Decision: treat P0236 as functioning baseline, defer filters/priority/colors/density/quest eligibility polish, resume Phase H broader integration priorities. No runtime code modified in P0237; no WoW redeploy.

## P0237 R0 pre-write packaging failure; R1 repair

The initial P0237 apply attempt **FAILED before tracked writes** with
`P0237 APPLY FAIL: P0237_MANIFEST.txt: invalid EOF`. The original
applier appended a blank final item to its manifest lines and then added
a final newline, yielding two trailing newlines; its own `check_hygiene`
correctly rejected the manifest. The user-reported `git status --short`
showed only the same three untracked PNG artwork previews and no tracked
changes. This was an assistant-generated artifact defect, **not** a WoW
runtime failure. R1 removes the extra empty list item, retains the
pre-write manifest check and exact pushed-P0236 baseline guards, and
records this failure. Do not reuse the original R0 ZIP.
