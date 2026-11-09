-- P0393: trainer-style presentation around the original merchant controls.
local _, Logres = ...
local Merchant = {}
Logres.NPCMerchantCatalogue = Merchant

local config = Logres.PanelConfigs.trainer
local visual, style = config.preview, config.landscape
local palette, geometry = style.palette, style.geometry
local list, sidebar = geometry.list, geometry.left
local firstX, firstY, columnGap = list.x + 22, list.y + 31, 125
local live, preview, visit, stockOnly
local guildPreviewStep = 0
local merchantState = false
local hooked = setmetatable({}, {__mode = "k"})
local result, starts, restores = "idle", 0, 0
local goodbyeWidth, goodbyeHeight, goodbyeX, goodbyeY = 78, 24, -45, -12
local pagerCenter, pagerY, chevronGap = list.x + list.w / 2 - 28, 91, 78

local function text(parent, value, font, x, y, width, color, align)
    local label = parent:CreateFontString(nil, "OVERLAY", font)
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", x, -y)
    label:SetSize(width, 22)
    label:SetJustifyH(align or "LEFT")
    label:SetTextColor(unpack(color))
    label:SetText(value)
    return label
end

local function wash(parent, x, y, w, h, rgba)
    local texture = parent:CreateTexture(nil, "BORDER")
    texture:SetPoint("TOPLEFT", parent, "TOPLEFT", x, -y)
    texture:SetSize(w, h)
    texture:SetColorTexture(unpack(rgba))
end

local function goodbyeArt(owner)
    local label = owner:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetAllPoints(owner)
    label:SetText("Goodbye")
    label:SetTextColor(0.97, 0.78, 0.44, 1)
    local line = owner:CreateTexture(nil, "ARTWORK")
    line:SetColorTexture(0.77, 0.60, 0.32, 0.72)
    line:SetHeight(1)
    line:SetPoint("BOTTOMLEFT", owner, "BOTTOMLEFT", 5, 0)
    line:SetPoint("BOTTOMRIGHT", owner, "BOTTOMRIGHT", -5, 0)
end

local function tabArt(owner, caption)
    local fill = owner:CreateTexture(nil, "BACKGROUND")
    fill:SetAllPoints(owner)
    fill:SetColorTexture(unpack(palette.active))
    local line = owner:CreateTexture(nil, "ARTWORK")
    line:SetPoint("TOPLEFT", owner, "TOPLEFT", 1, -3)
    line:SetPoint("BOTTOMLEFT", owner, "BOTTOMLEFT", 1, 3)
    line:SetWidth(2)
    line:SetColorTexture(unpack(palette.gold))
    -- Fixtures need a label. Live tabs already have Blizzard's localized text.
    local label
    if caption then
        label = owner:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetAllPoints(owner)
        label:SetText(caption)
    end
    return function(active)
        fill:SetShown(active)
        line:SetShown(active)
        if label then
            label:SetTextColor(unpack(active and palette.goldText or palette.body))
        end
    end
end

local function shell(owner, title, sample)
    assert(Logres.PanelSurface.Paint(owner, config.surface, visual.width, visual.height))
    local function label(value, x, y, width, tint)
        return text(owner, value, "GameFontHighlight", x, y, width, tint or palette.body)
    end
    wash(owner, sidebar.x, sidebar.y, sidebar.w, sidebar.h, palette.sidebarWash)
    wash(owner, list.x, list.y, list.w, list.h, palette.catalogueWash)
    wash(owner, sidebar.x + sidebar.w + 7, sidebar.y + 8, 1, sidebar.h - 16, palette.sidebarRule)
    wash(owner, 28, 85, visual.width - 56, 1, palette.gold)
    wash(owner, 28, 525, visual.width - 56, 1, palette.gold)
    local heading = text(owner, title, "GameFontHighlightLarge", 120, 19, visual.width - 240,
        palette.goldText, "CENTER")
    text(owner, sample and "MERCHANT  /  PREVIEW" or "MERCHANT  /  LIVE STOCK",
        "GameFontHighlightSmall", 120, 49, visual.width - 240, palette.muted, "CENTER")
    label("Merchant services", 42, 107, 200, palette.goldText)
    label("Buying and selling", 42, 196, 200, palette.goldText)
    label("Right-click an item to buy.", 42, 224, 200)
    label("Shift-click to choose quantity.", 42, 247, 200)
    label("Sell items from your bags.", 42, 270, 200)
    label("Stock and prices", list.x + 16, list.y + 4, 200, palette.goldText)
    label("Service controls", 42, 541, 240, palette.goldText)
    label("Repairs and other services appear when offered.", 42, 571, 440, palette.muted)
    return heading
