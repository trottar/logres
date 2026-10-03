# D-039 — Approved Visual Baseline and Implementation Translation

Status: **ACCEPTED — APPROVED VISUAL BASELINE**
Date: 2026-10-03

## Decision

The twelve reference sheets under `docs/design/approved/` are the approved visual
baseline for the current Logres World Ghost / Selective Hybrid E direction.

This closes broad visual exploration for the component families represented by
those sheets. The next work for those components is primarily **implementation
translation**: derive addon-capable textures/masks/glyphs, wire them into the
existing runtime or new capability slices, and calibrate layout/state behavior in
client.

Canonical asset index:
`../../design/approved/README.md`.

Canonical implementation audit:
`../architecture/VISUAL_IMPLEMENTATION_STATUS.md`.

D-033/D-034 remain the style foundation:
**thematic for meaning; restrained for interaction.**

## Authority / precedence

The reference art does not supersede technical safety or information policy.

Use this order when resolving apparent conflicts:

1. accepted product/safety/capability decisions;
2. this decision and the most specific approved component sheet;
3. broader overview/moodboard composition;
4. incidental example content printed inside a mockup.

A component sheet may refine an earlier visual hypothesis without authorizing a
new data source. Example quest text, quest/item names, item stats, NPC names,
counts, percentages, and world screenshots are illustrative unless a separate
product/capability decision says otherwise.

## Approved component baseline

### World Ghost / Selective Hybrid E foundation

Approved:
- dark, low-weight world-first composition;
- aged parchment, brushed/weathered bronze, muted cloth/leather, dark metal;
- restrained heraldic diamonds/runes/thin rules;
- narrative/meaning-heavy surfaces carry more ornament;
- repeated interaction controls remain simple;
- serif-forward narrative/context typography with restrained game-native UI text.

Exact font files are not frozen by the sheet. Production typography must use
available/licensed/client-safe fonts while preserving the approved role hierarchy.

### Shared percentage/resource bar

Approved:
- one shared framed bar family with normal and compact widths;
- visible percentage text inside/right of the bar;
- same geometry across percentage-based Logres-owned values;
- WoW-native resource color semantics for mana, energy, focus, rage, runic power,
  and accepted alternate/special power contexts;
- the player-health tunnel remains the explicit exception.

Secret-capable values still require native-safe transport. The art does not
permit Lua inspection/arithmetic merely to drive the fill.

### Action button primitive

Approved common geometry with state-layer changes only:
- default;
- hover;
- pressed/key activation, stronger than hover;
- checked/toggled;
- brief activation flash;
- cooldown overlay;
- out-of-range treatment;
- insufficient-resource treatment;
- unusable/disabled treatment.

The underlying spell/action icon remains dominant. High-density cluster layout,
hotkey/count calibration, and spacing are implementation/composition work, not a
reason to redesign the button family.

### Status / aura icon primitive

Approved:
- minimal frame around the native WoW icon;
- passive/default state;
- restrained urgent/actionable emphasis;
- lower-right reserved stack count and/or duration text;
- no timer sweep in the approved baseline.

This settles the visual primitive only. Aura filtering, priority, duration policy,
healer/support fallbacks, source capability, and stock suppression remain separate
runtime/product work.

### Cast-state cue primitive

Approved distinct cue family:
- player cast: angular amber/gold;
- player channel: flowing blue;
- target cast: angular orange;
- target channel: flowing violet;
- interrupted/failed: fractured red.

Cast vs channel is distinguished by silhouette first, color second. No progress
bar, timer, spell name, spell icon, or duration is added by this design.

### Target / enemy identity and relative danger

Approved visual direction:
- target/unit name above a shared percentage-health bar;
- bar color communicates reaction: hostile red, neutral yellow, friendly green;
- relative danger is hinted only through restrained hostile-name color/weight;
- no numeric enemy level, difficulty label, elite/rare icon, or classification
  badge is introduced;
- ally/pet compact treatment is quieter and reuses the same bar language.

The relative-danger data source and final world-attached target anchor remain
capability-gated. Visual approval does not authorize unsafe level/classification
inspection or removal of the current target fallback.

### NPC quest narrative

Approved:
- bounded narrative reading area;
- short text on one page;
- discrete player-driven pages for long text;
- subtle page indicator/navigation;
- objective/action text may wrap;
- authored Logres narrative treatment without inventing or summarizing source
  quest prose.

