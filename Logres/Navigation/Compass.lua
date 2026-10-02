local _, Logres = ...

local UPDATE_INTERVAL = 0.05
local COMPASS_WIDTH = 400
local COMPASS_HEIGHT = 42
local TAPE_WIDTH = 360
local VISIBLE_HALF_ANGLE = 100
local PIXELS_PER_DEGREE = TAPE_WIDTH / (VISIBLE_HALF_ANGLE * 2)

local DIRECTIONS = {
    { label = "N", degrees = 0, cardinal = true },
    { label = "NE", degrees = 45, cardinal = false },
    { label = "E", degrees = 90, cardinal = true },
    { label = "SE", degrees = 135, cardinal = false },
    { label = "S", degrees = 180, cardinal = true },
    { label = "SW", degrees = 225, cardinal = false },
    { label = "W", degrees = 270, cardinal = true },
    { label = "NW", degrees = 315, cardinal = false },
}

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function normalizeRelativeDegrees(value)
    return ((value + 180) % 360) - 180
end

local function headingFromFacing(facing)
    return (360 - math.deg(facing)) % 360
end

local Compass = Logres:RegisterModule("Compass", {
    OnInitialize = function(self)
        self.moduleEnabled = false
        self.policyEligible = false
        self.immersionEnabled = false
        self.context = "unknown"

        self.facingAPIAvailable = type(GetPlayerFacing) == "function"
        self.facingAvailable = false
        self.presentationActive = false
        self.headingDegrees = nil

        self.updateActive = false
        self.elapsed = 0
        self.lastReason = "initialize"
        self.lastError = nil

        local frame = CreateFrame("Frame", "LogresCompassFrame", UIParent)
        frame:SetSize(COMPASS_WIDTH, COMPASS_HEIGHT)
        frame:SetPoint("TOP", UIParent, "TOP", 0, -48)
        frame:SetFrameStrata("MEDIUM")
        frame:EnableMouse(false)
        frame:Hide()

        local baseline = frame:CreateTexture(nil, "BACKGROUND")
        baseline:SetSize(TAPE_WIDTH, 1)
        baseline:SetPoint("CENTER", frame, "CENTER", 0, -2)
        baseline:SetColorTexture(0.58, 0.46, 0.27, 0.38)

        local center = frame:CreateTexture(nil, "ARTWORK")
        center:SetSize(2, 22)
        center:SetPoint("CENTER", frame, "CENTER", 0, -1)
        center:SetColorTexture(0.93, 0.76, 0.39, 0.92)

        local centerCap = frame:CreateTexture(nil, "ARTWORK")
        centerCap:SetSize(8, 2)
        centerCap:SetPoint("TOP", center, "TOP", 0, 0)
        centerCap:SetColorTexture(0.93, 0.76, 0.39, 0.92)

        self.frame = frame
        self.directionWidgets = {}

        for index = 1, #DIRECTIONS do
            local definition = DIRECTIONS[index]

            local tick = frame:CreateTexture(nil, "ARTWORK")
            tick:SetSize(1, definition.cardinal and 12 or 8)
            tick:SetColorTexture(
                0.76,
                0.66,
                0.48,
                definition.cardinal and 0.72 or 0.45
            )

            local label = frame:CreateFontString(
                nil,
                "OVERLAY",
                definition.cardinal
                    and "GameFontNormal"
                    or "GameFontHighlightSmall"
            )
            label:SetText(definition.label)

            if definition.cardinal then
                label:SetTextColor(0.94, 0.84, 0.62, 0.96)
            else
                label:SetTextColor(0.72, 0.68, 0.60, 0.82)
            end

            self.directionWidgets[index] = {
                definition = definition,
                tick = tick,
                label = label,
            }
        end

        self.onUpdateHandler = function(_, elapsed)
            self:OnUpdate(elapsed)
        end
    end,

    OnEnable = function(self)
        self.moduleEnabled = true

        self:SubscribeState(function()
            self:ReconcilePolicy("state")
        end)

        self:SubscribePreferences(function()
            self:ReconcilePolicy("preference")
        end)

        self:ReconcilePolicy("enable")
    end,

    OnDisable = function(self)
        self.moduleEnabled = false
        self.policyEligible = false
        self:SetUpdateActive(false)
        self:ClearPresentation("module-disabled")
    end,
})

function Compass:SetUpdateActive(enabled)
    enabled = enabled and true or false

    if self.updateActive == enabled then
        return
    end

    self.updateActive = enabled
    self.elapsed = 0

    if enabled then
        self.frame:SetScript("OnUpdate", self.onUpdateHandler)
    else
        self.frame:SetScript("OnUpdate", nil)
    end