end

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function member(owner, key)
    local ok, value = pcall(function() return owner[key] end)
    if ok and ordinary(value) then return value end
end

local function method(owner, key)
    local value = member(owner, key)
    if type(value) == "function" then return value end
end

local function read(owner, key)
    local fn = method(owner, key)
    if not fn then return nil end
    local ok, value = pcall(fn, owner)
    if ok and ordinary(value) then return value, true end
    return nil, false
end

local function unlocked()
    if type(InCombatLockdown) ~= "function" then return false end
    local ok, locked = pcall(InCombatLockdown)
    return ok and ordinary(locked) and locked == false
end

local function mutable(frame)
    return frame and read(frame, "IsForbidden") == false and read(frame, "IsProtected") == false
end

local function fits()
    local w, h = read(UIParent, "GetWidth"), read(UIParent, "GetHeight")
    return type(w) == "number" and w >= visual.width
        and type(h) == "number" and h >= visual.height + math.abs(visual.y)
end

-- Native values in these captures are opaque restoration tokens.
local function anchor(plan, frame, point, relative, relativePoint, x, y)
    if not mutable(frame) then return false end
    local count = read(frame, "GetNumPoints")
    local get = method(frame, "GetPoint")
    local clear, set = method(frame, "ClearAllPoints"), method(frame, "SetPoint")
    if not get or not clear or not set or type(count) ~= "number"
        or count < 1 or count > 8 or count ~= math.floor(count) then return false end
    local old = {}
    for i = 1, count do
        local ok, p, r, rp, a, b = pcall(get, frame, i)
        if not ok then return false end
        old[i] = {p, r, rp, a, b}
    end
    plan[#plan + 1] = {
        apply = function()
            clear(frame)
            set(frame, point, relative, relativePoint, x, y)
        end,
        undo = function()
            clear(frame)
            for _, token in ipairs(old) do set(frame, unpack(token, 1, 5)) end
        end,
    }
    return true
end

local function resize(plan, frame, width, height)
    local get, set = method(frame, "GetSize"), method(frame, "SetSize")
    if not get or not set then return false end
    local ok, w, h = pcall(get, frame)
    if not ok then return false end
    plan[#plan + 1] = {
        apply = function() set(frame, width, height) end,
        undo = function() set(frame, w, h) end,
    }
    return true
end

-- Optional, named decorative regions only. No controls, visibility or scripts.
local function fade(plan, region)
    if not mutable(region) then return false end
    local get, set = method(region, "GetAlpha"), method(region, "SetAlpha")
    if not get or not set then return false end
    local ok, alpha = pcall(get, region)
    if not ok then return false end
    plan[#plan + 1] = {
        apply = function() set(region, 0) end,
        undo = function() set(region, alpha) end,
    }
    return true
end

local decorations = {"MerchantFramePortrait", "MerchantNameText", "BuybackBG",
    "MerchantFrameBottomLeftBorder", "MerchantFrameBottomRightBorder"}
local rootDecorations = {"Bg", "TitleBg", "TopTileStreaks", "PortraitContainer",
    "NineSlice", "Inset", "TitleText"}

local controlArt = setmetatable({}, {__mode = "k"})

local function artwork(button, render, caption, level)
    local existing = controlArt[button]
    if existing then return existing.frame, existing.select end
    local overlay = CreateFrame("Frame", nil, button)
    overlay:Hide()
    overlay:EnableMouse(false)
    overlay:SetAllPoints(button)
    if level then overlay:SetFrameLevel(level) end
    local select = render(overlay, caption)
    controlArt[button] = {frame = overlay, select = select}
    return overlay, select
end

