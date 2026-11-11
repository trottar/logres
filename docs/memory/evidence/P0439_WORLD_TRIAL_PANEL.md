# P0439 — Panel-owned world-target trial input and results

## Baseline, symptom and result

Verified P0438 main `4fc6e8257e5597f4a91dbf88a44415eb1edd916f`
(tree `6dc2544fda892ec6745fb992bd48930c2467eb50`). On November 10 the
user reported that chat is unreadable during gameplay and the standalone
`worldtrial on/off` command cannot be the test workflow. The accepted
right-click Report Bug developer panel is the required UI owner. L-047 OPEN.
No Forever trial result had been obtained; do not treat that as an attachment
failure or a successful attachment.

## Change

Phase H injects view-local World Trial ON, World Trial OFF, and World Trial
Status buttons immediately after the four trainer controls. They are visible
on page one without adding/changing any of the 122 registered diagnostics.
The existing Panel:RunCommand routes results into its scrolling/saved output
rather than ordinary chat. Status reports only HUD-owned booleans, counts and
reason; the world anchor is never inspected for presentation or secret data.
Left-click Report Bug continues to save worldTargetTrial and screenshot.

## Safety and expected test

P0438's hidden OOC anchor proof, forbidden-state gate, secure combat hide,
positive hostile requirement and fail-open native/screen fallback remain
unchanged. Saved screen-space preference remains default OFF. There is no
new production renderer and no 50% secondary live unit policy.

In Forever: deploy to `_forever_`; `/reload`; right-click Report Bug; select
H; click World Trial ON, then World Trial Status. The panel should display
PASS or DEFERRED with a reason (no visible chat required). Test OFF and its
status; left-click Report Bug for a saved incident, `/reload` and export.
Do not force nameplate settings for a positive test. If unavailable, record
DEFERRED, not PASS. WoW runtime remains UNVERIFIED until user evidence.
