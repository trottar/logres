# P0291 — Forever six-return trainer source and live presentation

Date: 2026-10-21. **PREPARED / WSL and WoW UNVERIFIED**. Baseline: verified GitHub main P0290 R2 `61838ba`.

## Observed source and client evidence

- User P0290 screenshot: **live five-spell row/name landscape PASS** (Mark of the Wild, Moonfire, Rejuvenation, Thorns, Wrath), stock window preserved; icon placeholders, unknown costs and unclassified requirements remain **INCOMPLETE**. No native interaction proof. The prior assistant had not addressed the actual Forever API layout.
- P0286 read `GetTrainerServiceInfo` types string/string/number/number and incorrectly labeled positions 3 and 4 as category and expansion. **CORRECTED INTERPRETATION (source evidence):** Blizzard Forever `Interface/AddOns/Blizzard_TrainerUI/Mainline/Blizzard_TrainerUI.lua` in `Ketho/wow-ui-source-forever` uses `name, serviceType, texture, reqLevel, serviceSubText, category = GetTrainerServiceInfo(index)`. Positions 3 and 4 are icon texture ID and required level; the real service type is field 2. The legacy Classic four-tuple still exists in external documentation, but is NOT the Forever tuple here. This is source evidence aligned with observed four scalar types; full 6-value runtime evidence is not yet recorded.
- Blizzard's current Forever implementation also uses `GetTrainerServiceCost(index)` and `GetTrainerServiceSkillReq(index)` for rows. It uses `SetTexture(texture)` with a file ID. We independently implement conservative copies through existing safe wrappers; no third-party code copied.

## Intended change and controls

- The probe first tries a six-value Forever branch when separately ordinary field-2 serviceType and numeric texture/requiredLevel prove the documented shape, preserving its legacy Classic fallback. A valid, bounded source file ID, required level, bounded rank label, skill requirement and optional description/cost enter an addon-owned snapshot. Every optional field independently passes the secret gate. All unknown data is withheld, not fabricated.
- The P0290 live adapter uses those copied fields in the SAME accepted landscape renderer. The P preview and native H skin geometry remain unchanged. Dynamic icon numbers are bounds-checked in the pure landscape model before passing to the normal texture setter. Level/rank/cost and selected details display when safe; otherwise safe placeholders. No eligibility-based Train/Train All action is enabled. Availability serviceType is observation only, not transaction authorization.
- Native frame filtering, selection, purchases, visibility, protected state and Blizzard transaction machinery remain intact. No GetPoint, protected setter, OnUpdate, gossip/trainer purchase or user-travel demand added. The developer panel **H Live Trainer ON/OFF** remains the sole trial path.

## Validation / negative evidence

- Previous P0290 R0 memory-health PREWRITE and R1 EOF whitespace POSTWRITE failures remain in their evidence records. P0290 R2 was pushed and its five-name screenshot is a scope-limited VISUAL PASS, not functional trainer integration.
- P0291 PREPARED only. Run full shadow PREWRITE/POSTWRITE check suite and `git diff --check`; then with an ordinary trainer open use H Live Trainer ON/OFF once to verify icon/rank/level/cost where the API safely exposes them. Missing fields are environmental DEFERRED, not a FAIL unless an expected source field is proved available.
- Do not infer category/availability semantics from the old numeric field 3, and do not re-run the generic H audit. Row completeness, live selection changes, search/filter interaction and purchases remain separate unverified gates.

**Explicit scope:** the earlier category/expansion reading was **WRONG** for Forever. There is **NO PURCHASE** through Logres in this patch.
