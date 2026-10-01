# D.6 — Restoration / Integration Validation

Status: ACTIVE — SOURCE-RESOLVED; RUNTIME DIAGNOSTIC NEXT
Opened: 2026-10-01

## Goal

Validate Phase D as one reversible system rather than as isolated features.

The focus is not new suppression policy.

The focus is:
- restoration;
- transition coherence;
- fail-open behavior;
- recovery;
- no required control/information loss.

## Required validation domains

### Preference lifecycle

Validate:
- Immersion ON;
- Immersion OFF;
- OFF -> ON;
- ON -> OFF;
- persisted preference through `/reload`.

### Protected transition safety

Validate:
- immersion change during combat;
- protected action replacement defers safely;
- Player replacement defers safely;
- Target replacement defers safely;
- deferred state converges after combat.

### Context integration

Validate:
- world policy;
- PvP modifier;
- natural instance transition where available;
- Quiet Mode restoration/reapplication;
- no unnecessary replacement churn.

### Module restoration

Validate developer recovery:
- module disable/restore path where supported;
- stock surfaces return before replacement interaction disappears;
- no invisible protected click regions remain.

### Required controls / information

Confirm Phase D does not remove currently required fallback surfaces:
- Primary stock ownership remains outside replacement;
- Party/CompactPartyFrame remain stock;
- target-of-target remains Blizzard-owned;
- target auras remain preserved;
- player class/resource child surfaces remain outside conventional shell
  suppression.

## Existing tracked follow-ups

These do not block D.6 unless reproduced as active regressions:
- intermittent unreproduced TargetFrame reappearance;
- future Aura / Status Presentation domain;
- cast cue color visual debt;
- D-020 live action editing;
- Primary replacement/routing ownership.

## Source/design resolution — P0062

Current source already has the restoration mechanics D.6 needs to validate.

### Restoration order

The supported replacement modules restore stock ownership before removing the
Logres path that substitutes for it:

- StockActionReplacement restores Bars 2–3 before restoring the prior Logres
  routing state;
- PlayerFrameReplacement restores the stock PlayerFrame shell/mouse state
  before disabling the Logres secure player interaction;
- TargetFrameReplacement restores stock TargetFrame presentation/mouse state
  before unregistering/disabling the Logres secure target interaction;
- QuietMode restores captured runtime presentation without writing saved chat
  visibility.

This order is the D.6 recovery invariant.

### Controller disable/re-enable

ImmersionController disable is already fail-open:

- Quiet Mode restore is immediate;
- action/Player/Target restore is requested;
- protected domains may defer in combat.

The controlled replacement modules remain independently enabled and each owns
its PLAYER_REGEN_ENABLED convergence path. Therefore a controller disable during
combat may safely leave a protected restore pending; the replacement module can
finish restoration after combat even though the controller itself is disabled.

Re-enabling ImmersionController subscribes again and immediately reconciles from
the current persisted preference + State.

### P0063 diagnostic shape

Add one integrated `Restoration Check`.

Out of combat it should perform a reversible cycle:

1. capture the original immersion preference;
2. verify the current controller/replacement state is settled;
3. flip the preference and verify all supported domains settle to the opposite
   ownership state;
4. restore the original preference and verify convergence;
5. disable ImmersionController and verify fail-open restoration while leaving
   the persisted preference unchanged;
6. re-enable ImmersionController and verify convergence back to the original
   preference-driven state;
7. verify the original preference is still the final preference.

In combat the check must be non-mutating. It should validate that requested
ownership follows the current preference and that protected action/Player/Target
state is either already converged or legally pending. Quiet Mode must remain
immediately coherent.

Runtime proof of combat deferral still requires an intentional immersion toggle
during combat followed by the same check after combat to prove convergence.

### Diagnostic evidence boundary

P0063 should add/use a narrow addon-owned recovery-state API.

Do not call protected Blizzard presentation getters merely to prove a native
mutation.

For Player interaction, add explicit Logres-owned interaction ownership state so
the integrated check can prove that no Logres secure click region remains active
after restoration without querying protected presentation state.

Target already tracks the corresponding unit-watch/mouse/suppression ownership
facts.

Static checks should enforce the recovery-state API and restoration ordering.

### Reload/context proof

`/reload` persistence and natural context transitions remain runtime actions,
not synthetic mutations inside Restoration Check.

Use:
- Restoration Check for reversibility/recovery;
- Context Policy Check for world/PvP/instance policy;
- Run All for the integrated regression surface.

Natural instance proof may remain environmental.

## Validation strategy

Prefer one integrated developer check over duplicating every module check.

The check should compose addon-owned recovery state from:
- ImmersionController;
- StockActionReplacement;
- QuietMode;
- PlayerFrameReplacement;
- TargetFrameReplacement.

Context Policy Check remains the canonical ActionContext/context-policy proof.

Do not inspect protected Blizzard presentation state solely for diagnostics.

## Exit

D.6 closes when:
- ON/OFF restoration is reliable;
- reload preserves the intended preference-driven state;
- combat-deferred protected transitions converge;
- Context Policy remains coherent;
- recovery paths remain fail-open;
- no required stock fallback is lost;
- no Lua/taint/secret regression is observed.

Phase D then completes.
