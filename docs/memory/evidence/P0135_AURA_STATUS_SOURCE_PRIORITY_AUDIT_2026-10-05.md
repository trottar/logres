# P0135 Aura / Status Source + Priority-Policy Audit — 2026-10-05

Status: **SOURCE + POLICY LAYER RESOLVED — READ-ONLY RUNTIME PROBE NEXT**
Logres baseline: `93b43d4bed2ff97a07cc0d9687f7d99ed474d0f2`
Runtime: unchanged at `0.0.65-dev`

## Scope

P0135 is source/policy evidence only.

It does not:
- query live aura state in Logres;
- render a new aura/status surface;
- hide or mutate Blizzard aura/status presentation;
- change target anchoring;
- change party/CompactPartyFrame ownership;
- change Camera or navigation behavior.

The purpose is to identify the exact safe source boundary and establish a
priority/fallback policy strong enough to design the next read-only runtime probe.

## Source pin

The upstream source used for this audit is:

- repository: `Gethe/wow-ui-source`;
- branch: `forever`;
- commit: `e3ecc27b64d30fdc735a3f6579b866858f9f9df1`;
- commit message: `1.60.1 (70205)`;
- `version.txt`: `1.60.1.70205`.

This exactly matches the tested Forever client generation used by Logres:
interface `16001`, client `1.60.1`, build `70205`.

Canonical upstream files reviewed:

- `Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitAuraDocumentation.lua`
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/SecretPredicateAPIDocumentation.lua`
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitConstantsDocumentation.lua`
- `Interface/AddOns/Blizzard_FrameXMLUtil/AuraUtil.lua`
- `Interface/AddOns/Blizzard_BuffFrame/BuffFrame.lua`
- `Interface/AddOns/Blizzard_PrivateAurasUI/Blizzard_PrivateAurasUI.lua`

## Aura read APIs

The generated Forever API documentation exposes `C_UnitAuras` read paths
including:

- `GetAuraDataByIndex(unit, index, filter)`;
- `GetAuraDataBySlot(unit, slot)`;
- `GetAuraDataByAuraInstanceID(unit, auraInstanceID)`;
- `GetBuffDataByIndex(unit, index, filter)`;
- `GetDebuffDataByIndex(unit, index, filter)`;
- `GetAuraSlots(unit, filter, maxSlots, continuationToken)`;
- `GetUnitAuras(unit, filter, maxCount)`.

The payload-returning aura functions are capability-tagged and the primary
payload reads are marked `SecretWhenUnitAuraRestricted`.

Therefore **API presence does not establish that a live player/target aura payload
is ordinary or inspectable**.

## Secret-first source contract

Forever also exposes `C_Secrets` predicates specifically for aura access:

- `ShouldAurasBeSecret()`;
- `ShouldUnitAuraIndexBeSecret(unit, index, filter)`;
- `ShouldUnitAuraInstanceBeSecret(unit, auraInstanceID)`;
- `ShouldUnitAuraSlotBeSecret(unit, slot)`;
- `ShouldSpellAuraBeSecret(spellIdentifier)`.

The generated documentation explicitly describes the index/instance/slot
predicates as tests for whether the corresponding aura query would produce secret
values.

This resolves the source-layer design:

**Logres must preflight aura secrecy before obtaining an aura payload.**

If the predicate is absent, errors, or says the requested aura is secret, Logres
must not query or inspect that aura payload.

Even after a non-secret preflight, the probe must retain the project's normal
defense-in-depth rule:
- wrap API calls;
- reject any returned value that is secret;
- secret-check every candidate field before inspection;
- never stringify/compare/count/format a secret value.

## Event model

`UNIT_AURA` is the stock event-driven invalidation path.

Forever's `UnitAuraUpdateInfo` structure contains:
- `isFullUpdate`;
- `removedAuraInstanceIDs`;
- `addedAuras`;
- `updatedAuraInstanceIDs`.

Stock `BuffFrame` registers `UNIT_AURA` for player/vehicle and consumes the update
model.

However `addedAuras` contains `AuraData`, which is exactly the secret-capable
payload domain being audited.

Therefore the next Logres probe should use `UNIT_AURA` only as an **invalidation
signal**. It should not inspect or count `updateInfo.addedAuras` or any other
secret-capable payload-bearing field.

## Bounded enumeration decision

For the first Logres runtime proof, prefer the indexed path:

1. use fixed, bounded indices;
2. use explicit source-defined filters;
3. call `C_Secrets.ShouldUnitAuraIndexBeSecret(unit, index, filter)` first;
4. only when that returns ordinary `false`, call
   `C_UnitAuras.GetAuraDataByIndex(unit, index, filter)`;
5. reject secret return values/fields without inspection.

This is easier to audit than bulk `GetUnitAuras()` and avoids depending on
secret-capable delta payloads from `UNIT_AURA`.

The first probe does not need exhaustive enumeration. It needs representative,
bounded proof of the player and target paths.

## Source-defined filter vocabulary

