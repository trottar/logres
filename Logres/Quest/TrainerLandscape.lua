-- P0281: one landscape trainer composition built from a plain presentation model.
-- Fixture only until a native adapter/controller independently clears D-047 gates.
-- This renderer creates ONLY Logres-owned, mouse-inert frames; no native calls.
local _, Logres = ...
local Landscape = {}
Logres.NPCTrainerLandscape = Landscape
local theme = Logres.Theme.panelSurface
local config = Logres.PanelConfigs.trainer.landscape
local SOLID = "Interface\\Buttons\\WHITE8x8"

local function color(texture, rgba)
    texture:SetTexture(SOLID)
    texture:SetVertexColor(rgba[1], rgba[2], rgba[3], rgba[4])
end

local function rect(owner, x, y, w, h, rgba)
    local t = owner:CreateTexture(nil, "ARTWORK")
    color(t, rgba)
    t:SetPoint("TOPLEFT", owner, "TOPLEFT", x, -y)
    t:SetSize(w, h)
    return t
end

local function text(owner, value, x, y, w, h, font, rgba, align)
    local t = owner:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    t:SetPoint("TOPLEFT", owner, "TOPLEFT", x, -y)
    t:SetSize(w, h)
    t:SetJustifyH(align or "LEFT")
    t:SetJustifyV("MIDDLE")
    t:SetText(value)
    t:SetTextColor(rgba[1], rgba[2], rgba[3], rgba[4])
    return t
end

local function frame(owner, x, y, w, h)
    local f = CreateFrame("Frame", nil, owner)
    f:SetPoint("TOPLEFT", owner, "TOPLEFT", x, -y)
    f:SetSize(w, h)
    f:EnableMouse(false)
    return f
end

local function icon(owner, path, x, y, side)
    local f = frame(owner, x, y, side, side)
    rect(f, 0, 0, side, side, config.palette.iconBorder)
    local img = f:CreateTexture(nil, "ARTWORK")
    img:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
    img:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
    img:SetTexture(path)
    return f
end

local function boundedString(value, limit)
    return type(value) == "string" and #value <= limit
end

-- The model contains content only. Geometry and art live in TrainerPanelConfig.
-- A future guarded live adapter can supply this same shape, but none exists yet.
function Landscape.Fixture()
    return {
        title = "Thonys Pillarstone",
        subtitle = "Journeyman Enchanter",
        search = "Search...",
        -- Synthetic utility fixture: no Blizzard filter or money API consulted.
        filters = {label="Filters", mode="Categorize", categorized=true},
        funds = {label="Funds", gold="1", silver="20", copper="58"},
        trainAll = {label="Train All (1, 1s)", enabled=false},
        categories = {"All", "Weapon", "Chest", "Bracer", "Glove", "Boots", "Other"},
        activeCategory = 1,
        profession = "Enchanting (40)",
        rows = {
            {name="Enchant Chest - Minor Absorption", requirement="Requires: Enchanting (40)", price="1s", icon="Interface\\Icons\\Spell_Holy_GreaterHeal", selected=true},
            {name="Enchant Bracer - Minor Stamina", requirement="Requires: Enchanting (15)", price="50c", icon="Interface\\Icons\\INV_Misc_Rune_01"},
            {name="Enchant Bracer - Minor Strength", requirement="Requires: Enchanting (10)", price="25c", icon="Interface\\Icons\\INV_Misc_Rune_02"},
            {name="Enchant Bracer - Minor Agility", requirement="Requires: Enchanting (10)", price="25c", icon="Interface\\Icons\\INV_Misc_Rune_03"},
            {name="Enchant Cloak - Minor Resistance", requirement="Requires: Enchanting (20)", price="50c", icon="Interface\\Icons\\INV_Misc_Rune_04"},
            {name="Enchant Weapon - Minor Striking", requirement="Requires: Enchanting (35)", price="1s 50c", icon="Interface\\Icons\\INV_Misc_Rune_05", disabled=true},
            {name="Enchant Shield - Minor Stamina", requirement="Requires: Enchanting (15)", price="50c", icon="Interface\\Icons\\INV_Misc_Rune_06"},
        },
        selected = {
            name="Enchant Chest - Minor Absorption",
            requirement="Requires: Enchanting (40)",
            description="Permanently enchants a chest armor to increase Arcane resistance by 5.",
            icon="Interface\\Icons\\Spell_Holy_GreaterHeal",
        },
        reagents = {{name="Lesser Magic Essence", count="0/1", icon="Interface\\Icons\\INV_Enchant_EssenceMagicSmall"}},
        trainLabel = "Train", trainEnabled = false,
        footnote = "VISUAL FIXTURE ONLY  /  NO TRAINER ACTIONS",
    }
