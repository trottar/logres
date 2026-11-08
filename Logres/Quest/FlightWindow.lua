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
local routeRequests = 0
local chooseRoute
local PAGE_SIZE = 6
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

local function renderRoutes(list)
    local count = math.max(1, math.ceil(#list.records / PAGE_SIZE))
    list.page = math.max(1, math.min(list.page, count))
    local offset = (list.page - 1) * PAGE_SIZE + 1
    local size = math.max(1, math.min(PAGE_SIZE, #list.records - offset + 1))
    local rows = Logres.NPCServiceCatalogue.Window(list.records, offset, size)
    for i, button in ipairs(list.buttons) do
        local route = rows[i]
        button.route = route
        button:SetShown(route ~= nil)
        if route then
            local canChoose = route.usable and not list.locked
                and (route.cost == 0 or (list.funds and list.funds >= route.cost))
            button.name:SetText(route.name)
            button.fare:SetText(route.price or "See map pin")
            button.name:SetTextColor(unpack(canChoose and palette.body or palette.muted))
            button:SetEnabled(canChoose == true)
            button.mark:SetShown(route.id == list.highlight)
        end
    end
    list.pageText:SetShown(count > 1)
    list.pageText:SetFormattedText("%d / %d", list.page, count)
    list.prev:SetShown(list.page > 1)
    list.next:SetShown(list.page < count)
    list.notice:SetText(list.message or (#list.records == 0
        and "No reachable flights listed." or "Click a route or pin to buy and fly."))
end

local function buildRouteList(parent, onChoose)
    local box = CreateFrame("Frame", nil, parent)
    box:SetPoint("TOPLEFT", parent, "TOPLEFT", 32, -102)
    box:SetSize(220, 578)
    box:EnableMouse(true)
    local list = {records = {}, page = 1, buttons = {}}
    for i = 1, PAGE_SIZE do
        local button = CreateFrame("Button", nil, box)
        button:SetSize(196, 49)
        button:SetPoint("TOPLEFT", box, "TOPLEFT", 12, -111 - (i - 1) * 54)
        chrome.wash(button, 0, 0, 196, 49, palette.sidebarWash)
        button.mark = button:CreateTexture(nil, "BACKGROUND")
        button.mark:SetAllPoints(button)
        button.mark:SetColorTexture(unpack(palette.active))
        button.name = chrome.text(button, "", "GameFontHighlightSmall", 8, 2, 181, palette.body)
        button.name:SetHeight(28)
        button.fare = chrome.text(button, "", "GameFontHighlightSmall", 8, 27, 181, palette.goldText)
        button:SetScript("OnClick", function()
            if button.route then onChoose(button.route) end
        end)
        list.buttons[i] = button
    end
    list.notice = chrome.text(box, "", "GameFontHighlightSmall", 12, 512, 194, palette.body)
    list.notice:SetHeight(44)
    list.pageText = chrome.text(box, "", "GameFontHighlightSmall", 70, 452, 80, palette.muted, "CENTER")
    local function arrow(previous)
        local button = CreateFrame("Button", nil, box)
        button:SetSize(28, 28)
        button:SetPoint("TOPLEFT", box, "TOPLEFT", previous and 44 or 148, -449)
        Logres.NPCNarrativePages.CreateChevron(button, previous)
        button:SetScript("OnClick", function()
            list.page = list.page + (previous and -1 or 1)
            renderRoutes(list)
        end)
        return button
    end
    list.prev, list.next = arrow(true), arrow(false)
    return list
end

local function paint(root, sample, foreground)
    assert(Logres.PanelSurface.Paint(root, config.surface, visual.width, visual.height))
    local text, wash = chrome.text, chrome.wash
    local labels = foreground or root
    wash(labels, 32, 102, 220, 578, palette.sidebarWash)
    wash(labels, 260, 102, 1, 578, palette.sidebarRule)
    wash(labels, 28, 85, visual.width - 56, 1, palette.gold)
    wash(root, mapX - 1, mapY - 1, mapSize + 2, mapSize + 2, palette.sidebarRule)
    text(labels, "Flight Paths", "GameFontHighlightLarge", 120, 19, visual.width - 240,
        palette.goldText, "CENTER")
    text(labels, sample and "FLIGHT MASTER  /  PREVIEW" or "FLIGHT MASTER",
        "GameFontHighlightSmall", 120, 49, visual.width - 240, palette.muted, "CENTER")
    text(labels, "Departure", "GameFontHighlight", 44, 114, 194, palette.goldText)
    local origin = text(labels, "", "GameFontHighlight", 44, 142, 194, palette.body)
    origin:SetHeight(42)
    text(labels, "Available flights", "GameFontHighlight", 44, 185, 194, palette.goldText)
    local view = {origin = origin}
    view.routes = buildRouteList(labels, function(route)
        if sample then
            view.routes.highlight = route.id
            renderRoutes(view.routes)
        else
            chooseRoute(route)
        end
    end)
    return view
end

local function showPin(view, index)
    local state = readAPI("TaxiNodeGetType", index)
    local amount = state == "REACHABLE" and readAPI("TaxiNodeCost", index) or nil
    lastState = state == "REACHABLE" and "reachable" or (state == "CURRENT" and "current" or "unavailable")
    lastFare = copper(amount) and amount or nil
    view.routes.highlight = state == "REACHABLE" and index or nil
    renderRoutes(view.routes)
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

local function setAndRestore(plan, object, getName, setName, value)
    local get, set = chrome.method(object, getName), chrome.method(object, setName)
    if not get or not set then return false end
    local ok, stock = pcall(get, object)
    if not ok then return false end
    plan[#plan + 1] = {
        apply = function() set(object, value) end,
        undo = function() set(object, stock) end,
    }
    return true
end

local function quietMouse(plan, frame)
    return chrome.mutable(frame)
        and setAndRestore(plan, frame, "IsMouseClickEnabled", "SetMouseClickEnabled", false)
        and setAndRestore(plan, frame, "IsMouseMotionEnabled", "SetMouseMotionEnabled", false)
end

local function knownChildren(root, routeMap, close)
    local get = chrome.method(root, "GetChildren")
    if not get then return false end
    local ok, children = pcall(function() return {get(root)} end)
    if not ok or #children < 2 or #children > 8 then return false end
    local mapFound, closeFound = false, false
    for _, child in ipairs(children) do
        if not chrome.ordinary(child) then return false end
        if child == routeMap then
            mapFound = true
        elseif child == close then
            closeFound = true
        elseif not chrome.mutable(child) or chrome.read(child, "IsMouseClickEnabled") ~= false
            or chrome.read(child, "IsMouseMotionEnabled") ~= false
            or chrome.read(child, "GetNumChildren") ~= 0 then
            return false
        end
    end
    return mapFound and closeFound
end

local function adopt(plan, child, root, host, relative, x, y, level)
    if not chrome.mutable(child) or chrome.read(child, "GetParent") ~= root then return false end
    local setParent = chrome.method(child, "SetParent")
    local geometry, layers = {}, {}
    if not setParent or not chrome.anchor(geometry, child, "TOPLEFT", relative, "TOPLEFT", x, y)
        or not chrome.resize(geometry, child, mapSize, mapSize) then return false end
    if level and (not setAndRestore(layers, child, "GetFrameStrata", "SetFrameStrata", visual.strata)
        or not setAndRestore(layers, child, "GetFrameLevel", "SetFrameLevel", level)) then
        return false
    end
    plan[#plan + 1] = {
        apply = function()
            setParent(child, host)
            for _, action in ipairs(geometry) do action.apply() end
            for _, action in ipairs(layers) do action.apply() end
        end,
        undo = function()
            setParent(child, root)
            for i = #geometry, 1, -1 do geometry[i].undo() end
            for i = #layers, 1, -1 do layers[i].undo() end
        end,
    }
    return true
end

local function matchesHostScale(routeMap, host)
    local actual = chrome.read(routeMap, "GetEffectiveScale")
    local expected = chrome.read(host, "GetEffectiveScale")
    return type(actual) == "number" and type(expected) == "number"
        and actual > 0 and expected > 0 and math.abs(actual - expected) < 0.001
end

local function capture(root, map, routeMap, host)
    local close = chrome.member(root, "CloseButton")
    local level = host:GetFrameLevel()
    local changes = {}
    if chrome.read(root, "GetParent") ~= UIParent or not close or not knownChildren(root, routeMap, close)
        or not adopt(changes, map, root, host, host, mapX, -mapY)
        or not adopt(changes, routeMap, root, host, map, 0, 0, level + 1)
        or not quietMouse(changes, root) or not quietMouse(changes, close)
        or not chrome.fade(changes, root) then
        return nil
    end
    return changes
end

local function restore(reason, closing)
    if not live then return true end
    if closing then live.art:Hide() end
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

local function resolvePin(session, id)
    local pin = chrome.member(_G, "TaxiButton" .. id)
    if not chrome.mutable(pin) or chrome.read(pin, "GetParent") ~= session.routeMap
        or chrome.read(pin, "GetID") ~= id or chrome.read(pin, "IsShown") ~= true
        or chrome.read(pin, "IsEnabled") ~= true then return nil end
    return pin, chrome.method(pin, "Click")
end

local function refreshRoutes(session)
    local list = session.art.view.routes
    local records, count = {}, readAPI("NumTaxiNodes")
    if type(count) == "number" and count >= 1 and count <= 400 and count == math.floor(count) then
        for id = 1, count do
            if readAPI("TaxiNodeGetType", id) == "REACHABLE" then
                local name = readAPI("TaxiNodeName", id)
                local cost = readAPI("TaxiNodeCost", id)
                local price = copper(cost)
                local _, click = resolvePin(session, id)
                if type(name) == "string" and name ~= "" then
                    records[#records + 1] = {id = id, name = name, cost = price and cost or nil,
                        price = price, usable = price ~= nil and click ~= nil}
                end
            end
        end
    end
    local funds = readAPI("GetMoney")
    list.records, list.funds = records, copper(funds) and funds or nil
    renderRoutes(list)
end

chooseRoute = function(route)
    local session = live
    if not session or session.pending or session.requested or not visit
        or not chrome.unlocked() or not inContext(Logres:GetState()) then return end
    local list = session.art.view.routes
    local cost, funds = readAPI("TaxiNodeCost", route.id), readAPI("GetMoney")
    if not route.usable or not copper(cost) or cost ~= route.cost
        or readAPI("TaxiNodeName", route.id) ~= route.name
        or readAPI("TaxiNodeGetType", route.id) ~= "REACHABLE"
        or (cost > 0 and (not copper(funds) or funds < cost)) then
        list.message = "Fare or availability changed. Choose again."
        refreshRoutes(session)
        return
    end
    local pin, click = resolvePin(session, route.id)
    if not click then
        list.message = "Use the map pin for this route."
        refreshRoutes(session)
        return
    end
    session.requested, list.locked = true, true
    routeRequests = routeRequests + 1
    list.message = "Flight requested. Use the map if you need to retry."
    renderRoutes(list)
    -- Only an explicit, revalidated sidebar click can invoke the original pin.
    local dispatched = pcall(click, pin, "LeftButton")
    if not dispatched and live == session then
        result = "sidebar-native-click-rejected"
        list.message = "Use the map pin for this route."
        renderRoutes(list)
    end
end

local function buildArt(root)
    local art = CreateFrame("Frame", nil, UIParent)
    art:Hide()
    art:SetSize(visual.width, visual.height)
    art:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
    art:SetFrameStrata(visual.strata)
    art:EnableMouse(false)
    art.view = paint(art, false)

    local goodbye = CreateFrame("Button", nil, art)
    goodbye:SetSize(78, 24)
    goodbye:SetPoint("TOPRIGHT", art, "TOPRIGHT", -45, -12)
    chrome.goodbyeArt(goodbye)
    goodbye:SetScript("OnClick", function()
        if live and live.root == root and not live.pending and chrome.unlocked() then
            local hide = chrome.member(_G, "HideUIPanel")
            if type(hide) == "function" then pcall(hide, root) end
        end
    end)
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
    if type(chrome.member(_G, "HideUIPanel")) ~= "function" then return end
    local cache = frames[root]
    if not cache.art then
        local built, art = pcall(buildArt, root)
        if not built or not art then stockOnly, result = true, "stock-art-unavailable"; return end
        cache.art = art
    end
    local art = cache.art
    local ok, plan = pcall(capture, root, map, routeMap, art)
    if not ok or not plan then stockOnly, result = true, "stock-layout-unsupported"; return end
    if preview then preview:Hide() end
    art.view.origin:SetText("Current flight master")
    local list = art.view.routes
    list.page, list.highlight, list.locked, list.message = 1, nil, false, nil
    lastState, lastFare = nil, nil
    live = {root = root, routeMap = routeMap, art = art, plan = plan, applied = 0}
    for i, action in ipairs(plan) do
        live.applied = i
        if not pcall(action.apply) then
            stockOnly = true
            restore("stock-layout-restored")
            return
        end
    end
    if not matchesHostScale(routeMap, art) then
        stockOnly = true
        restore("stock-scale-mismatch")
        return
    end
    if not pcall(art.Show, art) then
        stockOnly = true
        restore("stock-art-restored")
        return
    end
    pcall(bindPins, root, routeMap, art.view)
    if not pcall(refreshRoutes, live) then
        stockOnly = true
        restore("stock-routes-unavailable")
        return
    end
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
            if live and live.root == root then restore("taxi-frame-hidden", true) end
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
        pending = live and live.pending or nil, scaleMatched = live and not live.pending or false,
        lastNodeState = lastState, lastFareCopper = lastFare, hosted = live ~= nil,
        routeRequests = routeRequests, routes = live and #live.art.view.routes.records or 0}
end

local function buildPreview()
    local root = CreateFrame("Frame", nil, UIParent)
    root:Hide()
    root:SetSize(visual.width, visual.height)
    root:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
    root:SetFrameStrata(visual.strata)
    local view = paint(root, true)
    view.origin:SetText("Stormwind")
    view.routes.records = {
        {id = 1, name = "Sentinel Hill", cost = 110, price = "1s 10c", usable = true},
        {id = 2, name = "Lakeshire", cost = 240, price = "2s 40c", usable = true},
    }
    view.routes.funds = 1000
    view.routes.message = "Preview  /  Select a sample route"
    renderRoutes(view.routes)
    chrome.wash(root, mapX, mapY, mapSize, mapSize, {0.19, 0.15, 0.08, 0.94})
    for _, point in ipairs({
        {"Stormwind", 78, 312},
        {"Sentinel Hill", 166, 427, 1},
        {"Lakeshire", 393, 210, 2},
    }) do
        local pin = CreateFrame("Button", nil, root)
        pin:SetSize(135, 24)
        pin:SetPoint("TOPLEFT", root, "TOPLEFT", mapX + point[2], -mapY - point[3])
        chrome.text(pin, "• " .. point[1], "GameFontHighlight", 0, 0, 135, palette.goldText)
        pin:SetScript("OnClick", function()
            view.routes.highlight = point[4]
            renderRoutes(view.routes)
        end)
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
    restore("taxi-map-closed", true)
end)
Logres:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    visit = false
    restore("world-changed", true)
    if preview then preview:Hide() end
end)
Logres:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    if live and live.pending then
        restore(live.pending)
    else
        reconcile()
    end
end)
Logres:RegisterEvent("PLAYER_MONEY", function()
    if live and not live.pending and not live.requested then refreshRoutes(live) end
end)
Logres:RegisterEvent("DISPLAY_SIZE_CHANGED", function()
    if live and not chrome.fits() then
        restore("stock-small-viewport")
    elseif live and not matchesHostScale(live.routeMap, live.art) then
        stockOnly = true
        restore("stock-scale-mismatch")
    end
end)
Logres:SubscribeState(function(state)
    if live and not inContext(state) then
        visit = false
        restore("flight-context-ended", true)
    elseif visit then
        reconcile()
    end
end)
Logres:SubscribePreferences(function(preferences)
    if live and not preferences.immersionEnabled then restore("immersion-off")
    elseif preferences.immersionEnabled then reconcile() end
end)
