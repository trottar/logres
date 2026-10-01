# D.1 — Immersion Orchestration Source Review

Status: COMPLETE
Opened: 2026-10-01
Closed: 2026-10-01

## Result

D-024 is canonical.

Source review established:
- controller consumes preference + observed state;
- Phase C Bar 2–3 replacement can be automatically orchestrated;
- Quiet Mode can proceed as runtime-only chat/tab suppression;
- blanket Player/Target/Party suppression is not yet capability-safe.

## Blocking unit-frame findings

### Player

Full PlayerFrame suppression would also suppress Blizzard children including
class-resource / rune / totem / pet surfaces that Logres does not fully replace.

### Target

TargetFrame is a secure unit button and also carries aura/context presentation.

Current Logres target display does not replace all of those functions.

### Party

Normal and raid-style party member frames are secure unit buttons.

Current Logres party rows do not replace secure click targeting/menu behavior.

## Next

D.2:
implement the Immersion Controller runtime foundation and integrate the proven
Phase C selective action replacement.

No new Player/Target/Party suppression in D.2.
