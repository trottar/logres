# P0312 — Profession context and trainer source reconciliation

2026-10-22. Verified pushed P0311 main `8987489`. **PREPARED / WSL STATIC and WoW RUNTIME UNVERIFIED.**

## User-reported runtime regression and evidence

- After P0311, user screenshot at Thonys Pillarstone shows **five enchanting services in Blizzard** while Logres shows its **zero-service fallback**. This is a real source synchronization/display **FAIL**, not a genuine established empty profession list. P0309 Enchanting single-service purchase was previously USER PASS. A transient zero native count at Logres activation and no refresh despite later `TRAINER_UPDATE` is a narrow hypothesis; the screenshot alone does not prove timing as the cause.
- User states P0311's new profession Goodbye closes BOTH windows, and rejects that change while Blizzard is still the profession transaction/information fallback. Profession Goodbye will revert to **Logres-only dismissal**; class Goodbye remains native close as in P0308.
- User also rejects generic zero-service text when Fishing's **Journeyman** information is visible in Blizzard. P0310 Fishing Logres empty-state and preview passed visually; current source omitted the player's known skill rank. This patch uses read-only `GetProfessions`/`GetProfessionInfo` (supported in Forever) to display the character's source-verified owned professions, skill values and caps in the existing left sidebar; a cap of 150 maps to Journeyman, but **none** of this is evidence of trainer purchase availability.

## Policy and narrowly scoped correction

- Data-only `NPCTrainerProfessionContext` copies only independently ordinary native results. It does not treat an empty slot as proof of eligibility, nor a known skill as an NPC service. Unknown source fields produce explicit uncertainty. Same `TrainerLandscape.Render` receives the plain profession context model for existing P empty fixture and live profession sessions. UI is drawn below the left categories without layout redesign or native window writes.
- On native `TRAINER_UPDATE`, when Logres currently shows an empty-source profession model, reread the guarded native service probe **once per event**. Only if an ordinary nonzero source with valid rows becomes available, dismiss without marking the visit dismissed and rebuild through the existing guarded live adapter. No timer, polling, native filter mutation, background reassertion or Blizzard presentation access. This is not a claim the enchanting bug is solved until client retest.
- P0311's optional read-only filter explanation remains; native profession window stays visible. P0311's `TrainerProfessionCloseTrial` file remains archived/inert and its historical checker is explicitly migrated to record this user-rejected behavior, not falsified as runtime PASS. Class trainer purchases, Train All, native parking and native-close Goodbye remain untouched.

## Validation gates and limitations

P — Previews → Trainer Empty Preview must show synthetic profession context in the same production renderer. H — Integration and Polish → Trainer Family Check (READ-ONLY) remains diagnostic. Test enchanting immediate open vs Blizzard catalogue (should NOT be stale-empty once ready), fishing owned skill/rank in left context and disabled zero-row training, profession Goodbye Logres-only, class native Goodbye unchanged. Report any Lua/taint/secret-value errors as FAIL. Unowned profession detection and profession native parking remain **UNVERIFIED**; no invented Learn Profession button. Preserve historical P0303, P0304, P0307, P0310 failures.
