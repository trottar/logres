local _, Logres = ...

local BUTTON_COUNT = 12
local BUTTON_SIZE = 38
local BUTTON_GAP = 5
local COLUMNS = 4
local ROWS = 3

local ACTION_EVENTS = {
    "ACTIONBAR_SLOT_CHANGED",
    "ACTIONBAR_UPDATE_COOLDOWN",
    "ACTIONBAR_UPDATE_STATE",
    "ACTIONBAR_UPDATE_USABLE",
    "ACTION_USABLE_CHANGED",
    "ACTION_RANGE_CHECK_UPDATE",
    "ACTIONBAR_PAGE_CHANGED",
    "UPDATE_BINDINGS",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_ENTERING_WORLD",
}

local Primary = Logres:RegisterModule("PrimaryActions", {
    OnInitialize = function(self)
        local width =
            (COLUMNS * BUTTON_SIZE) + ((COLUMNS - 1) * BUTTON_GAP)
        local height =
            (ROWS * BUTTON_SIZE) + ((ROWS - 1) * BUTTON_GAP)

        local cluster = CreateFrame(
            "Frame",
            "LogresPrimaryActionCluster",
            UIParent
        )
        cluster:SetSize(width, height)
        cluster:SetPoint("CENTER", UIParent, "CENTER", 0, -260)
        cluster:SetFrameStrata("MEDIUM")

        local backdrop = cluster:CreateTexture(nil, "BACKGROUND")
        backdrop:SetPoint("TOPLEFT", cluster, "TOPLEFT", -7, 7)
        backdrop:SetPoint("BOTTOMRIGHT", cluster, "BOTTOMRIGHT", 7, -7)
        backdrop:SetColorTexture(0.025, 0.022, 0.018, 0.78)

        local bindingOwner = CreateFrame(
            "Frame",
            "LogresPrimaryActionBindingOwner",
            UIParent
        )

        self.cluster = cluster
        self.bindingOwner = bindingOwner
        self.buttons = {}
        self.currentPage = nil
        self.firstActionSlot = nil
        self.lastActionSlot = nil
        self.registeredCount = 0
        self.bindingRoutingEnabled = false
        self.bindingsApplied = false
        self.bindingKeyCounts = {}
        self.pendingPageRefresh = false
        self.pendingBindingRefresh = false

        for index = 1, BUTTON_COUNT do
            local name = "LogresPrimaryActionButton" .. index
            local button = CreateFrame(
                "CheckButton",
                name,
                cluster,
                "SecureActionButtonTemplate"
            )

            button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
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
            local column = zeroIndex % COLUMNS
            local row = math.floor(zeroIndex / COLUMNS)

            button:SetPoint(
                "TOPLEFT",
                cluster,
                "TOPLEFT",
                column * (BUTTON_SIZE + BUTTON_GAP),
                -(row * (BUTTON_SIZE + BUTTON_GAP))
            )

            local border = button:CreateTexture(nil, "BACKGROUND")
            border:SetAllPoints(button)
            border:SetColorTexture(0.13, 0.11, 0.085, 0.98)

            local inner = button:CreateTexture(nil, "BORDER")
            inner:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
            inner:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
            inner:SetColorTexture(0.025, 0.022, 0.018, 0.98)

            local icon = button:CreateTexture(nil, "ARTWORK")
            icon:SetPoint("TOPLEFT", button, "TOPLEFT", 4, -4)
            icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 4)
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

            local checked = button:CreateTexture(nil, "OVERLAY")
            checked:SetAllPoints(icon)
            checked:SetColorTexture(0.84, 0.68, 0.30, 0.22)
            button:SetCheckedTexture(checked)

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

            self.buttons[index] = button
        end

        local eventFrame = CreateFrame("Frame")
        eventFrame:SetScript("OnEvent", function(_, event, ...)
            self:HandleEvent(event, ...)
        end)

        self.eventFrame = eventFrame
    end,

    OnEnable = function(self)
        for index = 1, #ACTION_EVENTS do
            self.eventFrame:RegisterEvent(ACTION_EVENTS[index])
        end

        self:OwnCleanup(function()
            self.eventFrame:UnregisterAllEvents()
        end)

        self:ApplyActionPage()
        self:RefreshBindingLabels()
        self.cluster:Show()
        self:UpdateAll()
    end,

    OnDisable = function(self)
        -- PrimaryActions is not currently exposed as a combat-time toggle.
        -- Normal disable/cleanup is an out-of-combat development operation.
        if not InCombatLockdown() then
            self:ClearBindings()
            self:UnregisterButtons()
            self.cluster:Hide()
        else
            Logres:DevPrint(
                "PrimaryActions disable requested during combat; "
                .. "protected cleanup was not attempted."
            )
        end
    end,
})

function Primary:GetActionSlotForIndex(index)
    if not self.currentPage then
        return index
    end

    return ((self.currentPage - 1) * BUTTON_COUNT) + index
end

function Primary:UnregisterButtons()
    for index = 1, #self.buttons do
        local button = self.buttons[index]

        if button.registeredActionSlot then
            C_ActionBar.EnableActionRangeCheck(
                button.registeredActionSlot,
                false
            )
            C_ActionBar.UnregisterActionUIButton(button)
            button.registeredActionSlot = nil
        end
    end

    self.registeredCount = 0
end

