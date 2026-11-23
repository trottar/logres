-- P0285: on-demand trainer service SOURCE audit, never a presentation/controller.
-- Built for WoW Forever but refuses absent, protected or secret-capable state.
local _, Logres = ...
local Probe = {}
Logres.NPCNativeTrainerServiceProbe = Probe

local MAX_SAMPLE = 64
local MAX_SERVICES = 384
local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function method(owner, key)
    if not ordinary(owner) then return nil end
    local ok, fn = pcall(function() return owner[key] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end

local function read(owner, key)
    local fn = method(owner, key)
    if not fn then return nil end
    local ok, value = pcall(fn, owner)
    if not ok or not ordinary(value) then return nil end
    return value
end

local function api(name)
    local ok, fn = pcall(function() return _G[name] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end

local function scalar(fn, ...)
    if not fn then return nil, false end
    local ok, value = pcall(fn, ...)
    if not ok or not ordinary(value) then return nil, false end
    return value, true
end

local function cappedInteger(value, maximum)
    return type(value) == "number" and value >= 0 and value <= maximum
        and value == math.floor(value)
end

local function safeText(value, limit)
    if type(value) ~= "string" or #value > limit then return nil end
    return (value:gsub("[%c]", " "))
end

local function snapshotRow(infoFn, costFn, iconFn, index)
    local ok, name, subText, category, expanded = pcall(infoFn, index)
    if not ok or not ordinary(name) or not ordinary(subText)
        or not ordinary(category) or not ordinary(expanded) then
        -- An unrelated secret field must not discard an independently ordinary
        -- service name. Never inspect, compare, format or copy restricted fields.
        local safeName = nil
        if ok and ordinary(name) then safeName = safeText(name, 100) end
        return {index=index, state="deferred-secret-or-call", name=safeName}
    end
    local label = safeText(name, 100)
    local categoryKnown = category == "header" or category == "available"
        or category == "used" or category == "unavailable"
    -- Forever 1.60.1 returned a numeric category; capture as raw data only.
    -- No semantic enum value has been independently verified yet.
    local numericCategory = cappedInteger(category, 255)
    if not label or (not categoryKnown and not numericCategory) then
        -- We may inspect types only after the ordinary() gate above passes.
        -- Do not dereference an unexpected table-valued source or guess schema.
        return {index=index, state="unexpected-service-shape", name=label,
            shape={nameType=type(name), subTextType=type(subText),
                categoryType=type(category), expandedType=type(expanded),
                categoryValue=safeText(category, 32) or "unavailable"}}
    end
    local entry = {index=index,
        state=numericCategory and "numeric-category-unclassified" or "source-observed",
        name=label, subText=safeText(subText, 65) or "",
        category=numericCategory and "numeric-unclassified" or category,
        -- Numeric fields are addon-owned copies of individually ordinary values.
        rawNumericCategory=numericCategory and category or nil,
        rawExpansion=cappedInteger(expanded, 255) and expanded or nil,
        -- Header expansion is NOT interpreted as an action authorization.
        expansionKnown=expanded == nil or type(expanded) == "boolean"
            or type(expanded) == "number", cost="unavailable", icon="unavailable"}
    if category ~= "header" then
        local copper, known = scalar(costFn, index)
        if known and cappedInteger(copper, 100000000000) then entry.cost=copper end
        local icon, hasIcon = scalar(iconFn, index)
        if hasIcon and (type(icon) == "number" or type(icon) == "string") then
            entry.icon="present"
        end
    end
    return entry
end

-- P0291: Forever's actual six-field tuple differs from legacy Classic.
-- Blizzard_TrainerUI/Mainline reads name, serviceType, texture, reqLevel,
-- serviceSubText and category. Never treat texture/level as a service enum.
-- All values below are inspected ONLY after independent ordinary() gates.
local function snapshotForeverRow(infoFn, costFn, skillFn, descriptionFn, index)
    local ok, name, serviceType, texture, reqLevel, subText, category = pcall(infoFn, index)
    if not ok or not ordinary(serviceType) or not ordinary(texture)
        or not ordinary(reqLevel) then return nil end
    if type(serviceType) ~= "string" or type(texture) ~= "number"
        or type(reqLevel) ~= "number" then return nil end
    if serviceType ~= "available" and serviceType ~= "unavailable"
        and serviceType ~= "used" and serviceType ~= "header" then return nil end
    local row = {index=index, state="forever-service-observed",
        cost="unavailable", icon="unavailable", serviceType=serviceType}
    if ordinary(name) then row.name = safeText(name, 100) end
    if ordinary(subText) then row.rank = safeText(subText, 35) end
    if ordinary(category) then row.group = safeText(category, 50) end
    if cappedInteger(texture, 1000000000) and texture > 0 then
        row.textureID = texture
        row.icon = "present"
    end
    if cappedInteger(reqLevel, 120) and reqLevel > 1 then
        row.requiredLevel = reqLevel
    end
    -- Each optional source is independent: an absent cost/rank/description
    -- never invalidates a safe name, icon or level.
    if serviceType ~= "header" then
        if costFn then
            local okCost, copper, isProfession, extra = pcall(costFn, index)
            if okCost and ordinary(copper) and cappedInteger(copper, 100000000000) then
                row.cost = copper
                if ordinary(isProfession) and ordinary(extra) and extra == nil
                    and (isProfession == nil or type(isProfession) == "boolean") then
                    row.requiresProfessionConfirmation = isProfession == true
                end
            end
        end
        if skillFn then
            local skillOK, skill, rank, hasRequirement = pcall(skillFn, index)
            if skillOK and ordinary(skill) and ordinary(rank)
                and ordinary(hasRequirement) then
                local skillName = safeText(skill, 42)
                if skillName then
                    local rankNumber = cappedInteger(rank, 1000) and rank or nil
                    row.skillRequirement = skillName
                    row.skillRank = rankNumber
                end
            end
        end
        -- P0292: Forever stock trainer uses a bounded per-service list of
        -- prerequisite abilities. Read each field only if individually ordinary;
        -- hasAbility is never treated as authority to activate Train.
        local abilityCount, countKnown = scalar(api("GetTrainerServiceNumAbilityReq"), index)
        local abilityFn = api("GetTrainerServiceAbilityReq")
        if countKnown and cappedInteger(abilityCount, 4) and abilityFn then
            local abilities = {}
            for slot = 1, abilityCount do
                local got, abilityName, hasAbility = pcall(abilityFn, index, slot)
                if got and ordinary(abilityName) and ordinary(hasAbility) then
                    local safeAbility = safeText(abilityName, 42)
                    if safeAbility and #safeAbility > 0 then
                        abilities[#abilities + 1] = safeAbility
                    end
                end
            end
            if #abilities > 0 then row.abilityRequirements = abilities end
        end
        local description, knownDescription = scalar(descriptionFn, index)
        if knownDescription then row.description = safeText(description, 260) end
        -- GetTrainerServiceItemLink is indexed by this exact native service,
        -- not by an independently inferred spell or display-list position.
        local itemLink, linkKnown = scalar(api("GetTrainerServiceItemLink"), index)
        if linkKnown and Logres.NPCTrainerItemPreview
            and Logres.NPCTrainerItemPreview.ItemID(itemLink) then
            row.itemLink = itemLink
        end
    end
    return row
end

function Probe.Read()
    local report = {status="deferred", sampleLimit=MAX_SAMPLE, sample={},
        total="unknown", selected="unknown", wallet="unknown",
        mutationCalls=0, trainerPurchases=0, geometryWrites=0}
    -- A service count can be stale even when the trainer isn't open.
    -- Require BOTH normalized Logres state and the visible, safe native root.
    local state = Logres:GetState()
    if not state or state.interacting ~= true or state.interactionType ~= 7 then
        report.status="open-trainer-required"; return report
    end
    local locked, lockKnown = scalar(api("InCombatLockdown"))
    if not lockKnown or locked ~= false then
        report.status="combat-or-capability-deferred"; return report
    end
    local ok, root = pcall(function() return _G.ClassTrainerFrame end)
    if not ok or not ordinary(root) or root == nil then
        report.status="native-root-unavailable"; return report
    end
    if read(root, "IsProtected") ~= false or read(root, "IsShown") ~= true then
        report.status="native-root-protected-or-hidden"; return report
    end
    local countFn = api("GetNumTrainerServices")
    local infoFn = api("GetTrainerServiceInfo")
    local costFn = api("GetTrainerServiceCost")
    local iconFn = api("GetTrainerServiceIcon")
    local skillFn = api("GetTrainerServiceSkillReq")
    local descriptionFn = api("GetTrainerServiceDescription")
    report.api = {count=countFn and "present" or "absent",
        info=infoFn and "present" or "absent",
        cost=costFn and "present" or "absent",
        icon=iconFn and "present" or "absent",
        filterRead=api("GetTrainerServiceTypeFilter") and "present" or "absent",
        filterWrite=api("SetTrainerServiceTypeFilter") and "present" or "absent",
        selectionWrite=api("SelectTrainerService") and "present" or "absent",
        purchase=api("BuyTrainerService") and "present" or "absent"}
    if not countFn or not infoFn then
        report.status="required-service-api-unavailable"; return report
    end
    local total, countKnown = scalar(countFn)
    if not countKnown or not cappedInteger(total, MAX_SERVICES) then
        report.status="service-count-deferred"; return report
    end
    report.total=total
    local selection, selectionKnown = scalar(api("GetTrainerSelectionIndex"))
    if selectionKnown and cappedInteger(selection, MAX_SERVICES)
        and selection <= total then report.selected=selection end
    -- The NPC trainer title is optional and independent of any service row.
    -- Stock pet-trainer identity has a separate path; do not infer from it.
    local trainerName, nameKnown = scalar(api("UnitName"), "npc")
    if nameKnown then
        local safeName = safeText(trainerName, 90)
        if safeName and #safeName > 0 then report.trainerName = safeName end
    end
    local wallet, moneyKnown = scalar(api("GetMoney"))
    if moneyKnown and cappedInteger(wallet, 100000000000) then report.wallet=wallet end
    local bad = 0
    for index=1, math.min(total, MAX_SAMPLE) do
        local row = snapshotForeverRow(infoFn, costFn, skillFn, descriptionFn, index)
        if not row then row = snapshotRow(infoFn, costFn, iconFn, index) end
        report.sample[#report.sample + 1] = row
        if row.state ~= "source-observed" then bad = bad + 1 end
    end
    report.invalidRows=bad
    report.status="read-only-service-sample"
    if bad > 0 then report.status="service-row-shape-deferred" end
    return report
end

-- P0512: separate read-only item-detail adapter, co-located with the
-- read-only native trainer service probe to retain the approved Lua inventory.
local Preview = {}
Logres.NPCTrainerItemPreview = Preview

local function field(owner, key)
    if not ordinary(owner) or (type(owner) ~= "table"
        and type(owner) ~= "userdata") then return nil end
    local ok, value = pcall(function() return owner[key] end)
    if ok and ordinary(value) then return value end
end

local function method(owner, key)
    local fn = field(owner, key)
    if type(fn) == "function" then return fn end
end

local function itemID(link)
    if not ordinary(link) or type(link) ~= "string" or #link > 550 then return nil end
    local raw = link:match("|Hitem:(%d+):") or link:match("|Hitem:(%d+)|h")
        or link:match("^item:(%d+):") or link:match("^item:(%d+)$")
    if not raw then return nil end
    local id = tonumber(raw)
    if id and id > 0 and id <= 100000000 and id == math.floor(id) then
        return id
    end
end

function Preview.ItemID(link)
    return itemID(link)
end

local function sanitized(value)
    if not ordinary(value) or type(value) ~= "string" then return nil end
    if #value == 0 or #value > 220 then return nil end
    local text = value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("[%c]", " ")
    if #text == 0 or #text > 85 then return nil end
    return text
end

-- Report "loading" only when this client exposes an event-backed load API.
local function unavailableItemData(id)
    if method(field(_G, "C_Item"), "RequestLoadItemDataByID") then
        return "Crafted item stats loading; hover for full item tooltip.", "loading", id
    end
    return "Crafted item stats unavailable; hover for full item tooltip.", "unavailable", id
end

-- The client's tooltip facts are the only statistic source. Exclude the
-- item-name header and non-stat sell-price/footer; preserve actual source text.
function Preview.Summarize(link)
    local id = itemID(link)
    if not id then return nil, "no-exact-item", nil end
    local tooltipAPI = field(_G, "C_TooltipInfo")
    local get = method(tooltipAPI, "GetHyperlink")
    if not get then
        return "Crafted item stats unavailable in this client; hover for item tooltip.",
            "api-unavailable", id
    end
    local ok, tooltip = pcall(get, link)
    if not ok or not ordinary(tooltip) or type(tooltip) ~= "table" then
        return unavailableItemData(id)
    end
    local lines = field(tooltip, "lines")
    if type(lines) ~= "table" then
        return unavailableItemData(id)
    end
    local rendered, total = {}, 0
    for i = 2, math.min(#lines, 18) do
        local line = lines[i]
        if ordinary(line) and type(line) == "table" then
            local left = sanitized(field(line, "leftText"))
            local right = sanitized(field(line, "rightText"))
            if left and not left:match("^[Ss]ell [Pp]rice")
                and not left:match("^Binds ") and not left:match("^Soulbound$") then
                local combined = left
                if right and right ~= left and #left + #right < 87 then
                    combined = left .. "  " .. right
                end
                total = total + 1
                if #rendered < 3 then rendered[#rendered + 1] = combined end
            end
        end
    end
    if total == 0 then
        return unavailableItemData(id)
    end
    if total > 3 then rendered[#rendered + 1] = "Hover for complete item stats." end
    return table.concat(rendered, "\n"), "ready", id
end

-- Triggered once per item per trainer visit, never from an OnUpdate/poll loop.
function Preview.Request(id)
    if type(id) ~= "number" or id < 1 or id > 100000000
        or id ~= math.floor(id) then return false end
    local item = field(_G, "C_Item")
    local fn = method(item, "RequestLoadItemDataByID")
    if not fn then return false end
    return pcall(fn, id)
end

-- Native tooltip for full facts, shown only by deliberate hover over the
-- addon-owned detail text. No Blizzard frame is hidden, reparented or parked.
function Preview.ShowTooltip(owner, link)
    if not itemID(link) or not ordinary(owner) then return false end
    local tooltip = field(_G, "GameTooltip")
    if not ordinary(tooltip) then return false end
    local setOwner = method(tooltip, "SetOwner")
    local setLink = method(tooltip, "SetHyperlink")
    local show = method(tooltip, "Show")
    if not setOwner or not setLink or not show then return false end
    local ok = pcall(function()
        setOwner(tooltip, owner, "ANCHOR_RIGHT")
        setLink(tooltip, link)
        show(tooltip)
    end)
    return ok
end

function Preview.HideTooltip()
    local tooltip = field(_G, "GameTooltip")
    local hide = method(tooltip, "Hide")
    if hide then pcall(hide, tooltip) end
end

return Probe
