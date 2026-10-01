local _, Logres = ...

local TargetFrameReplacement =
    Logres:RegisterModule("TargetFrameReplacement", {
        OnInitialize = function(self)
            self.requestedEnabled = false
            self.appliedEnabled = false
            self.pending = false
            self.snapshot = nil
            self.unitWatchRegistered = false
            self.lastError = nil
            self.lastReason = "not-yet-requested"

            local interaction = CreateFrame(
                "Button",
                "LogresTargetUnitInteraction",
                UIParent,
                "SecureUnitButtonTemplate"
            )

            interaction:SetSize(260, 54)
            interaction:SetPoint("CENTER", UIParent, "CENTER", 0, -54)
            interaction:SetFrameStrata("HIGH")
            interaction:SetFrameLevel(101)
            interaction:RegisterForClicks("AnyUp")
            interaction:SetAttribute("unit", "target")
            interaction:SetAttribute("*type1", "target")
            interaction:SetAttribute("*type2", "togglemenu")
            interaction:EnableMouse(false)
            interaction:Hide()

            self.interaction = interaction

            local eventFrame = CreateFrame("Frame")
            eventFrame:SetScript("OnEvent", function(_, event)
                self:HandleEvent(event)
            end)
            self.eventFrame = eventFrame
        end,

        OnEnable = function(self)
            self.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

            self:OwnCleanup(function()
                self.eventFrame:UnregisterAllEvents()
            end)
        end,

        OnDisable = function(self)
            if not self.appliedEnabled then
                return
            end

            if InCombatLockdown() then
                Logres:DevPrint(
                    "TargetFrameReplacement disabled during combat while "
                    .. "selective replacement was active; stock restoration "
                    .. "was not attempted."
                )
                return
            end

            self.requestedEnabled = false
            self:ApplyRequestedState("module-disable")
        end,
    })

local PRESERVED_CONTEXT_KEYS = {
    "Auras",
    "RaidTargetIcon",
    "QuestIcon",
    "PingIconFrame",
}

local function getMouseState(frame)
    local state = {
        enabled = nil,
        clickEnabled = nil,
        motionEnabled = nil,
    }

    if type(frame.IsMouseEnabled) == "function" then
        state.enabled = frame:IsMouseEnabled() == true
    end

    if type(frame.IsMouseClickEnabled) == "function" then
        state.clickEnabled = frame:IsMouseClickEnabled() == true
    end

    if type(frame.IsMouseMotionEnabled) == "function" then
        state.motionEnabled = frame:IsMouseMotionEnabled() == true
    end

    return state
end

local function suppressMouse(frame)
    if type(frame.EnableMouse) == "function" then
        frame:EnableMouse(false)
    end

    if type(frame.SetMouseClickEnabled) == "function" then
        frame:SetMouseClickEnabled(false)
    end

    if type(frame.SetMouseMotionEnabled) == "function" then
        frame:SetMouseMotionEnabled(false)
    end
end

local function restoreMouse(frame, state)
    if state.enabled ~= nil
        and type(frame.EnableMouse) == "function"
    then
        frame:EnableMouse(state.enabled)
    end

    if state.clickEnabled ~= nil
        and type(frame.SetMouseClickEnabled) == "function"
    then
        frame:SetMouseClickEnabled(state.clickEnabled)
    end

    if state.motionEnabled ~= nil
        and type(frame.SetMouseMotionEnabled) == "function"
    then
        frame:SetMouseMotionEnabled(state.motionEnabled)
    end
end

function TargetFrameReplacement:GetStockFrames()
    local targetFrame = _G.TargetFrame

    if not targetFrame then
        return nil, "missing TargetFrame"
    end

    local container = targetFrame.TargetFrameContainer
    if not container then
        return nil, "missing TargetFrame.TargetFrameContainer"
    end

    local content = targetFrame.TargetFrameContent
    if not content then
        return nil, "missing TargetFrame.TargetFrameContent"
    end

    local main = content.TargetFrameContentMain
    if not main then
        return nil,
            "missing TargetFrame.TargetFrameContent.TargetFrameContentMain"
    end

    local contextual = content.TargetFrameContentContextual
    if not contextual then
        return nil,
            "missing TargetFrame.TargetFrameContent.TargetFrameContentContextual"
    end

    local preserved = {}

    for index = 1, #PRESERVED_CONTEXT_KEYS do
        local key = PRESERVED_CONTEXT_KEYS[index]
        local region = contextual[key]

        if not region then
            return nil,
                "missing TargetFrame contextual child: "
                .. tostring(key)
        end

        if type(region.IsIgnoringParentAlpha) ~= "function"
            or type(region.SetIgnoreParentAlpha) ~= "function"
        then
            return nil,
                "TargetFrame contextual child lacks parent-alpha API: "
                .. tostring(key)
        end

        preserved[#preserved + 1] = {
            key = key,
            region = region,
        }
    end

    return {
        targetFrame = targetFrame,
        container = container,
        contentMain = main,
        contextual = contextual,
        preserved = preserved,
        targetOfTarget = targetFrame.totFrame or _G.TargetFrameToT,
    }
