# C.3 — Secondary / Utility Clusters

Status: SOURCE-RESOLVED; IMPLEMENTATION NEXT
Opened: 2026-10-01

## Goal

Extend the proven secure action architecture into Logres' broader action
constellation without prematurely suppressing Blizzard's stock bars.

## Source resolution

Canonical evidence:
`../evidence/C3_SECONDARY_UTILITY_SOURCE_REVIEW_2026-10-01.md`

Canonical decision:
`../decisions/D-019_SECONDARY_UTILITY_CLUSTER_CONTRACT.md`

## First implementation scope

Secondary:
- slots `61–72`;
- `MULTIACTIONBAR1BUTTON1–12`;
- 3 x 4 left-side cluster.

Utility:
- slots `49–60`;
- `MULTIACTIONBAR2BUTTON1–12`;
- 3 x 4 right-side cluster.

Primary remains:
- current primary page;
- 4 x 3 center cluster.

## Reuse boundary

Extract a shared secure button/presentation primitive.

Do not rewrite Primary's proven paging/binding orchestration wholesale in the
same patch.

## Key-routing safety

Default:
- new cluster routing OFF.

Developer panel:
- Secondary Keys ON/OFF;
- Utility Keys ON/OFF.

Both domains must be mouse-tested and keyboard-tested.

## Visibility

Only static visual weighting in C.3.

C.4 owns contextual visibility/security policy.

## Stock UI

All Blizzard action bars remain visible in C.3.

## Runtime proof requirements

1. Secondary shows the expected stock Action Bar 2 actions.
2. Utility shows the expected stock Action Bar 3 actions.
3. mouse execution works on each cluster.
4. existing binding labels appear when present.
5. explicit Secondary Keys ON makes those existing keys execute via Logres.
6. Secondary Keys OFF releases routing.
7. explicit Utility Keys ON/OFF behaves equivalently.
8. cooldown/count/range/usability presentation works.
9. Primary remains regression-free.
10. ordinary combat execution works.
11. no protected/taint/Lua/secret errors occur.
12. layout coexists with Phase B HUD.
13. stock Blizzard bars remain present.

If the user's current Forever binding domain differs from the source mapping,
record the mismatch as runtime evidence and correct the contract rather than
forcing the current-source assumption.

## Exit

C.3 completes when both new fixed-slot domains are runtime-proven and Primary
remains intact.
