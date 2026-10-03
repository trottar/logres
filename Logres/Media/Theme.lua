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

Logres.Theme = theme