end

-- Build is intentionally pure: fixture/live adapters must present the same fields.
function Landscape.Build(model)
    if type(model) ~= "table" or not boundedString(model.title, 90)
        or not boundedString(model.subtitle, 90)
        or not boundedString(model.search, 70)
        or type(model.filters) ~= "table"
        or not boundedString(model.filters.label, 30)
        or not boundedString(model.filters.mode, 30)
        or type(model.filters.categorized) ~= "boolean"
        or type(model.funds) ~= "table"
        or not boundedString(model.funds.label, 30)
        or not boundedString(model.funds.gold, 10)
        or not boundedString(model.funds.silver, 10)
        or not boundedString(model.funds.copper, 10)
        or type(model.trainAll) ~= "table"
        or not boundedString(model.trainAll.label, 40)
        or type(model.trainAll.enabled) ~= "boolean"
        or not boundedString(model.profession, 70)
        or type(model.categories) ~= "table" or #model.categories < 1
        or #model.categories > 9 or type(model.rows) ~= "table"
        or #model.rows < 1 or #model.rows > config.maxRows
        or type(model.selected) ~= "table" or type(model.reagents) ~= "table"
        or #model.reagents > 3 or not boundedString(model.trainLabel, 30)
        or not boundedString(model.footnote, 100) then return nil end
    for i = 1, #model.categories do
        if not boundedString(model.categories[i], 32) then return nil end
    end
    for i = 1, #model.rows do
        local r = model.rows[i]
        if type(r) ~= "table" or not boundedString(r.name, 100)
            or not boundedString(r.requirement, 90)
            or not boundedString(r.price, 30) or not boundedString(r.icon, 180) then
            return nil
        end
    end
    for _, key in ipairs({"name", "requirement", "description", "icon"}) do
        if not boundedString(model.selected[key], 300) then return nil end
    end
    for i = 1, #model.reagents do
        local r = model.reagents[i]
        if type(r) ~= "table" or not boundedString(r.name, 80)
            or not boundedString(r.count, 20) or not boundedString(r.icon, 180) then
            return nil
        end
    end
    if type(model.activeCategory) ~= "number" or model.activeCategory < 1
        or model.activeCategory > #model.categories then return nil end
    return model
end

