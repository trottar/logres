-- P0397: present the Classic taxi map inside the shared NPC service shell.
-- The original map pins retain route selection, payment and travel.
local _, Logres = ...
local Flight = {}
Logres.NPCFlightWindow = Flight

local chrome = Logres.NPCServicePresentation
local config = Logres.PanelConfigs.trainer
local visual, palette = config.preview, config.landscape.palette
local mapX, mapY, mapSize = 279, 100, 580
local live, preview, visit, stockOnly
local result, opens, restores = "idle", 0, 0
local lastState, lastFare
local frames = setmetatable({}, {__mode = "k"})
local pins = setmetatable({}, {__mode = "k"})

local function readAPI(name, ...)
    local fn = chrome.member(_G, name)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn, ...)
    if ok and chrome.ordinary(value) then return value end
end

local function copper(value)
    if type(value) ~= "number" or value < 0 or value >= 1e12 or value ~= math.floor(value) then
        return nil
    end
    if value == 0 then return "Free" end
    local g, s, c = math.floor(value / 10000), math.floor(value / 100) % 100, value % 100
    local parts = {}
    if g > 0 then parts[#parts + 1] = g .. "g" end
    if s > 0 then parts[#parts + 1] = s .. "s" end
    if c > 0 then parts[#parts + 1] = c .. "c" end
    return table.concat(parts, " ")
end

local function paint(root, sample)
    assert(Logres.PanelSurface.Paint(root, config.surface, visual.width, visual.height))
    local text, wash = chrome.text, chrome.wash
    wash(root, 32, 102, 220, 578, palette.sidebarWash)
    wash(root, 260, 102, 1, 578, palette.sidebarRule)
    wash(root, 28, 85, visual.width - 56, 1, palette.gold)
    wash(root, mapX - 1, mapY - 1, mapSize + 2, mapSize + 2, palette.sidebarRule)
    text(root, "Flight Paths", "GameFontHighlightLarge", 120, 19, visual.width - 240,
        palette.goldText, "CENTER")
    text(root, sample and "FLIGHT MASTER  /  PREVIEW" or "FLIGHT MASTER",
        "GameFontHighlightSmall", 120, 49, visual.width - 240, palette.muted, "CENTER")
    text(root, "Departure", "GameFontHighlight", 44, 114, 194, palette.goldText)
    local origin = text(root, "", "GameFontHighlight", 44, 142, 194, palette.body)
    text(root, "Destination", "GameFontHighlight", 44, 218, 194, palette.goldText)
    local name = text(root, "", "GameFontHighlight", 44, 246, 194, palette.body)
    origin:SetHeight(42)
    name:SetHeight(42)
    local status = text(root, "", "GameFontHighlight", 44, 292, 194, palette.muted)
    local fare = text(root, "", "GameFontHighlight", 44, 325, 194, palette.goldText)
    text(root, "Hover over a destination for its fare.", "GameFontHighlightSmall",
        44, 376, 194, palette.body):SetHeight(42)
    text(root, sample and "Sample destinations only." or "Click a reachable pin to pay and fly.",
        "GameFontHighlightSmall", 44, 425, 194, palette.body):SetHeight(42)
    return {origin = origin, name = name, status = status, fare = fare}
end

local function showRoute(view, name, state, price)
    view.name:SetText(name or "Choose a map pin")
    view.status:SetText(state or "")
    view.fare:SetText(price and ("Fare  " .. price) or "")
end

local function showPin(view, index)
    local name, state = readAPI("TaxiNodeName", index), readAPI("TaxiNodeGetType", index)
    if type(name) ~= "string" or name == "" then name = nil end
    local price
    if state == "REACHABLE" then
        local amount = readAPI("TaxiNodeCost", index)
        price = copper(amount)
        lastState, lastFare = "reachable", price and amount or nil
        showRoute(view, name, "Available", price or "See map tooltip")
    elseif state == "CURRENT" then
        lastState, lastFare = "current", nil
        showRoute(view, name, "You are here")
    elseif state == "UNREACHABLE" or state == "DISTANT" then
        lastState, lastFare = "unavailable", nil
        showRoute(view, name, "Unavailable")
    else
        showRoute(view, name)
    end
end

local function bindPins(root, routeMap, view)
    local count = readAPI("NumTaxiNodes")
    if type(count) ~= "number" or count < 1 or count > 400 or count ~= math.floor(count) then return end
    for i = 1, count do
        local pin = chrome.member(_G, "TaxiButton" .. i)
        if pin and not pins[pin] and chrome.mutable(pin) and chrome.read(pin, "GetParent") == routeMap then
            local hook = chrome.method(pin, "HookScript")
            if hook then
                local attached = pcall(hook, pin, "OnEnter", function(button)
                    if live and live.root == root and live.art.view == view then
                        local index = chrome.read(button, "GetID")
                        if type(index) == "number" and index >= 1 and index <= 400
                            and index == math.floor(index) then showPin(view, index) end
                    end
                end)
                if attached then pins[pin] = true end
            end
        end
        if readAPI("TaxiNodeGetType", i) == "CURRENT" then
            local name = readAPI("TaxiNodeName", i)
            if type(name) == "string" and name ~= "" then view.origin:SetText(name) end
        end
    end
end

local borders = {"Bg", "TitleBg", "TopTileStreaks", "TitleText", "TopLeftCorner",
    "TopRightCorner", "TopBorder", "BotLeftCorner", "BotRightCorner", "BottomBorder",
    "LeftBorder", "RightBorder", "InsetBorderTopLeft", "InsetBorderTopRight",
    "InsetBorderBottomLeft", "InsetBorderBottomRight", "InsetBorderTop",
    "InsetBorderBottom", "InsetBorderLeft", "InsetBorderRight"}

local function capture(root, map)
    local close = chrome.member(root, "CloseButton")
    if not chrome.member(root, "Bg") or not chrome.member(root, "TitleText") then return nil end
    local changes = {}
    if not chrome.anchor(changes, root, visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
        or not chrome.resize(changes, root, visual.width, visual.height)
        or not chrome.anchor(changes, map, "TOPLEFT", root, "TOPLEFT", mapX, -mapY)
        or not chrome.resize(changes, map, mapSize, mapSize)
        or not chrome.mutable(close) or not chrome.goodbye(changes, root, close) then
        return nil
    end
    for _, key in ipairs(borders) do
        local region = chrome.member(root, key)
        if region and not chrome.fade(changes, region) then return nil end
    end
    return changes
end

local function restore(reason)
    if not live then return true end
    if not chrome.unlocked() then
        live.pending = reason
        result = "combat-restore-deferred"
        return false
    end
    local restored = true
    for i = live.applied, 1, -1 do
        if not pcall(live.plan[i].undo) then restored = false end
    end
    if not restored then
        live.pending = reason
        result = "restore-pending"
        return false
    end
    live.art:Hide()
    live = nil
    restores = restores + 1
    result = reason
    return true
end

local function inContext(state)
    return state and state.interacting == true and state.interactionType == 6
        and not state.onTaxi and Logres:GetPreference("immersionEnabled") == true
end

local function buildArt(root)
    local art = CreateFrame("Frame", nil, root)
    art:Hide()
    art:SetAllPoints(root)
    local level = chrome.read(root, "GetFrameLevel")
    if type(level) ~= "number" then return nil end
    art:SetFrameLevel(math.max(0, level - 1))
    art:EnableMouse(false)
    art.view = paint(art, false)
    return art
end

local function apply(root)
    if live or not visit or stockOnly or not inContext(Logres:GetState()) or not chrome.unlocked()
        or not chrome.mutable(root) or chrome.read(root, "IsShown") ~= true then return end
    if not chrome.fits() then result = "stock-small-viewport"; return end
    local map, routeMap = chrome.member(root, "InsetBg"), chrome.member(_G, "TaxiRouteMap")
    if not map or not routeMap or chrome.read(map, "GetParent") ~= root
        or chrome.read(routeMap, "GetParent") ~= root then
        result = "stock-map-shape-unsupported"
        return
    end
    local ok, plan = pcall(capture, root, map)
    if not ok or not plan then stockOnly, result = true, "stock-layout-unsupported"; return end
    local cache = frames[root]
    if not cache.art then
        local built, art = pcall(buildArt, root)
        if not built or not art then stockOnly, result = true, "stock-art-unavailable"; return end
        cache.art = art
    end
    if preview then preview:Hide() end
    local art = cache.art
    art.view.origin:SetText("Current flight master")
    showRoute(art.view)
    lastState, lastFare = nil, nil
    live = {root = root, art = art, plan = plan, applied = 0}
    for i, action in ipairs(plan) do
        live.applied = i
        if not pcall(action.apply) then
            stockOnly = true
            restore("stock-layout-restored")
            return
        end
    end
    if not pcall(art.Show, art) then
        stockOnly = true
        restore("stock-art-restored")
        return
    end
    pcall(bindPins, root, routeMap, art.view)
    opens = opens + 1
    result = "taxi-layout-active"
end

local function reconcile()
    if not visit or stockOnly or live or not chrome.unlocked() then return end
    local root = chrome.member(_G, "TaxiFrame")
    if not chrome.mutable(root) then result = "stock-taxi-frame-unsupported"; return end
    local cache = frames[root]
    if not cache then
        cache = {}
        frames[root] = cache
    end
    local hook = chrome.method(root, "HookScript")
    if not hook then return end
    if not cache.hide then
        cache.hide = pcall(hook, root, "OnHide", function()
            if live and live.root == root then restore("taxi-frame-hidden") end
        end)
        if not cache.hide then return end
    end
    if not cache.show then cache.show = pcall(hook, root, "OnShow", function() apply(root) end) end
    apply(root)
end

function Flight.Stock()
    stockOnly = true
    return restore("stock-requested"), result
end

function Flight.GetAudit()
    return {result = result, live = live ~= nil, opens = opens, restores = restores,
        pending = live and live.pending or nil, lastNodeState = lastState, lastFareCopper = lastFare}
end

local function buildPreview()
    local root = CreateFrame("Frame", nil, UIParent)
    root:Hide()
    root:SetSize(visual.width, visual.height)
    root:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
    root:SetFrameStrata(visual.strata)
    local view = paint(root, true)
    view.origin:SetText("Stormwind")
    showRoute(view)
    chrome.wash(root, mapX, mapY, mapSize, mapSize, {0.19, 0.15, 0.08, 0.94})
    for _, point in ipairs({
        {"Stormwind", 78, 312, "You are here"},
        {"Sentinel Hill", 166, 427, "Available", "1s 10c"},
        {"Lakeshire", 393, 210, "Unavailable"},
    }) do
        local pin = CreateFrame("Button", nil, root)
        pin:SetSize(135, 24)
        pin:SetPoint("TOPLEFT", root, "TOPLEFT", mapX + point[2], -mapY - point[3])
        chrome.text(pin, "• " .. point[1], "GameFontHighlight", 0, 0, 135, palette.goldText)
        pin:SetScript("OnClick", function() showRoute(view, point[1], point[4], point[5]) end)
    end
    local close = CreateFrame("Button", nil, root)
    close:SetSize(78, 24)
    close:SetPoint("TOPRIGHT", root, "TOPRIGHT", -45, -12)
    chrome.goodbyeArt(close)
    close:SetScript("OnClick", function() root:Hide() end)
    return root
end

function Flight.Preview()
    if live then return false, "close the live flight map first" end
    if not preview then
        local ok, frame = pcall(buildPreview)
        if not ok then return false, "preview-unavailable" end
        preview = frame
    end
    preview:SetShown(not preview:IsShown())
    return true, "flight-preview"
end

Logres:RegisterEvent("TAXIMAP_OPENED", function(_, system)
    local systems = chrome.member(Enum, "UIMapSystem")
    local taxi = systems and chrome.member(systems, "Taxi")
    visit = taxi ~= nil and chrome.ordinary(system) and system == taxi
    stockOnly = false
    if visit then reconcile() else restore("stock-map-system") end
end)
Logres:RegisterEvent("TAXIMAP_CLOSED", function()
    visit = false
    restore("taxi-map-closed")
end)
Logres:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    visit = false
    restore("world-changed")
    if preview then preview:Hide() end
end)
Logres:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    if live and live.pending then restore(live.pending) else reconcile() end
end)
Logres:RegisterEvent("DISPLAY_SIZE_CHANGED", function()
    if live and not chrome.fits() then restore("stock-small-viewport") end
end)
Logres:SubscribeState(function(state)
    if live and not inContext(state) then
        visit = false
        restore("flight-context-ended")
    elseif visit then
        reconcile()
    end
end)
Logres:SubscribePreferences(function(preferences)
    if live and not preferences.immersionEnabled then restore("immersion-off")
    elseif preferences.immersionEnabled then reconcile() end
end)
