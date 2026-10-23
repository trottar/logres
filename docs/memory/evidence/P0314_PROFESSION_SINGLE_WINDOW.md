# P0314 — profession trainer single-window and explicit stock restoration

2026-10-22. Baseline P0313 verified main `5824a1d`. **PREPARED / FULL STATIC AND WOW UNVERIFIED.**

## Observed accepted state
User supplied P0313 screenshots: Enchanting service list visible, Fishing zero-service Logres shell with current Fishing Journeyman 61/150 and complete all-professions section; user reports class trainer and checked professions working. Class single-window native parking + native-close Goodbye earlier user PASS; Enchanting one requested profession purchase was user PASS while Blizzard window still visible. User explicitly states profession Blizzard frames must go analogous to class, and prefers trainer completion ahead of NPC gossip. Generic focus messages “See offered training” and “No listed training services” are not acceptable final copy.

## New guarded policy
The whole `ClassTrainerFrame` is moved offscreen and remains IsShown for native source / purchase guard only after Logres has a valid model, finished renderer and wired an always-available user-clickable **Blizzard UI** action in the existing Train All button location. Source family `IsTradeskillTrainer` is an independently ordinary true boolean. `NPCServiceNativeParking.ParkProfession` is a one-shot scoped capability: fails to stock if ordinary source / combat / protection / anchors / native hooks / addon-owned conflict not satisfied. Parking.Restore is still the single restoration path; native anchors remain opaque restoration tokens. Restoration must complete before closing Logres, and rejected restore keeps Logres visible until event-driven retry; no invisible native clicks or broad hide hooks.

For profession Goodbye, the profession `CloseTrainer` controller is authorized ONLY after a positively recorded successful park and a successful stock restore. If native parking failed, normal profession Goodbye dismisses Logres without closing Blizzard, matching the user-accepted fallback. Explicit Blizzard UI action restores native frame and dismisses Logres on click without a native close. The empty Fishing service model is still inert and does not invent an offer; its real native information can be reached in one click.

## Existing contract migrations and limits
P0308/P0309/P0311/P0312/P0313 historical static contracts originally prohibited all profession parking and native Goodbye. Those blanket prohibitions are superseded by a guarded, fail-open capability with an explicit restoration action. They are migrated in this checkpoint, while all original class transaction, family/secret guards, source/API selection, legacy preview fixtures and load adjacency remain. Native profession purchase still uses P0309's one-service at most and independent service/cost revalidation, not class Train All. After a profession purchase request the current controller restores stock while the source may be stale; the user may observe Blizzard until a fresh interaction. This is an explicit **UNVERIFIED continuation limitation**, not a hidden success. No gameplay/test PASS is claimed from static reasoning. P0311 wrong native-close when stock remained visible and P0313 R0 checker failures remain durable negative history.

## WoW criteria
Run after pushed/deployed P0314: class trainer still Logres only, Goodbye natural; Enchanting, Cooking and zero-service Fishing show Logres alone after successful parking; in all profession sessions **Blizzard UI** restores the stock window while dismissing Logres; reopen then Goodbye closes the native visit without a stock flash. If any native frame stays visible, classify as DEFERRED rather than suppress forcefully, and inspect owned parking `GetAudit`. Actual purchase behavior while parked remains a separate test; no need to buy purely for proof. Any Lua/taint/secret/protected errors are FAIL and require correction.

## Next NPC family
Use already installed P — NPC Choices: Branching / Services / Overflow / Locked, `NPCOptionModel`, `NPCOptionSession`, `NPCOptionList`, and Quest Dialogue shared narrative. The next gated checkpoint is live gossip source sampling through H — Integration and Polish, not automatic click/stock suppression. D-046/D-047 authority.

## P0314 R0 PREWRITE artifact failure (2026-10-22)

R0 archive SHA-256 verified, baseline clean and pinned P0313 main checked. R0 stopped at `P0314_APPEND.md EOF` before candidate static checks or tracked writes. This was an assistant artifact-packaging failure, not a WoW runtime failure. R1 normalizes only the extracted append payload terminal newline and reruns the original guarded P0314 applier and its complete prewrite/postwrite checks. No runtime behavior is considered PASS from this correction.

## Subsequent user report and verified push (2026-10-22)

GitHub main `f40a8e0` contains P0314. User reports latest pushed checkpoint a success with no noticed issues. Record **user-reported runtime PASS within observed interactions**, while class/individual profession variants and native restoration under combat or subsequent purchase were not separately enumerated. Preserve the originally PREPARED evidence and P0314 R0 prewrite failure as history; do not overwrite them or infer complete runtime coverage.