end

function TargetFrameReplacement:IsInteractionReady()
    local interaction = self.interaction

    return interaction ~= nil
        and type(RegisterUnitWatch) == "function"
        and type(UnregisterUnitWatch) == "function"
        and interaction:GetAttribute("unit") == "target"
        and interaction:GetAttribute("*type1") == "target"
        and interaction:GetAttribute("*type2") == "togglemenu"
end

function TargetFrameReplacement:CaptureStock()
    local frames, frameError = self:GetStockFrames()

    if not frames then
        return nil, frameError
    end

    if not self:IsInteractionReady() then
        return nil,
            "Logres secure target interaction is not configured"
    end

    local preserved = {}

    for index = 1, #frames.preserved do
        local entry = frames.preserved[index]

        preserved[index] = {
            key = entry.key,
            region = entry.region,
            ignoreParentAlpha =
                entry.region:IsIgnoringParentAlpha() == true,
        }
    end

    return {
        targetFrame = frames.targetFrame,
        container = frames.container,
        contentMain = frames.contentMain,
        contextual = frames.contextual,
        preserved = preserved,

        containerAlpha = frames.container:GetAlpha(),
        contentMainAlpha = frames.contentMain:GetAlpha(),
        contextualAlpha = frames.contextual:GetAlpha(),

        mouse = getMouseState(frames.targetFrame),
    }
end

function TargetFrameReplacement:EnableInteraction()
    if self.unitWatchRegistered then
        self.interaction:EnableMouse(true)
        return
    end

    self.interaction:EnableMouse(true)
    RegisterUnitWatch(self.interaction)
    self.unitWatchRegistered = true
end

function TargetFrameReplacement:DisableInteraction()
    if self.unitWatchRegistered then
        UnregisterUnitWatch(self.interaction)
        self.unitWatchRegistered = false
    end

    self.interaction:EnableMouse(false)
    self.interaction:Hide()
end

function TargetFrameReplacement:SuppressStock(snapshot)
    for index = 1, #snapshot.preserved do
        snapshot.preserved[index].region:SetIgnoreParentAlpha(true)
    end

    snapshot.container:SetAlpha(0)
    snapshot.contentMain:SetAlpha(0)
    snapshot.contextual:SetAlpha(0)
    suppressMouse(snapshot.targetFrame)
end

function TargetFrameReplacement:RestoreStock(snapshot)
    snapshot.container:SetAlpha(snapshot.containerAlpha)
    snapshot.contentMain:SetAlpha(snapshot.contentMainAlpha)
    snapshot.contextual:SetAlpha(snapshot.contextualAlpha)

    for index = 1, #snapshot.preserved do
        local entry = snapshot.preserved[index]
        entry.region:SetIgnoreParentAlpha(entry.ignoreParentAlpha)
    end

    restoreMouse(snapshot.targetFrame, snapshot.mouse)
end

function TargetFrameReplacement:EnableReplacement(reason)
    if self.appliedEnabled then
        self.pending = false
        self.lastError = nil
        self.lastReason = reason or "already-applied"
        return true
    end

    if InCombatLockdown() then
        self.pending = true
        self.lastReason = reason or "deferred-enable"
        return false
    end

    local snapshot, captureError = self:CaptureStock()

    if not snapshot then
        self.requestedEnabled = false
        self.pending = false
        self.lastError = captureError
        self.lastReason = reason or "capture-failed"
        return false
    end

    local interactionOK, interactionError =
        pcall(function()
            self:EnableInteraction()
        end)

    if not interactionOK then
        pcall(function()
            self:DisableInteraction()
        end)

        self.requestedEnabled = false
        self.pending = false
        self.lastError =
            "secure target interaction enable failed: "
            .. tostring(interactionError)
        self.lastReason = reason or "interaction-failed"
        return false
    end

    local suppressed, suppressError =
        pcall(function()
            self:SuppressStock(snapshot)
        end)

    if not suppressed then
        local restoreOK, restoreError =
            pcall(function()
                self:RestoreStock(snapshot)
            end)

        pcall(function()
            self:DisableInteraction()
        end)

        self.requestedEnabled = false
        self.pending = false
        self.appliedEnabled = false
        self.snapshot = nil

        if restoreOK then
            self.lastError =
                "TargetFrame selective suppression failed and "
                .. "stock state was restored: "
                .. tostring(suppressError)
        else
            self.lastError =
                "TargetFrame selective suppression failed; "
                .. "restoration also failed: "
                .. tostring(suppressError)
                .. " | "
                .. tostring(restoreError)
        end

        self.lastReason = reason or "suppression-failed"
        return false
    end

    self.snapshot = snapshot
    self.appliedEnabled = true
    self.pending = false
    self.lastError = nil
    self.lastReason = reason or "enabled"

    return true
end

