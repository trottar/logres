# C.6 — Action Interface Integration Validation

Status: ACTIVE
Opened: 2026-10-01

## Goal

Validate Phase C as one integrated action interface rather than as isolated
features.

C.6 does not expand suppression scope.

It validates the already-proven capability boundaries together.

## Current Phase C capabilities

### Secure action execution
- Primary secure execution;
- Secondary slots 61–72;
- Utility slots 49–60.

### Presentation
- icon;
- cooldown;
- count;
- usability;
- range;
- local activation feedback.

### Context
- world weighting;
- combat weighting;
- PvP modifier;
- Utility intentionally more subdued.

### Routing
- explicit Logres key-routing paths;
- activation feedback follows routed execution.

### Selective stock replacement
- stock Bar 2;
- stock Bar 3;
- reversible/session-only;
- routing coupled to replacement.

## Explicit non-capabilities

Do not broaden C.6 into:
- MainActionBar suppression;
- special vehicle/override/form replacement;
- Bars 4–5 suppression;
- persistent stock replacement;
- final D-020 layout editor;
- live move/swap/remove action editing.

These remain separate capability gates.

## Integration validation matrix

### Baseline / reload
1. deploy current Phase C build;
2. `/reload`;
3. confirm replacement defaults OFF;
4. Run All PASS;
5. no Lua/secret/protected error.

### Normal world
6. Primary fully legible;
7. Secondary subdued;
8. Utility more subdued;
9. mouse execution works;
10. range/cooldown/count state remains correct;
11. action activation feedback works.

### Routed keyboard
12. enable/test Logres routing;
13. routed keys execute correct actions;
14. routed activation feedback appears;
15. releasing routing restores normal stock-key path where applicable.

### Combat
16. contextual alpha transitions correctly;
17. Primary/Secondary/Utility remain executable;
18. cooldown/range/usability remain coherent;
19. no protected mutation error;
20. pending replacement requests defer safely if exercised.

### PvP
21. PvP modifier raises action visibility outside combat;
22. combat still takes precedence.

### Selective replacement
23. Stock Replace ON removes only stock Bars 2–3;
24. Primary remains stock-visible;
25. Bars 4–5 remain stock-visible;
26. old Bar 2–3 locations do not create invisible mouse blockers;
27. Secondary/Utility routed keys remain functional;
28. Stock Replace OFF restores Bars 2–3.

### HUD coexistence
29. Phase B HUD and Phase C action constellation remain readable together;
30. health/resource/target/cast/ally presentation is not functionally blocked
    by the action interface.

## Environmental deferrals

Do not manufacture:
- instance entry solely for validation;
- vehicle/override/form state;
- current-target caster proof.

If naturally encountered, record evidence.

Otherwise retain existing explicit capability gates.

## Known open visual/product debt

Non-blocking for Phase C integration proof:
- cast/channel rune color regression;
- final action-layout customization;
- live action move/swap/remove editing;
- support for user's additional Bars 4–5;
- final art/tuning.

## Exit

C.6 completes when the integrated test matrix passes for the user's normal
world/combat/PvP workflow and selective replacement remains safely reversible.

Phase C then closes without claiming unsupported stock/special action domains.
