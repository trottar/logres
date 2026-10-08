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
