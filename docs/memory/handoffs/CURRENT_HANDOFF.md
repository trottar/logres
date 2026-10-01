# Current Handoff

Authoritative state: `../CURRENT.md`.

P0055 is verified pushed at `0c46f19`.

Current work:
**D.4 Target selective replacement runtime proof**

P0056 target:
`0.0.24-dev`

Adds TargetFrameReplacement, secure unit-watched target interaction, selective
stock target suppression, preserved aura/raid/quest/ping context, exact
restoration/combat deferral, and Target Frame Check.

Does not suppress target-of-target, Focus, boss targets, or Party.

P0056 changes runtime code; full deploy block is mandatory.

User performs all commits/pushes.
