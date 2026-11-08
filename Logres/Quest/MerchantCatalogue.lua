-- P0392: one renderer for the merchant preview and explicit live catalogue.
local _, Logres = ...
local Merchant = {}
Logres.NPCMerchantCatalogue = Merchant

local ROWS, LIMIT = 7, 200
local WIDTH, HEIGHT = 438, 394
local view, model, offset
local visit, live = false, false
local scenario, reads, result = 0, 0, "idle"
local labels = {
    empty = "This merchant has no items.",
    unavailable = "Catalogue unavailable. See Blizzard's merchant window.",
    handoff = "Use the native merchant window for transactions.",
}

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function field(info, key, kind)
    local value = info[key]
    if ordinary(value) and type(value) == kind then return value end
end

local function rowFromInfo(info)
    if not ordinary(info) or type(info) ~= "table" then return nil end
    local name = field(info, "name", "string")
    if not name or name == "" then return nil end
    local currency = info.currencyID
    local currencyKnown = ordinary(currency) and (currency == nil or type(currency) == "number")
    return {
        name = name,
        price = field(info, "price", "number"),
        stack = field(info, "stackCount", "number"),
        stock = field(info, "numAvailable", "number"),
        purchasable = field(info, "isPurchasable", "boolean"),
        extended = field(info, "hasExtendedCost", "boolean"),
        currency = field(info, "currencyID", "number"),
        currencyKnown = currencyKnown,
    }
end

local function readCatalogue()
    local api = C_MerchantFrame and C_MerchantFrame.GetItemInfo
    local legacy = GetMerchantItemInfo
    if type(GetMerchantNumItems) ~= "function"
        or (type(api) ~= "function" and type(legacy) ~= "function") then
        return nil
    end
    local count = GetMerchantNumItems()
    if not ordinary(count) or type(count) ~= "number"
        or count < 0 or count > LIMIT or count ~= math.floor(count) then
        return nil
    end
    local items = {}
    for i = 1, count do
        local info
        if type(api) == "function" then
            info = api(i)
        else
            local name, _, price, stack, stock, purchasable, _, extended, currency = legacy(i)
            info = { name = name, price = price, stackCount = stack, numAvailable = stock,
                isPurchasable = purchasable, hasExtendedCost = extended, currencyID = currency }
        end
        local row = rowFromInfo(info)
        if not row then return nil end
        items[i] = row
    end
    return items
end

local fixtures = {
    { state = "list", items = {
        { name = "Refreshing Spring Water", price = 25, stack = 5, stock = -1, extended = false, currencyKnown = true, purchasable = true },
        { name = "Coarse Thread", price = 10, stock = -1, extended = false, currencyKnown = true, purchasable = true },
        { name = "Pattern: Blue Linen Vest", price = 250, stock = 1, extended = false, currencyKnown = true, purchasable = true },
        { name = "Pattern: Red Linen Bag", price = 400, stock = 0, extended = false, currencyKnown = true, purchasable = false },
        { name = "Supply Satchel", extended = true, stock = 3 },
        { name = "Worn Satchel", price = 10005, stock = -1, extended = false, currencyKnown = true, purchasable = false },
        { name = "Simple Wood", price = 5, stock = -1, extended = false, currencyKnown = true, purchasable = true },
        { name = "Shiny Bauble", price = 50, stock = -1, extended = false, currencyKnown = true, purchasable = true },
    }},
    { state = "empty", items = {} },
    { state = "unavailable", items = {} },
    { state = "handoff", items = {} },
}

