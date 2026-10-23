# P0319 — universal NPC gossip stage presentation: runtime negative evidence and guarded correction

2026-10-23. Exact pushed GitHub main P0318 `de325e6` verified. **P0319 candidate PREPARED; WoW runtime UNVERIFIED** until the user deploys. Existing P0318 `0.0.219-dev` screenshots and diagnostics demonstrate a clear, reproducible PRESENTATION DESIGN FAIL: Logres displayed ordinary gossip options but did not display an NPC conversation stage with a nonempty narrative body and no ordinary options.

## Observed cases supplied by the user

- **Grimnur Stonebrand** (fishing trainer): P0318 Logres narrative and one `GetOptions()` row displayed alongside Blizzard; source `model-ready`, options=1, quests=0. This is visual coverage, **not proof of native button execution**.
- **Ironforge Guard**, first stage: Logres listed multiple direction choices with three-page option pagination, while Blizzard listed choices. After selecting a destination (fishing trainer and others), the **follow-up narrative** displayed in Blizzard but not Logres. The screenshot alone does not prove whether a new `GOSSIP_SHOW` event fired. P0318 rejects all zero-choice stage models even when their body is readable.
- **Gerrig Bonegrip**: P0318 prior diagnostic `model-ready`, options=0, quests=1. Quest-only NPC dialogue remained Blizzard-only, despite ordinary `C_GossipInfo.GetText` content. The quest entry must stay Blizzard-owned until a dedicated safe quest selection policy is implemented.
- **Eldrun Stormbreaker** (shaman trainer approached as a warlock): Blizzard displayed introductory text, Logres did not. The exact current C_GossipInfo option/quest counts were not sampled; treat text-only as a likely case, not a verified raw-data claim.

These are examples of one general option-count gate, **not** NPC-specific exclusions. Do not demand more NPC screenshots or special travel. Preserve complete failure evidence regardless of later success.

## Narrow implementation

`NPCGossipPresentation.TryShow` now accepts the validated gossip stage if its model root provides either one or more ordinary options or a nonempty string body. `NPCOptionSession.StartReadOnly` accepts a zero-option model only if the validated node has a nonempty narrative body. The SAME Quest/NPC narrative renderer displays the body; it clears rather than draws an empty option-list view. Nonzero options still use the approved existing paginated list and P0318 click controller. `GOSSIP_SHOW` continues to be the event-driven update source; `GOSSIP_CLOSED` and quest/service handoff clear Logres presentation. No timer, polling, native click, stock hide, native frame geometry, or camera edits are added.

For quest-only gossip, display body **additively** while Blizzard remains available to choose quests. Text-only follow-up can display without a fabricated button. A stage lacking any readable body and without gossip options stays Blizzard-owned. This is **fail-open**: none of these rules replace Blizzard quest selection, trainer transactions, or NPC services. Do not infer single-window completeness.

## Validation and deferrals

P0319 must pass the full 190-checker WSL suite PREWRITE and POSTWRITE, guarded baseline and source blobs, and `git diff --check`; user's commit/push then verify main. Deploy, `/reload`, speak with the already encountered NPC classes. Observe guard initial page and following directions text, Gerrig quest-only narrative, and text-only trainer prelude; verify native quest and service choices remain usable, no Lua/taint/secret errors. If follow-up still disappears, record separately as an event-delivery problem and examine authoritative events, without speculative polling. P0318 actual Logres-native click execution remains UNVERIFIED; no PASS implied.

Quest 237 reserved. This patch does not authorize native quest selection, replacement of stock frames, or any undocumented WoW behavior. Beta access ending on October 23 may defer additional runtime cases until November 4; defer without asserting PASS.
