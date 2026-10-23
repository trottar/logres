# P0319 — universal NPC text-only and quest-only dialogue stage presentation

Date: 2026-10-23. Baseline: verified pushed P0318 `de325e6`. PREPARED / WoW UNVERIFIED; WSL suite pending.

Remove two zero-gossip-choice eligibility restrictions in `NPCGossipPresentation` and `OptionSession`, preserving the exact shared Quest narrative renderer. Allow only verified stage models with a nonempty text body or actual options. Zero-option stages show narrative without inert empty option-list grid; options still use the existing guarded P0318 native choice controller. Mixed quest/gossip remains eligible; quest entries still only native/Blizzard. Native frame, protected click, camera and transaction policies untouched. P0318 guard follow-up, Gerrig, and Eldrun negative observations preserved in evidence. No speculative polling or `GOSSIP_UPDATE` event hook added.

Next: static checks, user push, deploy/reload, naturally retest guard follow-up and NPC text-only/quest-only, record any remaining event handoff failure as OPEN with evidence. Never claim runtime PASS without the client test.
