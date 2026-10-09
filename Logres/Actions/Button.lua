local _, Logres = ...

local ActionButton = {}
Logres.ActionButton = ActionButton

local actionStyle =
    Logres.Theme
    and Logres.Theme.action
    or {}
local actionAssets = actionStyle.assets or {}
local hotkeyStyle = actionStyle.hotkeyPlate or {}

local DEFAULT_BUTTON_SIZE = actionStyle.buttonSize or 42
local DEFAULT_BUTTON_GAP = actionStyle.buttonGap or 5
local DEFAULT_ICON_INSET = actionStyle.iconInset or 4
local DEFAULT_ART_OVERSCAN = actionStyle.artOverscan or 2
local HOTKEY_MIN_WIDTH = hotkeyStyle.minWidth or 16
local HOTKEY_HEIGHT = hotkeyStyle.height or 15
local HOTKEY_PADDING = hotkeyStyle.horizontalPadding or 4
local HOTKEY_RIGHT_INSET = hotkeyStyle.rightInset or 1
local HOTKEY_TOP_INSET = hotkeyStyle.topInset or 1
local HOTKEY_BORDER = hotkeyStyle.borderColor or { 0.46, 0.34, 0.18, 0.98 }
local HOTKEY_FILL = hotkeyStyle.fillColor or { 0.00, 0.00, 0.00, 0.98 }
local HOTKEY_TEXT = hotkeyStyle.textColor or { 0.96, 0.92, 0.82, 1.00 }

local function setActionArtBounds(texture, button)
    texture:SetPoint(
        "TOPLEFT",
        button,
        "TOPLEFT",
        -DEFAULT_ART_OVERSCAN,
        DEFAULT_ART_OVERSCAN
    )
    texture:SetPoint(
        "BOTTOMRIGHT",
        button,
        "BOTTOMRIGHT",
        DEFAULT_ART_OVERSCAN,
        -DEFAULT_ART_OVERSCAN
    )
end

-- P0174: preserve Blizzard action-slot rearrangement and hover details.
-- Never edit pet slots, inspect a cursor payload, or mutate action slots in combat.
local function ordinaryActionSlot(button)
    local slot = button.actionSlot
    if issecretvalue and issecretvalue(slot) then
        return nil
    end
    if type(slot) == "number" and slot >= 1 and slot <= 180
        and button.petActionSlot == nil
    then
        return slot
    end
    return nil
end

local function actionBarsUnlocked()
    if not Settings or type(Settings.GetValue) ~= "function" then
        return false
    end
    local ok, locked = pcall(Settings.GetValue, "lockActionBars")
    if not ok or (issecretvalue and issecretvalue(locked)) then
        return false
    end
    if type(locked) ~= "boolean" then
        return false
    end
    return not locked or (type(IsModifiedClick) == "function"
        and IsModifiedClick("PICKUPACTION"))
end

local function onActionDragStart(button)
    local slot = ordinaryActionSlot(button)
    if not slot or InCombatLockdown() or not actionBarsUnlocked() then
        return
    end
    PickupAction(slot)
end

local function onActionReceiveDrag(button)
    local slot = ordinaryActionSlot(button)
    if not slot or InCombatLockdown() then
        return
    end
    PlaceAction(slot)
    -- ACTIONBAR_SLOT_CHANGED owns the subsequent visual refresh.
end

local function onActionEnter(button)
    local slot = ordinaryActionSlot(button)
    local petSlot = button.petActionSlot
    if issecretvalue and issecretvalue(petSlot) then
        return
    end
    if slot and GameTooltip and type(GameTooltip.SetAction) == "function" then
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
        GameTooltip:SetAction(slot)
        GameTooltip:Show()
    elseif type(petSlot) == "number" and GameTooltip
        and type(GameTooltip.SetPetAction) == "function"
    then
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
        GameTooltip:SetPetAction(petSlot)
        GameTooltip:Show()
    end
end

local function onActionLeave()
    if GameTooltip then
        GameTooltip:Hide()
    end
end

