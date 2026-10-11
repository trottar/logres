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
