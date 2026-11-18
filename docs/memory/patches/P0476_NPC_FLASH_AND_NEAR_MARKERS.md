# P0476 — Near NPC compass marker and quest transition diagnostics

Baseline: `6447b501ecfc6ca20a75f1655732e3bf3f7ca494` (P0475).
Runtime 0.0.343-dev. Change only Logres Navigation/Compass, Quest/Dialogue,
Dev/Panel, version metadata, corresponding checker and memory. Source
intervention L-035 identified services, no new Blizzard ownership. L-002
receives read-only provenance but no suppression. L-002, L-035 remain OPEN
until separately validated in WoW Forever. Preserve prior failures and
fallback. Prewrite/postwrite, rollback and archive checks in audit/manifest.
