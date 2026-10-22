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

local function icon(owner, path, x, y, side, live)
    local f = frame(owner, x, y, side, side)
    -- Live icons can have partially transparent source art. A solid gold
    -- square behind the texture then dominates the entire face. Keep the
    -- synthetic P painter unchanged and only narrow the live gold border.
    if live then
        rect(f, 0, 0, side, side, config.palette.liveIconBacking):SetDrawLayer("BACKGROUND", -1)
    else
        rect(f, 0, 0, side, side, config.palette.iconBorder)
    end
    local img = f:CreateTexture(nil, "ARTWORK")
    img:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
    img:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
    if live then img:SetDrawLayer("OVERLAY", 1) end
    img:SetTexture(path)
    if live then
        rect(f, 0, 0, side, 1, config.palette.iconBorder):SetDrawLayer("OVERLAY", 2)
        rect(f, 0, side - 1, side, 1, config.palette.iconBorder):SetDrawLayer("OVERLAY", 2)
        rect(f, 0, 0, 1, side, config.palette.iconBorder):SetDrawLayer("OVERLAY", 2)
        rect(f, side - 1, 0, 1, side, config.palette.iconBorder):SetDrawLayer("OVERLAY", 2)
    end
    return f, img
end

local function boundedString(value, limit)
    return type(value) == "string" and #value <= limit
end

