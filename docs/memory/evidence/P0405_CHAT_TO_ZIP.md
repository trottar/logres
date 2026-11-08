# P0405 — Deterministic Chat-to-ZIP builder

GitHub main P0404 fab3259b9efdfeee7adb61c9fd2a4b6dadb35d96 verified. The user approved the centered Flight Paths window in Forever. The screenshot shows Goodbye, Stormwind departure, map pins and route line, and an Ironforge sidebar fare of 50c. Travel and Goodbye execution were not observed. P0403 multi-quest late acceptance awaits a natural reproduction. The user requested a pause on further NPC work to prioritize a reusable Chat-to-ZIP path.

## NPC follow-up

- L-001 and L-005 stay open or partial for multi-quest sequencing, reward choices and unsupported variants. Collect Report Bug only if relevant gameplay naturally occurs.
- L-002 native flashes stay deferred. Trainer purchase has a scoped profession pass. Confirmations and trainer variants retain safe stock handoff.
- L-003 regular merchant purchase, sale and buyback passed within scope. Quantity popup styling and special merchant operations are deferred.
- L-004 flight layout passes within the screenshot scope. Route execution and Goodbye remain unverified.
- Service coverage later includes innkeepers, spirit healers, stables, banks and auctions where available. Route merchant-like interactions through service/catalogue components and gossip/quest-like ones through their corresponding narrative and decision components. Preserve safe native fallback where coverage is incomplete.

## Packaging pilot

The old one-time ZIPs embedded handwritten per-patch packaging metadata. The new WSL builder accepts one Git unified diff, the exact baseline, and an explicit path list. It compares the real staged file list to that allowlist, builds on a baseline archive, and runs repository checkers in a temporary candidate. The self-contained ZIP has fixed member order, timestamps, metadata and uncompressed bytes. It embeds source and payload hashes and the exact checker names. Its applier refuses unexpected HEAD, tracked changes, path collisions or hash mismatches and runs the same suite before and after working-tree writes. A failed write or postwrite check restores patch-owned files. Output includes the SHA-256 and an apply-time manifest. Git commit and push remain user-controlled.

Version one handles UTF-8 text edits and additions under existing directories. Deletions, renames, binary assets, symlinks, new directories and mode changes require a separate workflow. In-game validation remains a separate gate for runtime patches. P0405 changes tools and project memory only. See docs/memory/patches/CHAT_TO_ZIP_WORKFLOW.md.
