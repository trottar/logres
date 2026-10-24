# P0331 — L-025/L-029 gameplay overlays beneath menus

**Baseline:** P0330 pushed main `1f48bbef79af2611f93063e253ca062a2a69fe18`, October 24 2026, manifest records 201 PREWRITE/POSTWRITE static checks. **Client status:** WoW Forever unavailable until November 4; all resulting presentation and protected-click behavior UNVERIFIED / ENVIRONMENTALLY DEFERRED, not PASS.

## Narrow observed source cause

The user's observed map/menu overlap (L-025) and action keybind plates above the health tunnel (L-029) are supported by the source's current presentation hierarchy, not yet reproduced after P0330: gameplay-only `LogresHUDRoot`, action feedback/keybind plate sibling, XP/progress notification roots, player/target aura lanes and optional native aura container occupy HIGH; action clusters, compass and focused quest root occupy MEDIUM. A UIParent-owned HIGH feedback frame is intentionally outside the action button hierarchy to remain visible when its cluster is faded, but also renders above a HIGH HUD tunnel. Native menus and dialogue have their own deliberate layers.

## Bounded implementation

Set only the *Logres-created, gameplay-only* roots to BACKGROUND: HUD, action cluster, UIParent feedback/keybind sibling, compass, active quest, XP pulse, objective progress pulse, StatusAuras, PlayerHelpfulAuras and the Logres native-aura container. Within BACKGROUND, explicitly set action feedback to level 10 and HUD root to level 20, so its health vignette masks are in front of the keybind plate without touching secure action attributes or the mask's secret-safe curves. Buttons remain interactive in gameplay and out of native menu space. Keep the feedback frame UIParent-owned so the separate activation path retains its original fade independence. Action-feedback historical contract is migrated to the new checked stratum rather than deleted. Bootstrap/TOC version parity becomes 0.0.225-dev; still 94 addon-loaded Lua files.

This does **not** modify NPC/quest dialogue, Logres developer/settings menus, Blizzard panels, camera, protected frame geometry, interaction routing, data sources, target aura algorithms, or native Blizzard UI suppression. The `NativeAccess` stock-recovery dock and other native restoration controls remain unchanged HIGH due to safety; they are **not** claimed visually accepted across open menus. No hooks, polling, blanket combat suppression or frame-level reassertion is introduced.

## Offline contract and environmental limits

P0331 adds `tools/check_p0331_gameplay_layers_contract.py` requiring all ten scoped gameplay roots to use BACKGROUND, correct intra-stratum ordering, historical feedback contract migration, retained stock-recovery dock/dialogue, version parity and issue continuity. Existing 201 feature checkers must run before and after tracked writes: expected 202 PREWRITE + 202 POSTWRITE. This is source policy evidence only. Screenshots with WorldMapFrame and a second native menu, overlapping action/keybind labels under low health, pet clicks/hotkeys, aura tooltip interactivity, and NPC dialogs are in-client gates for November 4; a failure is FAIL, not an environmental PASS.

**Known uncertainty:** native menu strata and click hit regions were not observed in the closed Forever client. BACKGROUND is intentionally below normal Blizzard interface strata, but full menu coverage is UNVERIFIED. Do not add a native frame mutation or combat-dependent hide without a reproduced overlap and safe fallback.

**Next:** verify user push, continue separate L-028 target-aura source correctness and remaining reported functional gaps offline; do not request client commands before access resumes.
