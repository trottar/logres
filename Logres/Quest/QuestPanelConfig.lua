-- P0277: quest-specific presentation inputs, independent of trainer geometry.
-- Existing approved quest sizes/position remain unchanged in this migration.
local _, Logres = ...
local style = Logres.Theme.questDialogue
local art = Logres.Theme.panelSurface
Logres.PanelConfigs = Logres.PanelConfigs or {}

local quest = {
    placement = { key = "questDialogue", point = "TOP", relativePoint = "TOP", x = 0, y = -110 },
    presentation = {
        width = 640, height = 320,
        titleWidth = 560, bodyWidth = 548, bodyHeight = 134,
        objectiveWidth = 548, objectiveHeight = 50,
        titleFont = "GameFontHighlightLarge", bodyFont = "GameFontHighlight",
        objectiveHeaderFont = "GameFontNormalSmall", objectiveFont = "GameFontNormal",
        pageFont = "GameFontHighlightSmall",
        colors = style.colors, assets = style.assets,
    },
    surface = {
        background = { mode = "stretch", texture = art.assets.panel,
            layer = "BACKGROUND" },
        divider = { texture = art.assets.divider, layer = "ARTWORK",
            horizontalInset = 72, height = 18, x = 0, y = -48 },
    },
}
Logres.PanelConfigs.quest = quest
return quest
