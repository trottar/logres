-- P0277: trainer inputs vary independently; visual vocabulary is shared.
-- These are addon-owned preview/art values, NOT Blizzard native control geometry.
local _, Logres = ...
local art = Logres.Theme.panelSurface
Logres.PanelConfigs = Logres.PanelConfigs or {}

local trainer = {
    preview = {
        width = 560, height = 430,
        point = "TOP", relativePoint = "TOP", x = 0, y = -110,
        strata = "DIALOG", mouse = false,
        title = "TRAINER / PANEL ART",
        note = "Visual fixture only — native trainer controls remain Blizzard-owned",
        titleFont = "GameFontHighlightLarge",
        noteFont = "GameFontHighlight",
        titleX = 0, titleY = -20, noteX = 0, noteY = 0,
        titleColor = art.colors.title, noteColor = art.colors.body,
    },
    surface = {
        background = {
            mode = "nine-slice", texture = art.assets.panel,
            layer = "BACKGROUND", sublevel = -7,
            corner = 40, referenceWidth = 640, referenceHeight = 320,
        },
        divider = {
            texture = art.assets.divider, layer = "BACKGROUND", sublevel = -6,
            horizontalInset = 72, height = 18, x = 0, y = -52,
        },
    },
}
Logres.PanelConfigs.trainer = trainer
return trainer
