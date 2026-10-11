local _, Logres = ...

local Layout = {}
Logres.Layout = Layout

local ANCHOR_SPECS = {
    navigation = {
        name = "LogresLayoutNavigation",
        point = "TOP",
        relativePoint = "TOP",
        x = 0,
        y = -48,
    },
    activeQuest = {
        name = "LogresLayoutActiveQuest",
        point = "TOPRIGHT",
        relativePoint = "TOPRIGHT",
        x = -360,
        y = -150,
    },
    questDialogue = {
        name = "LogresLayoutQuestDialogue",
        point = "TOP",
        relativePoint = "TOP",
        x = 0,
        y = -110,
    },
    contextObjective = {
        name = "LogresLayoutContextObjective",
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = -5,
    },
    contextXP = {
        name = "LogresLayoutContextXP",
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = -154,
    },
    playerReaction = {
        name = "LogresLayoutPlayerReaction",
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = -118,
    },
    targetFallback = {
        name = "LogresLayoutTargetFallback",
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = -54,
    },
    primaryActions = {
        name = "LogresLayoutPrimaryActions",
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = -350,
    },
    secondaryActions = {
        name = "LogresLayoutSecondaryActions",
        point = "CENTER",
        relativePoint = "CENTER",
        x = -190,
        y = -350,
    },
    bar4Actions = {
        name = "LogresLayoutBar4Actions",
        point = "CENTER",
        relativePoint = "CENTER",
        x = -460,
        y = -350,
    },
    bar5Actions = {
        name = "LogresLayoutBar5Actions",
        point = "CENTER",
        relativePoint = "CENTER",
        x = 460,
        y = -350,
    },
    utilityActions = {
        name = "LogresLayoutUtilityActions",
        point = "CENTER",
        relativePoint = "CENTER",
        x = 190,
        y = -350,
    },
    allies = {
        name = "LogresLayoutAllies",
        point = "CENTER",
        relativePoint = "CENTER",
        x = -330,
        y = -44,
    },
    classPet = {
        name = "LogresLayoutClassPet",
        point = "CENTER",
        relativePoint = "CENTER",
        x = -460,
        y = -190,
    },
    passiveStatus = {
        name = "LogresLayoutPassiveStatus",
        point = "CENTER",
        relativePoint = "CENTER",
        x = 118,
        y = -118,
    },
    nativeAccess = {
        name = "LogresLayoutNativeAccess",
        point = "TOPRIGHT",
        relativePoint = "TOPRIGHT",
        x = -22,
        y = -74,
    },
}

local anchors = {}
local bindCount = 0
local bindFailureCount = 0
local lastBindError = nil

for key, spec in pairs(ANCHOR_SPECS) do
    local anchor = CreateFrame("Frame", spec.name, UIParent)
    anchor:SetSize(1, 1)
    anchor:SetPoint(
        spec.point,
        UIParent,
        spec.relativePoint,
        spec.x,
        spec.y
    )
    anchor:EnableMouse(false)
    anchors[key] = anchor
end

function Layout.GetAnchor(key)
    return anchors[key]
end

function Layout.Bind(
    frame,
    key,
    point,
    relativePoint,
    x,
    y
)
    local anchor = anchors[key]
    if frame == nil then
        bindFailureCount = bindFailureCount + 1
        lastBindError = "frame-missing:" .. tostring(key)
        return false, lastBindError
    end
    if anchor == nil then
        bindFailureCount = bindFailureCount + 1
        lastBindError = "anchor-missing:" .. tostring(key)
        return false, lastBindError
    end

    local ok, bindError = pcall(
        function()
            frame:ClearAllPoints()
            frame:SetPoint(
                point or "CENTER",
                anchor,
                relativePoint or "CENTER",
                x or 0,
                y or 0
            )
        end
    )
    if not ok then
        bindFailureCount = bindFailureCount + 1
        lastBindError = tostring(bindError)
        return false, lastBindError
    end

    frame.logresLayoutAnchor = key
    bindCount = bindCount + 1
    lastBindError = nil
    return true, "bound"
end

