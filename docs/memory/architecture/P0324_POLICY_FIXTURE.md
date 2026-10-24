# P0324 — five-domain pure policy fixture specification

**Status:** isolated Python reference fixture, WoW integration **UNVERIFIED**. Verified P0323 `386a7ef` contains a 94-Lua-loaded-source audit; D-048 is the normative product contract. The files `tools/p0324_domain_policy.py` and `tools/check_p0324_five_domain_policy_contract.py` are **not** registered in `Logres/Logres.toc`. They cannot change current gameplay, preferences, or Blizzard frames.

## Boundary and semantics

D-048 domain ordering is **NAV, ACT, NPC, STATUS, CAM**. A five-bit mask covers exactly 32 requested states; bit set = `logres`, clear = `blizzard`. `evaluate(requested, coverage, current, restored)` accepts explicit, synthetic, caller-supplied facts: `coverage = full|partial|none`, `current = blizzard|logres`, `restored = bool`. It reads no client source, no secrets, no Blizzard presentation; it has no side effects.

Each domain result includes `requested`, `effective`, `fallback`, `pending`, and `reason`. If requested Blizzard, use native after restoration; if a previous Logres owner exists and native restoration is not confirmed, hold the Logres effective owner and report `pending-restore` pending=true, not an early removal. If requested Logres with no capability, effective stays Blizzard. Partial capabilities retain `native-required` fallback; full capabilities say `native-available` without claiming proof that stock UI is in fact accessible. These strings are **policy fixtures only**, not runtime assertions. Native ownership still requires real client capability, protected/combat gates, documented restoration and proof.

## Deterministic test coverage

- All **32** requested permutations, both full and no-capability cases.
- Five independent bit flip probes per permutation = **160** noninterference comparisons; changing one requested domain cannot change other domain outcomes.
- One partial-coverage fallback example per domain = five.
- One deferred-restore and resumed-native handoff per domain = five each; other four domains stay native.
- Invalid request maps and invalid mask values fail closed in the pure evaluator.
- Four schema-3 legacy boolean combinations: `immersionEnabled` and `activeQuestEnabled` both false/true; `legacy_passthrough` deep-copies but **never migrates or rewrites** any player setting. Other keys stay preserved. Current live schema remains 3.

## Implementation constraints and next gate

Pure reference fixtures permit source-level regression checks while Forever is unavailable. They do **not** prove execution of future Lua policy, saved migration behavior, native visible controls, secret/protected safety or combat transitions. Before wiring real selectors, explicitly decide safe legacy migration per domain and run matching Lua policy tests; protect D-047 frozen camera, action/pet and both distinct gossip/trainer parking owners. Runtime evidence on November 4 remains required for P0321 and future native restoration changes. New changes must not silently change previously accepted Immersion defaults.
