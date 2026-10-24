# P0328 — internal alpha packaging and installability preflight

**Baseline:** verified GitHub `main` P0327 `67c58185e2d05ce469ff7cdf7cc132f28814cf96`. **Outcome classification:** static preparation, client and distribution **UNVERIFIED / NOT APPROVED**. This is the existing launch roadmap's A0 (installation), A3 (regressions), and Nov 3 freeze work, not a substitute for the November 4 runtime gate. No addon-loaded Lua changes are permitted.

## Identified gap and narrow solution

`tools/deploy_logres.sh` can copy the complete development `Logres/` directory into an existing AddOns directory, but it is not a clean release staging/audit tool. `tools/check_addon_structure.py` confirms TOC paths/version while `docs/DEPENDENCIES.md` documents optional QuestieDB. There is no repository-root `LICENSE`, `LICENSE.md` or `COPYING` in the audited main tree, although `Logres/Camera/LIBCAMERA_NOTICE.txt` contains the required permissive LibCamera copyright and redistribution notice. **No Logres project license, approved public packaging or WoW Forever installation acceptance is inferred.** User approval and review are needed before distribution.

P0328 introduces `tools/stage_alpha_candidate.py` for **internal local QA**, with `--check` read-only by default and explicit `--output` restricted to a new ZIP directly within ignored `dist/`. It is not integrated into WoW or auto-deployed. It never touches source, live AddOns, saved data, deployment configuration or GitHub.

## Stage and safety contract

- Read actual `Logres/Logres.toc`; validate interface/version syntax, TOC–Bootstrap version parity, canonical unique Lua paths, no absolute/parent path traversal or symlinks; require optional `QuestieDB` (load-order hint, not bundled provider).
- Include `Logres/Logres.toc`, all and only TOC-loaded Lua, recognized production `Logres/Media/` art, `Logres/Camera/LIBCAMERA_NOTICE.txt`, and a conspicuous `Logres/INTERNAL_STAGING_NOTICE.txt`. Preserve folder layout required under `Interface/AddOns/Logres`.
- Exclude repository root documents, developer `tools/`, project memories, patch manifests, fixture Python, screenshots, machine paths, and QuestieDB's separately acquired data addon. Do not omit real Logres adapter modules whose filenames mention QuestieDB: they are internal source, not the external provider.
- ZIP members use deterministic ordering, timestamps and compression. Repeated staging of an unchanged source is byte-identical. Existing output archives cannot be overwritten; `--output` refuses paths outside ignored `dist/`.
- Any missing TOC Lua/media, unsafe symlink, duplicate, invalid version parity or missing attribution refuses staging before file output. A passing preflight does **not** certify an actual clean-install, usability, API safety, CVar integrity, CurseForge submission or public distribution rights.

## Manual internal preflight after committing

```bash
cd ~/Projects/logres
python3 tools/stage_alpha_candidate.py --check
# Optional explicit non-public QA package; do not distribute:
python3 tools/stage_alpha_candidate.py --output "$PWD/dist/Logres-internal-alpha-candidate.zip"
```

The package is **NOT APPROVED for publication**. `dist/` is ignored; local generated artifacts are never staged in Git. Do not run the packaging command as the deploy script. Use `tools/deploy_logres.sh` for the existing development deployment (only when in-game access resumes); verify file tree, game addon detection and missing optional provider then. `README.md` and `docs/DEPENDENCIES.md` remain design/developer guidance, not accepted user onboarding yet.

## Release blockers and resulting roadmap

- **L-019 / RELEASE:** project-owned license/redistribution decision and attribution/third-party review remain open. Retain LibCamera notice; never bundle QuestieDB without proven rights. Public CurseForge/Reddit exposure is NOT APPROVED.
- **A0:** test actual clean Forever AddOns install, optional QuestieDB absent/present, client Interface metadata compatibility, source/media load, and a repeatable rollback. Source inventory alone is not installation PASS.
- **A1/A3:** on November 4 begin with P0321 native GossipFrame restoration, then native merchant/flight service preservation and all five domains, reload/combat/context fallbacks, error export. Runtime Lua/taint/protected/secret failures block alpha.
- **A2/A4:** only advertise implemented selectors; five independent user settings and migrated saves are planned **not yet implemented**. A player-friendly settings/recovery guide, changelog, compatibility table and third-party notices remain unfinished release work.
- **Nov 3 candidate freeze:** run full static suite, stage preflight, issue triage, exact in-game diagnostic checklist. Freeze risky gameplay changes if not verified; do not silently claim release readiness.

See `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md` for exact ordered tests and evidence states. This checkpoint does not invalidate P0317–P0320 positive observations, fix P0321 UNVERIFIED native parking, or modify the established D-047 camera baseline.
