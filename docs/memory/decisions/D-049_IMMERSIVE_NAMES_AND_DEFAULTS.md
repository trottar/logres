# D-049 — Immersive overhead names and world defaults

Status: ACCEPTED user design; runtime implementation UNVERIFIED
Date: 2026-11-16

World Enemy defaults ON; screen-space enemy name/HP/input defaults OFF.
Respect explicit saved choices. Hide ambient NPC/player/pet labels and titles;
native selected-unit names plus current Logres combat plates remain. Preserve
accepted selected100% and secondary50% size/opacity and P0465 aura appearance.

Use one reversible, supported ordinary CVar whitelist in immersion policy,
OOC only, original values preserved across reload and restored on OFF/disable.
No native frame hiding/secret inspection/polling or anchor enumeration. Native
focused/target/mouseover semantics remain client validation, never source PASS.
This explicit user instruction supersedes only D-042's no-CVar/proof-opt-in
restriction and mandatory screen-fallback default. The screen display is now
an explicit opt-in; usable native fallback and restoration remain required.
Other D-042 anchor/secret/native-input boundaries remain unchanged.

See docs/memory/evidence/P0466_IMMERSIVE_NAME_DEFAULTS.md and L-049/L-050.

P0467 intake: user accepts P0466 requested default/name behavior on verified
main d1b1cdd. Scoped runtime PASS; full recovery/taint/other-client matrix remains
unverified. Prior implementation-UNVERIFIED label above is historical.
