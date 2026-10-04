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

Logres.Theme = theme
