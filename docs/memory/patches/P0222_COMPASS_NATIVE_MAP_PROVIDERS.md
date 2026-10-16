# P0222 — Multi-source compass roles, no fabricated detections

P0220 is verified at GitHub main `09175bc`; P0221 was applied locally but not pushed and its map-keyed quest-line request proved insufficient in the observed runtime (0.0.130-dev loadCount 293). This is a corrected coordinated checkpoint rather than another repeated quest-line request.

The P0222 candidate adds optional `C_QuestLog.GetQuestsOnMap` and `C_VignetteInfo` position providers to `NavigationSourceProbe`, consumes the previously captured `C_AreaPoiInfo` positions, and reuses the existing quest-line source as fallback. `Compass` draws accepted quest destinations, nearby available quest starts/local POIs, and classified treasure vignettes using approved sheet-12 assets and waypoint-like true bearings. Filters and identity gates use only ordinary addon-owned data. Normal minimap tracking filters alone still do not enumerate individual ore/herb positions; those remain OPEN. Diagnostic output names each source and rendered role even with zero candidates.

No new timer, native protected pin inspection, map state mutation, secure UI changes, or stock minimap suppression. In-client verification is mandatory; unpopulated sources are a negative source result, not a PASS.