-- P0192: read-only Phase H.2 v4 geometry audit. Design envelopes are NOT
-- native frame bounds and are NOT automatically applied to anchors.
-- Only addon-owned frame references are inspected; no Blizzard presentation
-- visibility or protected action state is read or mutated.
local H2_SCREEN_MAP_V4 = {
    { "compass", "LogresCompassFrame", 31.4, 4.8, 37.4, 6.9 },
    { "quest", "LogresActiveQuest", 80, 5, 19.6, 19.2 },
    { "enemy-debuff", "LogresStatusAurastarget", 65.2, 40, 6, 9 },
    { "enemy", "LogresHUDTarget", 72, 40, 13, 9 },
    { "enemy-buff", "LogresStatusAurastargetHelpful", 85.8, 40, 6, 9 },
    { "group", "LogresHUDAllies", 21, 32.7, 9, 25.9 },
    { "class", "LogresPetActionExecutionProbeCluster", 5.1, 53.5, 12, 5 },
    { "secondary", "LogresSecondaryActionCluster", 5.1, 60.4, 12, 38 },
    { "main", "LogresPrimaryActionCluster", 18.2, 60.4, 12, 38 },
    { "player-debuff", "LogresStatusAurasplayer", 39.5, 81, 22.5, 5.8 },
    { "resource", "LogresHUDResourceBar", 39.5, 88.3, 22.5, 6 },
    { "player-buff", "LogresPlayerHelpfulAuras", 76, 80.5, 23.4, 6.2 },
    { "utility", "LogresUtilityActionCluster", 76, 88.2, 23.4, 9.3 },
}

-- Values returned by geometry APIs can be unavailable or secret-capable.
-- A restricted value is never formatted, compared, counted, or used in math.
local function ordinaryGeometryNumber(value)
    if type(issecretvalue) ~= "function" then
        return false
    end
    local ok, secret = pcall(issecretvalue, value)
    if not ok or secret ~= false then
        return false
    end
    return type(value) == "number"
        and value == value
        and value > -10000000
        and value < 10000000
end

local function readAddonRect(frame)
    local ok, left, top, width, height = pcall(function()
        return frame:GetLeft(), frame:GetTop(), frame:GetWidth(), frame:GetHeight()
    end)
    if not ok or not ordinaryGeometryNumber(left)
        or not ordinaryGeometryNumber(top)
        or not ordinaryGeometryNumber(width)
        or not ordinaryGeometryNumber(height)
    then
        return nil
    end
    if width <= 0 or height <= 0 then
        return nil
    end
    return { left = left, top = top, width = width, height = height }
end

function Layout.GetH2ScreenMapAudit()
    local report = {
        rows = {}, total = #H2_SCREEN_MAP_V4,
        measured = 0, missing = 0, deferred = 0,
        reason = "source-only",
    }
    if type(InCombatLockdown) ~= "function" or InCombatLockdown() then
        report.deferred = report.total
        report.reason = "combat-or-lockdown-unavailable"
        return report
    end
    local root = readAddonRect(UIParent)
    if not root then
        report.deferred = report.total
        report.reason = "viewport-geometry-restricted"
        return report
    end
    local rootWidth, rootHeight = root.width, root.height
    report.reason = "read-only-addon-geometry"
    for index = 1, #H2_SCREEN_MAP_V4 do
        local s = H2_SCREEN_MAP_V4[index]
        local row = {
            id = s[1], frameName = s[2],
            targetX = s[3], targetY = s[4],
            targetW = s[5], targetH = s[6],
            state = "DEFERRED",
        }
        local frame = _G[s[2]]
        if not frame then
            row.state = "MISSING"
            report.missing = report.missing + 1
        else
            local rect = readAddonRect(frame)
            if not rect then
                report.deferred = report.deferred + 1
            else
                row.x = (rect.left - root.left) * 100 / rootWidth
                row.y = (root.top - rect.top) * 100 / rootHeight
                row.w = rect.width * 100 / rootWidth
                row.h = rect.height * 100 / rootHeight
                row.state = "MEASURED"
                report.measured = report.measured + 1
            end
        end
        report.rows[#report.rows + 1] = row
    end
    return report
end

function Layout.GetDebugStatus()
    local count = 0
    for _ in pairs(anchors) do
        count = count + 1
    end

    return {
        anchorCount = count,
        bindCount = bindCount,
        bindFailureCount = bindFailureCount,
        lastBindError = lastBindError,
    }
end


-- P0194 R2: one viewport-wide H.2 map. All thirteen approved regions and
-- all thirteen measured addon-owned proxies are shown together, read-only.
-- This is a visual calibration tool, NOT a layout mutation or collision PASS.
local h2MapOverlay = nil
local h2MapLastReason = "never-opened"

local function createMapOutline(parent, r, g, b, fillAlpha)
    local box = CreateFrame("Frame", nil, parent)
    box:EnableMouse(false)
    box:SetFrameLevel(parent:GetFrameLevel() + 1)
    local background = box:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(box)
    background:SetColorTexture(r, g, b, fillAlpha)
    local function edge(point1, point2, width, height)
        local line = box:CreateTexture(nil, "BORDER")
        line:SetColorTexture(r, g, b, 0.95)
        line:SetPoint(point1, box, point1, 0, 0)
        line:SetPoint(point2, box, point2, 0, 0)
        if width then line:SetWidth(width) else line:SetHeight(height) end
    end
    edge("TOPLEFT", "TOPRIGHT", nil, 2)
    edge("BOTTOMLEFT", "BOTTOMRIGHT", nil, 2)
    edge("TOPLEFT", "BOTTOMLEFT", 2, nil)
    edge("TOPRIGHT", "BOTTOMRIGHT", 2, nil)
    local label = box:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", box, "TOPLEFT", 2, -2)
    label:SetJustifyH("LEFT")
    label:SetTextColor(r, g, b, 1)
    box.logresH2Label = label
    box:Hide()
    return box
end

local function placeMapOutline(box, viewportWidth, viewportHeight,
                               x, y, w, h, label)
    box:ClearAllPoints()
    box:SetPoint("TOPLEFT", UIParent, "TOPLEFT",
        viewportWidth * x / 100, -viewportHeight * y / 100)
    box:SetSize(viewportWidth * w / 100, viewportHeight * h / 100)
    box.logresH2Label:SetText(label)
    box:Show()
end

local function getH2MapOverlay()
    if h2MapOverlay then return h2MapOverlay end
    local root = CreateFrame("Frame", "LogresH2ViewportMapOverlay", UIParent)
    root:SetAllPoints(UIParent)
    root:SetFrameStrata("TOOLTIP")
    root:EnableMouse(false)
    root:Hide()
    root.planned = {}
    root.measured = {}
    for index = 1, #H2_SCREEN_MAP_V4 do
        root.planned[index] = createMapOutline(root, 0.30, 0.66, 1.00, 0.07)
        root.measured[index] = createMapOutline(root, 1.00, 0.72, 0.22, 0.035)
    end
    local legend = root:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    legend:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 12, -12)
    legend:SetText("LOGRES H.2 SCREEN MAP | BLUE = APPROVED V4 | GOLD = CURRENT LOGRES FRAMES | /logres h2map off")
    legend:SetTextColor(1, 1, 1, 1)
    h2MapOverlay = root
    return root
