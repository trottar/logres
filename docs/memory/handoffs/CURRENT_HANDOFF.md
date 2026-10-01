# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Current phase:
**Phase C — Action Interface**

Current work:
**C.2 — Primary Action Cluster**

P0032 is prepared.

Version:
`0.0.14-dev`

Adds:
- 12 secure primary action buttons in a 4 x 3 cluster;
- existing ACTIONBUTTON1–12 key routing;
- icon/cooldown/count/usability/range presentation;
- Action Check in the developer panel.

Stock Blizzard bars stay visible.

Known limitation:
combat-time action-page remapping is deferred until combat ends.

P0032 also fixes a latent P0029 slash-output fallback recursion that the GUI path had masked.

P0032 changes runtime code; full deployment is mandatory before validation.

User performs all commits/pushes.
