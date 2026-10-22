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
        status="unavailable", nativeWrites=0, transactions=0}
    local get = api("GetProfessions")
    local info = api("GetProfessionInfo")
    if not get or not info then last=output.status; return output end
    local ok, p1, p2, arch, fish, cook, aid = pcall(get)
    if not ok then last="profession-list-deferred"; return output end
    local indexes = {p1, p2, arch, fish, cook, aid}
    local lines = {}
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
            end
        end
    end
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
function Context.GetAudit()
    return {reads=reads, last=last, nativeWrites=0, transactions=0}
end
return Context
