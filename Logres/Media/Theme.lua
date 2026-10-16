local _, Logres = ...

local MEDIA_ROOT = "Interface\\AddOns\\Logres\\Media\\"

local theme = Logres.Theme or {}
theme.mediaRoot = MEDIA_ROOT

theme.action = {
    buttonSize = 42,
    buttonGap = 5,
    iconInset = 4,
    artOverscan = 2,

    hotkeyPlate = {
        minWidth = 16,
        height = 15,
        horizontalPadding = 4,
        rightInset = 1,
        topInset = 1,
        borderColor = { 0.56, 0.40, 0.21, 0.99 },
        fillColor = { 0.00, 0.00, 0.00, 0.98 },
        textColor = { 0.99, 0.95, 0.86, 1.00 },
    },

    assets = {
        frame = MEDIA_ROOT .. "Action\\action_frame.tga",
        hover = MEDIA_ROOT .. "Action\\action_hover.tga",
        pressed = MEDIA_ROOT .. "Action\\action_pressed.tga",
        checked = MEDIA_ROOT .. "Action\\action_checked.tga",
        flash = MEDIA_ROOT .. "Action\\action_flash.tga",
    },
}


-- H.3: same approved action geometry; stronger metadata separation.
theme.nativeHarmfulAuras = {
    iconSize = 25,
    gap = 3,
    maxIcons = 5,
    iconInset = 2,
    frameColor = { 0.96, 0.73, 0.59, 0.98 },
    assets = { frame = MEDIA_ROOT .. "Aura\\aura_frame_passive.tga" },
}

theme.hudTypography = {
    targetName = { 0.97, 0.91, 0.80, 1.00 },
    allyName = { 0.89, 0.84, 0.74, 1.00 },
    petName = { 0.98, 0.89, 0.69, 1.00 },
    targetAccent = { 0.70, 0.47, 0.22, 0.74 },
    allyAccent = { 0.46, 0.34, 0.20, 0.65 },
    petAccent = { 0.73, 0.51, 0.27, 0.82 },
}

theme.nativeAccessDock = {
    background = { 0.035, 0.030, 0.024, 0.76 },
    ruleColor = { 0.42, 0.31, 0.18, 0.82 },
    stockRule = { 0.70, 0.49, 0.22, 0.96 },
    label = { 0.78, 0.72, 0.62, 0.96 },
    stockLabel = { 0.96, 0.85, 0.63, 1.00 },
    hover = { 0.66, 0.47, 0.22, 0.18 },
    fallbackText = { 0.96, 0.86, 0.66, 1.00 },
    fallbackHover = { 0.68, 0.47, 0.20, 0.25 },
    assets = {
        tab = MEDIA_ROOT .. "Dock\\dock_tab.tga",
        fallback = MEDIA_ROOT .. "Dock\\dock_fallback.tga",
    },
}

theme.percentageBar = {
    -- Sheet 02: slightly longer player resource, without altering target/quest fit.
    resource = {
        trackWidth = 210,
        trackHeight = 12,
        frameHeight = 20,
        textWidth = 38,
        textGap = 8,
        diamondSize = 12,
        font = "GameFontNormal",
    },
    normal = {
        trackWidth = 142,
        trackHeight = 12,
        frameHeight = 18,
        textWidth = 34,
        textGap = 8,
        diamondSize = 10,
        font = "GameFontNormal",
    },
    compact = {
        trackWidth = 58,
        trackHeight = 8,
        frameHeight = 14,
        textWidth = 30,
        textGap = 4,
        diamondSize = 8,
        font = "GameFontNormalSmall",
    },

    trackColor = { 0.012, 0.010, 0.008, 0.94 },
    borderColor = { 0.56, 0.40, 0.20, 0.98 },
    textColor = { 0.99, 0.95, 0.85, 1.00 },

    colors = {
        mana = { 0.16, 0.42, 0.86, 1.00 },
        rage = { 0.72, 0.07, 0.05, 1.00 },
        energy = { 0.88, 0.70, 0.10, 1.00 },
        focus = { 0.88, 0.38, 0.07, 1.00 },
        runicPower = { 0.08, 0.58, 0.78, 1.00 },
        alternate = { 0.72, 0.49, 0.13, 1.00 },
        targetHealth = { 0.62, 0.11, 0.07, 1.00 },
        allyHealth = { 0.18, 0.55, 0.27, 1.00 },
    },

    assets = {
        fill = MEDIA_ROOT .. "Bar\\percentage_fill.tga",
        diamond = MEDIA_ROOT .. "Bar\\percentage_diamond.tga",
    },
}


