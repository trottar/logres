local _, Logres = ...

local PlayerFrameReplacement =
    Logres:RegisterModule("PlayerFrameReplacement", {
        OnInitialize = function(self)
            self.requestedEnabled = false
            self.appliedEnabled = false
            self.pending = false
            self.snapshot = nil
            self.lastError = nil
            self.lastReason = "not-yet-requested"

            local interaction = CreateFrame(
                "Button",
                "LogresPlayerUnitInteraction",
                UIParent,
                "SecureUnitButtonTemplate"
            )

            interaction:SetSize(72, 30)
            interaction:SetPoint(
                "CENTER",
                UIParent,
                "CENTER",
                0,
                -118
            )
            interaction:SetFrameStrata("HIGH")
            interaction:SetFrameLevel(100)
            interaction:RegisterForClicks("AnyUp")
            interaction:SetAttribute("unit", "player")
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
                    "PlayerFrameReplacement disabled during combat while "
                    .. "selective replacement was active; stock restoration "
                    .. "was not attempted."
                )
                return
            end

            self.requestedEnabled = false
            self:ApplyRequestedState("module-disable")
        end,
    })

local function getMouseState(frame)
    local state = {
        enabled = nil,
        clickEnabled = nil,
        motionEnabled = nil,
    }

    if type(frame.IsMouseEnabled) == "function" then
        state.enabled =
            frame:IsMouseEnabled() == true
    end

    if type(frame.IsMouseClickEnabled) == "function" then
        state.clickEnabled =
            frame:IsMouseClickEnabled() == true
    end

    if type(frame.IsMouseMotionEnabled) == "function" then
        state.motionEnabled =
            frame:IsMouseMotionEnabled() == true
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
    if (
        state.enabled ~= nil
        and type(frame.EnableMouse) == "function"
    ) then
        frame:EnableMouse(state.enabled)
    end

    if (
        state.clickEnabled ~= nil
        and type(frame.SetMouseClickEnabled) == "function"
    ) then
        frame:SetMouseClickEnabled(
            state.clickEnabled
        )
    end

    if (
        state.motionEnabled ~= nil
        and type(frame.SetMouseMotionEnabled) == "function"
    ) then
        frame:SetMouseMotionEnabled(
            state.motionEnabled
        )
    end
end

function PlayerFrameReplacement:GetStockFrames()
    local playerFrame = _G.PlayerFrame

    if not playerFrame then
        return nil, "missing PlayerFrame"
    end

    local container =
        playerFrame.PlayerFrameContainer

    if not container then
        return nil, "missing PlayerFrame.PlayerFrameContainer"
    end

    local content =
        playerFrame.PlayerFrameContent

    if not content then
        return nil, "missing PlayerFrame.PlayerFrameContent"
    end

    local main =
        content.PlayerFrameContentMain

    if not main then
        return nil,
            "missing PlayerFrame.PlayerFrameContent.PlayerFrameContentMain"
    end

    return {
        playerFrame = playerFrame,
        container = container,
        contentMain = main,
        alternatePowerArea =
            content.AlternatePowerBarArea
            or _G.PlayerFrameAlternatePowerBarArea,
    }
end

function PlayerFrameReplacement:IsInteractionReady()
    local interaction = self.interaction

    return interaction ~= nil
        and interaction:GetAttribute("unit") == "player"
        and interaction:GetAttribute("*type1") == "target"
        and interaction:GetAttribute("*type2") == "togglemenu"
end

function PlayerFrameReplacement:CaptureStock()
    local frames, frameError =
        self:GetStockFrames()

    if not frames then
        return nil, frameError
    end

    if not self:IsInteractionReady() then
        return nil,
            "Logres secure player interaction is not configured"
    end

    return {
        playerFrame = frames.playerFrame,
        container = frames.container,
        contentMain = frames.contentMain,

        containerAlpha =
            frames.container:GetAlpha(),
        contentMainAlpha =
            frames.contentMain:GetAlpha(),

        mouse =
            getMouseState(frames.playerFrame),
    }
end

function PlayerFrameReplacement:EnableInteraction()
    self.interaction:Show()
    self.interaction:EnableMouse(true)
end

function PlayerFrameReplacement:DisableInteraction()
    self.interaction:EnableMouse(false)
    self.interaction:Hide()
end

function PlayerFrameReplacement:SuppressStock(snapshot)
    snapshot.container:SetAlpha(0)
    snapshot.contentMain:SetAlpha(0)
    suppressMouse(snapshot.playerFrame)
end

function PlayerFrameReplacement:RestoreStock(snapshot)
    snapshot.container:SetAlpha(
        snapshot.containerAlpha
    )
    snapshot.contentMain:SetAlpha(
        snapshot.contentMainAlpha
    )
    restoreMouse(
        snapshot.playerFrame,
        snapshot.mouse
    )
end

