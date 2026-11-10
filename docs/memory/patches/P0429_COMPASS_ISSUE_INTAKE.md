# P0429 — L-045 intermittent compass alignment report

2026-11-10. Verified baseline `06cca2c4d2e61543370ec93a3286cb592d922f4b` (P0428).
Ledger intake only. User first reported a slight compass misalignment, then
said it looked good and may have been a bug. Keep L-045 OPEN, intermittent
and unreproduced. The installed client build and exact misaligned element
are unknown.

The submitted screenshot shows `Priestess Josetta [profession] - 12 yd`
in compass focus and Michelle Belle in the target frame. Compass focus
and target selection are separate. The still does not establish a wrong
bearing or label. There is no corresponding Report Bug export. The original
screenshot is in the compass Chat handoff bundle as `compass-alignment.png`,
SHA-256 `781d670e9e6cdcc514e6ab7dd384aa98060679e7e7ee9bf682f79616a899e29f`.

At this baseline, `Logres/Navigation/Compass.lua` centers the caption
relative to the compass frame and positions glyphs by candidate bearing.
If it recurs, capture Report Bug once while visible and identify which
element is offset before changing layout or bearing. L-035 near-player
quest jitter, L-043 caption wording, and L-030/L-044 QuestieDB coverage and
freshness are separate. No code or runtime change. No WoW redeploy.