function ActionButton.CreateCluster(
    name,
    columns,
    rows,
    x,
    y,
    alpha
)
    local width =
        (columns * DEFAULT_BUTTON_SIZE)
        + ((columns - 1) * DEFAULT_BUTTON_GAP)
    local height =
        (rows * DEFAULT_BUTTON_SIZE)
        + ((rows - 1) * DEFAULT_BUTTON_GAP)

    local cluster = CreateFrame("Frame", name, UIParent)
    cluster:SetSize(width, height)
    cluster:SetPoint("CENTER", UIParent, "CENTER", x, y)
    cluster:SetFrameStrata("MEDIUM")
    cluster:SetAlpha(alpha or 1)

    local backdrop = cluster:CreateTexture(nil, "BACKGROUND")
    backdrop:SetPoint("TOPLEFT", cluster, "TOPLEFT", -7, 7)
    backdrop:SetPoint("BOTTOMRIGHT", cluster, "BOTTOMRIGHT", 7, -7)
    backdrop:SetColorTexture(0.025, 0.022, 0.018, 0.78)

    return cluster
end

function ActionButton.Create(
    name,
    parent,
    index,
    columns
)
    local button = CreateFrame(
        "CheckButton",
        name,
        parent,
        "SecureActionButtonTemplate"
    )

    button:SetSize(DEFAULT_BUTTON_SIZE, DEFAULT_BUTTON_SIZE)
    button:RegisterForClicks(
        "AnyUp",
        "LeftButtonDown",
        "RightButtonDown"
    )
    button:SetAttribute("type", "action")
    button:SetAttribute("typerelease", "actionrelease")
    button:SetAttribute("checkselfcast", true)
    button:SetAttribute("checkfocuscast", true)
    button:SetAttribute("checkmouseovercast", true)

    local zeroIndex = index - 1
    local column = zeroIndex % columns
    local row = math.floor(zeroIndex / columns)

    button:SetPoint(
        "TOPLEFT",
        parent,
        "TOPLEFT",
        column * (DEFAULT_BUTTON_SIZE + DEFAULT_BUTTON_GAP),
        -(row * (DEFAULT_BUTTON_SIZE + DEFAULT_BUTTON_GAP))
    )

    local border = button:CreateTexture(nil, "BACKGROUND")
    border:SetAllPoints(button)
    border:SetColorTexture(0.13, 0.11, 0.085, 0.98)

    local inner = button:CreateTexture(nil, "BORDER")
    inner:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    inner:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    inner:SetColorTexture(0.025, 0.022, 0.018, 0.98)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetPoint(
        "TOPLEFT",
        button,
        "TOPLEFT",
        DEFAULT_ICON_INSET,
        -DEFAULT_ICON_INSET
    )
    icon:SetPoint(
        "BOTTOMRIGHT",
        button,
        "BOTTOMRIGHT",
        -DEFAULT_ICON_INSET,
        DEFAULT_ICON_INSET
    )
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local cooldown = CreateFrame(
        "Cooldown",
        nil,
        button,
        "CooldownFrameTemplate"
    )
    cooldown:SetAllPoints(icon)
    cooldown:SetDrawBling(false)
    cooldown:SetDrawEdge(false)

    local frameArt = button:CreateTexture(nil, "OVERLAY")
    setActionArtBounds(frameArt, button)
    frameArt:SetTexture(actionAssets.frame)

    local hoverTexture = button:CreateTexture(nil, "HIGHLIGHT")
    setActionArtBounds(hoverTexture, button)
    hoverTexture:SetTexture(actionAssets.hover)
    hoverTexture:SetBlendMode("ADD")
    button:SetHighlightTexture(hoverTexture)

    local pushedTexture = button:CreateTexture(nil, "OVERLAY")
    setActionArtBounds(pushedTexture, button)
    pushedTexture:SetTexture(actionAssets.pressed)
    button:SetPushedTexture(pushedTexture)

    local checked = button:CreateTexture(nil, "OVERLAY")
    setActionArtBounds(checked, button)
    checked:SetTexture(actionAssets.checked)
    button:SetCheckedTexture(checked)

-- Activation feedback is outside the faded action-cluster hierarchy.
-- It stays visually strong even when Secondary/Utility are subdued.
local feedbackFrame = CreateFrame("Frame", nil, UIParent)
feedbackFrame:SetAllPoints(button)
feedbackFrame:SetFrameStrata("HIGH")
feedbackFrame:EnableMouse(false)