-- A compositional renderer, not a set of free-floating sample controls.
-- Native trainer input, labels, cost, row recycling and dimensions are untouched.
function Landscape.Render(owner, model)
    local view = Landscape.Build(model)
    if not view or not owner then return false, "invalid-landscape-model" end
    local p, g = config.palette, config.geometry
    local created = {}
    local ok = pcall(function()
        -- Paint *on the panel owner*: large child frames previously sat above
        -- parent-owned category text and formed opaque-looking black blocks.
        -- Washes are subtle artwork layered over the shared parchment texture.
        rect(owner, g.left.x, g.left.y, g.left.w, g.left.h, p.sidebarWash)
        rect(owner, g.list.x, g.list.y, g.list.w, g.list.h, p.catalogueWash)
        rect(owner, g.left.x + g.left.w + 7, g.left.y + 8,
            1, g.left.h - 16, p.sidebarRule)

        text(owner, view.title, 120, 19, config.width - 240, 28,
            "GameFontHighlightLarge", theme.colors.title, "CENTER")
        text(owner, view.subtitle, 120, 49, config.width - 240, 20,
            "GameFontHighlight", theme.colors.body, "CENTER")
        rect(owner, 28, 85, config.width - 56, 1, p.gold)

        -- Left-hand search and full vertical category selection.
        local filter = frame(owner, g.search.x, g.search.y, g.search.w, g.search.h)
        created[#created + 1] = filter
        -- Search, filter and category mode are inert fixture illustrations.
        -- Native Blizzard filter controls remain untouched in H mode.
        text(filter, view.search, 14, 2, g.search.w - 108, 24,
            "GameFontHighlightSmall", p.muted)
        rect(owner, g.filters.x, g.filters.y, g.filters.w, g.filters.h,
            p.sidebarWash)
        local filterBadge = frame(owner, g.filters.x, g.filters.y,
            g.filters.w, g.filters.h)
        created[#created + 1] = filterBadge
        text(owner, view.filters.label, g.filters.x + 8, g.filters.y + 1,
            g.filters.w - 24, 22, "GameFontHighlightSmall", p.body)
        text(owner, "v", g.filters.x + g.filters.w - 16, g.filters.y + 1,
            12, 22, "GameFontHighlightSmall", p.goldText, "CENTER")
        rect(owner, g.filterMode.x, g.filterMode.y, 10, 10, p.sidebarRule)
        if view.filters.categorized then
            rect(owner, g.filterMode.x + 2, g.filterMode.y + 2, 6, 6, p.gold)
        end
        text(owner, view.filters.mode, g.filterMode.x + 15,
            g.filterMode.y - 3, 145, 17, "GameFontHighlightSmall", p.muted)
        for i = 1, #view.categories do
            local y = g.categories.y + (i - 1) * g.categories.pitch
            if i == view.activeCategory then
                rect(owner, g.categories.x, y, g.categories.w, g.categories.height, p.active)
                rect(owner, g.categories.x, y, 3, g.categories.height, p.gold)
            end
            text(owner, view.categories[i], g.categories.x + 11, y,
                g.categories.w - 20, g.categories.height, "GameFontHighlight", p.body)
        end
        text(owner, view.profession, g.left.x + 11, g.status.y - 17,
            g.left.w - 22, 17, "GameFontHighlightSmall", p.muted)
        local status = frame(owner, g.status.x, g.status.y, g.status.w, g.status.h)
        created[#created + 1] = status
        rect(status, 3, 8, g.status.w - 6, 4, p.gold)

        -- Central list: seven complete rows with icon, description and price.
        for i = 1, #view.rows do
            local datum = view.rows[i]
            local y = g.list.y + g.list.top + (i - 1) * g.list.pitch
            local row = frame(owner, g.list.x + 8, y, g.list.w - 29, g.list.rowHeight)
            created[#created + 1] = row
            local rowState = datum.disabled and "disabled"
                or (datum.selected and "selected" or "normal")
            if not Logres.NPCTrainerMotif.PaintFixtureRow(row, rowState) then
                error("trainer-landscape-row-paint-failed")
            end
            if rowState == "selected" then
                rect(row, 0, 0, g.list.w - 29, g.list.rowHeight - 1, p.selected)
            end
            icon(row, datum.icon, 7, 5, 40)
            local nameColor = p.body
            if rowState == "selected" then nameColor = p.goldText
            elseif rowState == "disabled" then nameColor = p.muted end
            text(row, datum.name, 58, 5, g.list.w - 179, 22,
                "GameFontNormal", nameColor)
            text(row, datum.requirement, 58, 28, g.list.w - 179, 15,
                "GameFontHighlightSmall", datum.disabled and p.muted or p.body)
            text(row, datum.price, g.list.w - 126, 9, 87, 28,
                "GameFontNormal", p.body, "RIGHT")
        end
        rect(owner, g.list.x + g.list.w - 16, g.list.y + 8, 3, g.list.h - 18, p.rail)
        rect(owner, g.list.x + g.list.w - 18, g.list.y + 14, 7, 93, p.gold)

        -- Continuous lower detail section, spanning list and sidebar.
        rect(owner, 30, g.detail.y - 12, config.width - 60, 1, p.gold)
        rect(owner, g.detail.x, g.detail.y, g.detail.w, g.detail.h, p.detailWash)
        local selected = frame(owner, g.detail.x, g.detail.y, g.detail.w, g.detail.h)
        created[#created + 1] = selected
        icon(selected, view.selected.icon, 5, 7, 53)
        text(selected, view.selected.name, 70, 2, 458, 30,
            "GameFontNormalLarge", p.goldText)
        text(selected, view.selected.requirement, 70, 32, 443, 24,
            "GameFontHighlightSmall", p.body)
        text(selected, view.selected.description, 6, 73, 460, 63,
            "GameFontHighlight", p.body)

        text(owner, "Reagents", g.reagents.x, g.reagents.y,
            g.reagents.w, 24, "GameFontNormal", p.goldText)
        rect(owner, g.reagents.x, g.reagents.y + 28, g.reagents.w, 1, p.gold)
        for i = 1, #view.reagents do
            local item = view.reagents[i]
            local y = g.reagents.y + 39 + (i - 1) * 52
            local reagent = icon(owner, item.icon, g.reagents.x, y, 42)
            -- The quantity is owned by the icon frame so it stays above
            -- the icon artwork rather than disappearing beneath that child.
            text(reagent, item.count, 0, 27, 42, 14,
                "GameFontHighlightSmall", p.body, "CENTER")
            text(owner, item.name, g.reagents.x + 51, y + 3,
                g.reagents.w - 51, 37, "GameFontHighlightSmall", p.body)
            created[#created + 1] = reagent
        end
        -- Money values and cost/count are authored demo data, never live funds.
        text(owner, view.funds.label, g.funds.x, g.funds.y,
            49, 19, "GameFontHighlightSmall", p.muted)
        text(owner, view.funds.gold .. "g", g.funds.x + 50, g.funds.y,
            40, 19, "GameFontNormalSmall", p.goldText)
        text(owner, view.funds.silver .. "s", g.funds.x + 95, g.funds.y,
            41, 19, "GameFontNormalSmall", p.coinSilver)
        text(owner, view.funds.copper .. "c", g.funds.x + 144, g.funds.y,
            41, 19, "GameFontNormalSmall", p.coinCopper)
        local trainAll = frame(owner, g.trainAll.x, g.trainAll.y,
            g.trainAll.w, g.trainAll.h)
        created[#created + 1] = trainAll
        text(trainAll, view.trainAll.label, 0, 0,
            g.trainAll.w, g.trainAll.h, "GameFontHighlightSmall",
            view.trainAll.enabled and p.goldText or p.muted, "CENTER")
        local train = frame(owner, g.train.x, g.train.y, g.train.w, g.train.h)
        created[#created + 1] = train
        text(train, view.trainLabel, 0, 0, g.train.w, g.train.h,
            "GameFontHighlight", view.trainEnabled and p.goldText or p.muted, "CENTER")
        text(owner, view.footnote, 34, config.height - 29,
            config.width - 68, 17, "GameFontHighlightSmall", p.muted, "CENTER")

        -- Shared P0280 control painter, now attached to actual composition slots.
        local decorated = Logres.NPCTrainerComponents.Render({
            fixture=true, styles=config.previewComponents, elements={
            {id="trainer.filter", target=filter},
            {id="trainer.selection", target=selected},
            {id="trainer.status", target=status},
            {id="trainer.train", target=train},
            {id="trainer.trainAll", target=trainAll},
        }})
        if not decorated or decorated.styled ~= 5 then
            error("trainer-landscape-component-paint-failed")
        end
    end)
    if not ok then
        for i = 1, #created do pcall(function() created[i]:Hide() end) end
        return false, "landscape-construction-deferred"
    end
    return true, "landscape-fixture-rendered"
end

function Landscape.Preview(owner)
    return Landscape.Render(owner, Landscape.Fixture())
end

function Landscape.LiveCapability()
    return false, "native-reflow-and-transaction-fallback-unverified"
end
return Landscape