theme.castCue = {
    size = 24,

    assets = {
        frame = MEDIA_ROOT .. "Cast\\cast_frame.tga",
        playerCast = MEDIA_ROOT .. "Cast\\player_cast.tga",
        playerChannel = MEDIA_ROOT .. "Cast\\player_channel.tga",
        targetCast = MEDIA_ROOT .. "Cast\\target_cast.tga",
        targetChannel = MEDIA_ROOT .. "Cast\\target_channel.tga",
        interrupted = MEDIA_ROOT .. "Cast\\interrupted.tga",
    },
}


theme.contextMessage = {
    variants = {
        xp = {
            width = 360,
            height = 38,
            textWidth = 330,
            lineWidth = 138,
            lineHeight = 8,
            lineOffset = 7,
            diamondSize = 10,
            glowSize = 34,
            font = "GameFontNormalLarge",
        },
        objective = {
            width = 520,
            height = 54,
            textWidth = 500,
            lineWidth = 205,
            lineHeight = 8,
            lineOffset = 7,
            diamondSize = 10,
            glowSize = 38,
            font = "GameFontHighlight",
        },
    },

    colors = {
        normal = {
            text = { 0.88, 0.78, 0.54, 0.96 },
            line = { 0.58, 0.42, 0.22, 0.78 },
            diamond = { 0.82, 0.58, 0.20, 0.96 },
            glow = { 0.84, 0.55, 0.14, 0.24 },
        },
        complete = {
            text = { 1.00, 0.86, 0.48, 1.00 },
            line = { 0.84, 0.58, 0.20, 0.94 },
            diamond = { 1.00, 0.70, 0.24, 1.00 },
            glow = { 1.00, 0.58, 0.12, 0.58 },
        },
    },

    assets = {
        line = MEDIA_ROOT .. "Context\\context_line.tga",
        diamond = MEDIA_ROOT .. "Context\\context_diamond.tga",
        glow = MEDIA_ROOT .. "Context\\context_glow.tga",
    },
}



theme.playerHelpfulAuras = {
    maxIcons = 4,
    iconSize = 36,
    iconInset = 4,
    frameOverscan = 2,
    gap = 7,
    x = 118,
    y = -118,
    countWidth = 24,
    countHeight = 16,
    countFont = "GameFontHighlightSmall",

    colors = {
        countText = { 0.96, 0.92, 0.82, 1.00 },
    },

    assets = {
        frame = MEDIA_ROOT .. "Aura\\aura_frame_passive.tga",
        countPlate = MEDIA_ROOT .. "Aura\\aura_count_plate.tga",
    },
}

theme.healthTunnel = {
    colors = {
        outer = { 0.040, 0.035, 0.045, 1.00 },
        injury = { 0.31, 0.035, 0.065, 1.00 },
        critical = { 0.17, 0.020, 0.040, 1.00 },
        nearDeath = { 0.055, 0.012, 0.025, 1.00 },
        death = { 0.008, 0.004, 0.008, 1.00 },
    },

    assets = {
        outer = MEDIA_ROOT .. "Health\\health_outer.tga",
        injury = MEDIA_ROOT .. "Health\\health_injury.tga",
        critical = MEDIA_ROOT .. "Health\\health_critical.tga",
        nearDeath = MEDIA_ROOT .. "Health\\health_near_death.tga",
        death = MEDIA_ROOT .. "Health\\health_death.tga",
    },
}


theme.questDialogue = {
    width = 640,
    height = 320,
    x = 0,
    y = -110,
    titleWidth = 560,
    bodyWidth = 548,
    bodyHeight = 134,
    objectiveWidth = 548,
    objectiveHeight = 50,
    titleFont = "GameFontHighlightLarge",
    bodyFont = "GameFontHighlight",
    objectiveHeaderFont = "GameFontNormalSmall",
    objectiveFont = "GameFontNormal",
    pageFont = "GameFontHighlightSmall",

    colors = {
        title = { 0.94, 0.83, 0.60, 1.00 },
        body = { 0.92, 0.89, 0.81, 0.97 },
        objectiveHeader = { 0.66, 0.50, 0.28, 0.95 },
        objective = { 0.84, 0.76, 0.60, 0.97 },
        page = { 0.64, 0.56, 0.43, 0.90 },
        pageActive = { 0.92, 0.78, 0.48, 1.00 },
        pageInactive = { 0.34, 0.30, 0.24, 0.55 },
    },

    assets = {
        panel = MEDIA_ROOT .. "Quest\\quest_narrative_panel.tga",
        divider = MEDIA_ROOT .. "Quest\\quest_narrative_divider.tga",
        pageChevron = MEDIA_ROOT .. "Quest\\quest_page_chevron.tga",
    },
}

