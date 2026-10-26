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
        point = Logres.PanelConfigs.quest.placement.point,
        relativePoint = Logres.PanelConfigs.quest.placement.relativePoint,
        x = Logres.PanelConfigs.quest.placement.x,
        y = Logres.PanelConfigs.quest.placement.y,
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
    playerHarmful = {
        name = "LogresLayoutPlayerHarmful",
        point = "CENTER", relativePoint = "CENTER", x = -160, y = -118,
    },
    targetHarmful = {
        name = "LogresLayoutTargetHarmful",
        point = "CENTER", relativePoint = "CENTER", x = 220, y = -54,
    },
    targetHelpful = {
        name = "LogresLayoutTargetHelpful",
        point = "CENTER", relativePoint = "CENTER", x = 220, y = -100,
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


-- P0195: central D-045 viewport translation for addon-owned semantic anchors.
-- Planning boxes remain immutable; each live widget retains intrinsic size.
-- No protected frame is moved in combat; legacy P0166 anchors are fallback.
local H2_APPROVED_ANCHORS = {
    navigation = { id = "compass", x = 50.1, y = 4.8 },
    activeQuest = { id = "quest", x = 99.6, y = 5.0 },
    playerReaction = { id = "resource", x = 50.75, y = 91.3 },
    playerHarmful = { id = "player-debuff", x = 50.75, y = 83.9 },
    targetFallback = { id = "enemy", x = 78.5, y = 44.5 },
    targetHarmful = { id = "enemy-debuff", x = 68.2, y = 44.5 },
    targetHelpful = { id = "enemy-buff", x = 88.8, y = 44.5 },
    allies = { id = "group", x = 25.5, y = 45.65 },
    classPet = { id = "class", x = 11.1, y = 54.5 },
    secondaryActions = { id = "secondary", x = 11.1, y = 79.4 },
    primaryActions = { id = "main", x = 24.2, y = 79.4 },
    passiveStatus = { id = "player-buff", x = 82.35, y = 83.6 },
    utilityActions = { id = "utility", x = 87.7, y = 92.85 },
    -- Independent non-D-045 control surfaces: retain separate access.
    bar4Actions = { id = "bar4-safe-satellite", x = 34.8, y = 79.4 },
    bar5Actions = { id = "bar5-safe-satellite", x = 3.4, y = 79.4 },
    nativeAccess = { id = "native-access-safe-dock", x = 98.4, y = 27.8 },
}
local h2Placement = { active = false, reason = "not-attempted", anchors = 0 }

local function restoreOriginalLayoutAnchors()
    for key, anchor in pairs(anchors) do
        local spec = ANCHOR_SPECS[key]
        anchor:ClearAllPoints()
        anchor:SetPoint(
            spec.point, UIParent, spec.relativePoint, spec.x, spec.y
        )
    end
end

function Layout.ApplyApprovedV4()
    if type(InCombatLockdown) ~= "function" or InCombatLockdown() then
        h2Placement.active = false
        h2Placement.reason = "combat-deferred"
        return false, h2Placement.reason
    end
    local viewport = readAddonRect(UIParent)
    if not viewport then
        h2Placement.active = false
        h2Placement.reason = "viewport-unavailable"
        return false, h2Placement.reason
    end
    local ok, failure = pcall(function()
        for key, rule in pairs(H2_APPROVED_ANCHORS) do
            local anchor = anchors[key]
            anchor:ClearAllPoints()
            anchor:SetPoint(
                "CENTER", UIParent, "TOPLEFT",
                viewport.width * rule.x / 100,
                -viewport.height * rule.y / 100
            )
        end
    end)
    if not ok then
        -- Restore the prior usable layout rather than leaving partial moves.
        pcall(restoreOriginalLayoutAnchors)
        h2Placement.active = false
        h2Placement.reason = "anchor-translation-failed"
        return false, h2Placement.reason
    end
    h2Placement.active = true
    h2Placement.reason = "approved-v4-anchors"
    h2Placement.anchors = 16
    return true, h2Placement.reason
end

function Layout.GetH2PlacementStatus()
    return {
        active = h2Placement.active,
        reason = h2Placement.reason,
        anchors = h2Placement.anchors,
    }
end

-- Native event rebase, not a timer/polling loop or protected-frame hook.
local h2ViewportEvents = CreateFrame("Frame")
for _, event in ipairs({
    "PLAYER_ENTERING_WORLD", "UI_SCALE_CHANGED",
    "DISPLAY_SIZE_CHANGED", "PLAYER_REGEN_ENABLED",
}) do
    h2ViewportEvents:RegisterEvent(event)
end
h2ViewportEvents:SetScript("OnEvent", function()
    Layout.ApplyApprovedV4()
end)
Layout.ApplyApprovedV4()

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

-- P0353: original command-invoked read-only integration diagnostics.
local LAYOUT_EXPECTED = {
    { "LogresHUDResourceBar", "playerReaction" },
    { "LogresHUDTarget", "targetFallback" },
    { "LogresHUDAllies", "allies" },
    { "LogresPrimaryActionCluster", "primaryActions" },
    { "LogresSecondaryActionCluster", "secondaryActions" },
    { "LogresUtilityActionCluster", "utilityActions" },
    { "LogresBar4ActionCluster", "bar4Actions" },
    { "LogresBar5ActionCluster", "bar5Actions" },
    { "LogresCompassFrame", "navigation" },
    { "LogresQuestXPPulse", "contextXP" },
    { "LogresQuestObjectiveProgress", "contextObjective" },
    { "LogresActiveQuest", "activeQuest" },
    { "LogresQuestDialogue", "questDialogue" },
    { "LogresPlayerHelpfulAuras", "passiveStatus" },
    { "LogresPetActionExecutionProbeCluster", "classPet" },
    { "LogresNativeAccessDock", "nativeAccess" },
}

function Layout.RunDevLayoutCheck(emit)
    local status =
        Logres.Layout
        and Logres.Layout.GetDebugStatus
        and Logres.Layout.GetDebugStatus()
        or nil

    if not status then
        emit(
            "Logres layoutcheck: FAIL "
            .. "(layout status unavailable)"
        )
        return
    end

    local missing = 0
    local mismatched = 0

    for index = 1, #LAYOUT_EXPECTED do
        local definition = LAYOUT_EXPECTED[index]
        local frame = _G[definition[1]]
        local expected = definition[2]

        if not frame then
            missing = missing + 1
        elseif frame.logresLayoutAnchor ~= expected then
            mismatched = mismatched + 1
        end
    end

    local passed =
        status.anchorCount == #LAYOUT_EXPECTED + 3
        and status.bindFailureCount == 0
        and missing == 0
        and mismatched == 0

    emit(string.format(
        "Logres layoutcheck: %s (anchors=%s binds=%s failures=%s missing=%s mismatched=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(status.anchorCount),
        tostring(status.bindCount),
        tostring(status.bindFailureCount),
        tostring(missing),
        tostring(mismatched),
        tostring(status.lastBindError)
    ))

    local placement = Logres.Layout.GetH2PlacementStatus()
    emit(string.format(
        "Logres H2 v4 placement: %s (reason=%s anchors=%s)",
        placement.active and "APPLIED" or "DEFERRED",
        tostring(placement.reason), tostring(placement.anchors)
    ))

    -- P0192: geometry is diagnostic only. A successful source measurement is
    -- NOT collision/visibility/secure-action validation or layout acceptance.
    local h2 = Logres.Layout.GetH2ScreenMapAudit()
    emit(string.format(
        "Logres H2 v4 geometry AUDIT (measured=%s/%s missing=%s deferred=%s reason=%s; layout unchanged)",
        tostring(h2.measured), tostring(h2.total),
        tostring(h2.missing), tostring(h2.deferred), tostring(h2.reason)
    ))
    for index = 1, #h2.rows do
        local row = h2.rows[index]
        if row.state == "MEASURED" then
            emit(string.format(
                "Logres H2 %s %s actual=(%.1f,%.1f,%.1f,%.1f) planned=(%.1f,%.1f,%.1f,%.1f)",
                row.id, row.state, row.x, row.y, row.w, row.h,
                row.targetX, row.targetY, row.targetW, row.targetH
            ))
        else
            emit(string.format(
                "Logres H2 %s %s frame=%s planned=(%.1f,%.1f,%.1f,%.1f)",
                row.id, row.state, row.frameName,
                row.targetX, row.targetY, row.targetW, row.targetH
            ))
        end
    end
end
