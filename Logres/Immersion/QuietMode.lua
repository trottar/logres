local _, Logres = ...

local AUXILIARY_CONTROL_NAMES = {
    "ChatFrameChannelButton",
    "TextToSpeechButton",
    "QuickJoinToastButton",
}

local QuietMode =
    Logres:RegisterModule("QuietMode", {
        OnInitialize = function(self)
            self.requestedEnabled = false
            self.appliedEnabled = false
            self.lastError = nil
            self.lastReason = "not-yet-requested"
            self.reconcileScheduled = false

            self.regionSnapshots = {}
            self.editBoxSnapshots = {}
            self.chatShownSnapshots = {}

            local eventFrame = CreateFrame("Frame")
            eventFrame:SetScript("OnEvent", function(_, event)
                self:ScheduleReconcile("event:" .. tostring(event))
            end)
            self.eventFrame = eventFrame

            if (
                type(hooksecurefunc) == "function"
                and type(FCF_CheckShowChatFrame) == "function"
            ) then
                hooksecurefunc(
                    "FCF_CheckShowChatFrame",
                    function()
                        self:ScheduleReconcile(
                            "hook:FCF_CheckShowChatFrame"
                        )
                    end
                )
            end
        end,

        OnEnable = function(self)
            self.eventFrame:RegisterEvent("UPDATE_CHAT_WINDOWS")
            self.eventFrame:RegisterEvent(
                "UPDATE_FLOATING_CHAT_WINDOWS"
            )

            self:OwnCleanup(function()
                self.eventFrame:UnregisterAllEvents()
            end)
        end,

        OnDisable = function(self)
            local restored, result =
                self:RequestEnabled(false)

            if not restored then
                Logres:DevPrint(
                    "QuietMode fail-open restore failed: "
                    .. tostring(self.lastError or result)
                )
            end
        end,
    })

local function countTableEntries(values)
    local count = 0

    for _ in pairs(values) do
        count = count + 1
    end

    return count
end

local function getMouseEnabled(region)
    if (
        region
        and type(region.IsMouseEnabled) == "function"
    ) then
        return region:IsMouseEnabled() == true
    end

    return nil
end

local function setMouseEnabled(region, enabled)
    if (
        region
        and type(region.EnableMouse) == "function"
        and enabled ~= nil
    ) then
        region:EnableMouse(enabled)
    end
end

function QuietMode:CaptureRegion(region, kind, label)
    if not region or self.regionSnapshots[region] then
        return
    end

    self.regionSnapshots[region] = {
        alpha = region:GetAlpha(),
        mouseEnabled = getMouseEnabled(region),
        kind = kind,
        label = label,
    }
end

function QuietMode:SuppressRegion(region, kind, label)
    if not region then
        return
    end

    self:CaptureRegion(region, kind, label)

    region:SetAlpha(0)
    setMouseEnabled(region, false)
end

function QuietMode:CaptureEditBox(editBox)
    if not editBox or self.editBoxSnapshots[editBox] then
        return
    end

    if (
        type(editBox.IsIgnoringParentAlpha) ~= "function"
        or type(editBox.SetIgnoreParentAlpha) ~= "function"
    ) then
        error(
            "chat edit box does not support parent-alpha override"
        )
    end

    self.editBoxSnapshots[editBox] = {
        ignoreParentAlpha =
            editBox:IsIgnoringParentAlpha() == true,
    }
end

function QuietMode:PrepareEditBox(editBox)
    if not editBox then
        return
    end

    self:CaptureEditBox(editBox)
    editBox:SetIgnoreParentAlpha(true)
end

function QuietMode:CapturePersistentShown(frame)
    if (
        not frame
        or self.chatShownSnapshots[frame] ~= nil
        or type(FCF_GetChatWindowInfo) ~= "function"
    ) then
        return
    end

    local id = frame:GetID()

    if not id then
        return
    end

    local shown =
        select(7, FCF_GetChatWindowInfo(id))

    if shown ~= nil then
        self.chatShownSnapshots[frame] =
            shown == true
    end
end

function QuietMode:SuppressChatFrame(frame)
    if not frame then
        return
    end

    local frameName =
        frame:GetName() or "unnamed-chat-frame"

    self:CapturePersistentShown(frame)

    self:SuppressRegion(
        frame,
        "chatFrame",
        frameName
    )

    local tab =
        _G[frameName .. "Tab"]

    if tab then
        self:SuppressRegion(
            tab,
            "tab",
            frameName .. "Tab"
        )
    end

    local minimized =
        frame.minFrame
        or _G[frameName .. "Minimized"]

    if minimized then
        self:SuppressRegion(
            minimized,
            "minimized",
            frameName .. "Minimized"
        )
    end

    local editBox =
        frame.editBox
        or _G[frameName .. "EditBox"]

    if editBox then
        self:PrepareEditBox(editBox)
    end
