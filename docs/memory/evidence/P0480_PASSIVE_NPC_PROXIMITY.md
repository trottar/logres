# P0480 — L-035 passive native NPC proximity for 3/4-yard compass snap

2026-11-18. Verified GitHub main P0479 `7f6f2a2e4938bd01bdc7ffac71e0ce85691abfed`, tree `9ea76d43836c59bcae409e97127bcb637d3417fe`.
P0479 source/deployed runtime candidate `0.0.346-dev`; user reports
"Back to how it was without 3yrd proximity I wanted." This is a user-observed
**P0479 functional FAIL in normal untargeted NPC approach**, not a claim that
any specific screenshot or incident proves new behavior. P0477's near-NPC disappearance and P0478's rejected
approximation prefixes/floor-unknown captions and P0476's false 2D 2-yard
floor proximity remain distinct known negative outcomes.

## Narrow root cause

P0479 retains the correct 3/4yd hysteresis but the proof helper only
inspected `npc`, `target` and `mouseover` unit tokens. Typical nearby NPCs
have no such token until explicitly targeted or hovered. Thus the NPC was
left in its ordinary map-only bearing path, without requested sticky center.

Forever 1.60.1 exposes native `softinteract` (a proximity-selected unit
without a hard target) and `nameplateN` tokens when its nameplate lifecycle
has supplied them. These tokens can be matched by *ordinary* `UnitGUID`
Creature template ID and a normal `CheckInteractDistance(unit, 3)` result.
This is a **broad 3D interaction-range gate** (index 3 is approximately
7 yards), not proof of an exact 3-yard distance. The existing canonical map
X/Y distance <=3yd is still the snap threshold; 3–4yd stays latched only
when the same unit has live proof. Neither check discovers NPCs the client
has not exposed or guarantees an upper/lower floor match when vertical
separation is smaller than the interaction threshold. Exact Z for arbitrary
NPCs is not ordinarily available to addons; `ClosestUnitPosition` returns
secret-capable values and must not be inspected/branched on.

## P0480 implementation

Extend the existing secret-safe, out-of-combat native unit proof path to
`softinteract` first, followed by `npc`, `mouseover`, and `target`. Observe
`NAME_PLATE_UNIT_ADDED` / `NAME_PLATE_UNIT_REMOVED` on a dedicated addon event
frame and inspect only event-observed nameplate tokens, capped at 40 ordinary
nameplate indices. The existing compass refresh interval is unchanged.
Do not enable or alter nameplate CVars, forced targeting, soft interaction
settings, player input, or any protected Blizzard presentation. No stored
GUIDs or secret-capable values. Event tokens are checked anew before every
use; restricted/unavailable data fails open to the existing ordinary map
bearing and existing no-number <4yd label, never a made-up 3D distance.

Keep P0479 no-tilde visual language, opacity, source ranking, clipping,
service collision, map-keyed bearing hold, original quest marker snap and
Blizzard NPC/quest interaction fallback unchanged. Record *only* addon-owned
sources for successfully centered services: softinteract/nameplate/legacy;
Report Bug includes whether the nameplate event lifecycle registered.
L-002 intermittent Blizzard flash remains separately OPEN and unchanged.

## Test status and limitations

Source-level Lua fixtures exercise softinteract with no target, passive
nameplate add/remove and sanitization, missing/protected/secret/range refusal,
legacy target/mouseover, and preexisting 3/4-yard center/hold/release.
Historical contracts and transactional installer gates are required before
handoff. Even after all static tests pass, **WoW Forever runtime remains
UNVERIFIED**: check whether `softinteract` or native NPC nameplates are
available with the user's unchanged client settings. If no live token is
exposed, Logres must not invent proximity, and L-035 stays OPEN. Do not
ask the user to change settings or target an NPC merely to claim general
no-target behavior. A scoped in-client test can compare walking toward a
same-floor NPC with no hard target and an upper/lower-floor NPC nearby.

No evidence of the native popup owner is provided by this patch.

## Assistant preflight negative R0

First complete source-audit pass **263/342 STATIC PASS**; 79 historical
checker failures all traced to assistant-generated CURRENT.md (10009 bytes)
and CURRENT_HANDOFF.md (8064 bytes) exceeding enforced budgets (<9800 and
<8000). No runtime, parser or client failure was established by these
checks; R1 shortens only active summaries and preserves historical markers.
Do not treat R0 as PASS.
