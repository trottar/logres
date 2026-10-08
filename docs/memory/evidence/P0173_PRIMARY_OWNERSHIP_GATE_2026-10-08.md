# P0173 — Main primary-bar source and ownership gate

Date: 2026-10-08. Candidate runtime `0.0.89-dev`. Baseline GitHub `main` `3a5028c8`. **SOURCE FINDING + UNTESTED RUNTIME CANDIDATE.**

## Accepted observations

User reports P0172 leaves mostly Logres UI, with the native Main primary action bar still visible; all dock buttons tested work. Uploaded `0.0.88-dev` diagnostics: Native Access PASS at `folded=0 open=4` after manual reopening (not persistent fold proof), Layout PASS (16/18), Bars 2–5 replacement PASS, Action PASS with Primary `keys=false/12`, Run All PASS and `primaryRoutingOwned=false`. Do not treat that as evidence of safe Main suppression.

## Exact source finding

Forever 70245 source pin `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`:
- `Interface/AddOns/Blizzard_ActionBar/Mainline/MainActionBar.xml`: `MainActionBar` is an `EditModeActionBarTemplate` with 12 secure buttons, page number Up/Down controls, artwork and native Quick Keybind controls.
- `Interface/AddOns/Blizzard_ActionBar/Shared/MainActionBar.lua`: `MainActionBarMixin:AttachToFrame/DetachFromFrame` can reparent the root; MKB/gamepad init transitions Show/Hide it; the `ACTIONBAR_PAGE_CHANGED` lifecycle updates the page. This is not a stable ordinary-only background frame.
- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md` preserves `C_ActionBar` possess, vehicle, override, temp shapeshift and extra mode APIs and native cancel/exit/pitch/extra roles.

The existing Logres Primary 12 ID/actionpage secure button implementation offers normal-page execution and optional `SetOverrideBindingClick` key routing only. The presence of buttons and source API booleans does **not** prove combat-safe Main replacement, special-mode transitions or native edit/rearrangement. A simple Main `Hide` is specifically **DEFERRED**, not an accepted patch.

## P0173 diagnostic design

The probe reads only fixed source presence and secret-preflighted boolean `C_ActionBar` mode flags. It never captures secret-capable values as ordinary booleans, tries stock frame Show/Hide/alpha, reads protected native presentation state, mutates actionbar pages, changes key bindings automatically, polls, or forces Blizzard events.

Classification: read-only PASS with all mode sources ordinary and stock buttons present; otherwise DEFERRED. `normal=true` and `routingReady=true` are a candidate for a future replacement design, **not** authority to hide Main. Special or unknown modes remain stock.

## Runtime acceptance pending

P0173 must be deployed then tested on actual client. Before any Run All mutation, run Phase C Primary Ownership Check and save output; manual temporary Action Keys ON existing binding/left click proof, OFF native restoration, Action/Native checks, Run All. Record any Lua, taint, protected or secret errors as failures. If special mode is not naturally accessible, mark that proof environmentally DEFERRED. The primary visible duplication remains OPEN Phase H.1 work.
