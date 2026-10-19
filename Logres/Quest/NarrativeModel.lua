-- P0261 N1: source-independent NPC narrative and visual decision model.
-- This module owns no frames, native calls, interaction, or protected state.
local _, Logres = ...
local Model = {}
Logres.NPCNarrativeModel = Model

-- Only supply ordinary, already-validated source text. Native quest reads and
-- secret-value checks remain in their original guarded quest adapter.
function Model.FromLive(title, body, objective, reason, action)
    return {
        title = title,
        body = body,
        objective = objective,
        reason = reason,
        action = action,
        previewOnly = false,
        autoHide = false,
    }
end

local LONG_BODY = "The road from the old watchtower has grown quiet. Travelers who once crossed the ridge at dusk now turn back before the first milestone. A patrol found signs of a struggle near the ruined wall, but no one returned with the standard that marked the northern post.\n\nThe captain asks that you follow the broken road, search the stones beyond the ridge, and recover what remains of the watch. If the raiders still hold the pass, drive them out before returning to town.\n\nThere may be more to the silence than simple banditry. Keep your eyes on the valley as you climb."

-- Every fixture enters the exact same production narrative renderer.
-- Generic gossip is TEXT ONLY: no unsupported option-selection controls.
function Model.Preview(mode)
    local title, body, objective, action
    if mode == "long" then
        title = "The Lost Standard"
        body = LONG_BODY
        objective = "Recover the lost standard beyond the northern ridge and return it to the captain."
        action = "offer"
    elseif mode == "short" then
        title = "A Message for the Watch"
        body = "Deliver this sealed note to the captain at the watchtower."
        objective = "Bring the message to the captain."
        action = "offer"
    elseif mode == "generic" then
        title = "Travelers' Welcome"
        body = "The road ahead passes through the old forest. Watch for fallen stones near the bridge, and follow the lanterns into town."
        objective = ""
        action = "none"
    else
        return nil, "unknown-narrative-preview"
    end
    return {
        title = title,
        body = body,
        objective = objective,
        reason = "preview",
        action = action,
        previewOnly = true,
        autoHide = true,
    }
end

return Model