function PlayerFrameReplacement:EnableReplacement(reason)
    if self.appliedEnabled then
        self.pending = false
        self.lastError = nil
        self.lastReason =
            reason or "already-applied"
        return true
    end

    if InCombatLockdown() then
        self.pending = true
        self.lastReason =
            reason or "deferred-enable"
        return false
    end

    local snapshot, captureError =
        self:CaptureStock()

    if not snapshot then
        self.requestedEnabled = false
        self.pending = false
        self.lastError = captureError
        self.lastReason =
            reason or "capture-failed"
        return false
    end

    local interactionOK, interactionError =
        pcall(function()
            self:EnableInteraction()
        end)

    if not interactionOK then
        self.requestedEnabled = false
        self.pending = false
        self.lastError =
            "secure player interaction enable failed: "
            .. tostring(interactionError)
        self.lastReason =
            reason or "interaction-failed"
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
                "PlayerFrame selective suppression failed and "
                .. "stock state was restored: "
                .. tostring(suppressError)
        else
            self.lastError =
                "PlayerFrame selective suppression failed; "
                .. "restoration also failed: "
                .. tostring(suppressError)
                .. " | "
                .. tostring(restoreError)
        end

        self.lastReason =
            reason or "suppression-failed"
        return false
    end

    self.snapshot = snapshot
    self.appliedEnabled = true
    self.pending = false
    self.lastError = nil
    self.lastReason =
        reason or "enabled"

    return true
end

function PlayerFrameReplacement:DisableReplacement(reason)
    if not self.appliedEnabled then
        self.requestedEnabled = false
        self.pending = false
        self.lastError = nil
        self.lastReason =
            reason or "already-disabled"

        pcall(function()
            self:DisableInteraction()
        end)

        return true
    end

    if InCombatLockdown() then
        self.pending = true
        self.lastReason =
            reason or "deferred-disable"
        return false
    end

    local snapshot = self.snapshot

    if not snapshot then
        self.requestedEnabled = false
        self.appliedEnabled = false
        self.pending = false
        self.lastError =
            "PlayerFrame replacement active without restoration snapshot"
        self.lastReason =
            reason or "missing-snapshot"
        return false
    end

    local restored, restoreError =
        pcall(function()
            self:RestoreStock(snapshot)
        end)

    if not restored then
        self.lastError =
            "PlayerFrame stock restoration failed: "
            .. tostring(restoreError)
        self.lastReason =
            reason or "restore-failed"
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
            "PlayerFrame stock restored but Logres player "
            .. "interaction did not disable: "
            .. tostring(interactionError)
        self.lastReason =
            reason or "interaction-disable-failed"
        return false
    end

    self.lastError = nil
    self.lastReason =
        reason or "disabled"

    return true
end

function PlayerFrameReplacement:ApplyRequestedState(reason)
    if self.requestedEnabled then
        return self:EnableReplacement(reason)
    end

    return self:DisableReplacement(reason)
end

function PlayerFrameReplacement:RequestEnabled(
    enabled,
    reason
)
    self.requestedEnabled =
        enabled == true
    self.lastReason =
        reason or "request"

    if InCombatLockdown() then
        self.pending = true
        return false, "deferred"
    end

    local applied =
        self:ApplyRequestedState(reason)

    if applied then
        return true, "applied"
    end

    return false, "failed"
end

function PlayerFrameReplacement:HandleEvent(event)
    if (
        event == "PLAYER_REGEN_ENABLED"
        and self.pending
    ) then
        self:ApplyRequestedState(
            "PLAYER_REGEN_ENABLED"
        )
    end
end

function PlayerFrameReplacement:IsApplied()
    return self.appliedEnabled == true
end

function PlayerFrameReplacement:GetDebugStatus()
    local frames =
        self:GetStockFrames()

    local playerFrame =
        frames and frames.playerFrame or nil
    local container =
        frames and frames.container or nil
    local contentMain =
        frames and frames.contentMain or nil

    local mouse =
        playerFrame and getMouseState(playerFrame)
        or {
            enabled = nil,
            clickEnabled = nil,
            motionEnabled = nil,
        }

    local interaction =
        self.interaction

    return {
        moduleEnabled = self:IsEnabled(),

        requestedEnabled =
            self.requestedEnabled == true,
        appliedEnabled =
            self.appliedEnabled == true,
        pending =
            self.pending == true,
        snapshotReady =
            self.snapshot ~= nil,

        lastReason =
            self.lastReason,
        lastError =
            self.lastError,

        playerFrameFound =
            playerFrame ~= nil,
        containerFound =
            container ~= nil,
        contentMainFound =
            contentMain ~= nil,

        containerAlpha =
            container and container:GetAlpha() or nil,
        contentMainAlpha =
            contentMain and contentMain:GetAlpha() or nil,

        playerFrameMouseEnabled =
            mouse.enabled,
        playerFrameMouseClickEnabled =
            mouse.clickEnabled,
        playerFrameMouseMotionEnabled =
            mouse.motionEnabled,

        interactionReady =
            self:IsInteractionReady(),
        interactionShown =
            interaction
            and interaction:IsShown()
            or false,
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

        alternatePowerAreaFound =
            frames
            and frames.alternatePowerArea ~= nil
            or false,

        wholePlayerFrameSuppressedByLogres = false,
        directPlayerChildrenSuppressedByLogres = false,
        targetFrameSuppressedByLogres = false,
        partyFramesSuppressedByLogres = false,
    }
end
