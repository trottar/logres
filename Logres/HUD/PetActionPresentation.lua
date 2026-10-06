local _, Logres = ...

local ActionButton = Logres.ActionButton

if not ActionButton or type(ActionButton.Create) ~= "function" then
    error("Logres PetActionPresentation requires Logres.ActionButton.Create")
end

local ACTIVE_COLOR = { 1.00, 0.78, 0.30, 1.00 }
local AUTOCAST_COLOR = { 0.98, 0.42, 0.08, 1.00 }
local DARK_COLOR = { 0.03, 0.025, 0.018, 1.00 }
local ACTIVE_BORDER_SIZE = 3
local AUTOCAST_BORDER_SIZE = 2
local ACTIVE_PIP_SIZE = 7
local AUTOCAST_PIP_SIZE = 9

local trackedButtons = {}
local originalCreate = ActionButton.Create

local Presentation = Logres:RegisterModule("PetActionPresentation", {
    autoEnable = true,
})

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return true
    end

    local ok, secret = pcall(issecretvalue, value)
    if not ok then
        return true
    end

    return secret == true
end

local function ordinaryBoolean(value)
    if isSecret(value) then
        return nil
    end

    if type(value) ~= "boolean" then
        return nil
    end

    return value
end

local function ordinaryAttribute(value, expectedType)
    if isSecret(value) then
        return nil
    end

    if type(value) ~= expectedType then
        return nil
    end

    return value
end

local function createBorder(parent, inset, thickness, color)
    local border = {}

    local top = parent:CreateTexture(nil, "OVERLAY")
    top:SetPoint("TOPLEFT", parent, "TOPLEFT", inset, -inset)
    top:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -inset, -inset)
    top:SetHeight(thickness)
    top:SetColorTexture(color[1], color[2], color[3], color[4])
    top:Hide()
    border.top = top

    local bottom = parent:CreateTexture(nil, "OVERLAY")
    bottom:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", inset, inset)
    bottom:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -inset, inset)
    bottom:SetHeight(thickness)
    bottom:SetColorTexture(color[1], color[2], color[3], color[4])
    bottom:Hide()
    border.bottom = bottom

    local left = parent:CreateTexture(nil, "OVERLAY")
    left:SetPoint("TOPLEFT", parent, "TOPLEFT", inset, -inset)
    left:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", inset, inset)
    left:SetWidth(thickness)
    left:SetColorTexture(color[1], color[2], color[3], color[4])
    left:Hide()
    border.left = left

    local right = parent:CreateTexture(nil, "OVERLAY")
    right:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -inset, -inset)
    right:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -inset, inset)
    right:SetWidth(thickness)
    right:SetColorTexture(color[1], color[2], color[3], color[4])
    right:Hide()
    border.right = right

    return border
end

local function setBorderShown(border, shown)
    for _, edge in pairs(border) do
        if shown then
            edge:Show()
        else
            edge:Hide()
        end
    end
end

local function hidePetPresentation(button)
    setBorderShown(button.logresPetActiveBorder, false)
    setBorderShown(button.logresPetAutocastBorder, false)
    button.logresPetActivePipBorder:Hide()
    button.logresPetActivePip:Hide()
    button.logresPetAutocastPipBorder:Hide()
    button.logresPetAutocastPip:Hide()
    if button.logresPetActiveWash then
        button.logresPetActiveWash:Hide()
    end
    if button.logresPetAutocastRailBorder then
        button.logresPetAutocastRailBorder:Hide()
    end
    if button.logresPetAutocastRail then
        button.logresPetAutocastRail:Hide()
    end
    button.logresPetActiveShown = false
    button.logresPetAutocastShown = false
end

