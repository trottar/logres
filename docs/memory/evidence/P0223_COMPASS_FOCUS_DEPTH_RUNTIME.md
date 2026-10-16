# P0223 — First positive quest markers; focus selection and distance scale

Date: 2026-10-16. GitHub main P0222 `b1fa8442c532c506c5527bfc7ecc0684104dd6d0` verified. User screenshot shows real accepted quest direction markers and a correct quest title below the compass. This is the **first user-confirmed non-waypoint family**, limited to accepted quest map destinations; P0220/P0221 had no such proof.

## Runtime observation (0.0.131-dev, loadCount 295)
Read-only Navigation Source Probe on map 1432 captured 3 accepted quest-map POIs with ordinary positions: 237 `In Defense of the King's Lands` at 663.01 yards; 255 `Mercenaries` at 966.81 yards; 2039 `Find Bingles` at 733.38 yards. Super-tracked quest ID 237. Actual screenshot confirms quest markers and center identity. Quest-map `rolesAccepted:3`, `near:3` means all within the source's eight-radius major destination cap (radius 133.33y), **not** within the one-radius local POI cap. No source failure or secret skips. This is accepted as proof of production quest position/bearing, not of every possible quest objective.

## Presentation defects observed
All three accepted quests drew major glyphs although the design calls for one focused quest. Their graphic dimensions were constant at 10x18 despite very different world distances, because P0222's quest paint path did not call `manualWaypointDepthScaleForDistance`. User asked for focused-only presentation and distance-responsive sizes.

## P0223 correction candidate
Use only the already-validated ordinary `NavigationSourceProbe.superTrackedQuestID` to choose the accepted quest destination; retain all source rows for evidence without inventing a quest selection. If no super-tracked focus or no matching positioned destination, show no major quest marker; local POIs and tracking roles remain independent. Apply existing waypoint's bounded [0.70,1.20] distance-depth curve to the selected quest glyph, never to coordinates/bearings. Keep exact-bearing horizontal placement and manual waypoint unchanged. Add developer-panel fields for focusedQuestID, depth band and render scale. 0.0.132-dev runtime must still be tested.

## OPEN / SOURCE LIMITED
AreaPOI=0, vignette=0, availableQuestLines=0 in this same sample. Four active minimap tracking *filter choices* do not identify located objects. Thus **available quest giver POI**, **local service POI**, and **resource/tracking** glyphs remain unproven/OPEN. No fabricated blips, no pin scraping, no stock minimap suppression. Next source work should use a reproducible positive, ordinary coordinate feed or clearly scoped compatible location data. No travel or contrived gameplay required to force an environmental result.

## Acceptance criteria
With quest 237 focused, marker for 237 rotates at true bearing and is scaled smaller at 663y relative to a near quest of the same role. Unfocused 255 and 2039 do not render despite remaining in the probe's source list. Changing focus to another accepted quest selects that marker on the next source update. Focus absent or no valid source means no stale major marker. Immersion OFF hides all compass glyphs, stock map remains accessible, static contracts and WoW tests must pass.
