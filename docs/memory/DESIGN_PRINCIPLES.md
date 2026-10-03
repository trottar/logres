# Logres Design Principles

These principles constrain implementation choices. They describe product intent, not API feasibility.

## 1. World before abstraction

Prefer information communicated through the world, animation, sound, spatial context, encounter behavior, and restrained diegetic-like presentation over conventional bars and panels.

## 2. Imperfect knowledge is intentional

The addon may know more than it displays.

Not every available datum should be converted into a meter, icon, level number, warning, or classification badge.

## 3. Contextual revelation

Information should appear because the current situation makes it useful.

Exploration, combat, PvP, NPC interaction, instances, travel, and other states may reveal different amounts of interface information without becoming separate unrelated UIs.

## 4. Danger should be felt, not merely read

Player health is represented primarily by visual pressure at the screen edges rather than an exact health bar.

Enemy danger should often emerge through the encounter itself. Discovering that an enemy is elite/formidable after engagement is acceptable and sometimes desirable.

## 5. Animation first

Character and enemy animations should carry as much action/casting information as practical.

Supplementary UI should confirm ambiguity rather than replace animation with progress bars by default.

## 6. Controls should feel composed, not spreadsheet-like

Action controls use compact rectangular/square clusters with a coherent Warcraft aesthetic.

The primary cluster remains mentally available; less important controls recede until context calls for them.

## 7. Immersion is orchestration

Immersion mode coordinates multiple systems:
- compass/navigation;
- camera;
- action visibility;
- quest presentation;
- social silence;
- contextual HUD information.

It is not equivalent to hiding chat.

## 8. Instances are a distinct context

World-immersion features that do not make sense or cannot function in instances should suspend automatically and restore cleanly afterward.

Combat-critical presentation can remain.

## 9. PvP increases caution, not clutter

Being PvP flagged modifies visibility and camera/HUD caution.

It should reveal enough information/control access for situational awareness without falling back to a conventional maximal HUD.

## 10. Warcraft aesthetic, not Skyrim imitation

Skyrim is a reference for interaction patterns such as a compass and restrained quest presentation, not a visual skin to copy.

Logres should remain visually native to Warcraft.

## 11. Accessibility is a deliberate exception, not an accidental erosion

Where a role or player need requires more explicit information, provide configurable alternatives while preserving the default philosophy.

## 12. A failure that teaches is progress

Technical and aesthetic failures are recorded and used to narrow the design space.


## 13. Placement communicates meaning

Place information according to ownership, urgency, and relationship to the
world.

Urgent player state belongs near the player's reaction space. Passive state can
recede to the periphery. Target information should live on the world target
when safe. Detached frames are fallbacks when the world cannot carry required
information or interaction reliably.