local function coin(item)
    local value = item.price
    if item.extended ~= false or not item.currencyKnown or item.currency
        or type(value) ~= "number" or value < 0 or value >= 1e12
        or value ~= math.floor(value) then
        return "See Blizzard"
    end
    if value == 0 then return "Free" end
    local parts = {}
    local gold, silver, copper = math.floor(value / 10000), math.floor(value / 100) % 100, value % 100
    if gold > 0 then parts[#parts + 1] = gold .. "g" end
    if silver > 0 then parts[#parts + 1] = silver .. "s" end
    if copper > 0 then parts[#parts + 1] = copper .. "c" end
    return table.concat(parts, " ")
end

local function stock(item)
    if item.stock == 0 then return "Sold out" end
    if item.purchasable == false then return "Unavailable" end
    if item.stock and item.stock > 0 and item.stock < 40000 and item.stock == math.floor(item.stock) then
        return item.stock .. " in stock"
    end
    if item.purchasable == true and item.stock == -1 then return "In stock" end
    return "See Blizzard"
end

local function render()
    local last = math.max(1, math.floor((#model.items - 1) / ROWS) * ROWS + 1)
    offset = math.min(offset, last)
    local size = math.max(1, math.min(ROWS, #model.items - offset + 1))
    local page, first, _, finish = Logres.NPCServiceCatalogue.Window(model.items, offset, size)
    view.title:SetText(live and "Merchant Catalogue" or "Merchant Catalogue Preview")
    view.mode:SetText(live and "Live stock  /  Read-only" or "Sample stock  /  Preview " .. scenario .. " of 4")
    view.status:SetText(labels[model.state] or "")
    view.footer:SetText(#model.items > 0 and (first .. "–" .. finish .. " of " .. #model.items) or "")
    view.back:SetEnabled(first > 1)
    view.forward:SetEnabled(first < last)
    view.fixture:SetShown(not live)
    for index, frame in ipairs(view.rows) do
        local item = page[index]
        frame:SetShown(item ~= nil)
        if item then
            local quantity = item.stack and item.stack > 1 and item.stack < LIMIT * LIMIT
                and "  ×" .. item.stack or ""
            frame.name:SetText(item.name .. quantity)
            frame.price:SetText(coin(item))
            frame.stock:SetText(stock(item))
        end
    end
    view:Show()
end

local function close(reason)
    live, model = false, nil
    if view then view:Hide() end
    if reason then result = reason end
end

local function text(parent, font, point, x, y)
    local label = parent:CreateFontString(nil, "OVERLAY", font)
    label:SetPoint(point, parent, point, x, y)
    return label
end

local function button(parent, caption, width, point, x, y, action)
    local control = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    control:SetSize(width, 24)
    control:SetPoint(point, parent, point, x, y)
    control:SetText(caption)
    control:SetScript("OnClick", action)
    return control
end

local function ensureView()
    if view then return end
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:Hide()
    frame:SetSize(WIDTH, HEIGHT)
    frame:SetPoint("TOP", UIParent, "TOP", 184, -104)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("DIALOG")
    frame:EnableMouse(false)
    local art = Logres.Theme.panelSurface
    assert(Logres.PanelSurface.Paint(frame, {
        background = { mode = "stretch", texture = art.assets.panel, layer = "BACKGROUND" },
        divider = { texture = art.assets.divider, layer = "ARTWORK",
            horizontalInset = 48, height = 16, x = 0, y = -54 },
    }, WIDTH, HEIGHT))
    frame.title = text(frame, "GameFontNormalLarge", "TOP", 0, -17)
    frame.mode = text(frame, "GameFontHighlightSmall", "TOP", 0, -39)
    frame.status = text(frame, "GameFontHighlight", "CENTER", 0, 0)
    frame.status:SetWidth(WIDTH - 48)
    frame.footer = text(frame, "GameFontHighlightSmall", "BOTTOM", 0, 59)
    text(frame, "GameFontHighlightSmall", "BOTTOM", 0, 13):SetText("Purchases, sales, buyback and repairs use Blizzard's window.")
    button(frame, "Close", 58, "TOPRIGHT", -15, -16, function() close("dismissed") end)
    frame.fixture = button(frame, "Next sample", 96, "BOTTOM", 0, 29, function() Merchant.Preview() end)
    frame.back = button(frame, "Previous", 78, "BOTTOMLEFT", 24, 29, function()
        offset = math.max(1, offset - ROWS)
        render()
    end)
    frame.forward = button(frame, "Next", 78, "BOTTOMRIGHT", -24, 29, function()
        offset = offset + ROWS
        render()
    end)
    frame.rows = {}
    for i = 1, ROWS do
        local row = CreateFrame("Frame", nil, frame)
        row:SetSize(WIDTH - 48, 34)
        row:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -67 - (i - 1) * 36)
        row.name = text(row, "GameFontHighlight", "TOPLEFT", 2, -2)
        row.name:SetWidth(251)
        row.name:SetJustifyH("LEFT")
        row.name:SetMaxLines(1)
        row.price = text(row, "GameFontNormal", "TOPRIGHT", -2, -2)
        row.stock = text(row, "GameFontHighlightSmall", "BOTTOMLEFT", 2, 2)
        frame.rows[i] = row
    end
    view = frame
end

local function show()
    local ok = pcall(function()
        ensureView()
        render()
    end)
    if not ok then
        close("display-unavailable")
        return false, result
    end
    return true, result
end

function Merchant.Preview()
    live, offset = false, 1
    scenario = scenario % #fixtures + 1
    model = fixtures[scenario]
    result = "preview-" .. model.state
    return show()
end

local function refresh()
    reads = reads + 1
    local ok, items = pcall(readCatalogue)
    if not ok or not items then
        model = { state = "unavailable", items = {} }
    else
        model = { state = #items == 0 and "empty" or "list", items = items }
    end
    result = "live-" .. model.state
    return show()
end

local function merchantContext(state)
    return Logres:GetPreference("immersionEnabled") == true
        and state and state.interacting == true
        and state.interactionType == 5
end

function Merchant.OpenLive()
    if not visit or not merchantContext(Logres:GetState()) then
        return false, "open a Blizzard merchant while Immersion is on"
    end
    live, offset = true, 1
    return refresh()
end

function Merchant.GetAudit()
    return { result = result, visit = visit, live = live, reads = reads,
        rows = model and #model.items or 0, nativeOwner = "Blizzard" }
end

Logres:RegisterEvent("MERCHANT_SHOW", function()
    if live then close("merchant-reopened") end
    visit = true
end)
Logres:RegisterEvent("MERCHANT_UPDATE", function()
    if live then refresh() end
end)
Logres:RegisterEvent("MERCHANT_CLOSED", function()
    visit = false
    if live then close("merchant-closed") end
end)
Logres:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    visit = false
    close("world-changed")
end)
Logres:SubscribeState(function(state)
    if live and not merchantContext(state) then close("merchant-context-ended") end
end)
Logres:SubscribePreferences(function(preferences)
    if live and not preferences.immersionEnabled then close("immersion-off") end
end)

return Merchant