end

-- Source for gold rectangles is the existing P0192 secret-first measurement;
-- no Blizzard frame geometry, visibility, or secure control state is sampled.
function Layout.SetH2MapVisible(visible)
    if visible ~= true then
        if h2MapOverlay then h2MapOverlay:Hide() end
        h2MapLastReason = "hidden"
        return true, h2MapLastReason
    end
    if type(InCombatLockdown) ~= "function" or InCombatLockdown() then
        h2MapLastReason = "combat-deferred"
        return false, h2MapLastReason
    end
    local viewport = readAddonRect(UIParent)
    if not viewport then
        h2MapLastReason = "viewport-geometry-restricted"
        return false, h2MapLastReason
    end
    local report = Layout.GetH2ScreenMapAudit()
    if report.reason ~= "read-only-addon-geometry" then
        h2MapLastReason = report.reason
        return false, h2MapLastReason
    end
    local root = getH2MapOverlay()
    for index = 1, #H2_SCREEN_MAP_V4 do
        local plan = H2_SCREEN_MAP_V4[index]
        placeMapOutline(root.planned[index], viewport.width, viewport.height,
            plan[3], plan[4], plan[5], plan[6], plan[1] .. " [v4]")
        local row = report.rows[index]
        if row and row.state == "MEASURED" then
            placeMapOutline(root.measured[index], viewport.width,
                viewport.height, row.x, row.y, row.w, row.h,
                row.id .. " [actual]")
        else
            root.measured[index]:Hide()
        end
    end
    root:Show()
    h2MapLastReason = "shown"
    return true, "shown " .. tostring(report.measured)
        .. "/" .. tostring(report.total) .. " measured"
end

function Layout.GetH2MapOverlayStatus()
    return {
        shown = h2MapOverlay and h2MapOverlay:IsShown() or false,
        reason = h2MapLastReason,
    }
end

-- P0194 R3: copy only the approved non-secret design map to the panel.
-- Do not expose a live addon frame, native aura payload, or protected state.
function Layout.GetH2ScreenMapPlan()
    local result = {}
    for index = 1, #H2_SCREEN_MAP_V4 do
        local entry = H2_SCREEN_MAP_V4[index]
        result[index] = {
            id = entry[1], x = entry[3], y = entry[4],
            w = entry[5], h = entry[6],
        }
    end
    return result
end