local pressedOverlay = feedbackFrame:CreateTexture(nil, "OVERLAY")
pressedOverlay:SetAllPoints(feedbackFrame)
pressedOverlay:SetTexture(actionAssets.pressed)
pressedOverlay:Hide()

local activationFlash = feedbackFrame:CreateTexture(nil, "OVERLAY")
activationFlash:SetPoint("TOPLEFT", feedbackFrame, "TOPLEFT", -2, 2)
activationFlash:SetPoint("BOTTOMRIGHT", feedbackFrame, "BOTTOMRIGHT", 2, -2)
activationFlash:SetTexture(actionAssets.flash)
activationFlash:SetBlendMode("ADD")
activationFlash:SetAlpha(1)
activationFlash:Hide()

local activationAnimation = activationFlash:CreateAnimationGroup()
local activationFade = activationAnimation:CreateAnimation("Alpha")
activationFade:SetFromAlpha(1)
activationFade:SetToAlpha(0)
activationFade:SetDuration(0.24)
activationFade:SetSmoothing("OUT")

activationAnimation:SetScript("OnFinished", function()
    activationFlash:Hide()
    activationFlash:SetAlpha(1)
end)

activationAnimation:SetScript("OnStop", function()
    activationFlash:Hide()
    activationFlash:SetAlpha(1)
end)

button:HookScript("OnMouseDown", function(current)
    current.activationPressedOverlay:Show()
end)

button:HookScript("OnMouseUp", function(current)
    current.activationPressedOverlay:Hide()
end)

button:HookScript("OnLeave", function(current)
    current.activationPressedOverlay:Hide()
end)

button:HookScript("PostClick", function(current)
    ActionButton.Pulse(current)
end)

    local hotkeyPlateBorder = feedbackFrame:CreateTexture(nil, "OVERLAY")
    hotkeyPlateBorder:SetPoint(
        "TOPRIGHT",
        button,
        "TOPRIGHT",
        -HOTKEY_RIGHT_INSET,
        -HOTKEY_TOP_INSET
    )
    hotkeyPlateBorder:SetSize(HOTKEY_MIN_WIDTH, HOTKEY_HEIGHT)
    hotkeyPlateBorder:SetColorTexture(
        HOTKEY_BORDER[1],
        HOTKEY_BORDER[2],
        HOTKEY_BORDER[3],
        HOTKEY_BORDER[4]
    )
    hotkeyPlateBorder:SetDrawLayer("OVERLAY", 0)
    hotkeyPlateBorder:Hide()

    local hotkeyPlateFill = feedbackFrame:CreateTexture(nil, "OVERLAY")
    hotkeyPlateFill:SetPoint(
        "TOPLEFT",
        hotkeyPlateBorder,
        "TOPLEFT",
        1,
        -1
    )
    hotkeyPlateFill:SetPoint(
        "BOTTOMRIGHT",
        hotkeyPlateBorder,
        "BOTTOMRIGHT",
        -1,
        1
    )
    hotkeyPlateFill:SetColorTexture(
        HOTKEY_FILL[1],
        HOTKEY_FILL[2],
        HOTKEY_FILL[3],
        HOTKEY_FILL[4]
    )
    hotkeyPlateFill:SetDrawLayer("OVERLAY", 1)
    hotkeyPlateFill:Hide()

    local hotkeyText = feedbackFrame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlightSmall"
    )
    hotkeyText:SetPoint("CENTER", hotkeyPlateBorder, "CENTER", 0, 0)
    hotkeyText:SetJustifyH("CENTER")
    hotkeyText:SetTextColor(
        HOTKEY_TEXT[1],
        HOTKEY_TEXT[2],
        HOTKEY_TEXT[3],
        HOTKEY_TEXT[4]
    )
    hotkeyText:SetDrawLayer("OVERLAY", 2)
    hotkeyText:Hide()

    local countText = button:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlightSmall"
    )
    countText:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 3)
    countText:SetJustifyH("RIGHT")
    countText:SetTextColor(0.96, 0.92, 0.82, 1.00)

    button.logresIndex = index
    button.actionSlot = nil
    button.registeredActionSlot = nil
    button.icon = icon
    button.cooldown = cooldown
    button.hotkeyText = hotkeyText
    button.hotkeyPlateBorder = hotkeyPlateBorder
    button.hotkeyPlateFill = hotkeyPlateFill
    button.hotkeyPlateReady = true
    button.countText = countText
    button.actionFrameArt = frameArt
    button.actionHoverTexture = hoverTexture
    button.actionPushedTexture = pushedTexture
    button.actionCheckedTexture = checked
    button.actionVisualReady = true
    button.activationFeedbackFrame = feedbackFrame
    button.activationPressedOverlay = pressedOverlay
    button.activationFlash = activationFlash
    button.activationAnimation = activationAnimation
    button.activationFeedbackReady = true

    -- Normal action slots: Blizzard-compatible pickup/swap; pet slots
    -- remain intentionally stock-owned for editing.
    button:RegisterForDrag("LeftButton", "RightButton")
    button:SetScript("OnDragStart", onActionDragStart)
    button:SetScript("OnReceiveDrag", onActionReceiveDrag)
    button:SetScript("OnEnter", onActionEnter)
    button:SetScript("OnLeave", onActionLeave)

    return button
