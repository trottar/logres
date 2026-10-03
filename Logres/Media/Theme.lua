local _, Logres = ...

local MEDIA_ROOT = "Interface\\AddOns\\Logres\\Media\\"

local theme = Logres.Theme or {}
theme.mediaRoot = MEDIA_ROOT

theme.action = {
    buttonSize = 38,
    buttonGap = 5,
    iconInset = 4,
    artOverscan = 2,

    assets = {
        frame = MEDIA_ROOT .. "Action\\action_frame.tga",
        hover = MEDIA_ROOT .. "Action\\action_hover.tga",
        pressed = MEDIA_ROOT .. "Action\\action_pressed.tga",
        checked = MEDIA_ROOT .. "Action\\action_checked.tga",
        flash = MEDIA_ROOT .. "Action\\action_flash.tga",
    },
}

Logres.Theme = theme
