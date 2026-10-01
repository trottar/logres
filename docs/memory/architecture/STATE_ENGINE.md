# State Engine Architecture

## Principle

Logres separates **state detection** from **presentation policy**.

State detection answers facts:
- Is the player in combat?
- In an instance?
- PvP flagged?
- Interacting with an NPC?
- Mounted?
- Is immersion enabled?

Presentation policy answers:
- Should the compass exist?
- How opaque is the secondary action cluster?
- Which target information is visible?
- Which camera profile applies?

## Initial conceptual model

```lua
State = {
    immersion = true,
    context = "world",
    combat = false,
    pvpFlagged = false,
    mounted = false,
    resting = false,
}
```

This is illustrative, not yet implementation source.

## Constraint

Do not model every combination as a separate monolithic mode (`WorldPvPCombat`, `WorldCombat`, etc.) unless evidence proves modifiers cannot remain composable.

## Priority concept

Some contexts may override presentation more strongly:
1. protected/technical restrictions;
2. instance requirements;
3. combat;
4. PvP flag;
5. interaction/travel;
6. ordinary immersion/world defaults.

Exact priorities remain an implementation decision after the API audit.
