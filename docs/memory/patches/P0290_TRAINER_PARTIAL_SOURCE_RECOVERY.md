# P0290 — Trainer live partial-source recovery

Guarded runtime checkpoint on verified main `aee3f9d` (P0289 R1). Fixes confirmed all-or-nothing live adapter rejection `unsafe-or-incomplete-service-row` without inventing category meanings or adding a separate trainer audit. P0289's H panel registration is accepted as PASS by screenshot, while its live trial repeatedly failed to present any Logres-owned landscape and native mutation counters remained zero. This negative result remains OPEN pending a corrected client rendering test.

Implementation: name-only ordinary-gated salvage in existing source probe, partial/placeholder row model acceptance in `TrainerLiveTrial.FromSnapshot`, status `live-partial-visible` for user feedback. Same `NPCTrainerLandscape.Build`/`Render`, unchanged geometry/painter and stock Blizzard controls. Separate controller and native transaction work remain DEFERRED. The full static suite, diff hygiene, manifest, user-owned commit/push and in-game test are explicit gates. Does not claim a WoW PASS from source analysis.

## R1 repair after user WSL PREWRITE failure

R0 verified baseline but failed 1/161 `check_memory_health.py`: CURRENT.md exceeded the 20 KB hard threshold. PREWRITE wrote no tracked files. R1 removes accumulated history from CURRENT in favor of a short current-authority summary, keeping exact failures in evidence, investigations and patch index. The live Lua patch is unchanged; complete WSL suite and WoW trial remain unverified.

## R2 repair after user WSL postwrite whitespace failure

R1's 161 PREWRITE and 161 POSTWRITE checkers all passed, but `git diff --check` caught an added empty last line in CURRENT.md:38. The generator had unconditionally suffixed two newline characters to the final section; the prewrite shadow did not check Git whitespace. R2 makes the final-section newline singular, rejects duplicated EOF newlines, runs `git diff --no-index --check` across all 14 shadow candidate paths before real writes, then retains the final real-tree diff check. Runtime Lua behavior and native transaction boundaries unchanged. P0290 R1 failure retained as evidence; R2 WSL/WoW outcomes UNVERIFIED.
