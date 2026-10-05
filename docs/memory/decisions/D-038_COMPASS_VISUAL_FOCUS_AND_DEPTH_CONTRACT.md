# D-038 — Compass Visual Focus and Depth Contract

Status: ACCEPTED — FUTURE VISUAL CONTRACT; SOURCE-CAPABILITY GATED
Date: 2026-10-03

## Decision

Refine D-037's four semantic navigation roles into a coherent authored compass
visual/focus system under D-034's Selective Hybrid E rule:

**thematic for meaning; restrained for interaction.**

This decision defines how proven navigation sources should look and how the
player's visual attention should select contextual identity near the fixed center
heading marker. It does not prove any new Forever data source.

D-030 remains authoritative for current runtime behavior: the Blizzard minimap
stays stock until the complete replacement gate is actually satisfied.

## Compass structure

The compass remains a top-center horizontal heading tape with the world visible
behind it.

Accepted treatment:
- thin weathered antique-gold / brass baseline;
- cardinal directions stronger than intercardinal directions;
- fixed center-heading gnomon / spear-notch in brighter antique brass;
- quiet local contrast/shadow rather than a visible rectangular backing panel;
- restrained edge recession/fade rather than hard end caps;
- smooth tape motion beneath the fixed center marker;
- no degree-number ruler or persistent center heading number by default.

The normal no-navigation state is simply the clean heading compass. No empty
socket, placeholder, or "no waypoint" message is required.

## Marker glyph family

D-037's semantic roles receive distinct silhouettes, not merely recolored copies.

### Manual waypoint

Meaning:
**the player explicitly chose this destination.**

Accepted working glyph:
- open destination diamond / narrow rhombus;
- exact-bearing stem terminating on the tape;
- authored muted steel-blue / cyan-blue family;
- strongest moving destination marker.

### Quest destination

Meaning:
**the selected/current quest leads here.**

Accepted working glyph:
- small heraldic pennon / shield / quest-standard silhouette;
- exact-bearing stem;
- aged pale-gold / parchment-ivory / brass family;
- distinct from Warcraft `!` / `?` acquisition and turn-in punctuation.

No quest marker is shown without a real capability-proven destination bearing.

### Local radius POI

Meaning:
**a useful nearby place/service exists within local awareness.**

Accepted working glyph:
- small neutral open wayfinder seal / roundel;
- short exact-bearing stem;
- weathered bronze / bone / restrained brass family;
- smaller and quieter than manual or quest destinations.

Persistent POI text labels are not part of the ambient compass.

### Tracking

Meaning:
**the player's selected tracking mode detected something nearby.**

Accepted working glyph:
- tiny repeated faceted diamond / four-point heraldic pip;
- muted amber / dull antique-gold family;
- smallest and quietest marker role;
- one generic form independent of tracked category;
- never literal stock yellow dots.

Tracking identity or individual-name presentation is not assumed by this decision.

## Bearing truth and collision behavior

The horizontal attachment point represents the true bearing and is authoritative.

Collision resolution must not casually move markers sideways. In particular:
- no left/right jitter to make crowded markers fit;
- no random bearing offsets;
- no edge packing that falsifies direction.

Vertical lanes are the accepted collision mechanism.

Major semantic destinations remain individually legible:
- manual waypoint and quest destination do not merge into one glyph;
- coincident major markers may share a bearing anchor while their glyph bodies
  occupy separate vertical lanes.

Lower-priority repeated evidence may simplify:
- nearby POIs may use a restrained stacked-seal treatment when individually
  unreadable;
- very close tracking bearings may combine into a compact multi-facet treatment;
- tracking yields visually before it obscures manual, quest, or POI meaning.

Ambient hierarchy remains:
1. fixed center heading structure;
2. manual waypoint;
3. quest destination;
4. local POI;
5. tracking.

This hierarchy controls visual weight and collision priority; it does not choose
which centered identity name wins.

## Center-focus identity readout

When a navigation candidate approaches the fixed center heading marker, the compass
may reveal the identity of one candidate near center.

The readout is contextual and normally absent. It should sit with the center marker
rather than become a permanent row of labels across the tape.

Examples of intended identities include:
- a safely source-provided local POI/service identity such as `Leatherworker` or
  `Tailor`;
