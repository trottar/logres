# P0472 — Chat visible on startup (2026-11-17)

Baseline GitHub main P0471 `d35bb8590cbf3bc1e07e23bafe72bce1d8484987`,
verified tree `aeb6e04d11d86c6eeb9dbc6cf4dd3ca48a8f5cbe` and matching
SHA256-checked tracked-only handoff. User reports recent aura appearance
working well and explicitly requests default chat ON. This is a preference
change, not a diagnosed Quiet Mode runtime failure; no L-ID invented.

QuietMode manualOpen initializes true rather than false on each login/reload.
The existing P0469 Phase N Chat [SHOW]/[AUTO] remains the same in both
directions: AUTO re-enables Quiet Mode only in immersed world context; SHOW
restores stock chat. No persistent Blizzard shown-state, channel, CVar,
ChatFrame Hide/Show, protected input, edit-box or other immersion mutation.
Manual toggle remains session-only, and reload intentionally returns to SHOW.
Existing P0469 failed-restoration, queued-event and context checks retained;
actual-source fixture now explicitly tests initial SHOW and AUTO cycles.

Version 0.0.340-dev, static contract and source fixture updated. P0471 crest,
P0468/P0469 accepted auras and nameplate/50-50 geometry remain untouched.
Mandatory full exact-candidate checker suite, Lua parse, fixture execution,
canonical transactional ZIP PREWRITE/POSTWRITE/refusal/rollback and manifest
required before delivery; scope outcomes recorded in P0472 audit checkpoint.
WoW runtime result for P0472 is UNVERIFIED. Check Phase N Chat [SHOW]
after /reload, then [AUTO], then [SHOW], Phase D Quiet/Immersion checks,
and intentional outbound Enter-to-chat. Do not claim full chat/taint proof.

Author R0 full candidate: 334/335 STATIC PASS; version-policy checker
REFUSED because new P0472 contract pinned 0.0.340-dev. Changed only the
new contract to dynamic TOC/Bootstrap parity; historical checker preserved.
No user checkout writes, no ZIP release from R0.