local function updateButton(button)
    if button.logresPetType ~= "pet" then
        hidePetPresentation(button)
        return false
    end

    local slot = button.logresPetSlot
    if type(slot) ~= "number" or slot < 1 or slot > 10 then
        hidePetPresentation(button)
        return false
    end

    if type(GetPetActionInfo) ~= "function" then
        hidePetPresentation(button)
        return false
    end

    local ok,
        rawName,
        rawTexture,
        rawIsToken,
        rawIsActive,
        rawAutoCastAllowed,
        rawAutoCastEnabled = pcall(GetPetActionInfo, slot)

    if not ok then
        hidePetPresentation(button)
        return false
    end

    -- The first three results can be secret-capable and are intentionally never
    -- inspected here. Only the three state booleans are sanitized below.
    local _ = rawName
    _ = rawTexture
    _ = rawIsToken

    local isActive = ordinaryBoolean(rawIsActive)
    local autoCastAllowed = ordinaryBoolean(rawAutoCastAllowed)
    local autoCastEnabled = ordinaryBoolean(rawAutoCastEnabled)

    if isActive == nil or autoCastAllowed == nil or autoCastEnabled == nil then
        hidePetPresentation(button)
        return false
    end

    local activeShown = isActive == true
    local autocastShown = autoCastAllowed == true and autoCastEnabled == true

    setBorderShown(button.logresPetActiveBorder, activeShown)
    setBorderShown(button.logresPetAutocastBorder, autocastShown)

    if activeShown then
        button.logresPetActivePipBorder:Show()
        button.logresPetActivePip:Show()
        button.logresPetActiveWash:Show()
    else
        button.logresPetActivePipBorder:Hide()
        button.logresPetActivePip:Hide()
        button.logresPetActiveWash:Hide()
    end

    if autocastShown then
        button.logresPetAutocastPipBorder:Show()
        button.logresPetAutocastPip:Show()
        button.logresPetAutocastRailBorder:Show()
        button.logresPetAutocastRail:Show()
    else
        button.logresPetAutocastPipBorder:Hide()
        button.logresPetAutocastPip:Hide()
        button.logresPetAutocastRailBorder:Hide()
        button.logresPetAutocastRail:Hide()
    end

    button.logresPetActiveShown = activeShown
    button.logresPetAutocastShown = autocastShown
    return true
end

local function readAttribute(button, name, expectedType)
    local ok, value = pcall(button.GetAttribute, button, name)
    if not ok then
        return nil
    end

    return ordinaryAttribute(value, expectedType)
end

local function readEffectiveAttribute(button, name, mouseButton, expectedType)
    if type(SecureButton_GetModifiedAttribute) ~= "function" then
        return nil
    end

    local suffix = mouseButton == "LeftButton" and "1" or "2"
    local ok, value = pcall(
        SecureButton_GetModifiedAttribute,
        button,
        name,
        mouseButton,
        "",
        suffix
    )
    if not ok then
        return nil
    end

    return ordinaryAttribute(value, expectedType)
end

local function resolvePetBinding(button)
    for _, mouseButton in ipairs({ "LeftButton", "RightButton" }) do
        local actionType = readEffectiveAttribute(
            button,
            "type",
            mouseButton,
            "string"
        )

        if actionType == "pet" then
            local slot = readEffectiveAttribute(
                button,
                "action",
                mouseButton,
                "number"
            )

            if type(slot) == "number" and slot >= 1 and slot <= 10 then
                return "pet", slot, mouseButton
            end
        end
    end

    return nil, nil, nil
end

local function refreshPetBinding(button)
    local petType, slot, mouseButton = resolvePetBinding(button)
    button.logresPetType = petType
    button.logresPetSlot = slot
    button.logresPetBindingButton = mouseButton
    return updateButton(button)
end

local function primeAttributes(button)
    refreshPetBinding(button)
end