- a capability-proven focused quest title;
- a source-provided manual destination name if one exists.

Do not invent identity from objective prose, category assumptions, or unavailable
source data. Generic tracking pips remain unlabeled by default unless a later
capability/product decision explicitly proves and accepts individual identity.

## Focus candidate selection

The product intent is world-space proximity first.

For candidates within the accepted center focus region:
1. where safe comparable physical/world distance is capability-proven, the
   physically closer candidate wins;
2. angular alignment with the center heading is the secondary discriminator;
3. semantic priority may break a remaining practical tie.

Therefore a nearby `Tailor` may own the centered identity readout even when a much
farther quest destination is more nearly aligned with the center marker.

Capability discipline still applies:
- do not fabricate distance when sources are not comparable;
- do not treat arbitrary map-coordinate units as world distance without proof;
- when comparable distance is unavailable, fall back to angular alignment rather
  than pretending a proximity ordering exists.

Exact focus-cone degrees and tie tolerances are tuning values, not frozen by this
decision.

## Continuous angular name fade

Focused identity text fades continuously as angular deviation from the fixed center
marker increases.

Accepted perceptual behavior:
- near exact alignment: full or nearly full label opacity;
- modest deviation: gentle recession;
- larger deviation within the focus region: increasingly rapid fade;
- outside the focus region: identity text fully absent.

This is a continuous response, not a binary tooltip trigger.

Logical candidate retention may use a slightly wider hysteresis region to prevent
rapid identity swapping, but the label's visible opacity remains a continuous
function of angular deviation. Candidate changes should cross/recede cleanly rather
than flicker between names.

The text fades substantially faster than the underlying marker. A player turning
away should experience:

**named destination -> focused marker -> ordinary marker -> edge recession.**

## Distance-dependent marker presence

Where safe comparable distance is capability-proven, major destinations may use a
bounded depth cue:
- manual waypoint and quest destination become somewhat smaller/quieter when far;
- they become somewhat larger/more present when near;
- the scale range remains restrained and capped;
- apparent size is not an exact distance meter and no persistent distance number is
  implied by this contract.

Local POI scale remains mostly stable, with at most restrained proximity modulation.

Tracking markers remain effectively fixed-size so a dense tracked field does not
become a turbulent perspective effect.

Center focus may add only a small additional increase in marker opacity, scale, or
material highlight. No glow box, bounce, or selection panel is required.

## Edge behavior and motion

Markers recede toward the compass edges through opacity/contrast loss and may use a
very small scale recession. They disappear when outside the visible tape.

Reject:
- clamped edge arrows;
- fabricated off-screen guidance;
- giant side chevrons;
- frozen last-known bearings after source loss.

Motion should remain smooth, restrained, and directionally truthful:
- fixed center marker;
- tape and markers move with heading/bearing changes;
- no spring overshoot or decorative bounce;
- interpolation may hide update stepping only when it does not create meaningful
  directional lag;
- stale or invalid source information recedes promptly.

## Capability boundary

Only the manual user-waypoint marker is currently runtime-proven.

Quest destination, local POI, tracking-result positions, comparable physical
distances, and source-provided identities remain capability-gated according to
D-037 and `../investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`.

Unsupported roles or unavailable identity/distance inputs are omitted rather than
fabricated. This visual contract does not authorize minimap suppression, new polling,
protected/secret inspection, or production source assumptions.

## Scope

D-038 accepts the detailed compass visual/focus direction while leaving exact pixel
sizes, final color values, focus-angle thresholds, scale curves, and animation
constants for later art/runtime calibration.
## P0147 local-awareness calibration refinement

The first production calibration used absolute `120` / `1200` yard thresholds, but
its runtime acceptance sampled only the near endpoint and did not visually prove
variation. P0147 therefore grounds manual-waypoint depth in the live local-awareness
radius returned by `C_Minimap.GetViewRadius()`.

Accepted semantic bands for the manual waypoint are:
- close: at or within one-half local-awareness radius;
- near: from one-half through one full local-awareness radius;
- medium: beyond local awareness through four radii;
- far: four through eight radii, with the bounded minimum retained beyond eight.

The calibration remains restrained and is still a depth cue rather than a distance
meter. Runtime acceptance now requires cross-band diagnostics plus explicit user
visual confirmation that the marker changes size perceptibly.