end

function Compass:ClearPresentation(reason, errorText)
    self.facingAvailable = false
    self.presentationActive = false
    self.headingDegrees = nil
    self.lastReason = reason or "unavailable"
    self.lastError = errorText
    self.frame:Hide()
end

function Compass:UpdateTape(headingDegrees)
    for index = 1, #self.directionWidgets do
        local widget = self.directionWidgets[index]
        local offset = normalizeRelativeDegrees(
            widget.definition.degrees - headingDegrees
        )
        local magnitude = math.abs(offset)

        if magnitude <= VISIBLE_HALF_ANGLE then
            local x = offset * PIXELS_PER_DEGREE
            local fade = 1

            if magnitude > 78 then
                fade = math.max(
                    0,
                    (VISIBLE_HALF_ANGLE - magnitude)
                        / (VISIBLE_HALF_ANGLE - 78)
                )
            end

            widget.tick:ClearAllPoints()
            widget.tick:SetPoint("CENTER", self.frame, "CENTER", x, -2)
            widget.tick:SetAlpha(fade)
            widget.tick:Show()

            widget.label:ClearAllPoints()
            widget.label:SetPoint("BOTTOM", widget.tick, "TOP", 0, 4)
            widget.label:SetAlpha(fade)
            widget.label:Show()
        else
            widget.tick:Hide()
            widget.label:Hide()
        end
    end
end

function Compass:RefreshHeading(reason)
    if not self.policyEligible then
        self:ClearPresentation(reason or "policy-ineligible")
        return false
    end

    self.facingAPIAvailable = type(GetPlayerFacing) == "function"

    if not self.facingAPIAvailable then
        self:ClearPresentation(
            "facing-api-unavailable",
            "GetPlayerFacing unavailable"
        )
        return false
    end

    local ok, facing = pcall(GetPlayerFacing)

    if not ok then
        self:ClearPresentation(
            "facing-call-failed",
            "GetPlayerFacing call failed"
        )
        return false
    end

    if isSecret(facing) then
        self:ClearPresentation("facing-secret")
        return false
    end

    if facing == nil then
        self:ClearPresentation("facing-unavailable")
        return false
    end

    if type(facing) ~= "number" then
        self:ClearPresentation("facing-invalid")
        return false
    end

    local headingDegrees = headingFromFacing(facing)

    self:UpdateTape(headingDegrees)

    self.facingAvailable = true
    self.presentationActive = true
    self.headingDegrees = headingDegrees
    self.lastReason = reason or "heading-refresh"
    self.lastError = nil

    self.frame:Show()
    return true
end

function Compass:ReconcilePolicy(reason)
    local preferences = Logres:GetPreferences()
    local state = Logres:GetState()

    self.immersionEnabled = preferences.immersionEnabled == true
    self.context = state.context

    self.policyEligible =
        self.moduleEnabled == true
        and self.immersionEnabled == true
        and self.context == "world"

    if not self.policyEligible then
        self:SetUpdateActive(false)

        if not self.moduleEnabled then
            self:ClearPresentation("module-disabled")
        elseif not self.immersionEnabled then
            self:ClearPresentation("immersion-off")
        else
            self:ClearPresentation("context-" .. tostring(self.context))
        end

        return
    end

    -- World context is the only context in which E.2 samples facing.
    -- If a world sample is temporarily unavailable, keep the throttled
    -- sampler alive so capability can recover without inventing a heading.
    self:SetUpdateActive(true)
    self:RefreshHeading(reason or "policy")
end

function Compass:OnUpdate(elapsed)
    if not self.policyEligible then
        return
    end

    self.elapsed = self.elapsed + elapsed

    if self.elapsed < UPDATE_INTERVAL then
        return
    end

    self.elapsed = self.elapsed % UPDATE_INTERVAL
    self:RefreshHeading("onupdate")
end

function Compass:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled == true,
        rootReady = self.frame ~= nil,
        rootShown = self.frame ~= nil and self.frame:IsShown() or false,
        directionCount = #self.directionWidgets,

        immersionEnabled = self.immersionEnabled == true,
        context = self.context,
        policyEligible = self.policyEligible == true,

        facingAPIAvailable = self.facingAPIAvailable == true,
        facingAvailable = self.facingAvailable == true,
        updateActive = self.updateActive == true,

        presentationActive = self.presentationActive == true,
        headingDegrees = self.headingDegrees,

        lastReason = self.lastReason,
        lastError = self.lastError,
    }
end
