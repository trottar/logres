-- P0288: explicit, one-shot, read-only native trainer MODEL -> approved landscape.
-- This is not a trainer replacement. All Blizzard controls stay accessible.
local _, Logres = ...
local Trial = {}
Logres.NPCTrainerLiveTrial = Trial

local visual = Logres.PanelConfigs.trainer.preview
local panel = Logres.PanelConfigs.trainer
local placeholder = "Interface\\Icons\\INV_Misc_QuestionMark"
local active
local displays, deferrals = 0, 0
local last = "not-attempted"

local function bounded(value, max)
    return type(value) == "string" and #value > 0 and #value <= max
end

local function coin(copper)
    if type(copper) ~= "number" or copper < 0 or copper > 100000000000
        or copper ~= math.floor(copper) then
        return "?", "?", "?"
    end
    return tostring(math.floor(copper / 10000)),
        tostring(math.floor(copper / 100) % 100), tostring(copper % 100)
end

local function price(value)
    if type(value) ~= "number" or value < 0 or value > 100000000000
        or value ~= math.floor(value) then return "Cost unknown" end
    local g, s, c = coin(value)
    local parts = {}
    if g ~= "0" then parts[#parts + 1] = g .. "g" end
    if s ~= "0" then parts[#parts + 1] = s .. "s" end
    if c ~= "0" or #parts == 0 then parts[#parts + 1] = c .. "c" end
    return table.concat(parts, " ")
end

-- Pure conversion of *already secret-gated, addon-owned* probe results.
-- Numeric categories have NO inferred known/available/unavailable meaning.
function Trial.FromSnapshot(report)
    if type(report) ~= "table" or type(report.sample) ~= "table"
        or (report.status ~= "service-row-shape-deferred"
            and report.status ~= "read-only-service-sample") then
        return nil, "source-unavailable"
    end
    if #report.sample < 1 or #report.sample > 12 then
        return nil, "source-sample-size-deferred"
    end
    local rows, first, selected
    rows = {}
    for i = 1, #report.sample do
        local native = report.sample[i]
        if type(native) ~= "table" or not bounded(native.name, 100)
            or (native.state ~= "numeric-category-unclassified"
                and native.state ~= "source-observed")
            or type(native.index) ~= "number" or native.index ~= math.floor(native.index)
            or native.index < 1 or native.index > 384 then
            return nil, "unsafe-or-incomplete-service-row"
        end
        if i <= panel.landscape.maxRows then
            local selectedRow = type(report.selected) == "number"
                and native.index == report.selected
            local row = {serviceIndex=native.index, name=native.name,
                requirement="Availability not classified", price=price(native.cost),
                icon=placeholder, selected=selectedRow, disabled=false}
            rows[#rows + 1] = row
            if not first then first = row end
            if selectedRow then selected = row end
        end
    end
    if not first then return nil, "no-readable-services" end
    local g, s, c = coin(report.wallet)
    local model = {
        title="Trainer services", subtitle="LIVE SOURCE  /  BLIZZARD TRANSACTIONS",
        search="Search (stock)",
        filters={label="Filters", mode="Stock controls", categorized=false},
        funds={label="Funds", gold=g, silver=s, copper=c},
        trainAll={label="Train All unavailable", enabled=false},
        categories={"Visible services"}, activeCategory=1,
        profession="Source: " .. tostring(#report.sample) .. " sampled",
        rows=rows,
        selected={name=selected and selected.name or "Selection outside view",
            requirement="Availability not classified",
            description="Live name, index, cost and funds only. Use Blizzard's trainer to select, filter or train.",
            icon=placeholder},
        reagents={}, trainLabel="Stock Train", trainEnabled=false,
        footnote="LIVE READ-ONLY  /  TRAIN AND FILTER IN BLIZZARD WINDOW",
    }
    if not Logres.NPCTrainerLandscape.Build(model) then
        return nil, "landscape-model-rejected"
    end
    return model, "native-snapshot-mapped"
end

function Trial.Disable(why)
    if active then active:Hide(); active = nil end
    last = why or "trial-hidden"
    return true, last
end

local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
watcher:RegisterEvent("PLAYER_REGEN_DISABLED")
watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
watcher:SetScript("OnEvent", function()
    if active then Trial.Disable("native-context-ended") end
end)

function Trial.Toggle(mode)
    if mode == "off" or (mode == nil and active and active:IsShown()) then
        return Trial.Disable("trial-hidden")
    end
    if mode ~= nil and mode ~= "on" then return false, "use-on-or-off" end
    -- Probe.Read enforces trainer-open, ordinary native root, and out-of-combat.
    local report = Logres.NPCNativeTrainerServiceProbe.Read()
    local model, why = Trial.FromSnapshot(report)
    if not model then
        deferrals = deferrals + 1
        last = why
        return false, why
    end
    -- A fresh addon-owned panel prevents stale rows after native filter changes.
    -- It is mouse-inert; all Blizzard-native selection/training remains available.
    local ok, owner = pcall(function()
        local root = CreateFrame("Frame", nil, UIParent)
        root:SetSize(visual.width, visual.height)
        root:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
        root:SetFrameStrata(visual.strata)
        root:EnableMouse(false)
        root:Hide()
        if not Logres.PanelSurface.Paint(root, panel.surface, visual.width, visual.height) then
            error("live-panel-art-unavailable")
        end
        local rendered = Logres.NPCTrainerLandscape.Render(root, model)
        if not rendered then error("live-landscape-render-deferred") end
        return root
    end)
    if not ok or not owner then
        deferrals = deferrals + 1
        last = "addon-owned-render-deferred"
        return false, last
    end
    if active then active:Hide() end
    active = owner
    owner:Show()
    displays = displays + 1
    last = "live-read-only-visible"
    return true, last
end

function Trial.GetAudit()
    return {shown=active and active:IsShown() or false,
        displays=displays, deferrals=deferrals, last=last,
        purchases=0, filterWrites=0, selectionWrites=0, nativeGeometryWrites=0}
end

return Trial