theme.questOfferControls = {
    width = 410,
    height = 62,
    y = -4,
    buttonWidth = 150,
    buttonHeight = 38,
    buttonGap = 42,
    font = "GameFontHighlightLarge",
    feedbackFont = "GameFontHighlightSmall",

    colors = {
        decline = { 0.86, 0.82, 0.73, 0.96 },
        accept = { 0.96, 0.72, 0.24, 1.00 },
        hover = { 1.00, 0.86, 0.48, 1.00 },
        pressed = { 0.78, 0.55, 0.18, 1.00 },
        feedback = { 0.72, 0.64, 0.50, 0.92 },
    },

    assets = {
        rule = MEDIA_ROOT .. "Quest\\quest_offer_action_rule.tga",
    },
}

theme.activeQuest = {
    width = 320,
    minHeight = 136,
    headerHeight = 86,
    rowHeight = 42,
    rowGap = 6,
    bottomPadding = 14,
    x = -360,
    y = -150,
    titleWidth = 258,
    titleFont = "GameFontNormalLarge",
    ambientFont = "GameFontHighlightSmall",
    objectiveFont = "GameFontHighlightSmall",
    objectiveTextWidth = 250,

    colors = {
        title = { 0.94, 0.84, 0.62, 1.00 },
        ambient = { 0.70, 0.64, 0.51, 0.94 },
        objective = { 0.82, 0.76, 0.64, 0.96 },
        complete = { 1.00, 0.85, 0.40, 1.00 },
        completionDivider = { 1.00, 0.82, 0.38, 1.00 },
        completionSeal = { 1.00, 0.88, 0.51, 1.00 },
        progress = { 0.63, 0.45, 0.16, 1.00 },
        progressComplete = { 0.82, 0.64, 0.24, 1.00 },
        hover = { 0.86, 0.72, 0.44, 0.10 },
        unknown = { 0.44, 0.33, 0.18, 0.72 },
    },

    assets = {
        panel = MEDIA_ROOT .. "Quest\\active_quest_panel.tga",
        divider = MEDIA_ROOT .. "Quest\\active_quest_divider.tga",
        glyph = MEDIA_ROOT .. "Quest\\active_quest_glyph.tga",
    },
}

theme.compass = {
    width = 400,
    height = 54,
    tapeWidth = 360,
    tapeY = -4,
    visibleHalfAngle = 100,
    edgeFadeStart = 78,

    -- H.3: readable direction labels against bright sky; no geometry change.
    labelContrast = {
        cardinal = { 0.99, 0.95, 0.84, 1.00 },
        intercardinal = { 0.88, 0.83, 0.74, 0.96 },
        cardinalShadow = { 0.02, 0.02, 0.02, 0.95 },
        intercardinalShadow = { 0.02, 0.02, 0.02, 0.91 },
        shadowOffset = { 1, -1 },
    },

    baseline = {
        height = 8,
    },

    center = {
        width = 8,
        height = 24,
    },

    ticks = {
        cardinal = {
            width = 7,
            height = 16,
            labelGap = 3,
        },
        intercardinal = {
            width = 5,
            height = 11,
            labelGap = 3,
        },
    },

    manualWaypoint = {
        width = 12,
        height = 20,
        alpha = 0.95,
        focusAngle = 8,
        focusScale = 1.07,
        depthCloseRadiusFactor = 0.50,
        depthNearRadiusFactor = 1.00,
        depthMediumRadiusFactor = 4.00,
        depthFarRadiusFactor = 8.00,
        depthCloseScale = 1.20,
        depthNearScale = 1.05,
        depthMediumScale = 0.85,
        depthFarScale = 0.70,
        renderScaleMin = 0.70,
        renderScaleMax = 1.28,
    },

    labels = {
        cardinal = { 0.94, 0.84, 0.62, 0.96 },
        intercardinal = { 0.72, 0.68, 0.60, 0.82 },
    },

    assets = {
        baseline = MEDIA_ROOT .. "Compass\\compass_baseline.tga",
        center = MEDIA_ROOT .. "Compass\\compass_center.tga",
        cardinalTick = MEDIA_ROOT .. "Compass\\compass_tick_cardinal.tga",
        intercardinalTick = MEDIA_ROOT .. "Compass\\compass_tick_intercardinal.tga",
        manualWaypoint = MEDIA_ROOT .. "Compass\\compass_manual_waypoint.tga",
    },
}

Logres.Theme = theme
