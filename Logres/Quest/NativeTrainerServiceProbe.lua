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
        local copper, knownCost = scalar(costFn, index)
        if knownCost and cappedInteger(copper, 100000000000) then
            row.cost = copper
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

return Probe
