-- P0257: preview/live data contract for the existing quest reward visual.
-- This module owns NO frames, game-event subscriptions, native API reads,
-- secure/protected mutations or interaction handlers.
local _, Logres = ...
local Model = {}
Logres.QuestRewardModel = Model

-- Live adapters pass only values already checked by QuestDialogue's guarded
-- reader. Do not re-read, compare, stringify or otherwise inspect secret-
-- capable Blizzard data here. The model is a plain presentation envelope.
function Model.FromLive(cards, footer)
    return {
        cards = cards,
        footer = footer,
        action = "native-gated", -- policy remains CompletionControl/Blizzard
        previewOnly = false,
    }
end

-- Fixed visual fixtures use authored values, never a real quest or stock state.
-- Item ID 858 is only an optional read-only icon lookup hint in the preview;
-- it is NOT a quest-specific production reward mapping.
function Model.Preview(mode)
    local cards
    local footer
    local action
    if mode == "single" then
        cards = {
            { kind = "reward", name = "Sample healing potion",
              quantity = 3, itemID = 858,
              icon = "Interface\\Icons\\INV_Potion_51" },
        }
        footer = "1050 XP | 7s"
        action = "preview-complete"
    elseif mode == "multi" then
        cards = {
            { kind = "reward", name = "Sample supply crate", quantity = 2,
              icon = "Interface\\Icons\\INV_Box_01" },
            { kind = "choice", name = "Sample travel cloak", quantity = 1,
              icon = "Interface\\Icons\\INV_Misc_Cape_11" },
            { kind = "choice", name = "Sample leather gloves", quantity = 1,
              icon = "Interface\\Icons\\INV_Gauntlets_05" },
            { kind = "choice", name = "Sample healing potion", quantity = 3,
              icon = "Interface\\Icons\\INV_Potion_51" },
        }
        -- Same Complete Quest visual as Single. CHOICE cards remain
        -- display-only until the separate guarded selection path exists.
        footer = "1050 XP | 7s"
        action = "preview-complete" -- synthetic click is always inert
    else
        return nil, "unknown-preview-mode"
    end
    return {
        cards = cards,
        footer = footer,
        action = action,
        previewOnly = true,
        title = "Reward layout preview",
        body = "Visual sample only. This is not an actual quest reward.",
    }
end
return Model