end

local function petValueIsSecret(value)
    if type(issecretvalue) ~= "function" then
        return true
    end

    local ok, secret = pcall(issecretvalue, value)
    return not ok or secret == true
end

local function resolvePetActionName(rawName)
    if petValueIsSecret(rawName) or type(rawName) ~= "string" or rawName == "" then
        return nil
    end

    local tokenValue = _G[rawName]
    if type(tokenValue) == "string" and tokenValue ~= "" then
        return tokenValue
    end

    return rawName
end

function ActionButton.RegisterPet(button, petSlot)
    if InCombatLockdown() then
        return false
    end

    ActionButton.Unregister(button)

    -- Keep the proven shared secure-button object, but do not run addon code
    -- before protected pet execution. Baseline state is captured by ARM.
    button:RegisterForClicks("AnyUp")
    button:SetAttribute("useOnKeyDown", false)
    button:SetAttribute("type", nil)
    button:SetAttribute("typerelease", nil)
    button:SetAttribute("action", nil)
    button:SetAttribute("clickbutton", nil)
    button:SetAttribute("clickbutton1", nil)
    button:SetAttribute("clickbutton2", nil)
    button:SetAttribute("type1", "pet")
    button:SetAttribute("action1", petSlot)

    local macrotext
    if type(GetPetActionInfo) == "function" then
        local ok, rawName, _texture, _isToken, _isActive,
            rawAutoCastAllowed = pcall(GetPetActionInfo, petSlot)
        if ok
            and not petValueIsSecret(rawAutoCastAllowed)
            and rawAutoCastAllowed == true
        then
            local petName = resolvePetActionName(rawName)
            if petName then
                macrotext = "/petautocasttoggle " .. petName
            end
        end
    end

    if macrotext then
        button:SetAttribute("type2", "macro")
        button:SetAttribute("macrotext2", macrotext)
    else
        button:SetAttribute("type2", nil)
        button:SetAttribute("macrotext2", nil)
    end
    button:SetAttribute("action2", nil)

    button.petActionSlot = petSlot
    button.petActionDelegate = nil
    button.petAutocastMacroReady = macrotext ~= nil
    button.actionSlot = nil
    ActionButton.SetHotkeyLabel(button, "")

    return true
end

local function resolvePetTexture(rawTexture)
    if petValueIsSecret(rawTexture) or rawTexture == nil then
        return nil
    end

    local valueType = type(rawTexture)
    if valueType == "number" then
        return rawTexture
    end
    if valueType ~= "string" then
        return nil
    end

    local tokenValue = _G[rawTexture]
    if type(tokenValue) == "string" or type(tokenValue) == "number" then
        return tokenValue
    end

    return rawTexture
end