function TargetFrameReplacement:DisableReplacement(reason)
    if not self.appliedEnabled then
        self.requestedEnabled = false
        self.pending = false
        self.lastError = nil
        self.lastReason = reason or "already-disabled"

        pcall(function()
            self:DisableInteraction()
        end)

        return true
    end

    if InCombatLockdown() then
        self.pending = true
        self.lastReason = reason or "deferred-disable"
        return false
    end

    local snapshot = self.snapshot

    if not snapshot then
        self.requestedEnabled = false
        self.appliedEnabled = false
        self.pending = false
        self.lastError =
            "TargetFrame replacement active without restoration snapshot"
        self.lastReason = reason or "missing-snapshot"
        return false
    end

    local restored, restoreError =
        pcall(function()
            self:RestoreStock(snapshot)
        end)

    if not restored then
        self.lastError =
            "TargetFrame stock restoration failed: "
            .. tostring(restoreError)
        self.lastReason = reason or "restore-failed"
        return false
    end

    local interactionDisabled, interactionError =
        pcall(function()
            self:DisableInteraction()
        end)

    self.appliedEnabled = false
    self.requestedEnabled = false
    self.pending = false
    self.snapshot = nil

    if not interactionDisabled then
        self.lastError =
            "TargetFrame stock restored but Logres target "
            .. "interaction did not disable: "
            .. tostring(interactionError)
        self.lastReason = reason or "interaction-disable-failed"
        return false
    end

    self.lastError = nil
    self.lastReason = reason or "disabled"

    return true
end

function TargetFrameReplacement:ApplyRequestedState(reason)
    if self.requestedEnabled then
        return self:EnableReplacement(reason)
    end

    return self:DisableReplacement(reason)
end

function TargetFrameReplacement:RequestEnabled(enabled, reason)
    self.requestedEnabled = enabled == true
    self.lastReason = reason or "request"

    if InCombatLockdown() then
        self.pending = true
        return false, "deferred"
    end

    local applied = self:ApplyRequestedState(reason)

    if applied then
        return true, "applied"
    end

    return false, "failed"
end

function TargetFrameReplacement:HandleEvent(event)
    if event == "PLAYER_REGEN_ENABLED"
        and self.pending
    then
        self:ApplyRequestedState("PLAYER_REGEN_ENABLED")
    end
end

function TargetFrameReplacement:GetDebugStatus()
    local frames, frameError = self:GetStockFrames()

    local targetFrame = frames and frames.targetFrame or nil
    local container = frames and frames.container or nil
    local contentMain = frames and frames.contentMain or nil
    local contextual = frames and frames.contextual or nil

    local mouse =
        targetFrame and getMouseState(targetFrame)
        or {
            enabled = nil,
            clickEnabled = nil,
            motionEnabled = nil,
        }

    local preservedCount = 0
    local preservedIgnoreParentCount = 0

    if frames then
        preservedCount = #frames.preserved

        for index = 1, #frames.preserved do
            local region = frames.preserved[index].region

            if region:IsIgnoringParentAlpha() then
                preservedIgnoreParentCount =
                    preservedIgnoreParentCount + 1
            end
        end
    end

    local interaction = self.interaction

    return {
        moduleEnabled = self:IsEnabled(),

        requestedEnabled = self.requestedEnabled == true,
        appliedEnabled = self.appliedEnabled == true,
        pending = self.pending == true,
        snapshotReady = self.snapshot ~= nil,

        lastReason = self.lastReason,
        lastError = self.lastError or frameError,

        targetFrameFound = targetFrame ~= nil,
        containerFound = container ~= nil,
        contentMainFound = contentMain ~= nil,
        contextualFound = contextual ~= nil,

        containerAlpha =
            container and container:GetAlpha() or nil,
        contentMainAlpha =
            contentMain and contentMain:GetAlpha() or nil,
        contextualAlpha =
            contextual and contextual:GetAlpha() or nil,

        targetFrameMouseEnabled = mouse.enabled,
        targetFrameMouseClickEnabled = mouse.clickEnabled,
        targetFrameMouseMotionEnabled = mouse.motionEnabled,

        preservedCount = preservedCount,
        preservedIgnoreParentCount = preservedIgnoreParentCount,

        interactionReady = self:IsInteractionReady(),
        unitWatchRegistered = self.unitWatchRegistered == true,
        interactionShown =
            interaction and interaction:IsShown() or false,
        interactionMouseEnabled =
            interaction
            and interaction:IsMouseEnabled() == true
            or false,

        interactionUnit =
            interaction
            and interaction:GetAttribute("unit")
            or nil,
        interactionLeftType =
            interaction
            and interaction:GetAttribute("*type1")
            or nil,
        interactionRightType =
            interaction
            and interaction:GetAttribute("*type2")
            or nil,

        targetOfTargetFound =
            frames and frames.targetOfTarget ~= nil or false,

        wholeTargetFrameSuppressedByLogres = false,
        targetOfTargetSuppressedByLogres = false,
        focusFrameSuppressedByLogres = false,
        bossFramesSuppressedByLogres = false,
        partyFramesSuppressedByLogres = false,
    }
end
