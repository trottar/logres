# P0313 — trainer focus, all-owned-professions and empty fixture icon repair

Date 2026-10-22. Verified GitHub main P0312 `8776eb6`. **PREPARED / full WSL static and WoW runtime UNVERIFIED**.

## User evidence and current scope
P0312 user screenshots show all owned professions in the left sidebar: Tailoring 60/150 (Journeyman), Enchanting 41/75 (Apprentice), First Aid 9/75, Fishing 61/150 (Journeyman), Cooking 46/75. Enchanting five and Cooking seven Logres source-backed rows are restored, class training user reports intact. The P empty preview question-mark icon has returned to a bright yellow face: **OPEN VISUAL REGRESSION** in synthetic P, not demonstrated in live. User requests current NPC profession/rank and future rank requirement *in addition to*, not instead of, the full list.

## Accepted narrow implementation
The source adapter uses copied, ordinary `sourceSkillRequirement` rows as its strongest trainer discipline evidence. If there are zero source rows, guarded `C_TooltipInfo.GetUnit("npc")` unit-tooltip data or native `GetTrainerGreetingText` may identify exactly one known discipline; this is a read-only source observation, not a write to Blizzard UI or an inspection of native presentation frame state. Every native function/object/text element is gated ordinary before inspection, with bounded line counts and string lengths. If no unique source identifies the NPC discipline, show `Trainer profession unverified`, never assume the trainer teaches any one of the character's owned professions. Known rank/level/cap are derived solely from P0312's individually ordinary GetProfessionInfo results. Cooking Journeyman at required Cooking 50 is derived solely from a copied unavailable service named Journeyman with skill requirement 50, not a constant. Fishing with zero listed services gets a known current rank only when both independent sources match.

The left column has **Current trainer** and **Your professions** independently. Full owned lines remain unchanged; the new summary does not filter them. One extra optional data field reaches the existing shared Landscape.Render; both P EmptyFixture and live use it. P EmptyFixture uses `emptyFixtureIconFix` to opt into the proven live dark-backplate/thin-gold-border icon treatment; normal trainer fixture and live icons are unaffected. Synthetic preview remains inert. No gameplay purchases, native filters, native geometry, known rank purchases, new panel action, timers or transaction behavior changes.

## Evidence limits and tests
P0312 screenshot alone proves visual restoration of the skill lists; it does not prove a newly executed transaction or available-source rank identification. Tooltip/greeting data identification at Grimnur is **UNVERIFIED** until actual WoW test; missing or ambiguous data must fail open with a neutral current-trainer status. No requirement to manufacture a profession trainer visit or unowned profession for validation. Class trainer and P0311 native Goodbye historical outcomes remain preserved. Prior P0310 gallery checker R0/R1 and P0311 runtime Enchanting source failure are retained.

## P0313 R0 PREWRITE failure — preserved evidence

On 2026-10-22 the user ran the guarded P0313 R0 applier against clean P0312
`8776eb6`. The candidate anchor, version/load order, and prewrite whitespace
checks passed; the full PREWRITE reported **3/184 failures**:
`check_checker_version_policy.py` found an exact `0.0.214-dev` runtime
version frozen inside the newly authored feature checker, and
`check_p0297_trainer_icon_backplate_contract.py` /
`check_p0298_trainer_icon_layers_contract.py` rejected changed live skill/detail
icon call sites. **No tracked files were written**. This was an assistant
patch-generation/static-compatibility failure, not a WoW runtime result.

P0313 R1 repairs the checker by testing Bootstrap/TOC version parity
without an exact version pin. It preserves both historical icon invocations
**byte-for-byte** and marks only the addon-owned empty-preview icon owner
frames to opt into the already-existing dark backing and thin-gold-border
painter. No native icon, regular trainer preview, transaction, P gallery,
or Blizzard control changes are authorized. R1 complete WSL static and WoW
remain **UNVERIFIED** pending user testing.