function Primary:ApplyActionPage()
    if InCombatLockdown() then
        self.pendingPageRefresh = true
        return false
    end

    local page = C_ActionBar.GetActionBarPage()

    if page < 1 then
        page = 1
    end

    self:UnregisterButtons()

    self.currentPage = page
    self.firstActionSlot = ((page - 1) * BUTTON_COUNT) + 1
    self.lastActionSlot = self.firstActionSlot + BUTTON_COUNT - 1

    for index = 1, #self.buttons do
        local button = self.buttons[index]
        local actionSlot = self:GetActionSlotForIndex(index)

        button:SetAttribute("action", actionSlot)
        button.actionSlot = actionSlot

        C_ActionBar.RegisterActionUIButton(
            button,
            actionSlot,
            button.cooldown
        )
        C_ActionBar.EnableActionRangeCheck(actionSlot, true)

        button.registeredActionSlot = actionSlot
        self.registeredCount = self.registeredCount + 1
    end

    self.pendingPageRefresh = false
    self:UpdateAll()
    return true
end

function Primary:RefreshBindingLabels()
    for index = 1, #self.buttons do
        local button = self.buttons[index]
        local command = "ACTIONBUTTON" .. index
        local keys = { GetBindingKey(command) }

        self.bindingKeyCounts[index] = #keys
        button.hotkeyText:SetText(keys[1] or "")
    end
end

function Primary:RefreshOverrideBindings()
    if InCombatLockdown() then
        self.pendingBindingRefresh = true
        return false
    end

    ClearOverrideBindings(self.bindingOwner)
    self.bindingsApplied = false

    if self.bindingRoutingEnabled then
        for index = 1, #self.buttons do
            local button = self.buttons[index]
            local command = "ACTIONBUTTON" .. index
            local keys = { GetBindingKey(command) }

            for keyIndex = 1, #keys do
                SetOverrideBindingClick(
                    self.bindingOwner,
                    false,
                    keys[keyIndex],
                    button:GetName(),
                    "LeftButton"
                )
            end
        end

        self.bindingsApplied = true
    end

    self.pendingBindingRefresh = false
    return true
end

function Primary:SetBindingRoutingEnabled(enabled)
    self.bindingRoutingEnabled = enabled == true
    self:RefreshBindingLabels()

    if InCombatLockdown() then
        self.pendingBindingRefresh = true
        return false
    end

    return self:RefreshOverrideBindings()
end

function Primary:ClearBindings()
    self.bindingRoutingEnabled = false
    return self:RefreshOverrideBindings()
end


function Primary:UpdateIcon(button)
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

function Primary:UpdateCooldown(button)
    local actionSlot = button.actionSlot
    if not actionSlot then
        return
    end

    local duration = C_ActionBar.GetActionCooldownDuration(actionSlot)
    button.cooldown:SetCooldownFromDurationObject(duration, true)
end

function Primary:UpdateCount(button)
    local actionSlot = button.actionSlot
    if not actionSlot then
        return
    end

    -- The display count can be secret on Forever. Do not inspect it.
    button.countText:SetText(
        C_ActionBar.GetActionDisplayCount(actionSlot)
    )
end

function Primary:UpdateUsabilityAndRange(button)
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

function Primary:UpdateButton(button)
    self:UpdateIcon(button)
    self:UpdateCooldown(button)
    self:UpdateCount(button)
    self:UpdateUsabilityAndRange(button)
end

function Primary:UpdateAll()
    for index = 1, #self.buttons do
        self:UpdateButton(self.buttons[index])
    end
end

function Primary:UpdateSlot(actionSlot)
    for index = 1, #self.buttons do
        local button = self.buttons[index]

        if button.actionSlot == actionSlot then
            self:UpdateButton(button)
            return
        end
    end
end

function Primary:HandleEvent(event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        if self.pendingPageRefresh then
            self:ApplyActionPage()
        end

        if self.pendingBindingRefresh then
            self:RefreshOverrideBindings()
        end

        return
    end

    if event == "ACTIONBAR_PAGE_CHANGED" then
        self:ApplyActionPage()
        return
    end

    if event == "UPDATE_BINDINGS" then
        self:RefreshBindingLabels()

        if self.bindingRoutingEnabled or self.bindingsApplied then
            self:RefreshOverrideBindings()
        end

        return
    end

    if event == "ACTIONBAR_SLOT_CHANGED" then
        local actionSlot = ...

        if actionSlot == 0 then
            self:UpdateAll()
        else
            self:UpdateSlot(actionSlot)
        end

        return
    end

    if event == "ACTION_RANGE_CHECK_UPDATE" then
        local actionSlot = ...
        self:UpdateSlot(actionSlot)
        return
    end

    self:UpdateAll()
end

function Primary:GetDebugStatus()
    local boundButtonCount = 0

    for index = 1, #self.buttons do
        if (self.bindingKeyCounts[index] or 0) > 0 then
            boundButtonCount = boundButtonCount + 1
        end
    end

    return {
        moduleEnabled = self:IsEnabled(),
        clusterShown = self.cluster and self.cluster:IsShown() or false,
        buttonCount = self.buttons and #self.buttons or 0,
        registeredCount = self.registeredCount or 0,
        currentPage = self.currentPage,
        firstActionSlot = self.firstActionSlot,
        lastActionSlot = self.lastActionSlot,
        bindingRoutingEnabled = self.bindingRoutingEnabled == true,
        bindingsApplied = self.bindingsApplied == true,
        boundButtonCount = boundButtonCount,
        pendingPageRefresh = self.pendingPageRefresh == true,
        pendingBindingRefresh = self.pendingBindingRefresh == true,
        stockBarsSuppressed = false,
    }
end
