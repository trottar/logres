# P0220 — Available unaccepted quest starts as source-backed local compass POIs

Baseline: verified P0219 `63a7557` on `main`. Candidate version 0.0.129-dev; **WoW UNVERIFIED**.

- Accept nearby available and unaccepted quests as the local-POI role, not the accepted quest destination lane. Exact bearing, same-map, safe coordinate, range and quest-log eligibility are mandatory.
- Optional `NavigationSourceProbe.lua` read-only, secret-gated `C_QuestLine.GetAvailableQuestLines` candidate (maximum 24 entries), excluding accepted/completed/hidden state. Pinned Forever 1.60.1 API docs show position/name fields; they do not prove exhaustive quest-giver positions.
- `Compass.lua` reads only addon-owned sanitized candidates, rechecks player map position and current minimap view radius on its **existing** update cadence and renders up to eight nearby quest POI glyphs using P0219's approved sheet-12 asset. Exact-bearing x values are never adjusted; overlapping candidates may use vertical lanes. Name focus fades continuously from source-provided ordinary quest names. All markers disappear on lost eligibility/source/policy.
- No Blizzard canvas/pin inspection, no synthetic positions, no map mutation, no new polling, no pet/action/Blizzard minimap changes. If API lacks data, no Logres quest POI appears and native minimap remains available.
- Guarded baseline blobs, memory+roadmap+decision checkpoint, shadow full static suite, whitespace validation, manifest, no commit/push. Evidence and any runtime failures are to be recorded durably; **candidate is not accepted or complete until WoW tests**.
