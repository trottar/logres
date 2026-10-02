local _, Logres = ...

local PULSE_SECONDS = 2.0

local XP = Logres:RegisterModule("QuestXP", {
    autoEnable = true,
})

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

function XP:HidePulse(reason)
    self.pulseGeneration = self.pulseGeneration + 1
    self.pulseShown = false

    if self.root then
        self.root:Hide()
    end

    if reason then
        self.lastPresentationReason = reason
    end
end

function XP:ClearBaseline(reason, errorText, secretObserved)
    self.baselineXP = nil
    self.baselineMaxXP = nil
    self.lastSampleReason = reason
    self.lastError = errorText
    self.lastSampleSecret = secretObserved and true or false
    self:HidePulse(reason)
end

function XP:ReadSample(reason)
    self.xpAPIAvailable =
        type(UnitXP) == "function"
        and type(UnitXPMax) == "function"

    if not self.xpAPIAvailable then
        self:ClearBaseline(
            "xp-api-unavailable",
            "UnitXP/UnitXPMax unavailable",
            false
        )
        return nil, nil
    end

    local currentOK, currentXP = pcall(UnitXP, "player")
    local maxOK, maxXP = pcall(UnitXPMax, "player")

    if not currentOK or not maxOK then
        self:ClearBaseline(
            "xp-call-failed",
            "UnitXP/UnitXPMax call failed",
            false
        )
        return nil, nil
    end

    if isSecret(currentXP) or isSecret(maxXP) then
        self:ClearBaseline("xp-secret", nil, true)
        return nil, nil
    end

    if type(currentXP) ~= "number"
        or type(maxXP) ~= "number"
    then
        self:ClearBaseline(
            "xp-invalid",
            "UnitXP/UnitXPMax returned non-number",
            false
        )
        return nil, nil
    end

    if currentXP < 0 then
        self:ClearBaseline(
            "xp-invalid-current",
            "UnitXP returned negative value",
            false
        )
        return nil, nil
    end

    if maxXP <= 0 then
        self:ClearBaseline("level-cap-or-no-xp", nil, false)
        return nil, nil
    end

    self.lastSampleReason = reason or "sample"
    self.lastError = nil
    self.lastSampleSecret = false

    return currentXP, maxXP
end

function XP:SetBaseline(currentXP, maxXP, reason)
    self.baselineXP = currentXP
    self.baselineMaxXP = maxXP
    self.lastCurrentXP = currentXP
    self.lastMaxXP = maxXP
    self.lastSampleReason = reason or "baseline"
    self.lastError = nil
end

function XP:RefreshBaseline(reason)
    local currentXP, maxXP =
        self:ReadSample(reason or "baseline-refresh")

    if currentXP == nil or maxXP == nil then
        return false
    end

    self:SetBaseline(
        currentXP,
        maxXP,
        reason or "baseline-refresh"
    )
    return true
end

function XP:PresentText(text, reason)
    if not self.moduleEnabled then
        self:HidePulse("module-disabled")
        return false, "module-disabled"
    end

    if not self.immersionEnabled then
        self:HidePulse("immersion-off")
        return true, "suppressed-immersion-off"
    end

    if not self.timerAvailable then
        self:HidePulse("timer-unavailable")
        return false, "timer-unavailable"
    end

    self.pulseGeneration = self.pulseGeneration + 1
    local generation = self.pulseGeneration

    self.text:SetText(text)
    self.root:Show()
    self.pulseShown = true
    self.lastPresentationReason = reason or "pulse"

    C_Timer.After(PULSE_SECONDS, function()
        if not self.moduleEnabled then
            return
        end

        if self.pulseGeneration ~= generation then
            return
        end

        self.pulseShown = false
        self.root:Hide()
    end)

    return true, "shown"
end

function XP:PresentXP(delta, currentXP, maxXP, reason)
    local progressPercent =
        (currentXP / maxXP) * 100

    self.lastDelta = delta
    self.lastProgressPercent = progressPercent

    local text = string.format(
        "+%d XP  ·  %.0f%%",
        delta,
        progressPercent
    )

    if not self.immersionEnabled then
        self.suppressedCount = self.suppressedCount + 1
        self:HidePulse("xp-event-immersion-off")
        return true, "suppressed-immersion-off"
    end

    self.pulseCount = self.pulseCount + 1
    return self:PresentText(text, reason or "xp-event")
end

function XP:HandleXPUpdate(reason)
    self.xpEventCount = self.xpEventCount + 1

    local currentXP, maxXP =
        self:ReadSample(reason or "PLAYER_XP_UPDATE")

    if currentXP == nil or maxXP == nil then
        return
    end

    if self.baselineXP == nil
        or self.baselineMaxXP == nil
    then
        self:SetBaseline(
            currentXP,
            maxXP,
            "xp-event-baseline"
        )
        return
    end

    if maxXP ~= self.baselineMaxXP then
        self:SetBaseline(
            currentXP,
            maxXP,
            "xp-range-changed-rebaseline"
        )
        return
    end

    local delta = currentXP - self.baselineXP

    self:SetBaseline(
        currentXP,
        maxXP,
        reason or "PLAYER_XP_UPDATE"
    )

    if delta <= 0 then
        self.lastDelta = delta
        self.lastProgressPercent =
            (currentXP / maxXP) * 100
        self.lastPresentationReason =
            "xp-nonpositive-rebaseline"
        return
    end

    self:PresentXP(
        delta,
        currentXP,
        maxXP,
        reason or "PLAYER_XP_UPDATE"
    )
