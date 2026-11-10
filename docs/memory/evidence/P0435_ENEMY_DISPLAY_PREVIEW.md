# P0435 — Enemy shared fixture and saved preference (2026-11-10)

Baseline: verified P0434 `d3ca9cce3ae404949c692ea7f1e1e23dda2d54e4`.

## Evidence and policy

P0432 Forever `0.0.305-dev`, incident 10457 observed `anchorPresent=true`
in combat, `lastCombatAttachmentState=combat-lockdown`, no secret skips or
failures. This proves access, not safe addon-owned attachment. No OOC safe
proxy attachment PASS; secondary unit identity and confirmed player aggro
have not been runtime verified. D-042 and L-011 still prohibit relocation.

## Implemented scope

- A saved Boolean `screenSpaceEnemyFrameEnabled` defaults false via additive
  schema-3 defaults on new AND existing saves and publishes change normally.
  Settings displays it, but it cannot suppress target fallback while world
  attachment remains unavailable. No changes to native nameplate settings.
- Existing HUD Preview ON/OFF (P tab via right-click Report Bug) additionally
  shows an owned enemy fixture panel. A synthetic OOC selected-only 100% unit
  and combat 100% selected + synthetic confirmed-aggro 50% secondary use the
  shipped percentage-bar primitive, typography, accent and cast spacing.
- Target harmful and helpful fixture lanes reuse StatusAuras' own 25px icon,
  3px gap, 2-column/5-icon code and share each frame's scale/alpha. Their
  roots are placed on opposite sides with 25px unit-frame gaps, preserving
  V8 relative placement. No aura instance, secret or protected state is read
  by the fixture. Live target helpful/harmful and native fallback unchanged.
- Report Bug records sanitized preference and fixture readiness, not a
  claim of actual world attachment or threat data.

## Explicit limitations

This is a **visual preview only**, not automatic world presentation. Actual
OOC only-selected and combat confirmed-aggro policy remain the acceptance
criteria for a later production renderer. No safe relative SetPoint during
combat has been established. No synthetic aura is presented as live.

## Acceptance and tests

Use P-tab existing HUD Preview ON then OFF. Confirm standalone preview shows
single selected OOC at 100%, combat target 100%, secondary 50% in both
geometry and alpha, with beneficial/harmful icon spacing and no changes to
normal Logres UI or Blizzard targets. Test new and existing saves default
OFF and preference persists after reload. Inspect Report Bug fields.
Static author-check and guarded WSL apply need independent PASS; preview in
Forever, protected failure paths and aura correctness remain UNVERIFIED.
