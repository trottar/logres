# P0333 — L-021/L-024 pet hotkeys and active-spell visual coherence

**Baseline:** pushed GitHub P0332 `cbc2015a87a91035b25e6ea65585164ef495f470` (2026-10-24), with P0332 R0 refused prewrite because its generator reversed blob/path pairs; R1 committed. **Classification:** source-level correction prepared; full WSL and WoW remain UNVERIFIED / ENVIRONMENTALLY DEFERRED until November 4, 2026.

## User reports and narrow cause

L-021 user reports that pet action buttons lack keys such as `C-2`. `PetActionExecutionProbe.lua` sets every Logres pet hotkey label to empty and `Actions/Button.lua` clears it during `RegisterPet`; unlike primary/secondary action bars, the pet probe has no `UPDATE_BINDINGS` presentation route. Blizzard's pet binding command format is `BONUSACTIONBUTTON1`–`BONUSACTIONBUTTON10` (used in its own PetActionButton hotkey code); do not remap the binding.

L-024 reports a superficial active-spell outline defect. `ActionButton.UpdatePet` enables the generic `CheckButton` checked overlay for active pet state, while `PetActionPresentation` separately shows a full pet-active edge border and wash. This produces competing active-outlining layers. The existing overlay also hides valid ordinary active state if either independent autocast boolean cannot be read. These are source-proven presentation conflicts but the client's exact visual symptom is not independently reproduced.

## Implementation boundary

Read `GetBindingKey("BONUSACTIONBUTTON" .. slot)` through `pcall` and `issecretvalue`; do not inspect, format or forward a secret or invalid value. Display only a validated ordinary first key using the existing `ActionButton.SetHotkeyLabel`, which already formats CTRL/SHIFT/ALT. Never `SetBinding`, `SetOverrideBinding`, or alter secure pet button type/action/page attributes. Refresh labels after the existing out-of-combat pet button configuration and upon `UPDATE_BINDINGS`. Unbound or unavailable labels are blank, not fabricated.

Decorated pet buttons retain their already established dedicated active edge and pip, while `ActionButton.UpdatePet` suppresses only the redundant generic checked overlay; an undecorated pet button retains that generic fallback. A valid ordinary active flag now shows its custom outline regardless of unknown/secret autocast flags; autocast remains shown only when both necessary ordinary booleans affirm it. Never inspect secret state. Leave normal action buttons, native pet actions, secure clicks, stock restoration, combat lockdown and frame strata unchanged. Keep all old negative evidence.

## Static/runtime gates

The P0152 R7 historical adapter checker is migrated to match the explicitly conditional checked-state fallback. New `check_p0333_pet_presentation_contract.py` asserts source placement, pet binding sanitization, `UPDATE_BINDINGS`, no secure routing change, conditional checked overlay, independently guarded active/autocast presentation, and six deterministic binding cases and four active/autocast policy cases. Expected 204 PREWRITE shadow and 204 POSTWRITE checkers; strict exact P0332 clean-main baseline/14 Git blobs, shadow hygiene, rollback and P0333 manifest. The 204-checker suite can be run only on the user's full WSL checkout.

**November 4:** after initial P0321 gossip restoration priority, verify a pet with a bound CTRL modifier shows `c-2` using the existing plate, another bound/unbound slot, an ordinary `UPDATE_BINDINGS` change, active spell presentation versus autocast and unreadable-state fallback, Immersion ON/OFF, combat/secure execution, Pet Stock recovery. Record Lua/taint/protected/secret errors as FAIL; environmental absence as DEFERRED. No runtime PASS is claimed. Subsequent offline issues: L-023 PvP symbols, L-022/L-027 quest visuals/native popups, compass L-030–032.
