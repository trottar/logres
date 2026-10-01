# Social / Quiet Mode Architecture

## Intent

Quiet Mode supports deliberate social silence during immersive play.

Candidate behavior:
- hide chat frames/tabs;
- suppress nonessential social UI presentation where permitted;
- retain configurable critical/system exceptions;
- optionally support an away/immersion indication only if current WoW restrictions permit it safely.

## Constraint

Do not promise automated replies or hidden social actions until the Forever API audit establishes what addon chat/social operations are permitted.

## D-025 Quiet Mode runtime presentation

Quiet Mode does not change communication status.

First pass suppresses passive chat/social visuals at runtime while preserving
intentional outbound chat.

Direct ChatFrame Hide/Show is forbidden because Blizzard persists
ChatWindowShown from those scripts.

Selected path:
- snapshot alpha/mouse;
- alpha zero;
- mouse disabled;
- edit boxes ignore parent alpha;
- exact restore.

Auto replies remain outside this contract.