end

function XP:ApplyPreferences(preferences)
    self.immersionEnabled =
        preferences.immersionEnabled == true

    if not self.immersionEnabled then
        self:HidePulse("immersion-off")
    end
end

function XP:ShowPreview()
    if not self.moduleEnabled then
        return false, "module-disabled"
    end

    if not self.immersionEnabled then
        self:HidePulse("immersion-off")
        return true, "suppressed-immersion-off"
    end

    self.previewCount = self.previewCount + 1

    return self:PresentText(
        "+123 XP  ·  72%",
        "preview"
    )
end

function XP:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled == true,
        rootReady = self.root ~= nil,
        rootShown =
            self.root ~= nil
            and self.root:IsShown()
            or false,
        textReady = self.text ~= nil,
        eventFrameReady = self.eventFrame ~= nil,
        timerAvailable = self.timerAvailable == true,
        xpAPIAvailable = self.xpAPIAvailable == true,
        immersionEnabled = self.immersionEnabled == true,

        playerXPEventRegistered =
            self.eventRegistration.PLAYER_XP_UPDATE == true,
        levelEventRegistered =
            self.eventRegistration.PLAYER_LEVEL_UP == true,
        worldEventRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD == true,

        baselineAvailable =
            type(self.baselineXP) == "number"
            and type(self.baselineMaxXP) == "number",
        lastCurrentXP = self.lastCurrentXP,
        lastMaxXP = self.lastMaxXP,
        lastDelta = self.lastDelta,
        lastProgressPercent = self.lastProgressPercent,

        xpEventCount = self.xpEventCount,
        levelEventCount = self.levelEventCount,
        worldEventCount = self.worldEventCount,
        pulseCount = self.pulseCount,
        suppressedCount = self.suppressedCount,
        previewCount = self.previewCount,
        pulseShown = self.pulseShown == true,

        lastSampleSecret = self.lastSampleSecret == true,
        lastSampleReason = self.lastSampleReason,
        lastPresentationReason = self.lastPresentationReason,
        lastError = self.lastError,
    }
end

function XP:OnInitialize()
    self.moduleEnabled = false
    self.immersionEnabled = false

    self.xpAPIAvailable =
        type(UnitXP) == "function"
        and type(UnitXPMax) == "function"
    self.timerAvailable =
        C_Timer ~= nil
        and type(C_Timer.After) == "function"

    self.baselineXP = nil
    self.baselineMaxXP = nil
    self.lastCurrentXP = nil
    self.lastMaxXP = nil
    self.lastDelta = nil
    self.lastProgressPercent = nil

    self.xpEventCount = 0
    self.levelEventCount = 0
    self.worldEventCount = 0
    self.pulseCount = 0
    self.suppressedCount = 0
    self.previewCount = 0
    self.pulseGeneration = 0
    self.pulseShown = false

    self.lastSampleSecret = false
    self.lastSampleReason = "initialize"
    self.lastPresentationReason = "initialize"
    self.lastError = nil

    local root = CreateFrame(
        "Frame",
        "LogresQuestXPPulse",
        UIParent
    )
    root:SetSize(280, 32)
    root:SetPoint(
        "CENTER",
        UIParent,
        "CENTER",
        0,
        -154
    )
    root:SetFrameStrata("HIGH")
    root:EnableMouse(false)
    root:Hide()

    local text = root:CreateFontString(
        "LogresQuestXPPulseText",
        "OVERLAY",
        "GameFontNormalLarge"
    )
    text:SetAllPoints(root)
    text:SetJustifyH("CENTER")
    text:SetTextColor(0.88, 0.76, 0.46, 0.96)
    text:SetShadowColor(0, 0, 0, 0.85)
    text:SetShadowOffset(1, -1)
    text:ClearText()

    self.root = root
    self.text = text

    local eventFrame = CreateFrame("Frame")
    local events = {
        "PLAYER_XP_UPDATE",
        "PLAYER_LEVEL_UP",
        "PLAYER_ENTERING_WORLD",
    }

    self.eventRegistration = {}

    for index = 1, #events do
        local event = events[index]
        local ok = pcall(
            eventFrame.RegisterEvent,
            eventFrame,
            event
        )
        self.eventRegistration[event] = ok and true or false
    end

    eventFrame:SetScript("OnEvent", function(_, event, unit)
        if not self.moduleEnabled then
            return
        end

        if event == "PLAYER_XP_UPDATE" then
            if unit and unit ~= "player" then
                return
            end

            self:HandleXPUpdate(event)
            return
        end

        if event == "PLAYER_LEVEL_UP" then
            self.levelEventCount =
                self.levelEventCount + 1
            self:RefreshBaseline(event)
            return
        end

        if event == "PLAYER_ENTERING_WORLD" then
            self.worldEventCount =
                self.worldEventCount + 1
            self:RefreshBaseline(event)
        end
    end)

    self.eventFrame = eventFrame
end

function XP:OnEnable()
    self.moduleEnabled = true

    self:SubscribePreferences(function(preferences)
        self:ApplyPreferences(preferences)
    end)

    self:ApplyPreferences(Logres:GetPreferences())
    self:RefreshBaseline("enable")
end

function XP:OnDisable()
    self.moduleEnabled = false
    self:HidePulse("module-disabled")
    self.baselineXP = nil
    self.baselineMaxXP = nil
end
