# P0332 — L-028 target harmful fallback canonical scan

**Baseline:** pushed P0331 `dce2355cd960dab457f933982ca39d45c0610c98` on 2026-10-24. **Result:** source correction prepared; in-client WoW behavior UNVERIFIED / ENVIRONMENTALLY DEFERRED until November 4. P0331's 202-checker manifest documents source checks, not a gameplay PASS.

## Observed user report and source finding

The user observed duplicate target DoT icons and missing debuffs. In `StatusAuras.lua`, a fallback target harmful renderer consulted `HARMFUL|PLAYER`, `HARMFUL|CROWD_CONTROL`, and `HARMFUL` as separate index spaces. A shared `seen` index keyed only by validated `auraInstanceID` cannot suppress repeated entries when that ID is absent/secret. Its six-index per-filter bound and five-icon cap can omit an ordinary DoT farther down the unfiltered list. This is a proven possible source for duplicate icons, not proof that it caused each observed game symptom. The active Blizzard-backed native AuraContainer uses a distinct `HARMFUL` group and must be considered separately; no runtime source attribution yet.

## Correction and limits

P0332 narrows the **legacy ordinary target harmful fallback only** to one `HARMFUL` index domain. It scans at most 16 indices, collects validated ordinary candidates and favors a positively ordinary `isFromPlayerOrPlayerPet` flag before filling at most five spots in canonical order. Secret/unknown origins remain eligible; no spell-ID, texture, name or source comparison substitutes for opaque aura identity. The ordinary `auraInstanceID` guard still removes proven duplicate IDs. Existing player harmful priority and target helpful filters remain unchanged. Native `CustomAuraContainerTemplate`, Blizzard auras, secure frames, UI strata, camera, pet controls, quest behavior, and SavedVariables remain untouched.

Risk: a single baseline filter no longer implies crowd-control urgency for ordinary target harmful rows; all fallback harmful rows use the harmful presentation. This is intentionally traded for identity-safe canonical membership. That urgent treatment is still available via the native Blizzard aura presentation where supported; a future priority label requires separately evidence-backed ordinary identification. Unknown/secret aura data cannot be filled in by Lua; Blizzard stock remains the fallback. Native aura container packing and client-specific duplication remain UNVERIFIED.

## Offline acceptance

Migrate historical `tools/check_status_auras_contract.py` to canonical target membership without weakening its secret-safe guards. New P0332 checker validates single-source scan bound, source-independent origin guard, retention of all stock/native controls and six deterministic synthetic conditions: unrelated same-icon unknown-ID rows, known identical ID duplication, player-origin beyond initial six, display cap, unknown distinct instances, and empty set. Require 203/203 PREWRITE and POSTWRITE static checks, exact baseline blobs and diff hygiene; no static run is claimed until WSL executes it.

## In-client gate November 4

After P0321 gossip restoration first, check target with one DoT, multiple distinct DoTs, duplicate spell from two casters where possible naturally, five-plus target harmful effects, secret/combat restrictions and target swap. Compare screenshots, Phase H aura histories, `nativeActive` status, `duplicateUnknown`, `secretSkips` and tooltip identity; failures retain FAIL, absent contexts DEFERRED. Do not hide native auras or globally deduplicate icons/spells without proof.

## P0332 R0 baseline-parse refusal and R1 repair (2026-10-24)

The user ran the original P0332 ZIP on the P0331 checkout. Its SHA-256 check and extraction passed, but the applier refused before any tracked write with `baseline path missing 8780844d85b00f1a8ca160de31697c6e9f9fe0b3`. The original payload correctly listed expected Git SHA first and repository-relative path second, but the applier mistakenly formed `dict(line.split())`, treating the Git SHA as the path. This is an **assistant patch-artifact failure**, not a WoW defect, baseline mismatch, or source-code regression. P0332 R1 corrects the parsing to `{path: sha}` and adds preflight validation for 12 unique safe relative paths, 40-character Git blob IDs, and the known P0331 StatusAuras blob. All WSL PREWRITE/POSTWRITE and WoW runtime checks remain UNVERIFIED until explicitly executed; no runtime status is promoted by this packaging repair.
