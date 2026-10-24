# P0328 — internal staging preflight evidence

## Source observations

At verified pushed P0327 `67c58185e2d05ce469ff7cdf7cc132f28814cf96`, `Logres/Logres.toc` lists 94 loaded Lua files, optional `QuestieDB`, and current dev version; `Core/Bootstrap.lua` maintains matching version metadata. `tools/deploy_logres.sh` deploys development source, not a curated release archive; `.gitignore` ignores `dist/`. Production art is under `Logres/Media/`. `Logres/Camera/LIBCAMERA_NOTICE.txt` contains a LibCamera copyright and permission notice requiring preservation. The repository tree does not contain a root project `LICENSE`/`LICENSE.md`/`COPYING`; any public distribution terms therefore remain **UNRESOLVED**.

## Positive preparation and negative limits

The Python internal staging tool/checker adds deterministic TOC/member selection and archive tests. Source mutation, malicious traversal, symlink, stale metadata, unwanted optional provider bundling and overwriting are negative tests: rejection is expected. No WoW client process, AddOns installation, secure action, merchant purchase, flight travel or NPC native parking was exercised. No new runtime defect was reproduced. This patch is TOOLS/DOCS ONLY: P0321 GossipFrame parking/restoration remains Forever **UNVERIFIED / DEFERRED until November 4**; L-001–L-018 issue classifications and Quest 237 remain unchanged. License gap L-019 is a new source-grounded distribution blocker, not proof that code cannot be internally tested.

## Validation requirements

P0328 guarded applier checks exact clean pushed P0327, expected blobs, complete static suite **199 PREWRITE + 199 POSTWRITE**, candidate whitespace, `git diff --check`, generated manifest and rollback on tracked postwrite failure. The author-side deterministic stage fixture and static checker are not a real clean-install or runtime PASS. The Nov 4 test runbook must record scoped PASS/FAIL/DEFERRED/UNREPRODUCED, never infer PASS from a hypothetical route or client unavailable condition. **Public alpha NOT APPROVED.** No WoW redeployment required.
