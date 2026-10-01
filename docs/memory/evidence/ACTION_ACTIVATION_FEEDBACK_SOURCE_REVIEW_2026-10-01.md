# Action Activation Feedback Source Review — 2026-10-01

Status: SOURCE-RESOLVED
Date: 2026-10-01

## Trigger

P0039 action execution works, range feedback works, and normal GCD/cooldown
display works.

The user reported that actually using a Logres action has no immediate
per-button response.

This is blocking before stock Blizzard action-bar suppression because the
stock interface currently supplies useful tactile activation feedback.

## Blizzard precedent

Current Blizzard action-button source explicitly manages pressed button state:

```text
ActionButtonDown
    -> SetButtonState("PUSHED")

ActionButtonUp
    -> SetButtonState("NORMAL")
```

Current Blizzard ActionButtonTemplate also defines:
- a PushedTexture;
- a PostClick path in the action-button code template.

Logres' hand-built bare SecureActionButtonTemplate buttons were missing these
presentation affordances.

## P0040 correction

### Held mouse press

Adds the standard pushed texture:

```text
Interface\Buttons\UI-Quickslot-Depress
```

### Activation pulse

Every secure Logres action button gets a short additive pulse from its
`PostClick` path.

Purpose:
- mouse execution has immediate local response;
- temporary override-binding clicks have the same response;
- feedback is independent from GCD/cooldown/range state.

## Safety boundary

The activation pulse:
- does not inspect spell IDs;
- does not inspect cast GUIDs;
- does not consume spellcast payloads;
- does not change protected secure action attributes;
- is presentation-only.

The separate player cast/channel rune remains the global ongoing cast cue.

P0040 does not claim that the activated button remains highlighted for the
entire cast/channel duration.

## Sources

Current Blizzard source:
- `Blizzard_ActionBar/Shared/ActionButton.lua`
- `Blizzard_ActionBar/Mainline/ActionButtonTemplate.xml`

Relevant precedent:
- explicit PUSHED/NORMAL state;
- PushedTexture;
- PostClick action-button path.