function ActionButton.UpdatePet(button, petSlot)
    local state = {
        occupied = false,
        active = nil,
        autoCastAllowed = nil,
        autoCastEnabled = nil,
    }

    if type(GetPetActionInfo) ~= "function" then
        button.icon:Hide()
        button:SetChecked(false)
        return state
    end

    local ok, rawName, rawTexture, _rawIsToken, rawIsActive,
        rawAutoCastAllowed, rawAutoCastEnabled, rawSpellID,
        rawChecksRange, rawInRange = pcall(GetPetActionInfo, petSlot)

    if not ok then
        button.icon:Hide()
        button:SetChecked(false)
        return state
    end

    local texture = resolvePetTexture(rawTexture)
    if texture ~= nil then
        button.icon:SetTexture(texture)
        button.icon:Show()
        state.occupied = true
    else
        button.icon:Hide()
    end

    if not petValueIsSecret(rawName) and rawName ~= nil then
        state.occupied = true
    end
    if not petValueIsSecret(rawSpellID) and rawSpellID ~= nil then
        state.occupied = true
    end

    local active
    if not petValueIsSecret(rawIsActive) and type(rawIsActive) == "boolean" then
        active = rawIsActive
    end
    state.active = active
    button:SetChecked(active == true)

    local autoCastAllowed
    local autoCastEnabled
    if not petValueIsSecret(rawAutoCastAllowed) and type(rawAutoCastAllowed) == "boolean" then
        autoCastAllowed = rawAutoCastAllowed
    end
    if not petValueIsSecret(rawAutoCastEnabled) and type(rawAutoCastEnabled) == "boolean" then
        autoCastEnabled = rawAutoCastEnabled
    end
    state.autoCastAllowed = autoCastAllowed
    state.autoCastEnabled = autoCastEnabled
    button.petAutoCastAllowed = autoCastAllowed == true
    button.petAutoCastEnabled = autoCastEnabled == true

    if button.actionFrameArt then
        if autoCastAllowed == true and autoCastEnabled == true then
            button.actionFrameArt:SetVertexColor(1.00, 0.72, 0.24, 1.00)
        elseif autoCastAllowed == true then
            button.actionFrameArt:SetVertexColor(0.72, 0.58, 0.34, 1.00)
        else
            button.actionFrameArt:SetVertexColor(1.00, 1.00, 1.00, 1.00)
        end
    end

    if type(GetPetActionCooldown) == "function" then
        local cooldownOK, start, duration = pcall(GetPetActionCooldown, petSlot)
        if cooldownOK
            and not petValueIsSecret(start)
            and not petValueIsSecret(duration)
            and type(start) == "number"
            and type(duration) == "number"
        then
            button.cooldown:SetCooldown(start, duration)
        end
    end

    local checksRange
    local inRange
    if not petValueIsSecret(rawChecksRange) and type(rawChecksRange) == "boolean" then
        checksRange = rawChecksRange
    end
    if not petValueIsSecret(rawInRange) and type(rawInRange) == "boolean" then
        inRange = rawInRange
    end

    local usable
    if type(GetPetActionSlotUsable) == "function" then
        local usableOK, rawUsable = pcall(GetPetActionSlotUsable, petSlot)
        if usableOK
            and not petValueIsSecret(rawUsable)
            and type(rawUsable) == "boolean"
        then
            usable = rawUsable
        end
    end

    if checksRange == true and inRange == false then
        button.icon:SetVertexColor(0.95, 0.28, 0.24, 1.00)
    elseif usable == false then
        button.icon:SetVertexColor(0.48, 0.46, 0.43, 0.88)
    else
        button.icon:SetVertexColor(1.00, 1.00, 1.00, 1.00)
    end

    button.countText:SetText("")
    return state
end

function ActionButton.UpdatePetAll(buttons)
    for index = 1, #buttons do
        ActionButton.UpdatePet(buttons[index], index)
    end
end

function ActionButton.Pulse(button)
    local animation = button.activationAnimation
    local flash = button.activationFlash

    animation:Stop()
    flash:SetAlpha(1)
    flash:Show()
    animation:Play()
end

function ActionButton.CountFeedbackReady(buttons)
    local count = 0

    for index = 1, #buttons do
        local button = buttons[index]

        if (
            button.activationFeedbackReady == true
            and button.activationFeedbackFrame ~= nil
            and button.activationPressedOverlay ~= nil
            and button.activationFlash ~= nil
            and button.activationAnimation ~= nil
        ) then
            count = count + 1
        end
    end

    return count
end

local function normalizeHotkeyLabel(label)
    local text = tostring(label or "")
    if text == "" then
        return ""
    end

    text = text:upper()
    text = text:gsub("SHIFT%-", "s-")
    text = text:gsub("CTRL%-", "c-")
    text = text:gsub("ALT%-", "a-")
    return text
