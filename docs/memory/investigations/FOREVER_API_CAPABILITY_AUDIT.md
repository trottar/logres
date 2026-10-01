# I-001 — WoW Forever API Capability Audit

Status: QUEUED  
Phase: 0.2  
Opened: 2026-09-30

## Question

What APIs, events, restrictions, and protected-state rules does the current WoW Forever client expose for the systems Logres intends to build?

## Why this must happen first

Logres intentionally depends on unusual presentation choices. Building against remembered Retail/Classic behavior risks architectural rework if Forever differs or inherits modern restrictions.

## Audit areas

### Client/project identification
- project constants;
- interface/TOC requirements;
- addon loading/version behavior.

### State/events
- combat;
- PvP flag;
- instance entry/type;
- resting;
- mounted/travel;
- NPC interaction.

### Player health/resource
- exact vs percentage APIs;
- secret values;
- update events;
- safe display transforms/curves.

### Unit information
- target/focus/party/pet;
- health/power;
- level;
- classification/elite state;
- restrictions in combat/instances.

### Casting/channeling
- self casting;
- hostile casting;
- event availability;
- secret/protected data.

### Actions
- secure action buttons;
- combat lockdown;
- visibility/alpha/layout changes allowed during combat.

### Navigation
- player map position;
- facing;
- map IDs;
- objective/quest locations;
- restrictions inside instances.

### Questing
- quest text/objective APIs;
- tracker data;
- NPC interaction events.

### Social
- chat frame manipulation;
- whisper/system message handling;
- automated outbound replies;
- addon restriction state.

### Camera
- CVars;
- zoom;
- shoulder offset;
- dynamic pitch/focus;
- protected/restricted contexts.

## Evidence standard

For each important capability:
1. current primary documentation/source if available;
2. source examples from maintained Forever-compatible addons where useful;
3. in-client probe later when behavior is uncertain or architecture-critical.

Record contradictions explicitly.

## Result states

Each audited item should end as one of:
- VERIFIED AVAILABLE;
- VERIFIED AVAILABLE WITH RESTRICTIONS;
- VERIFIED UNAVAILABLE;
- DOCUMENTED BUT NOT RUNTIME VERIFIED;
- UNKNOWN / NEEDS PROBE.

## Negative results

Unsupported APIs, secret-value failures, forbidden operations, taint/combat-lockdown failures, and misleading documentation are first-class results and must be preserved.

## Deliverables

- this investigation updated with findings;
- evidence records for substantive source/runtime proof;
- `architecture/API_BOUNDARIES.md` curated from verified findings;
- decisions for implementation choices forced by those boundaries.