local function decorateButton(button)
    if button.logresPetPresentationReady then
        return
    end

    local activeBorder = createBorder(button, 1, ACTIVE_BORDER_SIZE, ACTIVE_COLOR)
    local autocastBorder = createBorder(button, -2, AUTOCAST_BORDER_SIZE, AUTOCAST_COLOR)

    local activePipBorder = button:CreateTexture(nil, "OVERLAY")
    activePipBorder:SetSize(ACTIVE_PIP_SIZE + 2, ACTIVE_PIP_SIZE + 2)
    activePipBorder:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2)
    activePipBorder:SetColorTexture(DARK_COLOR[1], DARK_COLOR[2], DARK_COLOR[3], DARK_COLOR[4])
    activePipBorder:Hide()

    local activePip = button:CreateTexture(nil, "OVERLAY")
    activePip:SetSize(ACTIVE_PIP_SIZE, ACTIVE_PIP_SIZE)
    activePip:SetPoint("CENTER", activePipBorder, "CENTER", 0, 0)
    activePip:SetColorTexture(ACTIVE_COLOR[1], ACTIVE_COLOR[2], ACTIVE_COLOR[3], ACTIVE_COLOR[4])
    activePip:Hide()

    local autocastPipBorder = button:CreateTexture(nil, "OVERLAY")
    autocastPipBorder:SetSize(AUTOCAST_PIP_SIZE + 2, AUTOCAST_PIP_SIZE + 2)
    autocastPipBorder:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 2, 2)
    autocastPipBorder:SetColorTexture(DARK_COLOR[1], DARK_COLOR[2], DARK_COLOR[3], DARK_COLOR[4])
    autocastPipBorder:Hide()

    local autocastPip = button:CreateTexture(nil, "OVERLAY")
    autocastPip:SetSize(AUTOCAST_PIP_SIZE, AUTOCAST_PIP_SIZE)
    autocastPip:SetPoint("CENTER", autocastPipBorder, "CENTER", 0, 0)
    autocastPip:SetColorTexture(AUTOCAST_COLOR[1], AUTOCAST_COLOR[2], AUTOCAST_COLOR[3], AUTOCAST_COLOR[4])
    autocastPip:Hide()

    button.logresPetPresentationReady = true
    button.logresPetActiveBorder = activeBorder
    button.logresPetAutocastBorder = autocastBorder
    button.logresPetActivePipBorder = activePipBorder
    button.logresPetActivePip = activePip
    local activeWash = button:CreateTexture(nil, "OVERLAY")
    activeWash:SetPoint("TOPLEFT", button, "TOPLEFT", 5, -5)
    activeWash:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -5, 5)
    activeWash:SetColorTexture(1.00, 0.72, 0.18, 0.18)
    activeWash:SetBlendMode("ADD")
    activeWash:Hide()

    local autocastRailBorder = button:CreateTexture(nil, "OVERLAY")
    autocastRailBorder:SetPoint("BOTTOM", button, "BOTTOM", 0, 4)
    autocastRailBorder:SetSize(18, 5)
    autocastRailBorder:SetColorTexture(DARK_COLOR[1], DARK_COLOR[2], DARK_COLOR[3], DARK_COLOR[4])
    autocastRailBorder:Hide()

    local autocastRail = button:CreateTexture(nil, "OVERLAY")
    autocastRail:SetPoint("CENTER", autocastRailBorder, "CENTER", 0, 0)
    autocastRail:SetSize(16, 3)
    autocastRail:SetColorTexture(AUTOCAST_COLOR[1], AUTOCAST_COLOR[2], AUTOCAST_COLOR[3], AUTOCAST_COLOR[4])
    autocastRail:SetBlendMode("ADD")
    autocastRail:Hide()

    button.logresPetAutocastPipBorder = autocastPipBorder
    button.logresPetAutocastPip = autocastPip
    button.logresPetActiveWash = activeWash
    button.logresPetAutocastRailBorder = autocastRailBorder
    button.logresPetAutocastRail = autocastRail
    button.logresPetType = nil
    button.logresPetSlot = nil
    button.logresPetBindingButton = nil
    button.logresPetActiveShown = false
    button.logresPetAutocastShown = false

    button:HookScript("OnAttributeChanged", function(current, name)
        if name == "type"
            or name == "action"
            or name == "type1"
            or name == "action1"
            or name == "type2"
            or name == "action2"
            or name == "*type1"
            or name == "*action1"
            or name == "*type2"
            or name == "*action2"
        then
            refreshPetBinding(current)
        end
    end)

    button:HookScript("PostClick", function(current)
        refreshPetBinding(current)
    end)

    trackedButtons[#trackedButtons + 1] = button
    primeAttributes(button)
end

function ActionButton.Create(...)
    local button = originalCreate(...)
    decorateButton(button)
    return button
end

local function refreshTrackedButtons()
    for index = 1, #trackedButtons do
        refreshPetBinding(trackedButtons[index])
    end
end

local function dispatchDefaultArm(reason)
    Presentation.defaultArmAttemptCount = (Presentation.defaultArmAttemptCount or 0) + 1
    Presentation.defaultArmLastTrigger = reason

    if type(InCombatLockdown) == "function" and InCombatLockdown() then
        Presentation.defaultArmPending = true
        Presentation.defaultArmLastResult = "combat-deferred"
        return false
    end

    if type(Logres.RunDevCommand) ~= "function" then
        Presentation.defaultArmLastResult = "command-router-unavailable"
        return false
    end

    local ok, commandError = Logres:RunDevCommand("petactionexecprobe arm", function() end)

    if ok then
        Presentation.defaultArmDispatchCount = (Presentation.defaultArmDispatchCount or 0) + 1
        Presentation.defaultArmPending = false
        Presentation.defaultArmLastResult = "arm-command-dispatched"
        return true
    end

    Presentation.defaultArmLastResult = commandError and "arm-command-failed" or "arm-command-rejected"
    return false
end

local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_PET" and unit ~= "player" then
        return
    end

    if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_PET" then
        dispatchDefaultArm(event)
    elseif event == "PLAYER_REGEN_ENABLED" and Presentation.defaultArmPending then
        dispatchDefaultArm(event)
    end

    refreshTrackedButtons()
end)