Forever's `AuraUtil.AuraFilters` defines useful semantic filters:

- `HELPFUL` — helpful auras;
- `HARMFUL` — harmful auras;
- `PLAYER` — cast by player, pet, or vehicle;
- `RAID` — helpful auras the player can apply / harmful auras the player can
  dispel;
- `CROWD_CONTROL` — crowd-control effects;
- `RAID_IN_COMBAT`;
- `RAID_PLAYER_DISPELLABLE`;
- `BIG_DEFENSIVE`;
- `IMPORTANT`;
- `DISPELLABLE`;
- `EXTERNAL_DEFENSIVE`.

These are stronger source semantics than inventing spell lists in Logres.

P0135 does **not** claim every filter will produce a populated ordinary result in
the user's current gameplay. That is the P0136 runtime question.

## Candidate ordinary metadata

Current Blizzard aura code consumes metadata including:

- name;
- icon;
- applications/count;
- dispel name/type;
- duration;
- expiration time;
- source unit;
- stealable state;
- spell ID;
- can-apply state;
- boss-aura state;
- player/pet origin;
- priority/nameplate flags;
- time modifier;
- points;
- active-player-dispel capability.

These are candidate presentation inputs only after per-aura secrecy is proven.

Duration/count/caster/dispellable information is therefore **source-available but
runtime-unproven as ordinary data**.

## Priority policy — player

The accepted layout direction already separates urgency from passive state.

### Urgent player lane

Player harmful auras own the urgent lane near resources/reaction space.

Priority order for capability/probe purposes:

1. harmful crowd control;
2. harmful auras source-filtered as player-dispellable / raid-relevant;
3. other ordinary harmful auras.

This establishes information priority, not final icon count or final visual size.

No aura may be promoted, sorted, timed, or labeled using a field that has not
first been proven ordinary.

### Passive player lane

Helpful player auras are lower urgency and remain peripheral.

The production goal is **curated context, not a permanent exhaustive buff wall**.

Candidate useful source categories include:
- player/pet-origin helpful auras;
- important helpful auras;
- big defensives / external defensives when contextually meaningful.

P0135 does not authorize dropping unclassified helpful information from Blizzard's
existing surface. Stock remains the completeness fallback.

## Priority policy — target

The intended endpoint remains status spatially associated with the actual world
target.

Candidate high-value target categories are:

1. harmful auras applied by player/pet (`HARMFUL|PLAYER`);
2. crowd-control effects;
3. helpful target auras that are dispellable/stealable or classified important;
4. big defensives / external defensives.

But world-attached target anchoring is a separate unproven capability slice.

Therefore P0135 does not create a persistent Logres target-status replacement.
Stock target aura/status remains available until both:
- source/runtime status proof; and
- world-target placement/fallback proof

are complete.

## Private/restricted auras

Forever has explicit private-aura APIs/UI.

Private/restricted aura handling remains Blizzard-owned.

P0136 must not attempt to enumerate or inspect private/restricted payloads. A
secret predicate result is a terminal skip for that aura in the diagnostic.

## PvP / group / accessibility policy

PvP is a modifier, not Immersion OFF.

For aura/status:
- PvP may increase emphasis of actionable ordinary status;
- it does not justify unsafe reads or stock suppression;
- party/CompactPartyFrame aura/dispel information remains Blizzard-owned;
- healer/support-required group information remains stock until an explicit secure
  replacement is complete;
- future Logres aura visuals must not rely on color alone for dispel/urgency
  meaning; icon/shape/text/tooltip affordances remain required accessibility
  options.

## Stock-surface retention

P0135 explicitly preserves:

- Blizzard player BuffFrame/debuff presentation;
- Blizzard target aura/status presentation;
- private-aura presentation;
- party/CompactPartyFrame aura/dispel indicators;
- nameplate aura/status surfaces;
- all related Blizzard interaction/tooltip affordances.

No suppression is authorized by this audit.

## P0136 runtime probe contract

Next:
**P0136 — read-only aura/status runtime probe.**

The probe should:

- be event-driven only;
- observe `UNIT_AURA`, target changes, and initial world state;
- treat `UNIT_AURA` as invalidation only and ignore secret-capable update payloads;
- probe `player` and `target` separately;
- use bounded indexed scans with `HELPFUL` / `HARMFUL` and a small set of the
  source-defined priority filters above;
- preflight every index with `ShouldUnitAuraIndexBeSecret`;
- skip secret/unavailable/error states without reading their payload;
- record only ordinary addon-owned diagnostic summaries;
- never hide/mutate/reparent Blizzard UI;
- never cancel or mutate an aura;
- never run a periodic poll.

Success should establish which representative player/target categories actually
produce ordinary usable metadata on this Forever client.

Environmental absence of a category is **DEFERRED**, not FAIL.

## Classification

**SOURCE + PRIORITY-POLICY LAYER RESOLVED.**

Production aura/status replacement is **not** authorized.

P0136 read-only runtime evidence is required next.