end

function QuietMode:SuppressAuxiliaryControls()
    local dock = _G.GENERAL_CHAT_DOCK

    if dock and dock.overflowButton then
        self:SuppressRegion(
            dock.overflowButton,
            "auxiliary",
            "GeneralChatDockOverflow"
        )
    end

    for index = 1, #AUXILIARY_CONTROL_NAMES do
        local name =
            AUXILIARY_CONTROL_NAMES[index]
        local control = _G[name]

        if control then
            self:SuppressRegion(
                control,
                "auxiliary",
                name
            )
        end
    end
end

function QuietMode:SuppressAll()
    local seen = {}
    local chatFrames = _G.CHAT_FRAMES

    if type(chatFrames) == "table" then
        for _, frameName in pairs(chatFrames) do
            local frame = _G[frameName]

            if frame and not seen[frame] then
                seen[frame] = true
                self:SuppressChatFrame(frame)
            end
        end
    end

    local defaultFrame = _G.DEFAULT_CHAT_FRAME

    if defaultFrame and not seen[defaultFrame] then
        self:SuppressChatFrame(defaultFrame)
    end

    self:SuppressAuxiliaryControls()
end

function QuietMode:RestoreAll()
    local errors = {}

    for region, snapshot in pairs(self.regionSnapshots) do
        local ok, restoreError = pcall(function()
            region:SetAlpha(snapshot.alpha)
            setMouseEnabled(
                region,
                snapshot.mouseEnabled
            )
        end)

        if not ok then
            errors[#errors + 1] =
                tostring(snapshot.label)
                .. ": "
                .. tostring(restoreError)
        end
    end

    for editBox, snapshot in pairs(self.editBoxSnapshots) do
        local ok, restoreError = pcall(function()
            editBox:SetIgnoreParentAlpha(
                snapshot.ignoreParentAlpha
            )
        end)

        if not ok then
            errors[#errors + 1] =
                "editBox: " .. tostring(restoreError)
        end
    end

    if #errors > 0 then
        self.lastError =
            "restore failure: "
            .. table.concat(errors, " | ")
        return false
    end

    self.regionSnapshots = {}
    self.editBoxSnapshots = {}
    self.chatShownSnapshots = {}

    return true
end

function QuietMode:FailOpen(reason)
    local originalError = tostring(reason)
    local restored = self:RestoreAll()

    self.requestedEnabled = false
    self.appliedEnabled = not restored

    if restored then
        self.lastError =
            "suppression failed and was restored: "
            .. originalError
    else
        self.lastError =
            "suppression failed; restoration also failed: "
            .. originalError
            .. " | "
            .. tostring(self.lastError)
    end
end

function QuietMode:ApplyEnabled(reason)
    if self.appliedEnabled then
        local ok, suppressError =
            pcall(function()
                self:SuppressAll()
            end)

        if not ok then
            self:FailOpen(suppressError)
            return false
        end

        self.lastReason =
            reason or "reassert"
        self.lastError = nil
        return true
    end

    self.regionSnapshots = {}
    self.editBoxSnapshots = {}
    self.chatShownSnapshots = {}

    local ok, suppressError =
        pcall(function()
            self:SuppressAll()
        end)

    if not ok then
        self:FailOpen(suppressError)
        return false
    end

    self.appliedEnabled = true
    self.lastReason =
        reason or "enable"
    self.lastError = nil
    return true
end

function QuietMode:ApplyDisabled(reason)
    if (
        not self.appliedEnabled
        and next(self.regionSnapshots) == nil
        and next(self.editBoxSnapshots) == nil
    ) then
        self.requestedEnabled = false
        self.lastReason =
            reason or "already-disabled"
        self.lastError = nil
        return true
    end

    local restored = self:RestoreAll()

    if not restored then
        self.lastReason =
            reason or "disable-failed"
        return false
    end

    self.appliedEnabled = false
    self.requestedEnabled = false
    self.lastReason =
        reason or "disable"
    self.lastError = nil
    return true
end

function QuietMode:RequestEnabled(enabled, reason)
    self.requestedEnabled =
        enabled == true

    if self.requestedEnabled then
        local applied =
            self:ApplyEnabled(reason)

        if applied then
            return true, "applied"
        end

        return false, "failed"
    end

    local restored =
        self:ApplyDisabled(reason)

    if restored then
        return true, "restored"
    end

    return false, "failed"
end

function QuietMode:ScheduleReconcile(reason)
    if (
        not self:IsEnabled()
        or not self.requestedEnabled
        or self.reconcileScheduled
    ) then
        return
    end

    self.reconcileScheduled = true

    C_Timer.After(0, function()
        self.reconcileScheduled = false

        if (
            not self:IsEnabled()
            or not self.requestedEnabled
        ) then
            return
        end

        local applied =
            self:ApplyEnabled(reason)

        if not applied then
            Logres:DevPrint(
                "QuietMode reconciliation failed open: "
                .. tostring(self.lastError)
            )
        end
    end)
end

local function currentChatFrames()
    local frames = {}
    local seen = {}
    local chatFrames = _G.CHAT_FRAMES

    if type(chatFrames) == "table" then
        for _, frameName in pairs(chatFrames) do
            local frame = _G[frameName]

            if frame and not seen[frame] then
                seen[frame] = true
                frames[#frames + 1] = frame
            end
        end
    end

    local defaultFrame = _G.DEFAULT_CHAT_FRAME

    if defaultFrame and not seen[defaultFrame] then
        frames[#frames + 1] = defaultFrame
    end

    return frames
end

function QuietMode:GetDebugStatus()
    local frames = currentChatFrames()

    local chatFrameCount = #frames
    local suppressedChatFrameCount = 0
    local tabCount = 0
    local suppressedTabCount = 0
    local editBoxCount = 0
    local editBoxIgnoreCount = 0

    for index = 1, #frames do
        local frame = frames[index]
        local frameName =
            frame:GetName() or ""

        if (
            frame:GetAlpha() == 0
            and getMouseEnabled(frame) == false
        ) then
            suppressedChatFrameCount =
                suppressedChatFrameCount + 1
        end

        local tab = _G[frameName .. "Tab"]

        if tab then
            tabCount = tabCount + 1

            if (
                tab:GetAlpha() == 0
                and getMouseEnabled(tab) == false
            ) then
                suppressedTabCount =
                    suppressedTabCount + 1
            end
        end

        local editBox =
            frame.editBox
            or _G[frameName .. "EditBox"]

        if editBox then
            editBoxCount = editBoxCount + 1

            if (
                type(editBox.IsIgnoringParentAlpha)
                    == "function"
                and editBox:IsIgnoringParentAlpha()
            ) then
                editBoxIgnoreCount =
                    editBoxIgnoreCount + 1
            end
        end
    end

    local persistentShownMatches = true

    if type(FCF_GetChatWindowInfo) == "function" then
        for frame, savedShown in pairs(
            self.chatShownSnapshots
        ) do
            local id = frame:GetID()

            if id then
                local currentShown =
                    select(
                        7,
                        FCF_GetChatWindowInfo(id)
                    ) == true

                if currentShown ~= savedShown then
                    persistentShownMatches = false
                    break
                end
            end
        end
    end

    local auxiliarySnapshotCount = 0

    for _, snapshot in pairs(self.regionSnapshots) do
        if snapshot.kind == "auxiliary" then
            auxiliarySnapshotCount =
                auxiliarySnapshotCount + 1
        end
    end

    return {
        moduleEnabled = self:IsEnabled(),
        requestedEnabled =
            self.requestedEnabled == true,
        appliedEnabled =
            self.appliedEnabled == true,

        chatFrameCount = chatFrameCount,
        suppressedChatFrameCount =
            suppressedChatFrameCount,
        tabCount = tabCount,
        suppressedTabCount =
            suppressedTabCount,
        editBoxCount = editBoxCount,
        editBoxIgnoreCount =
            editBoxIgnoreCount,

        regionSnapshotCount =
            countTableEntries(
                self.regionSnapshots
            ),
        editBoxSnapshotCount =
            countTableEntries(
                self.editBoxSnapshots
            ),
        auxiliarySnapshotCount =
            auxiliarySnapshotCount,

        persistentShownSnapshotCount =
            countTableEntries(
                self.chatShownSnapshots
            ),
        persistentShownMatches =
            persistentShownMatches,

        savedConfigurationMutation = false,

        lastReason = self.lastReason,
        lastError = self.lastError,
    }
end