function Presentation:OnInitialize()
    self.defaultArmAttemptCount = 0
    self.defaultArmDispatchCount = 0
    self.defaultArmPending = false
    self.defaultArmLastTrigger = nil
    self.defaultArmLastResult = nil
end

function Presentation:OnEnable()
    eventFrame:RegisterEvent("PET_BAR_UPDATE")
    eventFrame:RegisterEvent("PET_BAR_UPDATE_USABLE")
    eventFrame:RegisterEvent("PET_UI_UPDATE")
    eventFrame:RegisterEvent("UNIT_PET")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

    self:OwnCleanup(function()
        eventFrame:UnregisterAllEvents()
        self.defaultArmPending = false
    end)
end

local function diagnosticScalar(value)
    if isSecret(value) then
        return "<secret>"
    end

    local valueType = type(value)
    if valueType == "nil" then
        return "nil"
    end
    if valueType == "string" or valueType == "number" or valueType == "boolean" then
        return tostring(value)
    end

    return "<" .. valueType .. ">"
end

local function diagnosticAttribute(button, name)
    local ok, value = pcall(button.GetAttribute, button, name)
    if not ok then
        return "error", "<error>"
    end
    if isSecret(value) then
        return "secret", "<secret>"
    end

    return type(value), diagnosticScalar(value)
end

local function diagnosticPetState(slot)
    if type(slot) ~= "number" or slot < 1 or slot > 10 then
        return "slot-unavailable"
    end
    if type(GetPetActionInfo) ~= "function" then
        return "api-unavailable"
    end

    local ok,
        rawName,
        rawTexture,
        rawIsToken,
        rawIsActive,
        rawAutoCastAllowed,
        rawAutoCastEnabled = pcall(GetPetActionInfo, slot)

    if not ok then
        return "call-failed"
    end

    local _ = rawName
    _ = rawTexture
    _ = rawIsToken

    local isActive = ordinaryBoolean(rawIsActive)
    local autoCastAllowed = ordinaryBoolean(rawAutoCastAllowed)
    local autoCastEnabled = ordinaryBoolean(rawAutoCastEnabled)

    return string.format(
        "active=%s autocast=%s/%s",
        diagnosticScalar(isActive),
        diagnosticScalar(autoCastAllowed),
        diagnosticScalar(autoCastEnabled)
    )
end

