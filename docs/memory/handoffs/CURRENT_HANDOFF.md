# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Project Logres is in **Phase 0 / 0.3 — Minimal addon skeleton/load proof**.

P0005 prepares the first actual addon runtime:
- `Logres.toc`;
- namespace/event bus;
- database initialization;
- central state;
- `/logres status`;
- WSL deployment/check tooling.

It intentionally contains no product HUD.

Next:
1. commit/push P0005;
2. deploy to Forever;
3. `/reload`;
4. verify load message and `/logres status`;
5. verify `loadCount` increments across another reload;
6. exercise basic combat/instance state;
7. record runtime evidence or failures.

User performs all commits/pushes.
