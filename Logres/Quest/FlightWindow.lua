-- P0397: present the Classic taxi map inside the shared NPC service shell.
-- The original map pins retain route selection, payment and travel.
local _, Logres = ...
local Flight = {}
Logres.NPCFlightWindow = Flight

local chrome = Logres.NPCServicePresentation
-- Capture and restore native taxi input separately from the service view.
local host = {}
do
    local MAX_PINS = 400

    function host.IsPin(pin, parent, id)
        return type(id) == "number" and id >= 1 and id <= MAX_PINS and id == math.floor(id)
            and chrome.mutable(pin) and chrome.read(pin, "GetParent") == parent
            and chrome.read(pin, "GetObjectType") == "Button" and chrome.read(pin, "GetID") == id
            and chrome.member(_G, "TaxiButton" .. id) == pin
    end

    local function collectPins(root, routeMap, close, recoveryArt, activeCount)
        local pins, found, hasMap, hasClose = {}, {}, false, false
        if type(activeCount) ~= "number" or activeCount < 1 or activeCount > MAX_PINS
            or activeCount ~= math.floor(activeCount) then return nil end
        for _, parent in ipairs({root, routeMap}) do
            local get = chrome.method(parent, "GetChildren")
            if not get then return nil end
            local ok, children = pcall(function() return {get(parent)} end)
            if not ok or #children > MAX_PINS + 3 then return nil end
            for _, child in ipairs(children) do
                if not chrome.ordinary(child) then return nil end
                if parent == root and child == routeMap then
                    hasMap = true
                elseif parent == root and child == close then
                    hasClose = true
                elseif parent ~= root or child ~= recoveryArt then
                    if not chrome.mutable(child) then return nil end
                    local id = chrome.read(child, "GetID")
                    if not host.IsPin(child, parent, id) or found[id]
                        or chrome.read(child, "GetNumChildren") ~= 0 then return nil end
                    found[id] = true
                    pins[#pins + 1] = {frame = child, parent = parent}
                end
            end
        end
        for id = 1, activeCount do
            if not found[id] then return nil end
        end
        if hasMap and hasClose then return pins end
    end

    local function property(plan, frame, getter, setter, value)
        local get, set = chrome.method(frame, getter), chrome.method(frame, setter)
        if not get or not set then return false end
        local ok, original = pcall(get, frame)
        if not ok then return false end
        plan[#plan + 1] = {
            apply = function() set(frame, value) end,
            undo = function() set(frame, original) end,
        }
        return true
    end

    -- Restore parent before the original layer. SetParent can reset frame level.
    local function adopt(plan, frame, parent, target, strata, level)
        if not chrome.mutable(frame) or chrome.read(frame, "GetParent") ~= parent then return false end
        local set = chrome.method(frame, "SetParent")
        if not set then return false end
        local layers = {}
        if level and (not property(layers, frame, "GetFrameStrata", "SetFrameStrata", strata)
            or not property(layers, frame, "GetFrameLevel", "SetFrameLevel", level)) then return false end
        plan[#plan + 1] = {
            apply = function()
                if parent ~= target then set(frame, target) end
                for _, layer in ipairs(layers) do layer.apply() end
            end,
            undo = function()
                if parent ~= target then set(frame, parent) end
                for i = #layers, 1, -1 do layers[i].undo() end
            end,
        }
        return true
    end

    local function quietMouse(plan, frame)
        return chrome.mutable(frame)
            and property(plan, frame, "IsMouseClickEnabled", "SetMouseClickEnabled", false)
            and property(plan, frame, "IsMouseMotionEnabled", "SetMouseMotionEnabled", false)
    end

    function host.Capture(root, map, routeMap, art, recoveryArt, activeCount, x, y, size)
        local close = chrome.member(root, "CloseButton")
        if not chrome.mutable(routeMap) or not chrome.mutable(close)
            or chrome.read(root, "GetParent") ~= UIParent
            or type(chrome.member(_G, "HideUIPanel")) ~= "function" then return nil, "native-close-unavailable" end
        local pins = collectPins(root, routeMap, close, recoveryArt, activeCount)
        if not pins then return nil, "pin-shape-unsupported" end
        local plan, strata, level = {}, art:GetFrameStrata(), art:GetFrameLevel()
        -- Preserve original pin anchors. Native pins are anchored to the map
        -- texture and the native route container draws the matching route lines.
        if not adopt(plan, map, root, art)
            or not chrome.anchor(plan, map, "TOPLEFT", art, "TOPLEFT", x, -y)
            or not chrome.resize(plan, map, size, size)
            or not adopt(plan, routeMap, root, art, strata, level + 1)
            or not chrome.anchor(plan, routeMap, "TOPLEFT", map, "TOPLEFT", 0, 0)
            or not chrome.resize(plan, routeMap, size, size) then return nil, "map-capture-unavailable" end
        for _, pin in ipairs(pins) do
            if not adopt(plan, pin.frame, pin.parent, routeMap, strata, level + 2) then
                return nil, "pin-capture-unavailable"
            end
        end
        if not quietMouse(plan, root) or not quietMouse(plan, close) or not chrome.fade(plan, root) then
            return nil, "stock-capture-unavailable"
        end
        return plan, "captured", pins
    end

    function host.MatchesScale(art, routeMap, pins)
        local scale = chrome.read(art, "GetEffectiveScale")
        if type(scale) ~= "number" or scale <= 0 then return false end
        local function matches(frame)
            if not chrome.mutable(frame) then return false end
            local actual = chrome.read(frame, "GetEffectiveScale")
            return type(actual) == "number" and actual > 0 and math.abs(actual - scale) < 0.001
        end
        if not matches(routeMap) then return false end
        for _, pin in ipairs(pins) do
            if not matches(pin.frame) then return false end
        end
        return true
    end
end
local hostResult = "not-attempted"
local config = Logres.PanelConfigs.trainer
local visual, palette = config.preview, config.landscape.palette
local mapX, mapY, mapSize = 279, 100, 580
local live, preview, visit, stockOnly
local result, opens, restores = "idle", 0, 0
local lastState, lastFare
local routeRequests = 0
local hostGate, hostChildren, hostChild
local hostInventoryStatus, hostInventory
local MAX_INVENTORY_CHILDREN = 32
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
        if pin and not pins[pin] and (host.IsPin(pin, routeMap, i) or host.IsPin(pin, root, i)) then
            local hook = chrome.method(pin, "HookScript")
            if hook then
                local attached = pcall(hook, pin, "OnEnter", function(button)
                    if live and live.root == root and not live.pending then
                        local index = chrome.read(button, "GetID")
                        if type(index) == "number" and index >= 1 and index <= 400
                            and index == math.floor(index) then showPin(live.art.view, index) end
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

local function normalizeScale(changes, root)
    if chrome.read(root, "GetParent") ~= UIParent then return false end
    local get, set = chrome.method(root, "GetScale"), chrome.method(root, "SetScale")
    if not get or not set then return false end
    local ok, stockScale = pcall(get, root)
    if not ok then return false end
    -- The native value is an opaque token used only to restore the original panel.
    changes[#changes + 1] = {
        apply = function() set(root, 1) end,
        undo = function() set(root, stockScale) end,
    }
    return true
end

local function matchesParentScale(root)
    local actual = chrome.read(root, "GetEffectiveScale")
    local expected = chrome.read(UIParent, "GetEffectiveScale")
    return type(actual) == "number" and type(expected) == "number"
        and actual > 0 and expected > 0 and math.abs(actual - expected) < 0.001
end

local function capture(root, map)
    local close = chrome.member(root, "CloseButton")
    if not chrome.member(root, "Bg") or not chrome.member(root, "TitleText") then return nil end
    local changes = {}
    if not chrome.anchor(changes, root, visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
        or not normalizeScale(changes, root)
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

local function restore(reason, closing)
    if not live then return true end
    if closing and live.centered then live.art:Hide() end
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
    if not (host.IsPin(pin, session.routeMap, id) or host.IsPin(pin, session.root, id))
        or chrome.read(pin, "IsShown") ~= true
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
    local art = CreateFrame("Frame", nil, root)
    art:Hide()
    art:SetAllPoints(root)
    local level = chrome.read(root, "GetFrameLevel")
    if type(level) ~= "number" then return nil end
    art:SetFrameLevel(math.max(0, level - 1))
    art:EnableMouse(false)
    -- The text sits above native backing, while map artwork and input stay clear.
    local labels = CreateFrame("Frame", nil, art)
    labels:SetAllPoints(art)
    labels:SetFrameLevel(level + 2)
    labels:EnableMouse(false)
    art.view = paint(art, false, labels)
    return art
end

local function buildShell(sample, onGoodbye)
    local art = CreateFrame("Frame", nil, UIParent)
    art:Hide()
    art:SetSize(visual.width, visual.height)
    art:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
    art:SetFrameStrata(visual.strata)
    art:EnableMouse(false)
    art.view = paint(art, sample)
    local goodbye = CreateFrame("Button", nil, art)
    goodbye:SetSize(78, 24)
    goodbye:SetPoint("TOPRIGHT", art, "TOPRIGHT", -45, -12)
    chrome.goodbyeArt(goodbye)
    goodbye:SetScript("OnClick", function() onGoodbye(art) end)
    return art
end

local function buildHost(root)
    return buildShell(false, function(art)
        if live and live.art == art and not live.pending and chrome.unlocked() then
            local hide = chrome.member(_G, "HideUIPanel")
            if type(hide) == "function" then pcall(hide, root) end
        end
    end)
end

-- P0401: replay the retired host's capture checks without applying a plan.
-- Return bounded capability labels only. No original anchors or properties
-- are exposed, and this result never gates the recovered presentation.
local function propertyGate(frame, getName, setName, prefix)
    local get = chrome.method(frame, getName)
    if not get then return prefix .. "-getter" end
    if not chrome.method(frame, setName) then return prefix .. "-setter" end
    if not pcall(get, frame) then return prefix .. "-read" end
end

local function adoptionGate(root, child, prefix)
    if not chrome.mutable(child) then return prefix .. "-protected-or-unknown" end
    if chrome.read(child, "GetParent") ~= root then return prefix .. "-parent" end
    if not chrome.method(child, "SetParent") then return prefix .. "-set-parent" end
    -- The shared helpers capture opaque rollback tokens. The throwaway plans
    -- are discarded here, so no native setters or stored undo handlers run.
    if not chrome.anchor({}, child, "TOPLEFT", root, "TOPLEFT", 0, 0) then
        return prefix .. "-anchor-capture"
    end
    if not chrome.resize({}, child, mapSize, mapSize) then return prefix .. "-size-capture" end
end

local function mouseGate(frame, prefix)
    if not chrome.mutable(frame) then return prefix .. "-protected-or-unknown" end
    return propertyGate(frame, "IsMouseClickEnabled", "SetMouseClickEnabled", prefix .. "-click")
        or propertyGate(frame, "IsMouseMotionEnabled", "SetMouseMotionEnabled", prefix .. "-motion")
end

local function frameLabel(frame)
    local name = chrome.read(frame, "GetName")
    if type(name) ~= "string" or name == "" then name = chrome.read(frame, "GetDebugName") end
    if type(name) == "string" and #name <= 80 and name:match("^%a[%w_.]*$") then
        return name
    end
end

local function describeChild(child, index, routeMap, close)
    local row = {index = index}
    if not chrome.ordinary(child) then
        row.input = "restricted"
        return row
    end
    row.role = child == routeMap and "route-map" or (child == close and "close" or "other")
    if not chrome.mutable(child) then
        row.input = "protected-or-unknown"
        return row
    end

    row.name = frameLabel(child)
    local kind = chrome.read(child, "GetObjectType")
    if type(kind) == "string" and #kind <= 32 and kind:match("^%a+$") then row.kind = kind end
    local click = chrome.read(child, "IsMouseClickEnabled")
    local motion = chrome.read(child, "IsMouseMotionEnabled")
    local descendants = chrome.read(child, "GetNumChildren")
    if type(click) == "boolean" then row.click = click end
    if type(motion) == "boolean" then row.motion = motion end
    if type(descendants) == "number" and descendants >= 0 and descendants <= 1024
        and descendants == math.floor(descendants) then
        row.children = descendants
    end
    if row.click or row.motion then
        row.input = "direct"
    elseif row.click == false and row.motion == false and row.children == 0 then
        row.input = "inert-leaf"
    elseif row.children and row.children > 0 then
        row.input = "descendants-unchecked"
    else
        row.input = "unknown"
    end
    return row
end

local function inventoryChildren(children, recoveryArt, routeMap, close)
    if #children > MAX_INVENTORY_CHILDREN + (recoveryArt and 1 or 0) then
        hostInventoryStatus = "limit"
        return
    end
    local rows = {}
    for _, child in ipairs(children) do
        if not chrome.ordinary(child) or child ~= recoveryArt then
            if #rows == MAX_INVENTORY_CHILDREN then
                hostInventoryStatus = "limit"
                return
            end
            rows[#rows + 1] = describeChild(child, #rows + 1, routeMap, close)
        end
    end
    hostInventory, hostInventoryStatus = rows, "complete"
end

local function childGate(root, routeMap, close)
    local get = chrome.method(root, "GetChildren")
    if not get then return "children-method" end
    local ok, children = pcall(function() return {get(root)} end)
    if not ok then return "children-read" end
    -- The recovered art is a child of TaxiFrame on later visits. P0400's
    -- separate host was not, so omit only this exact addon-owned frame.
    local recoveryArt = frames[root] and frames[root].art
    inventoryChildren(children, recoveryArt, routeMap, close)
    local native = {}
    for index, child in ipairs(children) do
        if not chrome.ordinary(child) then
            hostChild = index
            return "child-restricted"
        end
        if child ~= recoveryArt then native[#native + 1] = child end
    end
    hostChildren = #native
    if #native < 2 or #native > 8 then return "children-count" end
    local mapFound, closeFound = false, false
    for index, child in ipairs(native) do
        if child == routeMap then
            mapFound = true
        elseif child == close then
            closeFound = true
        else
            hostChild = index
            if not chrome.mutable(child) then return "extra-child-protected-or-unknown" end
            if chrome.read(child, "IsMouseClickEnabled") ~= false then return "extra-child-click" end
            if chrome.read(child, "IsMouseMotionEnabled") ~= false then return "extra-child-motion" end
            if chrome.read(child, "GetNumChildren") ~= 0 then return "extra-child-descendants" end
            hostChild = nil
        end
    end
    if not mapFound then return "children-route-map-missing" end
    if not closeFound then return "children-close-missing" end
end

local function probeHost(root, map, routeMap)
    if chrome.read(root, "GetParent") ~= UIParent then return "root-parent" end
    local close = chrome.member(root, "CloseButton")
    if not close then return "close-missing" end
    return childGate(root, routeMap, close)
        or adoptionGate(root, map, "map")
        or adoptionGate(root, routeMap, "route-map")
        or propertyGate(routeMap, "GetFrameStrata", "SetFrameStrata", "route-map-strata")
        or propertyGate(routeMap, "GetFrameLevel", "SetFrameLevel", "route-map-level")
        or mouseGate(root, "root-mouse")
        or mouseGate(close, "close-mouse")
        or propertyGate(root, "GetAlpha", "SetAlpha", "root-alpha")
        or "capture-passed"
end

local function activate(root, routeMap, art, plan, hostedPins)
    if preview then preview:Hide() end
    art.view.origin:SetText("Current flight master")
    local list = art.view.routes
    list.page, list.highlight, list.locked, list.message = 1, nil, false, nil
    lastState, lastFare = nil, nil
    live = {root = root, routeMap = routeMap, art = art, plan = plan, applied = 0,
        centered = hostedPins ~= nil, hostedPins = hostedPins}
    for i, action in ipairs(plan) do
        live.applied = i
        if not pcall(action.apply) then return false, "stock-layout-restored" end
    end
    if hostedPins then
        if not host.MatchesScale(art, routeMap, hostedPins) then return false, "stock-scale-mismatch" end
    elseif not matchesParentScale(root) then
        return false, "stock-scale-mismatch"
    end
    if not pcall(art.Show, art) then return false, "stock-art-restored" end
    pcall(bindPins, root, routeMap, art.view)
    if not pcall(refreshRoutes, live) then return false, "stock-routes-unavailable" end
    opens = opens + 1
    result = "taxi-layout-active"
    return true
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
    local probed, gate = pcall(probeHost, root, map, routeMap)
    hostGate = probed and gate or "probe-error"
    local cache = frames[root]
    if not cache.host then
        local built, art = pcall(buildHost, root)
        if built then cache.host = art end
    end
    hostResult = "center-art-unavailable"
    if cache.host then
        local captured, plan, reason, hostedPins = pcall(host.Capture, root, map, routeMap,
            cache.host, cache.art, readAPI("NumTaxiNodes"), mapX, mapY, mapSize)
        hostResult = captured and reason or "center-capture-error"
        if captured and plan then
            local started, failure = activate(root, routeMap, cache.host, plan, hostedPins)
            if started then hostResult = "centered"; return end
            hostResult = failure
            if not restore(failure) then stockOnly = true; return end
        end
    end
    local ok, plan = pcall(capture, root, map)
    if not ok or not plan then stockOnly, result = true, "stock-layout-unsupported"; return end
    if not cache.art then
        local built, art = pcall(buildArt, root)
        if not built or not art then stockOnly, result = true, "stock-art-unavailable"; return end
        cache.art = art
    end
    if preview then preview:Hide() end
    local started, failure = activate(root, routeMap, cache.art, plan)
    if not started then
        stockOnly = true
        restore(failure)
    end
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
        lastNodeState = lastState, lastFareCopper = lastFare,
        hostGate = hostGate, hostChildren = hostChildren, hostChild = hostChild,
        hostResult = hostResult, centered = live and live.centered or false,
        hostInventoryStatus = hostInventoryStatus,
        routeRequests = routeRequests, routes = live and #live.art.view.routes.records or 0}
end

function Flight.GetHostChildAudit()
    return hostInventory
end

local function buildPreview()
    local root = buildShell(true, function(art) art:Hide() end)
    local view = root.view
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
        chrome.text(pin, "ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢ " .. point[1], "GameFontHighlight", 0, 0, 135, palette.goldText)
        pin:SetScript("OnClick", function()
            view.routes.highlight = point[4]
            renderRoutes(view.routes)
        end)
    end
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
    hostGate, hostChildren, hostChild = nil, nil, nil
    hostInventory, hostInventoryStatus = nil, "not-sampled"
    hostResult = "not-attempted"
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
    elseif live and not (live.centered and host.MatchesScale(live.art, live.routeMap, live.hostedPins)
        or not live.centered and matchesParentScale(live.root)) then
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