function Presentation:GetDiagnosticLines()
    local lines = {}
    local status = self:GetDebugStatus()

    lines[#lines + 1] = string.format(
        "Logres petstate: module=%s tracked=%s pet=%s readable=%s activeIndicators=%s autocastIndicators=%s armAttempts=%s armDispatches=%s armPending=%s armTrigger=%s armResult=%s",
        diagnosticScalar(status.moduleEnabled),
        diagnosticScalar(status.decoratedButtonCount),
        diagnosticScalar(status.petButtonCount),
        diagnosticScalar(status.stateReadableCount),
        diagnosticScalar(status.activeIndicatorCount),
        diagnosticScalar(status.autocastIndicatorCount),
        diagnosticScalar(status.defaultArmAttemptCount),
        diagnosticScalar(status.defaultArmDispatchCount),
        diagnosticScalar(status.defaultArmPending),
        diagnosticScalar(status.defaultArmLastTrigger),
        diagnosticScalar(status.defaultArmLastResult)
    )

    local probeOK, probe = pcall(Logres.GetModule, Logres, "PetActionExecutionProbe")
    if probeOK and probe and type(probe.GetDebugStatus) == "function" then
        local debugOK, probeStatus = pcall(probe.GetDebugStatus, probe)
        if debugOK and type(probeStatus) == "table" then
            lines[#lines + 1] = string.format(
                "Logres petstate: probe configured=%s pending=%s armed=%s visible=%s petBar=%s occupied=%s",
                diagnosticScalar(probeStatus.configured),
                diagnosticScalar(probeStatus.pending),
                diagnosticScalar(probeStatus.armed),
                diagnosticScalar(probeStatus.visible),
                diagnosticScalar(probeStatus.petBar),
                diagnosticScalar(probeStatus.occupied)
            )
        else
            lines[#lines + 1] = "Logres petstate: probe debug status unavailable"
        end
    else
        lines[#lines + 1] = "Logres petstate: probe module unavailable"
    end

    for index = 1, #trackedButtons do
        local button = trackedButtons[index]
        local typeKind, typeValue = diagnosticAttribute(button, "type")
        local actionKind, actionValue = diagnosticAttribute(button, "action")
        local type1Kind, type1Value = diagnosticAttribute(button, "type1")
        local action1Kind, action1Value = diagnosticAttribute(button, "action1")
        local type2Kind, type2Value = diagnosticAttribute(button, "type2")
        local action2Kind, action2Value = diagnosticAttribute(button, "action2")
        local shown = button:IsShown() and true or false

        lines[#lines + 1] = string.format(
            "Logres petstate: button[%s] shown=%s type=%s:%s action=%s:%s type1=%s:%s action1=%s:%s type2=%s:%s action2=%s:%s binding=%s cachedType=%s cachedSlot=%s activeShown=%s autocastShown=%s state={%s}",
            tostring(index),
            diagnosticScalar(shown),
            typeKind,
            typeValue,
            actionKind,
            actionValue,
            type1Kind,
            type1Value,
            action1Kind,
            action1Value,
            type2Kind,
            type2Value,
            action2Kind,
            action2Value,
            diagnosticScalar(button.logresPetBindingButton),
            diagnosticScalar(button.logresPetType),
            diagnosticScalar(button.logresPetSlot),
            diagnosticScalar(button.logresPetActiveShown),
            diagnosticScalar(button.logresPetAutocastShown),
            diagnosticPetState(button.logresPetSlot)
        )
    end

    return lines
end

function Presentation:GetDebugStatus()
    local decorated = 0
    local petButtons = 0
    local stateReadable = 0
    local activeIndicators = 0
    local autocastIndicators = 0

    for index = 1, #trackedButtons do
        local button = trackedButtons[index]
        decorated = decorated + 1

        refreshPetBinding(button)

        if button.logresPetType == "pet" then
            petButtons = petButtons + 1
            if updateButton(button) then
                stateReadable = stateReadable + 1
            end
            if button.logresPetActiveShown then
                activeIndicators = activeIndicators + 1
            end
            if button.logresPetAutocastShown then
                autocastIndicators = autocastIndicators + 1
            end
        end
    end

    return {
        moduleEnabled = self:IsEnabled(),
        decoratedButtonCount = decorated,
        petButtonCount = petButtons,
        stateReadableCount = stateReadable,
        activeIndicatorCount = activeIndicators,
        autocastIndicatorCount = autocastIndicators,
        defaultArmAttemptCount = self.defaultArmAttemptCount or 0,
        defaultArmDispatchCount = self.defaultArmDispatchCount or 0,
        defaultArmPending = self.defaultArmPending and true or false,
        defaultArmLastTrigger = self.defaultArmLastTrigger,
        defaultArmLastResult = self.defaultArmLastResult,
    }
end
