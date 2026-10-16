# Current Handoff — P0224 QuestieDB source audit

Authority: `docs/memory/CURRENT.md`.

P0223 is pushed and verified at `27505f1`. User confirms only the focused quest marker, correct bearing/name, and distance scaling; leave the slight close-range-size refinement for later. Other live role providers still yield zero local AreaPOI, vignette and available quest-line rows.

P0224 is **DOCS ONLY**: QuestieDB's published `QuestDB.startedBy` and `NpcDB.spawns` offer quest-start/NPC spawn candidates, not reliable live quest availability, full service categories, or engine tracking detections. AreaID→UiMapID mapping, percent normalization, client compatibility and provider performance must be proven. QuestieDB is not installed or made a dependency by Logres. Next: one positive/negative public-API+Forever map bridge experiment, then only a guarded optional runtime provider if validated. No WoW redeploy for P0224.
