# P0172 — Native surface root access and runtime gate

Date 2026-10-08. Baseline `26fa1ef7844e76e8c91016d0fe56f7f77458225d`, Forever 70245 pinned Blizzard UI source `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`.

## Source-backed domain mapping (not a runtime proof)

- Navigation: `Blizzard_Minimap/Mainline/Minimap.xml` defines `MinimapCluster`, containing minimap/tracking/indicator surfaces. It has native ping, zoom and tracking functions absent from Logres Compass. A dock toggle must reveal native root on demand.
- Full watched objectives: `Blizzard_ObjectiveTracker/Blizzard_ObjectiveTracker.xml` defines `ObjectiveTrackerFrame`; source manager `Blizzard_ObjectiveTrackerManager.lua` can update/show the managed container. A manual restored root remains essential for watched quests not exposed by one-focus Active Quest. Possible re-show from native lifecycle must be tested, never periodically re-hidden without evidence.
- XP/status: `Blizzard_StatusTrackingBar/Mainline/StatusTrackingBar.xml` defines `StatusTrackingBarManager`, main/secondary containers. Logres Context XP is transient; full native progress becomes accessible via the dock.
- Menu/bags: `Blizzard_MicroMenu/Mainline/MicroMenuContainer.xml` defines `MicroMenuContainer`; bags are independent `BagsBar`. Native functions remain usable through a dock and Immersion OFF.

All roots are captured with classified non-secret `IsShown()` only as restoration state, not as diagnostic readback. `Hide()` removes child interaction with its whole frame; unsupported/missing roots fail open. Combat lockdown defers actions. The diagnostic only reports addon-owned snapshots and state; manual full-screen interaction remains decisive. Source does not establish that protected stock roots will accept this mutation, or that Blizzard will not Show them later; these are open in-game gates.

MainActionBar has native vehicle/override/possess/bonus behavior and `MainActionBar` can change parent; PetActionBar contains protected drag/autocast/binding/target interaction. Existing Logres Primary/Pet units do not provide complete secure replacement. They **must not** be hidden merely to pass the visual test. Secure coverage remains unfinished H.1 product work.

## Test and failure discipline

Test clean login before Run All; each of four dock buttons opens/restores its actual native source, can click it, closes back to Logres; STOCK toggles all. Verify Immersion OFF restores exact native state, ON recloses; no clickable invisible stock children; no secure/taint/secret/Lua errors. Check native lifecycle updates after quest progress/world transition; re-shown native root is a runtime integration failure to record, not concealed by `GetDebugStatus()` ownership flags. Combat-time deferred access is not acceptable as full functional coverage if important UI becomes inaccessible; keep H.1 OPEN and correct. Do not require contrived gameplay.

Status: **STATIC CANDIDATE — IN-GAME VALIDATION PENDING.**
