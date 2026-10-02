local _, Logres = ...

local TargetFrameReplacement =
    Logres:RegisterModule("TargetFrameReplacement", {
        OnInitialize = function(self)
            self.requestedEnabled = false
            self.appliedEnabled = false
            self.pending = false
            self.snapshot = nil
            self.unitWatchRegistered = false
            self.interactionConfigured = false
            self.interactionMouseOwnedByLogres = false
            self.stockPresentationSuppressed = false
            self.stockMouseSuppressed = false
            self.contextualSuppressedCount = 0
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
            self.interactionConfigured = true

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

local SUPPRESSED_CONTEXT_KEYS = {
    "HighLevelTexture",
    "LeaderIcon",
    "GuideIcon",
    "BossIcon",
    "PvpIcon",
    "PrestigePortrait",
    "PrestigeBadge",
    "PetBattleIcon",
    "NumericalThreat",
}

-- Values returned by these protected/secret-capable frame queries are treated
-- as opaque restoration tokens. Do not branch, compare, format, or inspect them.
local function captureMouseState(frame)
    local state = {
        enabled = nil,
        clickEnabled = nil,
        motionEnabled = nil,
    }

    if type(frame.IsMouseEnabled) == "function" then
        state.enabled = frame:IsMouseEnabled()
    end

    if type(frame.IsMouseClickEnabled) == "function" then
        state.clickEnabled = frame:IsMouseClickEnabled()
    end

    if type(frame.IsMouseMotionEnabled) == "function" then
        state.motionEnabled = frame:IsMouseMotionEnabled()
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
                "missing preserved TargetFrame contextual child: "
                .. tostring(key)
        end

        preserved[#preserved + 1] = {
            key = key,
            region = region,
        }
    end

    local suppressed = {}

    for index = 1, #SUPPRESSED_CONTEXT_KEYS do
        local key = SUPPRESSED_CONTEXT_KEYS[index]
        local region = contextual[key]

        if not region then
            return nil,
                "missing suppressed TargetFrame contextual child: "
                .. tostring(key)
        end

        if type(region.GetAlpha) ~= "function"
            or type(region.SetAlpha) ~= "function"
        then
            return nil,
                "TargetFrame contextual child lacks alpha API: "
                .. tostring(key)
        end

        suppressed[#suppressed + 1] = {
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
        suppressed = suppressed,
        targetOfTarget =
            targetFrame.totFrame or _G.TargetFrameToT,
    }
end

function TargetFrameReplacement:IsInteractionReady()
    return self.interaction ~= nil
        and self.interactionConfigured == true
        and type(RegisterUnitWatch) == "function"
        and type(UnregisterUnitWatch) == "function"
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

    local suppressed = {}

    for index = 1, #frames.suppressed do
        local entry = frames.suppressed[index]

        suppressed[index] = {
            key = entry.key,
            region = entry.region,

            -- Opaque secret-capable alpha restoration token.
            -- Transport only; never inspect.
            alpha = entry.region:GetAlpha(),
        }
    end

    return {
        targetFrame = frames.targetFrame,
        container = frames.container,
        contentMain = frames.contentMain,
        preserved = frames.preserved,
        suppressed = suppressed,

        -- Alpha values are restoration tokens here; do not inspect them.
        containerAlpha = frames.container:GetAlpha(),
        contentMainAlpha = frames.contentMain:GetAlpha(),

        mouse = captureMouseState(frames.targetFrame),
    }
end

function TargetFrameReplacement:EnableInteraction()
    if self.unitWatchRegistered then
        self.interaction:EnableMouse(true)
        self.interactionMouseOwnedByLogres = true
        return
    end

    self.interaction:EnableMouse(true)
    self.interactionMouseOwnedByLogres = true

    RegisterUnitWatch(self.interaction)
    self.unitWatchRegistered = true
end

function TargetFrameReplacement:DisableInteraction()
    if self.unitWatchRegistered then
        UnregisterUnitWatch(self.interaction)
        self.unitWatchRegistered = false
    end

    self.interaction:EnableMouse(false)
    self.interactionMouseOwnedByLogres = false
    self.interaction:Hide()
end

function TargetFrameReplacement:SuppressStock(snapshot)
    self.contextualSuppressedCount = 0

    for index = 1, #snapshot.suppressed do
        local entry = snapshot.suppressed[index]

        entry.region:SetAlpha(0)
        self.contextualSuppressedCount =
            self.contextualSuppressedCount + 1
    end

    snapshot.container:SetAlpha(0)
    snapshot.contentMain:SetAlpha(0)
    self.stockPresentationSuppressed = true

    suppressMouse(snapshot.targetFrame)
    self.stockMouseSuppressed = true
end

function TargetFrameReplacement:RestoreStock(snapshot)
    snapshot.container:SetAlpha(snapshot.containerAlpha)
    snapshot.contentMain:SetAlpha(snapshot.contentMainAlpha)

    for index = 1, #snapshot.suppressed do
        local entry = snapshot.suppressed[index]

        -- Feed the opaque captured alpha token directly back.
        entry.region:SetAlpha(entry.alpha)
    end

    restoreMouse(snapshot.targetFrame, snapshot.mouse)

    self.contextualSuppressedCount = 0
    self.stockPresentationSuppressed = false
    self.stockMouseSuppressed = false
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

        self.contextualSuppressedCount = 0
        self.stockPresentationSuppressed = false
        self.stockMouseSuppressed = false

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

function TargetFrameReplacement:GetRecoveryStatus()
    return {
        moduleEnabled = self:IsEnabled(),
        requestedEnabled = self.requestedEnabled == true,
        appliedEnabled = self.appliedEnabled == true,
        pending = self.pending == true,
        snapshotReady = self.snapshot ~= nil,

        interactionConfigured =
            self.interactionConfigured == true,
        unitWatchRegistered =
            self.unitWatchRegistered == true,
        interactionMouseOwnedByLogres =
            self.interactionMouseOwnedByLogres == true,

        stockPresentationSuppressed =
            self.stockPresentationSuppressed == true,
        stockMouseSuppressed =
            self.stockMouseSuppressed == true,
        contextualSuppressedCount =
            self.contextualSuppressedCount,

        lastReason = self.lastReason,
        lastError = self.lastError,
    }
end

function TargetFrameReplacement:GetDebugStatus()
    local frames, frameError = self:GetStockFrames()

    return {
        moduleEnabled = self:IsEnabled(),

        requestedEnabled = self.requestedEnabled == true,
        appliedEnabled = self.appliedEnabled == true,
        pending = self.pending == true,
        snapshotReady = self.snapshot ~= nil,

        lastReason = self.lastReason,
        lastError = self.lastError or frameError,

        targetFrameFound =
            frames and frames.targetFrame ~= nil or false,
        containerFound =
            frames and frames.container ~= nil or false,
        contentMainFound =
            frames and frames.contentMain ~= nil or false,
        contextualFound =
            frames and frames.contextual ~= nil or false,

        preservedCount =
            frames and #frames.preserved or 0,
        suppressedContextCount =
            frames and #frames.suppressed or 0,
        contextualSuppressedCount =
            self.contextualSuppressedCount,

        stockPresentationSuppressed =
            self.stockPresentationSuppressed == true,
        stockMouseSuppressed =
            self.stockMouseSuppressed == true,

        interactionReady =
            self:IsInteractionReady(),
        interactionConfigured =
            self.interactionConfigured == true,
        unitWatchRegistered =
            self.unitWatchRegistered == true,
        interactionMouseOwnedByLogres =
            self.interactionMouseOwnedByLogres == true,

        interactionUnit = "target",
        interactionLeftType = "target",
        interactionRightType = "togglemenu",

        targetOfTargetFound =
            frames and frames.targetOfTarget ~= nil or false,

        wholeTargetFrameSuppressedByLogres = false,
        targetOfTargetSuppressedByLogres = false,
        focusFrameSuppressedByLogres = false,
        bossFramesSuppressedByLogres = false,
        partyFramesSuppressedByLogres = false,
    }
end
