-- P0277: trainer inputs vary independently; visual vocabulary is shared.
-- These are addon-owned preview/art values, NOT Blizzard native control geometry.
local _, Logres = ...
local art = Logres.Theme.panelSurface
Logres.PanelConfigs = Logres.PanelConfigs or {}

local trainer = {
    preview = {
        width = 820, height = 660,
        point = "TOP", relativePoint = "TOP", x = 0, y = -86,
        strata = "DIALOG", mouse = false,
        title = "TRAINER / PANEL ART",
        note = "Visual fixture only — native trainer controls remain Blizzard-owned",
        titleFont = "GameFontHighlightLarge",
        noteFont = "GameFontHighlight",
        titleX = 0, titleY = -20, noteX = 0, noteY = -59,
        titleColor = art.colors.title, noteColor = art.colors.body,
    },
    -- P0425: both services use content-fit geometry within the same painter.
    -- Merchant preserves native actions; trainer retains seven owned lesson rows
    -- and its native training handoff while occupying a compact viewport.
    merchant = {
        width = 800, height = 625,
        point = "TOP", relativePoint = "TOP", x = 0, y = -86,
        strata = "DIALOG", mouse = false,
        sidebar = {x=32, y=102, w=222, h=352},
        list = {x=268, y=102, w=500, h=352},
        topRuleY = 85, footerRuleY = 468,
        footerTitleY = 484, footerNoteY = 514,
        pagerY = 42, -- pixels above bottom edge
        tabY = 128, -- relative top offset shared by both native tabs
        buybackItemX = 592, buybackItemY = 405, -- stock buyback item above lower divider
        previewRowWidth = 192, previewNameWidth = 142,
        previewPriceWidth = 135,
    },
    -- P0425: compact trainer landscape retains seven complete rows and controls.
    -- Earlier P0281 geometry is recorded in historical evidence, not active.
    -- Approved landscape screenshot: ONE complete UI, not isolated sample paint.
    -- Only addon-owned preview geometry; live Blizzard child positions NEVER change.
    landscape = {
        width = 820, height = 660, maxRows = 7,
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
            hover = {0.84, 0.61, 0.29, 0.18},
            iconBorder = {0.63, 0.45, 0.23, 0.90},
            -- Dark, opaque live-only backing prevents a flat gold face when
            -- a native spell texture is translucent or not yet available.
            liveIconBacking = {0.06, 0.04, 0.025, 0.96},
            coinSilver = {0.78, 0.78, 0.73, 0.98},
            coinCopper = {0.75, 0.50, 0.30, 0.98},
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
            -- Preview-only: no native train-all control is mapped/claimed.
            ["trainer.trainAll"] = {fill={0.31,0.24,0.17,0.35},
                rule={0.73,0.56,0.35,0.64}, inset=1,
                fillSublevel=-2,ruleSublevel=-5,ruleHeight=1,ruleY=0},
        },
        geometry = {
            left = {x=32, y=102, w=222, h=352},
            search = {x=38, y=115, w=210, h=29},
            filters = {x=166, y=117, w=78, h=24},
            filterMode = {x=40, y=148},
            categories = {x=38, y=166, w=210, height=31, pitch=35},
            status = {x=40, y=422, w=205, h=19},
            list = {x=268, y=102, w=520, h=352, top=6, pitch=46, rowHeight=46},
            detail = {x=33, y=483, w=480, h=137},
            reagents = {x=532, y=483, w=252},
            funds = {x=533, y=569},
            trainAll = {x=532, y=593, w=140, h=31},
            train = {x=680, y=593, w=110, h=31},
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
        -- Preview-only category states. Ordinary skills inherit parchment;
        -- gold illumination belongs only to an explicitly selected row.
        previewStates = {
            normal = {wash={0.18,0.14,0.09,0.07}, rule={0.46,0.36,0.24,0.19}},
            selected = {wash={0.42,0.27,0.11,0.42}, rule={0.91,0.69,0.30,0.86}},
            disabled = {wash={0.16,0.13,0.11,0.10}, rule={0.36,0.31,0.25,0.15}},
        },
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
