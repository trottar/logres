# Immersion Mode Architecture

Immersion Mode is a global presentation policy composed from contextual state.

Potential controlled subsystems:
- compass;
- quest presentation;
- camera;
- action-cluster visibility;
- HUD density;
- XP presentation;
- social/Quiet Mode.

## World

Full immersion features may operate.

## Combat

Retain the visual language while increasing access to immediately useful information.

## PvP flagged

Use a cautious modifier:
- keep world immersion where practical;
- increase access/visibility to relevant actions and target/party information;
- avoid overly tight cinematic camera behavior.

## Instance

Suspend world-navigation/compass behavior automatically.

Do not equate "instance" with disabling Logres entirely. Core combat HUD and action presentation remain Logres-controlled where technically safe.

## D-024 orchestration boundary

Phase D introduces ImmersionController as stock suppression/restoration policy
authority.

Inputs:
- D-010 preferences;
- observed State;
- proven capability status.

Initial automatic stock capability:
- Phase C Bar 2–3 replacement.

Initial Quiet Mode policy:
- world + immersion ON -> desired;
- instance -> conservative restore.

Unit-frame suppression remains capability-gated because stock secure unit
frames provide target/menu interactions and PlayerFrame owns un-replaced class
resource children.

The controller coordinates replacement modules rather than duplicating their
internal snapshot/combat logic.
