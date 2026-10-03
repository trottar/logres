local _, Logres = ...

local ActionButton = {}
Logres.ActionButton = ActionButton

local actionStyle =
    Logres.Theme
    and Logres.Theme.action
    or {}
local actionAssets = actionStyle.assets or {}

local DEFAULT_BUTTON_SIZE = actionStyle.buttonSize or 38
local DEFAULT_BUTTON_GAP = actionStyle.buttonGap or 5
local DEFAULT_ICON_INSET = actionStyle.iconInset or 4
local DEFAULT_ART_OVERSCAN = actionStyle.artOverscan or 2

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

    local hotkeyText = button:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlightSmall"
    )
    hotkeyText:SetPoint("TOPRIGHT", button, "TOPRIGHT", -3, -3)
    hotkeyText:SetJustifyH("RIGHT")
    hotkeyText:SetTextColor(0.84, 0.78, 0.66, 0.90)

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

    return button
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
