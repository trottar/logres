# P0292 — Trainer identity, ability prerequisites and source status

Date: 2026-10-21. **PREPARED / WSL AND WOW UNVERIFIED.** Verified GitHub baseline P0291 `0afc23619aedb569a90471a7b3f66b0c8b4a75fb`.

## User-observed scope and negative result

User's P0291 `0.0.192-dev` WoW screenshot, beside a stock Druid trainer, shows five live names and ranks, spell icons, required levels, service costs and selected spell description. H panel says `live-read-only-visible`, `displays=3`, `deferrals=0`, and zero reported native purchases, filter, selection or geometry writes. **INFORMATION PARTIAL PASS, native replacement UNVERIFIED.** Blizzard shows `Wrath (Rank 2)` needs `Wrath (Rank 1)` as well as Level 6; Logres displays only Level 6. Logres heading reads `Trainer services` instead of `Mardant Strongoak`, and availability text is not classified. The user has deferred overall visual polishing. No screenshot proves transactional behavior or safe native suppression.

## External source evidence and narrow correction

Blizzard Forever `Interface/AddOns/Blizzard_TrainerUI/Mainline/Blizzard_TrainerUI.lua` (public `Ketho/wow-ui-source-forever`, `forever` branch) uses `GetTrainerServiceNumAbilityReq(skillIndex)` to bound ability requirements, `GetTrainerServiceAbilityReq(skillIndex, i)` for the name and possession flag, `ClassTrainerFrame:SetTitle(UnitName(unit))`, and `GetTrainerServiceInfo(skillIndex)` second return textual `available`/`unavailable`/`used`/`header`. Logres P0291 already verified the six-field source, but omitted ability requirements and name/title/status model fields. P0292 adds independent ordinary() guards for optional count, ability names and flags, a maximum four-ability bounded copy, and a guarded ordinary `UnitName("npc")` title with generic fallback. The ordinary NPC header is scoped to nonpet example; pet trainer identity remains UNVERIFIED. The model renders descriptive availability state from already-safe serviceType; this does not authorize Train or status toggles.

## Safety and validation gates

No native selection, purchase, filter, geometry, stock suppression, polling, interactivity or safe-session changes. Preserve the P0284 accepted portrait-free visual layout, the P0291 icons/prices/requirements, and the P0290 partial-field fallback. Unavailable or secret-capable individual information is withheld; no secret-capable value may be compared, counted, formatted or stringified. All fields are copied only after `ordinary()` checks. Bounded source lists remain `MAX_SAMPLE=12`, `MAX_SERVICES=384` and max four ability requirements per sampled row. No player-owned Lua action buttons. Full static checks PREWRITE/POSTWRITE and Git whitespace are mandatory, then one `/logres panel` H Live Trainer ON/OFF visual comparison against stock; runtime PASS is not claimed in advance.

Prior errors stay preserved: P0290 R0 CURRENT memory-health PREWRITE FAIL, P0290 R1 diff EOF FAIL; P0289 R0 frozen action inventories; P0287 R0 checker version pin; P0285–86 incorrect legacy tuple and P0288 partial-source rejection. No purchase needed to validate this informational change.
