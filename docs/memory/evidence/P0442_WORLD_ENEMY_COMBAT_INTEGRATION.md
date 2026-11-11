# P0442 — Combat world enemy integration after Forever #11400

Baseline P0441 main `a300d229ed5737d6a516fdb6d42f1d494a30034f`,
tree `03c9d8cd9986c6c9553082617299d8b1b7beefeb` (verified read-only).
Runtime Forever `0.0.312-dev`, session 105, incidents 11396/11398/11400:
selected red-named Forest Spider, **one live addon-owned combat attachment**,
`worldEnemyLiveCombatAttaches=1`, `worldEnemyLiveAttachments=1`,
`worldEnemyLiveFailures=0`, `worldEnemyLiveLastReason=owned-target-attached`.
Screenshots show native Blizzard nameplate and Logres world frame separated
vertically (VISUAL PARTIAL), while real Logres health tracks 89% then 66%.
This is positive combat attachment evidence, NOT proof of full replacement,
protected-state safety in every transition, world auras in every condition,
confirmed per-unit aggro, or safe suppression of native nameplate information.

P0442 adjusts only the opt-in, existing 100% selected-target trial to use the
native anchor's CENTER instead of its TOP so both presentations occupy the
same region. Native Blizzard nameplates, children, interaction and CVars are
**untouched**; overlapping native information may remain visible. This is
not authorization to hide native controls or claim duplicate removal PASS.
Selected-target changes hide the old owned frame before revalidating a new
anchor. The health event handler will not write a new target into the old
world frame. `NAME_PLATE_UNIT_REMOVED` never reacquires during the removal
event: an ordinary validated attached token is compared, unrelated removals
leave the current trial alone, and missing/unknown identity conservatively
hides the owned frame. Status and Report Bug expose addon-owned detaches and
removal reasons; neither inspects native geometry or secret values.

Testing required in Forever: enable World Enemy ON out of combat from
Report Bug > H, engage a red hostile, verify centered world bar and auras,
change targets, move behind camera/leave combat and remove nameplate;
check native clicks and normal screen-space fallback. Use World Enemy Status
then Report Bug. This patch is a guarded visual/lifecycle integration trial;
**not production suppression**. Secondary 50% remains disabled until actual
threat-ownership evidence exists. Runtime of P0442 UNVERIFIED.

Author R0 negative result: 298/306 static, eight refusals from a noncanonical compound L-011 status and removed historical CURRENT P0425/P0426/P0427 markers; no user tracked files or GitHub writes. Corrected in R1, full author check rerun pending.
