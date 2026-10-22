-- P0312: read-only player profession context. NEVER a trainer purchase offer.
-- GetProfessions/GetProfessionInfo expose owned skills, not this NPC's services.
local _, Logres = ...
local Context = {}
Logres.NPCTrainerProfessionContext = Context
local reads, last = 0, "not-read"
local tiers = {[75]="Apprentice", [150]="Journeyman",
    [225]="Expert", [300]="Artisan"}

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end
local function api(name)
    local ok, fn = pcall(function() return _G[name] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end
local function number(value)
    return ordinary(value) and type(value) == "number" and value >= 0
        and value <= 1000 and value == math.floor(value)
end
function Context.Read()
    reads = reads + 1
    local output = {title="Your professions", lines={"Skill data unavailable"},
        status="unavailable", owned={}, nativeWrites=0, transactions=0}
    local get = api("GetProfessions")
    local info = api("GetProfessionInfo")
    if not get or not info then last=output.status; return output end
    local ok, p1, p2, arch, fish, cook, aid = pcall(get)
    if not ok then last="profession-list-deferred"; return output end
    local indexes = {p1, p2, arch, fish, cook, aid}
    local lines, owned = {}, {}
    for slot = 1, 6 do
        local index = indexes[slot]
        -- Empty profession slots have nil/false; neither implies that this NPC
        -- can teach that profession. Do not inspect a secret-capable index.
        if number(index) and index > 0 and index <= 800 then
            local got, name, icon, skill, maximum = pcall(info, index)
            if got and ordinary(name) and type(name) == "string"
                and #name > 0 and #name <= 35 and number(skill)
                and number(maximum) and maximum >= skill and maximum > 0 then
                local tier = tiers[maximum]
                local line = name .. " " .. tostring(skill) .. "/" .. tostring(maximum)
                if tier then line = line .. " (" .. tier .. ")" end
                if #line <= 54 then lines[#lines + 1] = line end
                owned[#owned + 1] = {name=name, level=skill, cap=maximum, tier=tier}
            end
        end
    end
    output.owned = owned
    if #lines > 0 then
        output.lines = lines
        output.status = "owned-skill-lines"
    else
        output.lines = {"No verified owned skills"}
        output.status = "no-readable-skill-lines"
    end
    last=output.status
    return output
end
-- P0313: a trainer's discipline is a separate, read-only source from
-- character ownership. A matching native service skill requirement wins;
-- with zero rows use independently guarded native unit-tooltip data or the
-- native trainer greeting. Ambiguity is displayed as UNKNOWN, not guessed.
local disciplineNames = {"Alchemy", "Blacksmithing", "Enchanting", "Engineering",
    "Herbalism", "Inscription", "Jewelcrafting", "Leatherworking", "Mining",
    "Skinning", "Tailoring", "Fishing", "Cooking", "First Aid", "Archaeology"}

local function wholeWord(haystack, word)
    local text, needle = haystack:lower(), word:lower()
    local at = 1
    while true do
        local first, lastIndex = string.find(text, needle, at, true)
        if not first then return false end
        local before = first > 1 and text:sub(first - 1, first - 1) or ""
        local after = text:sub(lastIndex + 1, lastIndex + 1)
        if not before:match("[%w]") and not after:match("[%w]") then return true end
        at = lastIndex + 1
    end
end

local function singleDiscipline(text)
    if type(text) ~= "string" or #text == 0 or #text > 600 then return nil end
    local found
    for _, name in ipairs(disciplineNames) do
        if wholeWord(text, name) then
            if found then return nil end
            found = name
        end
    end
    return found
end

local function sourceDiscipline(catalog)
    local found
    for i = 1, math.min(#catalog, 64) do
        local row = catalog[i]
        local label = type(row) == "table" and row.sourceSkillRequirement or nil
        if type(label) == "string" and #label > 0 and #label <= 42 then
            local name = singleDiscipline(label)
            if name then
                if found and found ~= name then return nil end
                found = name
            end
        end
    end
    return found
end

local function tooltipDiscipline()
    local ok, namespace = pcall(function() return _G.C_TooltipInfo end)
    if not ok or not ordinary(namespace) or type(namespace) ~= "table" then return nil end
    local fetched, fn = pcall(function() return namespace.GetUnit end)
    if not fetched or not ordinary(fn) or type(fn) ~= "function" then return nil end
    local received, payload = pcall(fn, "npc")
    if not received or not ordinary(payload) or type(payload) ~= "table" then return nil end
    local hasLines, lines = pcall(function() return payload.lines end)
    if not hasLines or not ordinary(lines) or type(lines) ~= "table" then return nil end
    local found
    -- A bounded fixed-slot read avoids branching on native collection length.
    for i = 1, 8 do
        local lineOK, line = pcall(function() return lines[i] end)
        if lineOK and ordinary(line) and type(line) == "table" then
            local got, label = pcall(function() return line.leftText end)
            if got and ordinary(label) and type(label) == "string"
                and #label > 0 and #label <= 120
                and wholeWord(label, "trainer") then
                local name = singleDiscipline(label)
                if name then
                    if found and found ~= name then return nil end
                    found = name
                end
            end
        end
    end
    return found
end

local function greetingDiscipline()
    local greeting = api("GetTrainerGreetingText")
    if not greeting then return nil end
    local ok, text = pcall(greeting)
    if not ok or not ordinary(text) then return nil end
    return singleDiscipline(text)
end

function Context.Focus(context, catalog)
    if type(context) ~= "table" or type(context.owned) ~= "table"
        or type(catalog) ~= "table" then return nil end
    local name = sourceDiscipline(catalog)
    if not name and #catalog == 0 then
        name = tooltipDiscipline() or greetingDiscipline()
    end
    if not name then
        return {title="Trainer profession unverified", rank="Rank not verified",
            detail="Blizzard trainer available"}
    end
    local owned
    for _, entry in ipairs(context.owned) do
        if entry.name == name then owned = entry; break end
    end
    local rank = owned and ((owned.tier or "Rank unclassified") .. " "
        .. tostring(owned.level) .. "/" .. tostring(owned.cap))
        or "Owned rank not verified"
    local nextTier, threshold
    local tierNames = {"Apprentice", "Journeyman", "Expert", "Artisan"}
    for _, row in ipairs(catalog) do
        if row.sourceSkillRequirement == name
            and type(row.sourceSkillRank) == "number"
            and row.sourceSkillRank >= 1 and row.sourceSkillRank <= 1000
            and row.sourceType == "unavailable" then
            for _, tier in ipairs(tierNames) do
                if type(row.name) == "string"
                    and row.name:sub(1, #tier + 1) == tier .. " " then
                    if not threshold or row.sourceSkillRank < threshold then
                        nextTier, threshold = tier, row.sourceSkillRank
                    end
                end
            end
        end
    end
    local detail = nextTier and ("Next: " .. nextTier .. " at " .. tostring(threshold))
        or (#catalog == 0 and "No listed training services" or "See offered training")
    return {title=name .. " trainer", rank=rank, detail=detail}
end

function Context.GetAudit()
    return {reads=reads, last=last, nativeWrites=0, transactions=0}
end
return Context