-- File IDs are accepted only inside the source-independent model.
-- The native source independently secret-gates every copied value.
local function validIcon(value)
    return boundedString(value, 180)
        or (type(value) == "number" and value > 0
            and value <= 1000000000 and value == math.floor(value))
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
            or not boundedString(r.price, 30) or not validIcon(r.icon) then
            return nil
        end
    end
    for _, key in ipairs({"name", "requirement", "description"}) do
        if not boundedString(model.selected[key], 300) then return nil end
    end
    if not validIcon(model.selected.icon) then return nil end
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
    local liveControls = {rows={}}
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
        if view.localBrowse then
            liveControls.searchHint = text(filter, view.search, 14, 2,
                g.search.w - 108, 24, "GameFontHighlightSmall", p.muted)
        else
            text(filter, view.search, 14, 2, g.search.w - 108, 24,
                "GameFontHighlightSmall", p.muted)
        end
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
        liveControls.filterMode = text(owner, view.filters.mode, g.filterMode.x + 15,
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
        liveControls.statusText = text(owner, view.profession, g.left.x + 11, g.status.y - 17,
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
            -- Local-browse row paint is initially neutral. Reusable selection
            -- wash and font colors update in place; P fixture states unchanged.
            if view.localBrowse then rowState = "normal" end
            if not Logres.NPCTrainerMotif.PaintFixtureRow(row, rowState) then
                error("trainer-landscape-row-paint-failed")
            end
            local selectionWash
            if rowState == "selected" then
                selectionWash = rect(row, 0, 0, g.list.w - 29, g.list.rowHeight - 1, p.selected)
            elseif view.localBrowse then
                selectionWash = rect(row, 0, 0, g.list.w - 29, g.list.rowHeight - 1, p.selected)
                selectionWash:Hide()
            end
            local hoverWash
            if view.localBrowse then
                hoverWash = rect(row, 0, 0, g.list.w - 29,
                    g.list.rowHeight - 1, p.hover)
                hoverWash:Hide()
            end
            local _, image = icon(row, datum.icon, 7, 5, 40, view.localBrowse)
            local nameColor = p.body
            if rowState == "selected" then nameColor = p.goldText
            elseif rowState == "disabled" then nameColor = p.muted end
            local nameText = text(row, datum.name, 58, 5, g.list.w - 179, 22,
                "GameFontNormal", nameColor)
            local requirementText = text(row, datum.requirement, 58, 28, g.list.w - 179, 15,
                "GameFontHighlightSmall", datum.disabled and p.muted or p.body)
            local priceText = text(row, datum.price, g.list.w - 126, 9, 87, 28,
                "GameFontNormal", p.body, "RIGHT")
            if view.localBrowse then
                liveControls.rows[i] = {frame=row, image=image, name=nameText,
                    requirement=requirementText, price=priceText, selected=selectionWash,
                    hover=hoverWash}
            end
        end
        rect(owner, g.list.x + g.list.w - 16, g.list.y + 8, 3, g.list.h - 18, p.rail)
        if not view.localBrowse then
            -- P fixture retains static decorative thumb; LIVE uses owned Slider.
            rect(owner, g.list.x + g.list.w - 18, g.list.y + 14, 7, 93, p.gold)
        end

        -- Continuous lower detail section, spanning list and sidebar.
        rect(owner, 30, g.detail.y - 12, config.width - 60, 1, p.gold)
        rect(owner, g.detail.x, g.detail.y, g.detail.w, g.detail.h, p.detailWash)
        local selected = frame(owner, g.detail.x, g.detail.y, g.detail.w, g.detail.h)
        created[#created + 1] = selected
        local _, selectedImage = icon(selected, view.selected.icon, 5, 7, 53, view.localBrowse)
        local selectedName = text(selected, view.selected.name, 70, 2, 458, 30,
            "GameFontNormalLarge", p.goldText)
        local selectedRequirement = text(selected, view.selected.requirement, 70, 32, 443, 24,
            "GameFontHighlightSmall", p.body)
        local selectedDescription = text(selected, view.selected.description, 6, 73, 460, 63,
            "GameFontHighlight", p.body)
        if view.localBrowse then
            liveControls.detail = {icon=selectedImage, name=selectedName,
                requirement=selectedRequirement, description=selectedDescription}
        end

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
        local trainAllText = text(trainAll, view.trainAll.label, 0, 0,
            g.trainAll.w, g.trainAll.h, "GameFontHighlightSmall",
            view.trainAll.enabled and p.goldText or p.muted, "CENTER")
        if view.localBrowse then liveControls.trainAllText = trainAllText end
        local train = frame(owner, g.train.x, g.train.y, g.train.w, g.train.h)
        created[#created + 1] = train
        local trainText = text(train, view.trainLabel, 0, 0, g.train.w, g.train.h,
            "GameFontHighlight", view.trainEnabled and p.goldText or p.muted, "CENTER")
        if view.localBrowse then liveControls.trainText = trainText end
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
    return true, "landscape-fixture-rendered", liveControls
end

-- Change ONLY addon-owned row regions from a previously captured source.
-- No native data read, native UI write, frame recreation, or polling.
function Landscape.UpdateLiveRows(controls, view)
    if not view or not view.localBrowse or not Landscape.Build(view)
        or type(controls) ~= "table" or type(controls.rows) ~= "table" then
        return false
    end
    local p = config.palette
    for i = 1, #controls.rows do
        local slot = controls.rows[i]
        local datum = view.rows[i]
        if slot.hover then slot.hover:Hide() end
        if datum then
            slot.image:SetTexture(datum.icon)
            slot.name:SetText(datum.name)
            slot.requirement:SetText(datum.requirement)
            slot.price:SetText(datum.price)
            slot.name:SetTextColor(unpack(datum.selected and p.goldText
                or (datum.disabled and p.muted or p.body)))
            if slot.selected then
                if datum.selected then slot.selected:Show() else slot.selected:Hide() end
            end
            slot.frame:Show()
        else
            slot.frame:Hide()
        end
    end
    controls.filterMode:SetText(view.filters.mode)
    controls.statusText:SetText(view.profession)
    if not controls.trainText then return false end
    controls.trainText:SetText(view.trainLabel)
    controls.trainText:SetTextColor(unpack(view.trainEnabled and p.goldText or p.muted))
    if not controls.detail then return false end
    controls.detail.icon:SetTexture(view.selected.icon)
    controls.detail.name:SetText(view.selected.name)
    controls.detail.requirement:SetText(view.selected.requirement)
    controls.detail.description:SetText(view.selected.description)
    return true
end

-- P0310: deterministic, inert zero-service fixture using production rendering.
function Landscape.EmptyFixture()
    local view = Landscape.Fixture()
    local empty = Logres.NPCServiceEmptyState.Build({
        name="No trainer services listed",
        note="Blizzard has not supplied any training services",
        detail="This is synthetic preview data. No native trainer, profession ownership, learning offer or purchase is implied.",
        icon="Interface\\Icons\\INV_Misc_QuestionMark",
    })
    if not empty then return nil end
    view.title = "Example Trainer"
    view.subtitle = "EMPTY SOURCE  /  VISUAL FIXTURE"
    view.categories = {"Trainer services"}
    view.filters.mode = "All sampled"
    view.profession = "0 native services | Blizzard available"
    view.rows = {empty.row}
    view.selected = empty.selected
    view.reagents = {}
    view.trainAll = {label="Train All unavailable", enabled=false}
    view.trainLabel = "Stock Train"
    view.trainEnabled = false
    view.footnote = "EMPTY FIXTURE ONLY  /  NO TRAINER ACTIONS"
    return view
end

function Landscape.EmptyPreview(owner)
    return Landscape.Render(owner, Landscape.EmptyFixture())
end

function Landscape.Preview(owner)
    return Landscape.Render(owner, Landscape.Fixture())
end

function Landscape.LiveCapability()
    return false, "native-reflow-and-transaction-fallback-unverified"
end
return Landscape
