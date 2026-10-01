# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Current work:
**A.2 — Additional Context Sensors**

P0010 implementation is prepared.

New fields:
- mounted;
- resting;
- onTaxi;
- interacting;
- interactionType.

New diagnostic:
`/logres sensorcheck`

The user is currently near the Ironforge flight path, so runtime proof should use that location:
- mount/dismount locally;
- nearby interaction;
- one short taxi leg;
- check taxi true + mounted false during flight.

No extra instance/combat travel is required.

User performs all commits/pushes.
