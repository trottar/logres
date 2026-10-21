-- P0277: trainer inputs vary independently; visual vocabulary is shared.
-- These are addon-owned preview/art values, NOT Blizzard native control geometry.
local _, Logres = ...
local art = Logres.Theme.panelSurface
Logres.PanelConfigs = Logres.PanelConfigs or {}

local trainer = {
    preview = {
        width = 896, height = 712,
        point = "TOP", relativePoint = "TOP", x = 0, y = -86,
        strata = "DIALOG", mouse = false,
        title = "TRAINER / PANEL ART",
        note = "Visual fixture only — native trainer controls remain Blizzard-owned",
        titleFont = "GameFontHighlightLarge",
        noteFont = "GameFontHighlight",
        titleX = 0, titleY = -20, noteX = 0, noteY = -59,
        titleColor = art.colors.title, noteColor = art.colors.body,
    },
    -- Approved landscape screenshot: ONE complete UI, not isolated sample paint.
    -- Only addon-owned preview geometry; live Blizzard child positions NEVER change.
    landscape = {
        width = 896, height = 712, maxRows = 7,
        palette = {
            -- Preserve the existing textured PanelSurface underneath.
            -- Translucent *warm* tonal washes; no opaque black subpanels.
            sidebarWash = {0.36, 0.25, 0.13, 0.12},
            catalogueWash = {0.36, 0.25, 0.13, 0.09},
            detailWash = {0.34, 0.23, 0.12, 0.07},
            sidebarRule = {0.73, 0.51, 0.26, 0.44},
            rail = {0.35, 0.24, 0.12, 0.40},
            gold = art.motifs.goldLine,
            goldText = art.colors.title,
            body = art.colors.body,
            muted = {0.76, 0.69, 0.57, 0.96},
            active = {0.37, 0.26, 0.14, 0.49},
            selected = {0.41, 0.29, 0.16, 0.15},
            iconBorder = {0.63, 0.45, 0.23, 0.90},
        },
        -- Only the synthetic P composition opts into these lighter recipes.
        -- The shared Components.Render implementation is unchanged for native H.
        previewComponents = {
            ["trainer.filter"] = {fill={0.39,0.27,0.14,0.23},
                rule={0.65,0.45,0.23,0.56}, inset=1,
                fillSublevel=-2,ruleSublevel=-5,ruleHeight=1,ruleY=0},
            ["trainer.selection"] = {fill={0.36,0.24,0.12,0.065},
                rule={0.72,0.52,0.29,0.30}, inset=1,
                fillSublevel=-2,ruleSublevel=-5,ruleHeight=1,ruleY=0},
            ["trainer.status"] = {fill={0.31,0.23,0.13,0.18},
                rule={0.62,0.46,0.23,0.48}, inset=1,
                fillSublevel=-2,ruleSublevel=-5,ruleHeight=1,ruleY=0},
            ["trainer.train"] = {fill={0.31,0.24,0.17,0.35},
                rule={0.73,0.56,0.35,0.64}, inset=1,
                fillSublevel=-2,ruleSublevel=-5,ruleHeight=1,ruleY=0},
        },
        geometry = {
            left = {x=32, y=102, w=222, h=392},
            search = {x=38, y=115, w=210, h=29},
            categories = {x=38, y=166, w=210, height=31, pitch=35},
            status = {x=40, y=463, w=205, h=19},
            list = {x=273, y=102, w=591, h=392, top=6, pitch=52, rowHeight=52},
            detail = {x=33, y=529, w=531, h=140},
            reagents = {x=574, y=529, w=253},
            train = {x=732, y=642, w=120, h=31},
        },
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
