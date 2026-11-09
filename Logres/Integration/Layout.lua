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
    reportBug = {
        name = "LogresLayoutReportBug",
        point = "TOPRIGHT",
        relativePoint = "TOPRIGHT",
        x = -96,
        y = -224,
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

-- P0192/P0420: read-only H.2 geometry audit. Design envelopes are NOT
-- native frame bounds and are NOT automatically applied to anchors.
-- Only addon-owned frame references are inspected; no Blizzard presentation
-- visibility or protected action state is read or mutated.
local H2_SCREEN_MAP_V4 = {
    { "compass", "LogresCompassFrame", 31.4, 6.55, 37.4, 6.9 },
    { "activeQuest", "LogresActiveQuest", 78.2, 5.4, 19.6, 19.2 },
    { "questDialogue", "LogresQuestDialogue", 35.0, 28.0, 30.0, 30.0 },
    { "contextObjective", "LogresQuestObjectiveProgress", 40.0, 47.5, 20.0, 5.0 },
    { "contextXP", "LogresQuestXPPulse", 40.0, 61.0, 20.0, 4.0 },
    { "player-debuff", "LogresStatusAurasplayer", 39.5, 81.0, 22.5, 5.8 },
    { "resource", "LogresHUDResourceBar", 39.5, 88.3, 22.5, 6.0 },
    { "player-buff", "LogresPlayerHelpfulAuras", 77.0, 72.5, 22.0, 5.0 },
    { "enemy-debuff", "LogresStatusAurastarget", 65.2, 40.0, 6.0, 9.0 },
    { "enemy", "LogresHUDTarget", 72.0, 40.0, 13.0, 9.0 },
    { "enemy-buff", "LogresStatusAurastargetHelpful", 85.8, 40.0, 6.0, 9.0 },
    { "group", "LogresHUDAllies", 20.0, 32.7, 10.0, 25.9 },
    { "petActions", "LogresPetActionExecutionProbeCluster", 5.0, 52.5, 10.0, 5.0 },
    { "bar2", "LogresSecondaryActionCluster", 0.0, 56.0, 10.0, 38.0 },
    { "bar1", "LogresPrimaryActionCluster", 9.0, 56.0, 8.0, 38.0 },
    { "bar4", "LogresBar4ActionCluster", 5.0, 90.0, 10.0, 8.0 },
    { "bar3", "LogresUtilityActionCluster", 76.0, 80.0, 24.0, 10.0 },
    { "bar5", "LogresBar5ActionCluster", 76.0, 90.0, 24.0, 8.0 },
    { "reportBug", "LogresBugReportButton", 91.0, 33.25, 8.0, 3.5 },
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
    -- The approved authoring envelope is not the actual button footprint.
    -- Compare the authored center against the known addon-owned secure grid
    -- extent for action clusters, while keeping other design envelopes intact.
    local plan = Layout.GetH2ScreenMapPlan()
    report.reason = "read-only-addon-geometry"
    for index = 1, #H2_SCREEN_MAP_V4 do
        local s = H2_SCREEN_MAP_V4[index]
        local target = plan[index]
        local row = {
            id = s[1], frameName = s[2],
            targetX = target.x, targetY = target.y,
            targetW = target.w, targetH = target.h,
            expectedMode = target.mode,
            designW = s[5], designH = s[6],
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
                -- Position error is calculated independently of the
                -- approved design-envelope size, in UIParent logical units.
                row.offsetX = (row.x - target.x) * rootWidth / 100
                row.offsetY = (row.y - target.y) * rootHeight / 100
                row.designDeltaW = (row.w - s[5]) * rootWidth / 100
                row.designDeltaH = (row.h - s[6]) * rootHeight / 100
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


-- P0416: approved user-authored five-bar source/role/geometry profile.
-- These are author-time constants, not a live combat/editor mutation.
-- All 12 secure action slots and their persistent Blizzard bindings stay fixed.
local ACTION_BAR_LAYOUT = {
    primary = { role = "primary", columns = 3, rows = 4,
        xPercent = 13, yPercent = 75, scale = 1 },
    secondary = { role = "secondary", columns = 2, rows = 6,
        xPercent = 5, yPercent = 75, scale = 1 },
    utility = { role = "utility", columns = 6, rows = 2,
        xPercent = 88, yPercent = 85, scale = 1 },
    bar4 = { role = "secondary", columns = 6, rows = 2,
        xPercent = 10, yPercent = 95, scale = 1 },
    bar5 = { role = "utility", columns = 6, rows = 2,
        xPercent = 88, yPercent = 95, scale = 1 },
}

function Layout.GetActionBarSpec(key)
    local source = ACTION_BAR_LAYOUT[key]
    if not source then return nil end
    -- Return a copy: callers cannot mutate the authored layout profile.
    return { role = source.role, columns = source.columns,
        rows = source.rows, xPercent = source.xPercent,
        yPercent = source.yPercent, scale = source.scale }
end

-- Check the authored five 12-button extents before moving ANY anchors.
-- Only UIParent's previously classified ordinary viewport geometry and our
-- own action/theme constants are used: no protected Blizzard inspection.
local function actionBarsFitViewport(width, height)
    local style = Logres.Theme and Logres.Theme.action or {}
    local size, gap = style.buttonSize or 42, style.buttonGap or 5
    local art = style.artOverscan or 2
    if type(size) ~= "number" or type(gap) ~= "number"
        or type(art) ~= "number" or size <= 0 or gap < 0 or art < 0 then
        return false, "action-geometry-unavailable"
    end
    local rectangles = {}
    for _, key in ipairs({"primary", "secondary", "utility", "bar4", "bar5"}) do
        local item = ACTION_BAR_LAYOUT[key]
        local w = (item.columns * size + (item.columns - 1) * gap)
            * item.scale
        local h = (item.rows * size + (item.rows - 1) * gap)
            * item.scale
        local centerX = width * item.xPercent / 100
        local centerY = height * item.yPercent / 100
        local margin = art * item.scale + 1
        local left, right = centerX - w / 2, centerX + w / 2
        local top, bottom = centerY - h / 2, centerY + h / 2
        if left < margin or right > width - margin
            or top < margin or bottom > height - margin then
            return false, "action-bounds:" .. key
        end
        for _, previous in ipairs(rectangles) do
            -- Maintain a small separation between secure click regions.
            if left < previous.right + 2 and right > previous.left - 2
                and top < previous.bottom + 2
                and bottom > previous.top - 2 then
                return false, "action-overlap:" .. key .. ":" .. previous.key
            end
        end
        rectangles[#rectangles + 1] = {
            key = key, left = left, right = right, top = top, bottom = bottom,
        }
    end
    return true, "approved-action-bounds"
end

-- P0195: central D-045 viewport translation for addon-owned semantic anchors.
-- Planning boxes remain immutable; each live widget retains intrinsic size.
-- No protected frame is moved in combat; legacy P0166 anchors are fallback.
local H2_APPROVED_ANCHORS = {
    navigation = { id = "compass", x = 50.1, y = 6.55 },
    activeQuest = { id = "activeQuest", x = 97.8, y = 5.4 },
    questDialogue = { id = "questDialogue", x = 50.0, y = 28.0 },
    contextObjective = { id = "contextObjective", x = 50.0, y = 50.0 },
    contextXP = { id = "contextXP", x = 50.0, y = 63.0 },
    playerReaction = { id = "resource", x = 50.75, y = 91.3 },
    playerHarmful = { id = "player-debuff", x = 50.75, y = 83.9 },
    targetFallback = { id = "enemy", x = 78.5, y = 44.5 },
    targetHarmful = { id = "enemy-debuff", x = 68.2, y = 44.5 },
    targetHelpful = { id = "enemy-buff", x = 88.8, y = 44.5 },
    allies = { id = "group", x = 25.0, y = 45.65 },
    classPet = { id = "petActions", x = 10.0, y = 55.0 },
    secondaryActions = { id = "bar2", x = ACTION_BAR_LAYOUT.secondary.xPercent, y = ACTION_BAR_LAYOUT.secondary.yPercent },
    primaryActions = { id = "bar1", x = ACTION_BAR_LAYOUT.primary.xPercent, y = ACTION_BAR_LAYOUT.primary.yPercent },
    passiveStatus = { id = "player-buff", x = 77.0, y = 75.0 },
    utilityActions = { id = "bar3", x = ACTION_BAR_LAYOUT.utility.xPercent, y = ACTION_BAR_LAYOUT.utility.yPercent },
    bar4Actions = { id = "bar4", x = ACTION_BAR_LAYOUT.bar4.xPercent, y = ACTION_BAR_LAYOUT.bar4.yPercent },
    bar5Actions = { id = "bar5", x = ACTION_BAR_LAYOUT.bar5.xPercent, y = ACTION_BAR_LAYOUT.bar5.yPercent },
    nativeAccess = { id = "native-access-safe-dock", x = 98.4, y = 27.8 },
    reportBug = { id = "reportBug", x = 95.0, y = 35.0 },
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
    local fit, boundsReason = actionBarsFitViewport(viewport.width, viewport.height)
    if not fit then
        -- On a smaller/changed viewport, restore the known legacy anchors
        -- instead of leaving protected action clusters clipped offscreen.
        local restored = pcall(restoreOriginalLayoutAnchors)
        h2Placement.active = false
        h2Placement.reason = restored and boundsReason or "action-fallback-failed"
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
    h2Placement.reason = "approved-screen-map"
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
    legend:SetText("LOGRES H.2 | BLUE = EXPECTED AT APPROVED ANCHOR | GOLD = MEASURED LOGRES FRAME | /logres h2map off")
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
    local plan = Layout.GetH2ScreenMapPlan()
    for index = 1, #plan do
        local target = plan[index]
        placeMapOutline(root.planned[index], viewport.width, viewport.height,
            target.x, target.y, target.w, target.h,
            target.id .. (target.mode == "design-fallback"
                and " [design]" or " [expected]"))
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

-- P0419: preserve the approved center and show the real authored grid
-- footprint for action clusters. The original H.2 design-envelope widths
-- were never the secure button frame dimensions; their blue/orange mismatch
-- was a diagnostic projection error, not evidence of displaced bindings.
-- This reads only previously classified UIParent geometry plus addon-owned
-- role/style constants. No native frame or protected state is inspected.
local H2_ACTION_PLAN_KEYS = {
    bar1 = "primary", bar2 = "secondary", bar3 = "utility",
    bar4 = "bar4", bar5 = "bar5",
}

local function actionPlanFootprint(id, viewport)
    local key = H2_ACTION_PLAN_KEYS[id]
    local columns, rows, scale
    if key then
        local spec = ACTION_BAR_LAYOUT[key]
        columns, rows, scale = spec.columns, spec.rows, spec.scale
    elseif id == "petActions" then
        columns, rows, scale = 5, 2, 1 -- PetActionExecutionProbe source grid
    else
        return nil
    end
    local theme = Logres.Theme and Logres.Theme.action or {}
    local size, gap = theme.buttonSize or 42, theme.buttonGap or 5
    if type(size) ~= "number" or type(gap) ~= "number"
        or size <= 0 or gap < 0 then
        return nil
    end
    return (columns * size + (columns - 1) * gap) * scale
            * 100 / viewport.width,
        (rows * size + (rows - 1) * gap) * scale
            * 100 / viewport.height
end

-- P0420: project each remaining addon-owned widget from its approved
-- semantic anchor and its currently measured intrinsic size. This is a
-- position comparison, NOT a claim that design-envelope sizes were approved
-- for runtime mutation. Bind() supplies the same alignment below for each
-- supported owned frame; unmeasurable frames retain the historical envelope.
local H2_INTRINSIC_ANCHORS = {
    compass = { key = "navigation", point = "TOP" },
    activeQuest = { key = "activeQuest", point = "TOPRIGHT" },
    questDialogue = { key = "questDialogue", point = "TOP" },
    contextObjective = { key = "contextObjective", point = "CENTER" },
    contextXP = { key = "contextXP", point = "CENTER" },
    ["player-debuff"] = { key = "playerHarmful", point = "CENTER" },
    resource = { key = "playerReaction", point = "CENTER" },
    ["player-buff"] = { key = "passiveStatus", point = "LEFT" },
    ["enemy-debuff"] = { key = "targetHarmful", point = "CENTER" },
    enemy = { key = "targetFallback", point = "CENTER" },
    ["enemy-buff"] = { key = "targetHelpful", point = "CENTER" },
    group = { key = "allies", point = "CENTER" },
    reportBug = { key = "reportBug", point = "CENTER" },
}

local function intrinsicExpectedRect(entry, viewport)
    if type(InCombatLockdown) ~= "function" or InCombatLockdown() then
        return nil
    end
    local binding = H2_INTRINSIC_ANCHORS[entry[1]]
    if not binding then return nil end
    local approved = H2_APPROVED_ANCHORS[binding.key]
    local frame = _G[entry[2]] -- P0192 addon-owned frame allowlist only
    if not approved or not frame then return nil end
    local rect = readAddonRect(frame)
    if not rect then return nil end
    local w, h = rect.width * 100 / viewport.width,
        rect.height * 100 / viewport.height
    local x, y = approved.x, approved.y
    if binding.point == "TOP" then
        x = x - w / 2
    elseif binding.point == "TOPRIGHT" then
        x = x - w
    elseif binding.point == "LEFT" then
        y = y - h / 2
    else
        x, y = x - w / 2, y - h / 2
    end
    return x, y, w, h
end

-- The design envelope is preserved in SCREEN_MAP_V5.json. The H.2 blue
-- outline is instead an expected frame footprint at the approved anchor,
-- using source-exact action grids or secret-checked, addon-owned dimensions.
-- Gold remains independent observed frame geometry. Any true offset stays
-- visible because expected X/Y never comes from the measured frame position.
function Layout.GetH2ScreenMapPlan()
    local result = {}
    local viewport = readAddonRect(UIParent)
    for index = 1, #H2_SCREEN_MAP_V4 do
        local entry = H2_SCREEN_MAP_V4[index]
        local x, y, w, h = entry[3], entry[4], entry[5], entry[6]
        local mode = "design-fallback"
        if viewport then
            local gridW, gridH = actionPlanFootprint(entry[1], viewport)
            if gridW and gridH then
                local approvedKey = H2_ACTION_PLAN_KEYS[entry[1]]
                local centerX, centerY
                if approvedKey then
                    local spec = ACTION_BAR_LAYOUT[approvedKey]
                    centerX, centerY = spec.xPercent, spec.yPercent
                else
                    centerX, centerY = H2_APPROVED_ANCHORS.classPet.x,
                        H2_APPROVED_ANCHORS.classPet.y
                end
                x, y = centerX - gridW / 2, centerY - gridH / 2
                w, h = gridW, gridH
                mode = "authored-grid"
            else
                local px, py, pw, ph = intrinsicExpectedRect(entry, viewport)
                if px and py and pw and ph then
                    x, y, w, h = px, py, pw, ph
                    mode = "intrinsic-anchor"
                end
            end
        end
        result[index] = { id = entry[1], x = x, y = y, w = w, h = h,
            mode = mode, designW = entry[5], designH = entry[6] }
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
    { "LogresBugReportButton", "reportBug" },
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
        "Logres H2 approved placement: %s (reason=%s anchors=%s)",
        placement.active and "APPLIED" or "DEFERRED",
        tostring(placement.reason), tostring(placement.anchors)
    ))

    -- P0192: geometry is diagnostic only. A successful source measurement is
    -- NOT collision/visibility/secure-action validation or layout acceptance.
    local h2 = Logres.Layout.GetH2ScreenMapAudit()
    emit(string.format(
        "Logres H2 geometry AUDIT (measured=%s/%s missing=%s deferred=%s reason=%s; layout unchanged)",
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
            emit(string.format(
                "Logres H2 %s position-offset=(%+.1f,%+.1f) design-size-delta=(%+.1f,%+.1f) UI-units projection=%s",
                row.id, row.offsetX, row.offsetY,
                row.designDeltaW, row.designDeltaH, row.expectedMode
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