end

function ActionButton.SetHotkeyLabel(button, label)
    local text = normalizeHotkeyLabel(label)

    if text == "" then
        button.hotkeyText:SetText("")
        button.hotkeyText:Hide()
        button.hotkeyPlateFill:Hide()
        button.hotkeyPlateBorder:Hide()
        return
    end

    button.hotkeyText:SetText(text)
    local textWidth = math.ceil(button.hotkeyText:GetStringWidth())
    local plateWidth = math.max(
        HOTKEY_MIN_WIDTH,
        textWidth + (HOTKEY_PADDING * 2)
    )

    button.hotkeyPlateBorder:SetWidth(plateWidth)
    button.hotkeyPlateBorder:Show()
    button.hotkeyPlateFill:Show()
    button.hotkeyText:Show()
end

function ActionButton.RegisterPresentation(button, actionSlot)
    if (
        button.registeredActionSlot
        and button.registeredActionSlot ~= actionSlot
    ) then
        C_ActionBar.EnableActionRangeCheck(
            button.registeredActionSlot,
            false
        )
        C_ActionBar.UnregisterActionUIButton(button)
    end

    button.actionSlot = actionSlot

    C_ActionBar.RegisterActionUIButton(
        button,
        actionSlot,
        button.cooldown
    )
    C_ActionBar.EnableActionRangeCheck(actionSlot, true)

    button.registeredActionSlot = actionSlot
end

function ActionButton.Register(button, actionSlot)
    button:SetAttribute("action", actionSlot)
    ActionButton.RegisterPresentation(button, actionSlot)
end

function ActionButton.Unregister(button)
    if not button.registeredActionSlot then
        return
    end

    C_ActionBar.EnableActionRangeCheck(
        button.registeredActionSlot,
        false
    )
    C_ActionBar.UnregisterActionUIButton(button)
    button.registeredActionSlot = nil
end

function ActionButton.UpdateIcon(button)
    local actionSlot = button.actionSlot
    if not actionSlot then
        return
    end

    if C_ActionBar.HasAction(actionSlot) then
        local texture = C_ActionBar.GetActionTexture(actionSlot)

        if texture then
            button.icon:SetTexture(texture)
            button.icon:Show()
        else
            button.icon:Hide()
        end
    else
        button.icon:Hide()
    end
end

function ActionButton.UpdateCooldown(button)
    local actionSlot = button.actionSlot
    if not actionSlot then
        return
    end

    local duration = C_ActionBar.GetActionCooldownDuration(actionSlot)
    button.cooldown:SetCooldownFromDurationObject(duration, true)
end

function ActionButton.UpdateCount(button)
    local actionSlot = button.actionSlot
    if not actionSlot then
        return
    end

    -- The display count can be secret on Forever. Do not inspect it.
    button.countText:SetText(
        C_ActionBar.GetActionDisplayCount(actionSlot)
    )
end

function ActionButton.UpdateUsabilityAndRange(button)
    local actionSlot = button.actionSlot
    if not actionSlot then
        return
    end

    local usable, lackingResources =
        C_ActionBar.IsUsableAction(actionSlot)
    local inRange = C_ActionBar.IsActionInRange(actionSlot)

    if inRange == false then
        button.icon:SetVertexColor(0.95, 0.28, 0.24, 1.00)
    elseif usable then
        button.icon:SetVertexColor(1.00, 1.00, 1.00, 1.00)
    elseif lackingResources then
        button.icon:SetVertexColor(0.38, 0.54, 0.90, 0.92)
    else
        button.icon:SetVertexColor(0.48, 0.46, 0.43, 0.88)
    end
end

function ActionButton.Update(button)
    ActionButton.UpdateIcon(button)
    ActionButton.UpdateCooldown(button)
    ActionButton.UpdateCount(button)
    ActionButton.UpdateUsabilityAndRange(button)
end

function ActionButton.UpdateAll(buttons)
    for index = 1, #buttons do
        ActionButton.Update(buttons[index])
    end
end

function ActionButton.UpdateSlot(buttons, actionSlot)
    for index = 1, #buttons do
        local button = buttons[index]

        if button.actionSlot == actionSlot then
            ActionButton.Update(button)
            return true
        end
    end

    return false
end
