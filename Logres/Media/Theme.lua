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
        borderColor = { 0.46, 0.34, 0.18, 0.98 },
        fillColor = { 0.00, 0.00, 0.00, 0.98 },
        textColor = { 0.96, 0.92, 0.82, 1.00 },
    },

    assets = {
        frame = MEDIA_ROOT .. "Action\\action_frame.tga",
        hover = MEDIA_ROOT .. "Action\\action_hover.tga",
        pressed = MEDIA_ROOT .. "Action\\action_pressed.tga",
        checked = MEDIA_ROOT .. "Action\\action_checked.tga",
        flash = MEDIA_ROOT .. "Action\\action_flash.tga",
    },
}


theme.percentageBar = {
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
    borderColor = { 0.45, 0.32, 0.15, 0.96 },
    textColor = { 0.94, 0.90, 0.80, 1.00 },

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


theme.compass = {
    width = 400,
    height = 54,
    tapeWidth = 360,
    tapeY = -4,
    visibleHalfAngle = 100,
    edgeFadeStart = 78,

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
