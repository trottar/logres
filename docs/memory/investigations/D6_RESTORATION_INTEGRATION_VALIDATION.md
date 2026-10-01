# D.6 — Restoration / Integration Validation

Status: ACTIVE
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

## Validation strategy

Prefer one integrated developer check over duplicating every module check.

The check may compose addon-owned diagnostic state already exposed by:
- ImmersionController;
- StockActionReplacement;
- QuietMode;
- PlayerFrameReplacement;
- TargetFrameReplacement;
- ActionContext.

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