### NPC quest interaction states

The previously open interaction-control art is now visually resolved.

Approved states include:
- short quest offer;
- long offer page(s) and final page;
- rewards shown where appropriate;
- Decline / Accept;
- incomplete quest progress with Continue;
- completion with no reward choice;
- reward-choice list with selected-reward emphasis;
- Complete Quest.

This does not claim runtime control capability. D-035's fail-open replacement gate
remains authoritative: Blizzard quest/gossip controls remain available until the
matching Logres information and interaction are capability-proven.

### Context message family

Approved transient center-world family:
- XP change;
- objective progress;
- objective completion;
- thin-rule/diamond authored accent;
- brief appearance and recession rather than permanent chrome.

Existing Phase F runtime/visual proofs remain valid; final asset/style integration
can reuse those producers rather than re-opening the product concept.

### Active Quest

Approved one-focus panel:
- parchment/heraldic meaning-heavy treatment;
- quest title and restrained ambient progress phrase;
- one or multiple objective rows;
- default objective progress uses the shared bar language;
- deliberate hover/inspection reveals exact mechanical counts;
- quest-complete state is a distinct quiet completion treatment;
- still not a permanent multi-quest tracker.

### Player-health tunnel

The approved health sheet is the visual calibration reference for D-036's frozen
continuous visible-field contract.

It shows representative states from 100% through 0% with progressively narrowing
clear field, stronger peripheral darkness, and restrained injury pressure.

The printed percentages/visible-area labels are **calibration examples**, not Lua
thresholds. Where an annotated example and an older approximate D-036 table differ
slightly, implement a smooth perceptual curve satisfying the same frozen rule rather
than literal threshold branching. D-036's secret-safe native transport remains
mandatory.

### Compass / navigation

The approved compass state sheet is the most specific visual calibration for the
D-037/D-038 family.

Final lane organization:
- center heading remains fixed;
- manual waypoint and quest destination occupy the **major-destination lane above
  the tape**;
- local POI is **centered on the tape**;
- tracking is the quiet **below-tape** lane;
- true horizontal bearing remains authoritative; collisions use vertical
  separation/within-role simplification rather than sideways bearing falsification.

Approved approximate actual-UI glyph scales from the sheet:
- center marker: ~22 px high / ~7 px wide;
- manual waypoint: ~16 / ~12;
- quest destination: ~18 / ~10;
- local POI: ~9 / ~9;
- tracking: ~5 / ~4.

Approved bounded scale intent:
- manual waypoint: far ~80%, nominal 100%, near ~115%;
- quest destination: far ~85%, nominal 100%, near ~110%;
- focused major destination: only a further restrained ~5–8% emphasis;
- POI: nominal 100%, near ~105%, focused ~10–15% stronger;
- tracking: fixed scale.

Approved name-fade calibration example:
- 0°: 100%;
- ~2°: ~70%;
- ~4°: ~35%;
- ~6°: ~10%;
- ~8° and beyond: absent.

These are calibration anchors, not immutable constants. D-038's focus rule remains:
where safe comparable world distance exists, nearest wins before angular alignment;
otherwise use angular alignment without fabricating distance.

Only manual waypoint source capability is currently proven. Quest destination,
local POI, tracking results, identity, and comparable distance remain separately
gated. D-030 still keeps the Blizzard minimap stock until the complete replacement
gate passes.

## What visual work remains

The approved baseline is broad, but not literally every future surface is art-complete.
Residual design/calibration work includes:
- class-specific discrete resource mechanics (runes, combo points, etc.) where the
  shared percentage bar is inappropriate;
- exact hotkey/count typography and 36-button cluster spacing/density calibration;
- settings/accessibility presentation;
- any future capability-proven surface not represented by the approved sheets;
- final in-client scaling, pixel alignment, contrast, and motion tuning.

Those are narrower follow-up tasks. They do not reopen the overall World Ghost /
Selective Hybrid E language.

## Runtime boundary

This decision changes no Lua/runtime behavior.

Approved sheets do not by themselves authorize:
- Blizzard suppression;
- protected mutation;
- secret-value inspection;
- quest interaction ownership at runtime;
- world-target anchoring;
- unproven quest/POI/tracking sources;
- minimap removal.

Each runtime integration still follows the existing capability, restoration,
combat-lockdown, and fail-open contracts.
