# P0461 — Preserve native nameplate aura presentation (2026-11-16)

## Exact baseline and scoped observation

GitHub main verified `edf37197e2f3b087a3f1b51d7ec41e6a3832aee4`,
tree `fe8063edd6f5b94af08c0a1a75a71c3fd8e1015b`, version
0.0.329-dev. Latest user Report Bug Forever session 132 #13580
(2026-11-16 12:29:32 EST), standalone and ZIP diagnostics identical,
source/deployed/capture version match. User reports **HP/nameplates
worked great, no observed issues** besides auras. Report: selected
3 attaches / 3 restorations, secondary 4 attaches / 4 restorations,
17 stable secondary updates, 0 owner/restore failures; screenshot is
post-combat, so it cannot prove auras while applied. This is a scoped
player VISUAL PASS for HP, not exhaustive OFF/taint coverage. L-011
PARTIAL; L-028 aura OPEN.

## Evidence and isolated source defect

`StatusAuras` ordinary target reader reports 0 harmful/0 helpful,
40 `C_Secrets.ShouldUnitAuraIndexBeSecret` index skips (not 40 distinct
auras). P0449 native world AuraContainer **initialized** and P0450
`HUD:ClaimNativeEnemyDecor` thus adds both Blizzard `AurasFrame`
`DebuffListFrame`/`BuffListFrame` to its opacity claim. That mutation
suppresses native nameplate auras without any proof that addon world
children have visible icons. This source behavior is observed directly;
it is a plausible cause of missing aura display, not a verified causal
record of one particular hidden debuff in the screenshot.

P0449 earlier user confirmed world icons visible; duplication with a
screen target copy was reported. P0450 suppressed both native nameplate
aura lists and the owned screen target copy in response. P0461 corrects
the unsafe policy rather than adding another unreadable aura source.

## Proposed owner and constraints

While World Enemy ON, native *nameplate* aura lists (Blizzard engine)
remain the sole world aura renderer for selected and secondary enemies.
No stock aura list is captured or modified, even if unprotected. Addon
world-native AuraContainer construction is kept as historical code but
no longer invoked for live ownership; ordinary world lanes are kept
hidden to prevent duplicate textures. The independent addon-owned
screen `target` AuraContainer remains a fallback if ordinary native
list references are unavailable; it receives reversible opaque alpha
handoff only when stock nameplate aura lists are structurally present.
These references are validated without probing protected icon children,
aura contents, `IsShown`, alpha or other secure presentation state.
Native casts, CC/raid, click regions, and chosen selected/secondary HP
are untouched. No new polling/secret comparisons/secure SetUnit changes.

## Acceptance and possible limitation

Test in Forever with known harmful and helpful **actually applied** to
selected and nonselected enemies; visually check native aura icons
appear once, are legible beside Logres HP, and no remote/screen duplicate.
Verify ownership on unrelated removal, target switch, OFF restore,
click, casts, secret/taint errors and restoration refusal.
A preserved native aura source does not guarantee a particular client
configuration renders a specific aura. Full visual PASS must not be
claimed from static evidence. Old P0454/P0455/P0458/P0459 failures,
P0449 icon PASS, P0450 duplicates FAIL all remain historical.
