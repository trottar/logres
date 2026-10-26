# P0346 — Architecture gap and optimization priority register

**Authority:** verified pushed `main` P0345 `626b22038d09e738bd3fa90684e3a95e36905d45`, P0323 TOC/module ownership audit, P0324 inert domain policy fixtures, D-046/D-047/D-048 and CURRENT. **STATIC/UNVERIFIED**; no WoW runtime PASS. This is a planning tool, not an authorization to weaken stock Blizzard fallbacks.

## Confirmed structural baseline

- **94/94** loaded Lua files match exactly all `Logres/**/*.lua` files in pushed source; no missing load-list entry or orphan was found.
- `Logres/Core/Commands.lua` is about **241 KB, 6,581 lines** and has many independent diagnostic/command responsibilities. The developer-panel registry is **120** actions across phases with **38** P previews. P0343 R0 demonstrated the cost of violating historic registry counts (8/214 PREWRITE REFUSED before writes).
- Source includes existing P0323 complete module ownership and P0324 **32-combination** D-048 model. Neither supplies five live independent requested/effective/restoration switches.

## Prioritized gaps and narrow next evidence

| Priority | Gap | Safe next increment | Gate |
| --- | --- | --- | --- |
| P1 | Five independent D-048 selectors are not live | Specify per-domain requested/effective/partial/native-fallback state adapter and saved schema migration as a separate checkpoint, preserving legacy immersion settings | P0321 native restoration and safe 32-combination source tests; no premature runtime ownership claim |
| P1 | P0321, P0330–P0345 runtime changes not yet client accepted | Run contingent November 4 natural-context regression sequence with exact observed PASS/FAIL/DEFERRED | In-game evidence; no static-only acceptance |
| P1 | L-022 focused quest artifact, L-027 popup identity and L-028 target debuff inconsistency remain OPEN | Use previously prepared preview, Frame Stack and cached aura-route diagnostics; patch only a reproduced cause | Preserve Blizzard quest controls, native aura fallback and native frame controls |
| P2 | Cross-domain 241 KB command dispatcher is difficult to maintain | Extract one *read-only diagnostic* at a time behind an unchanged command/panel entry, with deliberate historical static checker migration | Full checker suite before and after; no action-inventory change |
| P2 | Large dialogue/camera/navigation modules need evidence-based decomposition | Map source adapters vs presentation/interaction and benchmark specific event/callback paths before code moves | No reactive camera changes while D-047 frozen; no new polling |
| P2 | Static checker suite has hundreds of historical string contracts | Use this pure audit and negative fixture to detect source/registry drift; review when checker migrations are genuinely necessary | 217 exact PREWRITE and POSTWRITE checker PASS, no relaxed historical gate |
| P1 release | L-019 root project license/public redistribution decision | Owner to select license and verify third-party notices/QuestieDB rights before public packaging | Public distribution remains BLOCKED |

## Invariants / exclusions

Do not infer missing Lua functionality merely from file size. Do not delete a Blizzard information/control surface unless Logres has a safe capability-gated replacement and restoration. No player exact HP, conventional player bar, secret-value readback, protected click region, global native suppression or CAMERA refactor. PvP remains a presentation modifier. Keep stock party, target-of-target and auras as designed until separately replaced. Do not claim optimizations improve FPS without runtime measurements.

## Tool usage

```bash
python3 tools/architecture_health_audit.py --strict
python3 tools/architecture_health_audit.py --json
```

The audit measures source structure only. It does not execute addon Lua or interact with the WoW client.
