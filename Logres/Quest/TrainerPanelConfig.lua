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
        titleX = 0, titleY = -20, noteX = 0, noteY = -59,
        titleColor = art.colors.title, noteColor = art.colors.body,
    },
    motif = {
        solidTexture = "Interface\\Buttons\\WHITE8x8",
        panelTexture = art.assets.panel,
        rowWash = art.motifs.rowWash,
        rowRule = art.motifs.goldLine,
        scrollRule = art.motifs.scrollRule,
        scrollAlpha = 0.95,
        scrollSublevel = -8, scrollRuleSublevel = -7,
        scrollInset = 1, scrollTopInset = 1, scrollBottomInset = 1,
        scrollRuleHeight = 2,
        rowWashSublevel = -1, rowRuleSublevel = 0,
        rowInset = 1, rowTopInset = 0, rowBottomInset = 0,
        rowRuleHeight = 1, rowRuleY = 0,
        preview = { width = 440, height = 32, x = 0, rows = {-264, -307} },
    },
    -- P0280: own fixtures and native source mappings use these SAME paint recipes.
    -- Preview geometry is addon-owned; no Blizzard button geometry is set.
    components = {
        solidTexture = "Interface\\Buttons\\WHITE8x8",
        ids = {"trainer.filter", "trainer.selection", "trainer.status", "trainer.train"},
        styles = {
            ["trainer.filter"] = {fill=art.motifs.controlFill, rule=art.motifs.controlRule,
                inset=1, fillSublevel=-2, ruleSublevel=-5, ruleHeight=2, ruleY=0},
            ["trainer.selection"] = {fill=art.motifs.selectionFill, rule=art.motifs.goldLine,
                inset=1, fillSublevel=-2, ruleSublevel=-5, ruleHeight=2, ruleY=0},
            ["trainer.status"] = {fill=art.motifs.statusFill, rule=art.motifs.scrollRule,
                inset=1, fillSublevel=-2, ruleSublevel=-5, ruleHeight=1, ruleY=0},
            ["trainer.train"] = {fill=art.motifs.trainFill, rule=art.motifs.goldLine,
                inset=1, fillSublevel=-2, ruleSublevel=-5, ruleHeight=2, ruleY=0},
        },
        preview = {
            ["trainer.filter"] = {width=198,height=26,x=-112,y=-115,
                label="Available  /  All Skills",font="GameFontHighlightSmall",textColor=art.colors.body},
            ["trainer.selection"] = {width=440,height=50,x=0,y=-200,
                label="Enchant Chest - Minor Absorption",font="GameFontHighlight",textColor=art.colors.title},
            ["trainer.status"] = {width=246,height=24,x=-92,y=-369,
                label="Enchanting  |  41 / 75",font="GameFontHighlightSmall",textColor=art.colors.body},
            ["trainer.train"] = {width=104,height=30,x=165,y=-367,
                label="TRAIN",font="GameFontHighlight",textColor=art.colors.title},
        },
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
