# P0279 — Service element mapping registry and M verification inspector

Date: 2026-10-20. Baseline: pushed `41826a9324b5484fde9f6fe162d10beb5b808ea4` (P0278 R1).
**Prepared; WSL full-suite and WoW M-tab outcomes unverified.**

## User-approved reference and scope

The user's approved landscape Enchanting trainer screenshot is the **desired design**, not an actual installed UI. P0278 R1 screenshot shows a real functioning, partially Logres-styled, still vertically framed Blizzard trainer. User reports improvement, but styling remains **PARTIAL / OPEN**. Do not conflate artwork mockup with validated native controls.

The user requests a durable, indexed association of each proposed Logres service UI element with the actual Blizzard surface/child, reusable for merchants, flight masters, and subsequent native services. A dedicated developer-panel **M — UI Mapping** tab must show indexed mappings and support controlled highlight/hide verification. No further speculative full reskin should precede this association.

## Sources, confidence and mapping

- ElvUI Forever trainer source (`ElvUI/Game/Shared/Skins/Trainer.lua`) explicitly uses `ClassTrainerFrame.ScrollBox`, `ForEachFrame`, `ClassTrainerFrame.FilterDropdown`, `.ScrollBar`, `ClassTrainerStatusBar`, `ClassTrainerSkillIcon`, `ClassTrainerTrainButton`, `ClassTrainerFrame.money` and the skill-step control.
- ElvUI merchant source (`ElvUI/Game/Shared/Skins/Merchant.lua`) uses `MerchantFrame`, indexed `MerchantItem` controls, buyback, money, tabs, and repair; native/Modern variants may differ.
- ElvUI taxi source (`ElvUI/Game/Shared/Skins/Taxi.lua`) identifies Classic `TaxiFrame`, `TaxiMap`, `TaxiRouteMap`, and close control. Forever availability must be probed independently.
- Aurora Classic is a secondary reference; its trainer uses fixed `ClassTrainerSkillN` rows, not necessarily Forever's ScrollBox hierarchy.
- No code or visual assets are copied from ElvUI/Aurora. Source-level names are **SOURCE_CANDIDATE** until verified in the running Forever client. Proposed left category sidebar, search, reagent view and Train All have **UNMAPPED** native source; do not invent one.

## Design and safety invariants

`Quest/ServiceElementIndex.lua` contains data only: stable IDs, service, role, label, native field path, source, status and independent inspector outline parameters (color, size, strata). `Dev/MappingInspector.lua` is an on-demand read-only resolver; it first establishes an ordinary native reference and unprotected/shown state out of combat. A mouse-disabled, addon-owned overlay highlights only the resolved object's bounds. It is temporarily parented to a verified unprotected native frame so closing that frame also hides the overlay; OFF restores the overlay parent to UIParent. **The native object's** layer, visibility, parent, field, texture, alpha, protected action and transaction state are never modified. **Hide removes the overlay only**, not a Blizzard UI control. Dynamic recycled ScrollBox row IDs are intentionally DEFERRED (`dynamic-row-identity-unverified`) until a real client row identity probe; no probing by secret-capable classification.

`Dev/Panel.lua` adds **M** as a paginated verification view; individual indexed mappings can be selected and highlighted and the highlight can be explicitly hidden. Every selection records service, role, source/status, and PASS or DEFERRED in the existing `LogresDiagnosticsDB` export. Existing 108 H/P and phase actions remain unchanged; P preview/live styling is separately managed by D-046. In-game highlighting is not proof of skinnability.

## Deferred follow-ups

- Future service maps must add names only after source inspection and client confirmation.
- Trainer rows and category identity need an evidence-backed `ForEachFrame` mapping and possible recycling/update lifecycle, not speculative hooks.
- Native control hiding/reparenting, safe reversible styling, filtering, transaction handling and landscape reflow remain separate gated work; the inspector performs no such mutations.
- System-wide overlaps between Logres HUD and Blizzard panels remain deferred to a global strata/visibility refinement rather than trainer-specific hacks.

## Validation checklist / status

Static: exact baseline; full candidate shadow checkers; diff; manifest; no unauthorized action registrations; no native writes. Client: open real trainer; `/logres` -> M; choose `trainer.frame`, `trainer.list`, `trainer.filter`, `trainer.train`, and unavailable `trainer.search`; verify correct highlighted bounds, explicit OFF, and DEFERRED for unsupported fields; close/reopen and verify no click interception or errors. Repeat mapping on merchant and flight master **only when naturally accessible**, no travel requirement. No WoW PASS is claimed by this document.
