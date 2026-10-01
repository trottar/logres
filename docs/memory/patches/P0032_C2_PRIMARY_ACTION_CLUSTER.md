# P0032 — C.2 primary action cluster

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Intent

Implement the first Logres secure action cluster.

## Runtime

Version:
`0.0.13-dev -> 0.0.14-dev`

Adds:
- Actions/Primary.lua;
- 12 SecureActionButtonTemplate buttons;
- 4 x 3 layout;
- current action-page slot mapping;
- native action-button registration;
- secret-safe cooldown/count presentation;
- usability/range tint;
- existing ACTIONBUTTON1–12 session override bindings;
- Action Check diagnostics.

Stock Blizzard action bars remain visible.

## Combat policy

Secure action execution works through protected buttons.

Page/binding protected mutations:
- apply out of combat;
- defer during lockdown;
- retry on PLAYER_REGEN_ENABLED.

Known C.2 limitation:
combat-time page changes leave Logres on its prior mapped page until combat ends.

## Additional fix

P0029's command-output fallback contained recursive `emit(message)` wiring.

The panel path worked because it supplied an output sink.

P0032 restores `print(message)` for no-sink slash output and adds static
regression coverage.

## Validation-tool false failure

The first P0032 validation run stopped before packaging because the newly added
`check_action_contract.py` contained an invalid Python regular-expression
character class.

Classification:
- static-tool implementation failure;
- not an addon runtime/API failure;
- not evidence against the secure action implementation.

The regex was corrected and the complete repository validation suite was rerun.

Final result:
all static checks PASS.

## Runtime proof

Required:
- Action Check PASS;
- cluster visible;
- click execution;
- keyboard execution;
- cooldown transport;
- ordinary combat execution;
- no protected/secret errors;
- `/logres status` slash fallback prints normally.