local function append(plan, changes)
    for _, action in ipairs(changes) do plan[#plan + 1] = action end
end

local function present(plan, overlay)
    plan[#plan + 1] = {
        apply = function() overlay:Show() end,
        undo = function() overlay:Hide() end,
    }
end

local function goodbye(plan, frame, button)
    local changes = {}
    for _, key in ipairs({"GetNormalTexture", "GetPushedTexture", "GetHighlightTexture", "GetDisabledTexture"}) do
        local region, known = read(button, key)
        if not known or (not region and key == "GetNormalTexture")
            or (region and not fade(changes, region)) then return false end
    end
    if not resize(changes, button, goodbyeWidth, goodbyeHeight)
        or not anchor(changes, button, "TOPRIGHT", frame, "TOPRIGHT", goodbyeX, goodbyeY) then
        return false
    end
    local ok, overlay = pcall(artwork, button, goodbyeArt)
    if not ok then return false end
    present(changes, overlay)
    append(plan, changes)
    return true
end

local function selectedTab(frame)
    local id = member(frame, "selectedTab")
    if id == 1 or id == 2 then return id end
end

local function refreshTabs()
    if not live or not live.tabs then return end
    local id = selectedTab(live.frame)
    if id then
        for i, update in ipairs(live.tabs) do update(i == id) end
    end
end

local tabHooks = setmetatable({}, {__mode = "k"})
local function skinTabs(plan, frame, first, second)
    local id = selectedTab(frame)
    if not id then return nil end
    local changes, tabs = {}, {}
    for i, button in ipairs({first, second}) do
        local modern = member(button, "Left") ~= nil
        local suffixes = modern and {"Left", "Middle", "Right", "LeftActive", "MiddleActive", "RightActive",
            "LeftHighlight", "MiddleHighlight", "RightHighlight"}
            or {"Left", "Middle", "Right", "LeftDisabled", "MiddleDisabled", "RightDisabled", "HighlightTexture"}
        for _, suffix in ipairs(suffixes) do
            local region = modern and member(button, suffix) or member(_G, "MerchantFrameTab" .. i .. suffix)
            if not fade(changes, region) then return nil end
        end
        local level = read(button, "GetFrameLevel")
        if type(level) ~= "number" or level < 1 then return nil end
        if not tabHooks[button] then
            local hook = method(button, "HookScript")
            if not hook or not pcall(hook, button, "OnClick", refreshTabs) then return nil end
            tabHooks[button] = true
        end
        local ok, overlay, select = pcall(artwork, button, tabArt, nil, level - 1)
        if not ok then return nil end
        select(i == id)
        tabs[i] = select
        present(changes, overlay)
    end
    append(plan, changes)
    return tabs
end

local function pagerArt(owner, previous)
    local texture = Logres.NPCNarrativePages.CreateChevron(owner, previous)
    local colors = Logres.Theme.questDialogue.colors
    return function(enabled)
        texture:SetVertexColor(unpack(enabled and colors.pageActive or colors.pageInactive))
    end
end

local pagerHooks = setmetatable({}, {__mode = "k"})

local function skinPageButton(plan, button, previous)
    if not mutable(button) then return false end
    local enabled = read(button, "IsEnabled")
    local get = method(button, "GetRegions")
    local hook = method(button, "HookScript")
    if type(enabled) ~= "boolean" or not get or not hook then return false end
    local ok, regions = pcall(function() return {get(button)} end)
    if not ok or #regions < 2 or #regions > 8 then return false end

    -- The two stock merchant pager buttons have a static word label and
    -- decorative textures. Refuse an unexpected child or region shape.
    local labels, seen = 0, {}
    for _, region in ipairs(regions) do
        if not ordinary(region) or read(region, "GetParent") ~= button then return false end
        local kind = read(region, "GetObjectType")
        if kind == "FontString" then
            labels = labels + 1
        elseif kind ~= "Texture" then
            return false
        end
        if not fade(plan, region) then return false end
        seen[region] = true
    end
    if labels ~= 1 then return false end
    for _, key in ipairs({"GetNormalTexture", "GetPushedTexture", "GetDisabledTexture", "GetHighlightTexture"}) do
        local region, known = read(button, key)
        if not known or (not region and key == "GetNormalTexture") then return false end
        if region and not seen[region] then
            if read(region, "GetParent") ~= button or not fade(plan, region) then return false end
            seen[region] = true
        end
    end

    local painted, overlay, select = pcall(artwork, button, pagerArt, previous)
    if not painted then return false end
    local registered = pagerHooks[button]
    if not registered then
        registered = {}
        pagerHooks[button] = registered
    end
    if not registered.enable then
        registered.enable = pcall(hook, button, "OnEnable", function() select(true) end)
    end
    if not registered.disable then
        registered.disable = pcall(hook, button, "OnDisable", function() select(false) end)
    end
    if not registered.enable or not registered.disable then return false end
    select(enabled)
    present(plan, overlay)
    return true
end

local function placePager(plan, frame)
    local changes, art = {}, {}
    local prev, nextPage = member(_G, "MerchantPrevPageButton"), member(_G, "MerchantNextPageButton")
    local label = member(_G, "MerchantPageText")
    local styled = skinPageButton(art, prev, true) and skinPageButton(art, nextPage, false)
    local gap = styled and chevronGap or 107
    if not anchor(changes, prev, "CENTER", frame, "BOTTOMLEFT", pagerCenter - gap, pagerY)
        or not anchor(changes, nextPage, "CENTER", frame, "BOTTOMLEFT", pagerCenter + gap, pagerY)
        or not anchor(changes, label, "CENTER", frame, "BOTTOMLEFT", pagerCenter, pagerY) then
        return false
    end
    append(plan, changes)
    if styled then append(plan, art) end
    return styled
end

local function capture(frame)
    local plan = {}
    local close = member(frame, "CloseButton")
    local tab = member(_G, "MerchantFrameTab1")
    local secondTab = member(_G, "MerchantFrameTab2")
    local first = member(_G, "MerchantItem1")
    if not close or not tab or not secondTab or not first then return nil end
    -- Verify both native tabs and every item has a real input target. Their
    -- buttons, IDs, tooltip/modified clicks and scripts stay native.
    for i = 1, 12 do
        local row = member(_G, "MerchantItem" .. i)
        local button = row and member(row, "ItemButton")
        if not button or read(row, "GetParent") ~= frame or read(button, "GetParent") ~= row then
            return nil
        end
    end
    if not anchor(plan, frame, visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
        or not resize(plan, frame, visual.width, visual.height)
        or not anchor(plan, tab, "TOPLEFT", frame, "TOPLEFT", 38, -140)
        or not anchor(plan, secondTab, "LEFT", tab, "RIGHT", 6, 0)
        or not anchor(plan, first, "TOPLEFT", frame, "TOPLEFT", firstX, -firstY) then
        return nil
    end
    for i = 2, 12, 2 do
        local row = member(_G, "MerchantItem" .. i)
        local previous = member(_G, "MerchantItem" .. (i - 1))
        if not anchor(plan, row, "TOPLEFT", previous, "TOPRIGHT", columnGap, 0) then return nil end
    end
    for i = 1, 12 do
        fade(plan, member(_G, "MerchantItem" .. i .. "NameFrame"))
    end
    for _, key in ipairs(decorations) do fade(plan, member(_G, key)) end
    for _, key in ipairs(rootDecorations) do fade(plan, member(frame, key)) end
    local title = member(frame, "TitleContainer")
    if title then fade(plan, member(title, "TitleText")) end
    -- Some layouts expose an item-filter dropdown in the upper right.
    local filter = member(frame, "FilterDropdown")
    if filter and not anchor(plan, filter, "TOPRIGHT", frame, "TOPRIGHT", -45, -97) then
        return nil
    end
    local goodbyeMode = goodbye(plan, frame, close) and "goodbye" or "stock-x"
    if goodbyeMode == "stock-x" and not anchor(plan, close, "TOPRIGHT", frame, "TOPRIGHT", -34, -20) then
        return nil
    end
    local tabs = skinTabs(plan, frame, tab, secondTab)
    local pagerStyled = placePager(plan, frame)
    return plan, goodbyeMode, tabs, pagerStyled
end

local function restore(reason)
    if not live then return true end
    if not unlocked() then
        live.pending = reason
        result = "combat-restore-deferred"
        return false
    end
    local complete = true
    for i = live.applied, 1, -1 do
        if not pcall(live.plan[i].undo) then complete = false end
    end
    if not complete then
        live.pending = reason
        result = "restore-incomplete"
        return false
    end
    live.art:Hide()
    live = nil
    restores = restores + 1
    result = reason
    return true
end

local function context(state)
    return Logres:GetPreference("immersionEnabled") == true and state
        and state.interacting == true and state.interactionType == 5
end

local artByFrame = setmetatable({}, {__mode = "k"})
local function merchantName()
    if type(UnitName) == "function" then
        local ok, name = pcall(UnitName, "npc")
        if ok and ordinary(name) and type(name) == "string" and name ~= "" then return name end
    end
    return "Merchant"
end

local function buildLiveArt(frame)
    local art = artByFrame[frame]
    if art then
        art.heading:SetText(merchantName())
        return art
    end
    local level = read(frame, "GetFrameLevel")
    if type(level) ~= "number" then return nil end
    art = CreateFrame("Frame", nil, frame)
    art:Hide()
    art:SetAllPoints(frame)
    art:SetFrameLevel(math.max(0, level - 1))
    art:EnableMouse(false)
    art.heading = shell(art, merchantName(), false)
    artByFrame[frame] = art
    return art
end

local function apply(frame)
    if live or stockOnly or not visit or not unlocked() or not context(Logres:GetState())
        or not mutable(frame) or read(frame, "IsShown") ~= true then return end
    if not fits() then
        result = "stock-layout-small-viewport"
        return
    end
    local positioning = Logres.NPCNativeServicePlacementTrial.GetAudit()
    if positioning.active ~= "none" or positioning.autoEnabled then
        result = "native-placement-owns-session"
        return
    end
    local ok, plan, goodbyeMode, tabs, pagerStyled = pcall(capture, frame)
    if not ok or not plan then
        stockOnly, result = true, "stock-layout-unsupported"
        return
    end
    local built, art = pcall(buildLiveArt, frame)
    if not built or not art then
        stockOnly, result = true, "stock-art-unavailable"
        return
    end
    if preview then preview:Hide() end
    live = {frame = frame, art = art, plan = plan, applied = 0, goodbye = goodbyeMode,
        tabs = tabs, pagerStyled = pagerStyled}
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
    starts = starts + 1
    result = "merchant-layout-active"
end

local function reconcile()
    if not visit or stockOnly or not unlocked() then return end
    local frame = member(_G, "MerchantFrame")
    if not mutable(frame) then result = "stock-frame-unavailable"; return end
    local hooks = hooked[frame]
    if not hooks then
        hooks = {}
        hooked[frame] = hooks
    end
    local hook = method(frame, "HookScript")
    if not hook then return end
    if not hooks.hide then
        hooks.hide = pcall(hook, frame, "OnHide", function()
            if live and live.frame == frame then restore("merchant-hidden") end
        end)
        if not hooks.hide then result = "stock-hide-hook-unavailable"; return end
    end
    if not hooks.show then
        hooks.show = pcall(hook, frame, "OnShow", function() apply(frame) end)
    end
    apply(frame)
end

function Merchant.IsActive()
    return live ~= nil
end

function Merchant.OpenLive()
    if not visit or not context(Logres:GetState()) then
        return false, "open a merchant while Immersion is on"
    end
    if live then
        stockOnly = true
        return restore("stock-requested"), result
    end
    stockOnly = false
    reconcile()
    return live ~= nil, result
end

local sampleItems = {
    {"Refreshing Spring Water", 132794, "25c  /  ×5"},
    {"Coarse Thread", 132891, "10c"},
    {"Pattern: Blue Linen Vest", 134942, "2s 50c"},
    {"Fine Thread", 132892, "1s"},
    {"Red Dye", 134732, "50c"},
    {"Simple Wood", 135435, "5c"},
    {"Pattern: White Wedding Dress", 134942, "25s"},
    {"Bleach", 134797, "25c"},
    {"Blue Dye", 134731, "50c"},
    {"Bolt of Linen Cloth", 132890, "1s 50c"},
}
local function buildPreview()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:Hide()
    frame:SetSize(visual.width, visual.height)
    frame:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
    frame:SetFrameStrata(visual.strata)
    frame:EnableMouse(false)
    shell(frame, "Tailoring Supplies", true)
    for i, caption in ipairs({"Merchant", "Buyback"}) do
        local tab = CreateFrame("Frame", nil, frame)
        tab:SetSize(80, 30)
        tab:SetPoint("TOPLEFT", frame, "TOPLEFT", 38 + (i - 1) * 86, -140)
        tabArt(tab, caption)(i == 1)
    end
    local rows, perPage = {}, 6
    for i, item in ipairs(sampleItems) do
        local slot = (i - 1) % perPage
        local x = firstX + (slot % 2) * (153 + columnGap)
        local y = firstY + math.floor(slot / 2) * 52
        local row = CreateFrame("Frame", nil, frame)
        row:SetPoint("TOPLEFT", frame, "TOPLEFT", x, -y)
        row:SetSize(270, 42)
        wash(row, -3, -3, 42, 42, palette.iconBorder)
        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(36, 36)
        icon:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
        icon:SetTexture(item[2])
        text(row, item[1], "GameFontHighlight", 45, 0, 224, palette.body)
        text(row, item[3], "GameFontHighlightSmall", 45, 18, 214, palette.goldText)
        rows[i] = row
    end
    local indicator = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    indicator:SetPoint("CENTER", frame, "BOTTOMLEFT", pagerCenter, pagerY)
    indicator:SetTextColor(unpack(Logres.Theme.questDialogue.colors.page))
    local function previewArrow(previous)
        local button = CreateFrame("Button", nil, frame)
        button:SetPoint("CENTER", frame, "BOTTOMLEFT",
            pagerCenter + (previous and -chevronGap or chevronGap), pagerY)
        button:SetSize(28, 28)
        return button, pagerArt(button, previous)
    end
    local prev, paintPrev = previewArrow(true)
    local nextPage, paintNext = previewArrow(false)
    local count = math.ceil(#rows / perPage)
    local page = 1
    local function showPage(target)
        page = target
        for i, row in ipairs(rows) do row:SetShown(math.ceil(i / perPage) == page) end
        indicator:SetFormattedText("%d / %d", page, count)
        prev:SetEnabled(page > 1)
        nextPage:SetEnabled(page < count)
        paintPrev(page > 1)
        paintNext(page < count)
    end
    prev:SetScript("OnClick", function() showPage(math.max(1, page - 1)) end)
    nextPage:SetScript("OnClick", function() showPage(math.min(count, page + 1)) end)
    showPage(1)
    local close = CreateFrame("Button", nil, frame)
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", goodbyeX, goodbyeY)
    close:SetSize(goodbyeWidth, goodbyeHeight)
    goodbyeArt(close)
    close:SetScript("OnClick", function() frame:Hide() end)
    return frame
end

-- P0415: the P carousel keeps merchant preview; registrar uses the SAME
-- NPC quest/option frame fixture as live, not a second painted service panel.
function Merchant.Preview()
    if live or (Logres.NPCGuildRegistrar and Logres.NPCGuildRegistrar.IsVisible()) then
        return false, "close the live NPC service first"
    end
    if guildPreviewStep == 0 then
        if not preview then
            local ok, built = pcall(buildPreview)
            if not ok then return false, "merchant-preview-unavailable" end
            preview = built
        end
        preview:Show()
        guildPreviewStep = 1
        return true, "merchant-preview (next: guild registrar)"
    end
    if guildPreviewStep == 1 then
        if preview then preview:Hide() end
        local ok, reason = Merchant.GuildPreview()
        if not ok then guildPreviewStep = 0; return false, reason end
        guildPreviewStep = 2
        return true, "guild-registrar-option-preview (next: close)"
    end
    if preview then preview:Hide() end
    local d = Logres:GetModule("QuestDialogue")
    if d and d.optionSession and d.optionSession.active
        and not d.optionSession.liveReadOnly and d.optionSession.mode == "guild-registrar" then
        d:HidePresentation("service-previews-closed")
    end
    guildPreviewStep = 0
    return true, "service-previews-closed"
end

function Merchant.GetAudit()
    return {result = result, visit = visit == true, live = live ~= nil,
        starts = starts, restores = restores, pending = live and live.pending or nil,
        goodbye = live and live.goodbye or nil, tabsStyled = live and live.tabs ~= nil or false,
        pagerStyled = live and live.pagerStyled or false,
        nativeOwner = "Blizzard"}
end

-- P0415: Guild Registrar source/action adapter for the existing Quest/NPC
-- narrative and option modules. No separate service frame or Blizzard child
-- geometry. Stock GuildRegistrarFrame remains the transaction owner.
local Registrar = {}
Logres.NPCGuildRegistrar = Registrar
local active, stockOnly = false, false
local opens, closes, deferrals, actions, rejected = 0, 0, 0, 0, 0
local last = "registrar-awaiting-visit"

local function dialogue()
    return Logres:GetModule("QuestDialogue")
end

local function registrarState()
    local state = Logres:GetState()
    return state and state.interacting == true and ordinary(state.interactionType)
        and state.interactionType == 11
end

local function sample()
    if not registrarState() then return nil, "registrar-context-unavailable" end
    local root = member(_G, "GuildRegistrarFrame")
    local greeting = member(_G, "GuildRegistrarGreetingFrame")
    local purchase = member(_G, "GuildRegistrarPurchaseFrame")
    if not mutable(root) or read(root, "IsShown") ~= true
        or not greeting or not purchase or read(greeting, "GetParent") ~= root
        or read(purchase, "GetParent") ~= root then
        return nil, "registrar-native-source-unavailable"
    end
    -- A purchase/edit step is a different, transactional native form. It
    -- remains stock until a dedicated input/controller adapter is proven.
    if read(greeting, "IsShown") ~= true
        or read(purchase, "IsShown") ~= false then
        return nil, "registrar-purchase-stock-owner"
    end
    if type(UnitName) ~= "function" then return nil, "registrar-npc-unavailable" end
    local ok, npc = pcall(UnitName, "npc")
    if not ok or not ordinary(npc) or type(npc) ~= "string"
        or npc == "" or #npc > 100 then
        return nil, "registrar-npc-unvalidated"
    end
    local records, buttons = {}, {}
    for index = 1, 2 do
        local button = member(_G, "GuildRegistrarButton" .. index)
        local label = button and read(button, "GetText")
        local enabled = button and read(button, "IsEnabled")
        local getScript = button and method(button, "GetScript")
        local scriptOK, script = false, nil
        if getScript then scriptOK, script = pcall(getScript, button, "OnClick") end
        if not button or read(button, "GetParent") ~= greeting
            or read(button, "IsShown") ~= true
            or not mutable(button)
            or type(label) ~= "string" or #label < 1 or #label > 100
            or type(enabled) ~= "boolean" or not scriptOK
            or not ordinary(script) or type(script) ~= "function" then
            return nil, "registrar-choice-source-unvalidated"
        end
        buttons[index] = {frame=button, script=script}
        records[index] = {label=label, enabled=false,
            serviceKind="guild-registrar", serviceIndex=index,
            serviceStatus=enabled and 0 or 1,
            reason=enabled and nil or "Unavailable"}
    end
    local model = Logres.NPCOptionModel.FromValidated(npc, "registrar", {
        registrar = {title=npc, body="Available guild services.",
            options=records},
    })
    model.nativeService = "guild-registrar"
    return {model=model, root=root, buttons=buttons}
end

function Registrar.IsVisible()
    local d = dialogue()
    return active and d and d.presentationShown == true
        and d.optionSession and d.optionSession.liveReadOnly == true
        and d.optionSession.model
        and d.optionSession.model.nativeService == "guild-registrar"
end

function Registrar.CanSelect()
    return Registrar.IsVisible() and unlocked()
        and Logres.NPCServiceNativeParking.GetAudit().key == "guild-registrar"
end

-- Every owner of the shared dialogue may request its dismissal. Restore the
-- parked stock root before ANY such dismissal clears the Logres option view.
function Registrar.PrepareDialogueExit(reason)
    if not active then return true end
    local restored = Logres.NPCServiceNativeParking.Restore(reason or "registrar-dialogue-exit")
    if not restored then
        Logres.NPCServiceNativeParking.DeferExit()
        last = "registrar-stock-restore-deferred"
        deferrals = deferrals + 1
        return false
    end
    active = false
    closes = closes + 1
    if not registrarState() then stockOnly = false end
    Logres.NPCServiceSession.Dismiss("guild-registrar")
    last = reason or "registrar-dialogue-exit"
    return true
end

function Registrar.Close(reason)
    if not active then
        if not registrarState() then stockOnly = false end
        return true
    end
    if not Registrar.PrepareDialogueExit(reason or "registrar-exit") then
        return false
    end
    local d = dialogue()
    if d and d.optionSession and d.optionSession.model
        and d.optionSession.model.nativeService == "guild-registrar" then
        d:HidePresentation(reason or "registrar-closed")
    end
    last = reason or "registrar-closed"
    return true
end

function Registrar.OnNativeHidden()
    Registrar.Close("registrar-native-hidden")
end

function Registrar.TryShow()
    if active then return true end
    if stockOnly then return false end
    local d = dialogue()
    if not d or not d.moduleEnabled or not d.immersionEnabled
        or d.presentationShown or d.completionActive or d.progressActive
        or d.activeDetail then
        last = "registrar-dialogue-busy"
        return false
    end
    local source, why = sample()
    if not source then
        last = why
        deferrals = deferrals + 1
        return false
    end
    local shown, status = d:ShowReadOnlyGossip(source.model)
    if not shown or status ~= "shown" then
        last = "registrar-dialogue-deferred"
        deferrals = deferrals + 1
        return false
    end
    -- Only after the complete approved Logres view is visible can the native
    -- root be moved outside the viewport. Native scripts remain intact.
    local parked = Logres.NPCServiceNativeParking.Park("guild-registrar")
    if not parked then
        stockOnly = true
        deferrals = deferrals + 1
        local audit = Logres.NPCServiceNativeParking.GetAudit()
        if audit.key == "guild-registrar" and audit.pending then
            -- Root could not be restored after a failed mutation. Keep the
            -- visible Logres view inert until deferred stock restoration.
            active = true
            Logres.NPCServiceNativeParking.DeferExit()
            d.optionView:SetServiceSelectable(false)
            last = "registrar-stock-restoration-pending"
            return true
        end
        d:HidePresentation("registrar-native-stock-owner")
        last = "registrar-stock-parking-unavailable"
        return false
    end
    active = true
    d.optionView:SetServiceSelectable(Registrar.CanSelect())
    opens = opens + 1
    last = "registrar-logres-quest-dialogue"
    Logres:TraceEvent("npc", "guild-registrar-owned", {result=last})
    return true
end

local function deny(reason)
    rejected = rejected + 1
    last = reason
    return false, reason
end

function Registrar.Activate(model, index)
    if not Registrar.CanSelect() or type(model) ~= "table"
        or model.nativeService ~= "guild-registrar"
        or type(index) ~= "number" or index ~= math.floor(index)
        or index < 1 or index > 2 then
        return deny("registrar-choice-inactive")
    end
    -- Revalidate every row and its original script immediately before the
    -- intentional click. A stale menu never dispatches a native transaction.
    local fresh, why = sample()
    if not fresh or fresh.model.title ~= model.title then
        return deny(why or "registrar-npc-changed")
    end
    local oldRows = model.nodes[model.start].options
    local newRows = fresh.model.nodes[fresh.model.start].options
    for i = 1, 2 do
        if not oldRows[i] or not newRows[i]
            or oldRows[i].label ~= newRows[i].label
            or oldRows[i].serviceStatus ~= newRows[i].serviceStatus
            or oldRows[i].serviceIndex ~= newRows[i].serviceIndex then
            return deny("registrar-service-list-changed")
        end
    end
    if newRows[index].serviceStatus ~= 0 then
        return deny("registrar-service-unavailable")
    end
    if not Logres.NPCServiceNativeParking.Restore("registrar-native-choice") then
        return deny("registrar-native-restore-deferred")
    end
    -- Do not reopen the Logres service menu on the same visit after native
    -- purchase/registration is requested. The stock form remains available.
    Logres.NPCServiceSession.Dismiss("guild-registrar")
    Registrar.Close("registrar-native-choice")
    actions = actions + 1
    local ok = pcall(fresh.buttons[index].script, fresh.buttons[index].frame, "LeftButton")
    if not ok then return deny("registrar-native-handler-refused-stock-visible") end
    last = "registrar-native-service-requested"
    return true, last
end

function Registrar.Goodbye()
    if not Registrar.IsVisible() then return false, "registrar-inactive" end
    if not Logres.NPCServiceNativeParking.Restore("registrar-goodbye") then
        return false, "registrar-native-restore-deferred"
    end
    Logres.NPCServiceSession.Dismiss("guild-registrar")
    Registrar.Close("registrar-goodbye")
    local root = member(_G, "GuildRegistrarFrame")
    if root and ordinary(HideUIPanel) and type(HideUIPanel) == "function" then
        pcall(HideUIPanel, root)
    end
    return true, "registrar-goodbye-issued"
end

function Registrar.GetAudit()
    return {result=last, live=Registrar.IsVisible() == true,
        visits=opens, closes=closes, deferrals=deferrals,
        actions=actions, rejected=rejected,
        nativeOwner="Blizzard", nativeControls="untouched"}
end

function Merchant.GuildGetAudit()
    return Registrar.GetAudit()
end

function Merchant.GuildPreview()
    if Registrar.IsVisible() then return false, "registrar-live" end
    return dialogue():ShowOptionPreview("guild-registrar")
end

Logres.NPCServiceSession.Register("guild-registrar", {
    interactionType=11, nativeFrame="GuildRegistrarFrame",
    loadedAddon="Blizzard_UIPanels_Game", automatic=true,
    open=function() return Registrar.TryShow() end,
    close=function(reason) return Registrar.Close(reason) end,
    isVisible=function() return Registrar.IsVisible() end,
})
Logres:RegisterEvent("GUILD_REGISTRAR_SHOW", function()
    -- Native readiness can arrive after a normalized interaction state event.
    Logres.NPCServiceSession.Reconcile("registrar-show")
end)
Logres:RegisterEvent("GUILD_REGISTRAR_CLOSED", function()
    Registrar.Close("registrar-closed-event")
end)
Logres:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    stockOnly = false
    Registrar.Close("registrar-world-changed")
    guildPreviewStep = 0
end)
Logres:SubscribePreferences(function(preferences)
    if not preferences.immersionEnabled and active then
        Logres.NPCServiceSession.Dismiss("guild-registrar")
        Registrar.Close("registrar-immersion-off")
    end
end)

Logres:RegisterEvent("MERCHANT_SHOW", function()
    if not visit then visit, stockOnly = true, false end
    reconcile()
end)
Logres:RegisterEvent("MERCHANT_UPDATE", function()
    if live then refreshTabs() elseif visit then reconcile() end
end)
Logres:RegisterEvent("MERCHANT_CLOSED", function()
    visit = false
    restore("merchant-closed")
end)
Logres:RegisterEvent("PLAYER_ENTERING_WORLD", function()
    visit, merchantState = false, false
    restore("world-changed")
    if preview then preview:Hide() end
end)
Logres:RegisterEvent("DISPLAY_SIZE_CHANGED", function()
    if live and not fits() then restore("stock-layout-small-viewport") end
end)
Logres:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    if live and live.pending then
        restore(live.pending)
    elseif visit then
        reconcile()
    end
end)
Logres:SubscribeState(function(state)
    local inMerchant = state.interacting == true and state.interactionType == 5
    if inMerchant and not merchantState and not visit then
        visit, stockOnly = true, false
    elseif merchantState and not inMerchant then
        visit = false
        restore("merchant-context-ended")
    end
    merchantState = inMerchant
    if inMerchant and not live then reconcile() end
end)
Logres:SubscribePreferences(function(preferences)
    if live and not preferences.immersionEnabled then
        restore("immersion-off")
    elseif preferences.immersionEnabled then
        reconcile()
    end
end)

-- Shared, reversible service chrome. Each service owns its source and lifecycle.
Logres.NPCServicePresentation = {ordinary = ordinary, member = member, method = method,
    read = read, unlocked = unlocked, mutable = mutable, fits = fits, anchor = anchor,
    resize = resize, fade = fade, goodbye = goodbye, goodbyeArt = goodbyeArt, text = text, wash = wash}

return Merchant
