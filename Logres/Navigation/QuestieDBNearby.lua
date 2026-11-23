local _, Logres = ...

-- P0230: zone-selecting, bounded QuestieDB NPC quest-start candidates.
-- Database spawns are historical possibilities, never confirmed quest offers.
local Nearby = Logres:RegisterModule("QuestieDBNearby", { autoEnable = true })
local LOCAL_RADIUS_YARDS = 50
local IDS_PER_FRAME = 96
local MAX_SPAWNS_PER_NPC = 32
local MAX_QUEST_IDS_PER_NPC = 32
local MAX_QUEST_ELIGIBILITY_CHECKS_PER_REFRESH = 16
local MAX_QUEST_ELIGIBILITY_CACHE = 2048
local MAX_CACHED_SPAWNS = 1024
local MAX_NEARBY = 8
local MAX_MAP_PARENT_DEPTH = 12
-- Service roles are source flags, NOT dependent on any historical quest.
-- One category per NPC, in preferred order; no fixed numeric bit values.
local SERVICE_ROLES = {
    { kind = "flight", flag = "FLIGHT_MASTER" },
    { kind = "inn", flag = "INNKEEPER" },
    { kind = "repair", flag = "REPAIR" },
    -- Discovery mode: enable every supported *service* enum role, even when
    -- Blizzard minimap tracking for that type is off. No generic gossip pins.
    { kind = "vendor", flag = "VENDOR" },
    { kind = "trainer", flag = "TRAINER" },
    { kind = "banker", flag = "BANKER" },
    { kind = "auction", flag = "AUCTIONEER" },
    { kind = "stable", flag = "STABLEMASTER" },
    { kind = "battle", flag = "BATTLEMASTER" },
    { kind = "healer", flag = "SPIRIT_HEALER" },
    { kind = "guide", flag = "SPIRIT_GUIDE" },
    { kind = "tabard", flag = "TABARD_DESIGNER" },
    { kind = "petition", flag = "PETITIONER" },
    { kind = "barber", flag = "BARBER" },
    { kind = "reforge", flag = "ARCANE_REFORGER" },
    { kind = "transmog", flag = "TRANSMOGRIFIER" },
}
local SERVICE_PRIORITY = {}
for index, role in ipairs(SERVICE_ROLES) do SERVICE_PRIORITY[role.kind] = index end
local MAX_SERVICE_SPAWNS_PER_NPC = 16
local MAX_SERVICE_SPAWNS_PER_CATEGORY = 96
local MAX_NEARBY_SERVICES = 32
local MAX_NEARBY_PER_SERVICE_KIND = 2

local function ordinary(value, kind)
    if type(issecretvalue) ~= "function" then return nil end
    local ok, secret = pcall(issecretvalue, value)
    if not ok or secret ~= false then return nil end
    if kind and type(value) ~= kind then return nil end
    return value
end

local function number(value)
    value = ordinary(value, "number")
    if not value or value ~= value or value == math.huge or value == -math.huge then
        return nil
    end
    return value
end

local function read(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn, ...)
    return ok and ordinary(value) or nil
end

-- P0484: independent, deliberately conservative quest eligibility. QuestieDB
-- describes historical quest records; these checks use current *player* facts.
-- Conditional data that Logres cannot prove still fails closed. No 3D NPC
-- inference, protected widget inspection, hidden quest API or ticker.
local function validQuestID(id)
    id = number(id)
    return id and id > 0 and id == math.floor(id) and id or nil
end

local function readBoolean(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if not ok then return nil end
    -- Unlike the provider's nonboolean read helper, false is a real result.
    return ordinary(result, "boolean")
end

local function questState(questID)
    local log = _G.C_QuestLog
    if not log or type(log.IsOnQuest) ~= "function"
        or type(log.IsQuestFlaggedCompleted) ~= "function" then
        return nil, nil
    end
    return readBoolean(log.IsOnQuest, questID),
        readBoolean(log.IsQuestFlaggedCompleted, questID)
end

local function containsBit(mask, bit)
    return number(mask) and number(bit) and bit > 0
        and math.floor(mask / bit) % 2 == 1
end

local function checkIDArray(ids, predicate, mode)
    if ids == nil then return true end
    if type(ids) ~= "table" or #ids > 32 then return false end
    -- An ordinary empty relationship list imposes no restriction.
    if #ids == 0 then return true end
    local found = false
    for i=1,#ids do
        local id = validQuestID(ids[i])
        if not id then return false end
        local value = predicate(id)
        if value == nil then return false end
        if mode == "all" and not value then return false end
        if value then found = true end
    end
    return mode == "all" or found
end

-- P0510: every *distinctly classified* QuestSort holiday is checked by the
-- realm calendar. QuestSort -22 is only "Seasonal": it does not identify
-- which holiday, so a DB-only offer cannot be inferred from any active event.
-- Nonseasonal records are unaffected and observed native offers remain first.
-- Titles are the only portable current-day calendar identity on our Forever
-- source path; numeric eventID values disagree among game implementations.
local HOLIDAY_QUEST_SORT = {
    [-21] = "hallows-end", [-41] = "day-of-the-dead",
    [-364] = "darkmoon-faire", [-366] = "lunar-festival",
    [-369] = "midsummer", [-370] = "brewfest",
    [-374] = "noblegarden", [-375] = "pilgrims-bounty",
    [-376] = "love-is-in-the-air", [-378] = "childrens-week",
}
local HOLIDAY_BY_TITLE = {
    hallowsend = "hallows-end", dayofthedead = "day-of-the-dead",
    darkmoonfaire = "darkmoon-faire",
    darkmoonfaireelwynn = "darkmoon-faire",
    darkmoonfairemulgore = "darkmoon-faire",
    darkmoonfaireterokkar = "darkmoon-faire",
    darkmoonfaireterokkarforest = "darkmoon-faire",
    lunarfestival = "lunar-festival",
    midsummer = "midsummer", midsummerfirefestival = "midsummer",
    brewfest = "brewfest", noblegarden = "noblegarden",
    pilgrimsbounty = "pilgrims-bounty", loveisintheair = "love-is-in-the-air",
    childrensweek = "childrens-week",
    -- The following holidays have no distinct QuestSort in our provider.
    -- They must not satisfy a *different* holiday's category.
    feastofwinterveil = "winter-veil", winterveil = "winter-veil",
    harvestfestival = "harvest-festival",
    worldofwarcraftanniversary = "anniversary", wowanniversary = "anniversary",
}
local function holidayTitleKey(title)
    title = ordinary(title, "string")
    if not title or #title > 128 then return nil end
    -- Only supported English aliases are accepted: no guesses from a
    -- different HOLIDAY record or an arbitrary user calendar entry.
    local simple = title:lower():gsub("[^%a%d]", "")
    local name = HOLIDAY_BY_TITLE[simple]
    if name then return name end
    return nil
end

local function calendarHolidayActive(required)
    local clock = ordinary(_G.C_DateAndTime, "table")
    local cal = ordinary(_G.C_Calendar, "table")
    if not clock or not cal or type(clock.GetCurrentCalendarTime) ~= "function"
        or type(cal.GetNumDayEvents) ~= "function"
        or type(cal.GetDayEvent) ~= "function" then
        return nil, "holiday-calendar-unavailable"
    end
    local now = ordinary(read(clock.GetCurrentCalendarTime), "table")
    local day = now and number(now.monthDay)
    if not day or day ~= math.floor(day) or day < 1 or day > 31 then
        return nil, "holiday-date-unavailable"
    end
    local n = number(read(cal.GetNumDayEvents, 0, day))
    if not n or n < 0 or n > 64 or n ~= math.floor(n) then
        return nil, "holiday-calendar-incomplete"
    end
    for index = 1, n do
        local event = ordinary(read(cal.GetDayEvent, 0, day, index), "table")
        if not event then return nil, "holiday-calendar-incomplete" end
        local eventType = ordinary(event.calendarType, "string")
        if not eventType then return nil, "holiday-calendar-incomplete" end
        if eventType == "HOLIDAY" then
            local title = ordinary(event.title, "string")
            if not title then return nil, "holiday-calendar-incomplete" end
            if holidayTitleKey(title) == required then
                return true, "holiday-active:" .. required
            end
        end
    end
    return false, "holiday-inactive:" .. required
end

-- A day change must not retain yesterday's eligibility from the bounded
-- per-quest cache. This is sampled only when that cache is consulted; no
-- added timer or Blizzard calendar mutation is required.
local function calendarDayKey()
    local clock = ordinary(_G.C_DateAndTime, "table")
    local now = clock and ordinary(read(clock.GetCurrentCalendarTime), "table")
    local year = now and number(now.year)
    local month = now and number(now.month)
    local day = now and number(now.monthDay)
    if not year or year < 2000 or year > 9999 or year ~= math.floor(year)
        or not month or month < 1 or month > 12 or month ~= math.floor(month)
        or not day or day < 1 or day > 31 or day ~= math.floor(day) then
        return nil
    end
    return year * 10000 + month * 100 + day
end

local function independentlyEligible(questID)
    local db = ordinary(_G.QuestDB, "table")
    local lib = ordinary(_G.LibQuestieDB, "table")
    if not db or type(db.Get) ~= "function" or not lib
        or type(lib.RequireContract) ~= "function" then
        return false, "quest-data-unavailable"
    end
    if not read(db.Get, questID, "name") then
        return false, "quest-record-missing"
    end
    local onQuest, completed = questState(questID)
    if onQuest == nil or completed == nil then
        return false, "native-quest-status-unavailable"
    end
    if onQuest or completed then return false, "already-active-or-complete" end
    local level = number(read(_G.UnitLevel, "player"))
    if not level or level <= 0 then return false, "player-level-unavailable" end
    -- QuestieDB has sparse optional fields. A successful, ordinary nil is an
    -- absent restriction, while a failed call or secret-capable result is
    -- UNKNOWN and must not authorize a quest marker.
    local function fact(key)
        local ok, value = pcall(db.Get, questID, key)
        if not ok or type(issecretvalue) ~= "function" then return nil, false end
        local classified, secret = pcall(issecretvalue, value)
        if not classified or secret ~= false then return nil, false end
        return value, true
    end
    local function optionalNumber(key)
        local value, known = fact(key)
        if not known then return nil, false end
        if value == nil then return 0, true end
        return number(value), number(value) ~= nil
    end
    local requiredLevel, requiredKnown = optionalNumber("requiredLevel")
    local maxLevel, maxKnown = optionalNumber("requiredMaxLevel")
    if not requiredKnown or not maxKnown then return false, "level-data-unavailable" end
    if (requiredLevel > 0 and level < requiredLevel)
        or (maxLevel > 0 and level > maxLevel) then
        return false, "level-requirement"
    end

    local races, racesKnown = optionalNumber("requiredRaces")
    local classes, classesKnown = optionalNumber("requiredClasses")
    if not racesKnown or not classesKnown then return false, "mask-data-unavailable" end
    if races > 0 then
        if read(lib.RequireContract, 3) ~= true then return false, "race-contract-unavailable" end
        local e = ordinary(lib.Enum, "table")
        local masks = e and ordinary(e.raceMaskById, "table")
        local ok, _, _, rawID = pcall(_G.UnitRace, "player")
        local id = ok and number(rawID) or nil
        local bit = masks and id and number(masks[id])
        if not bit then return false, "race-unavailable" end
        if not containsBit(races, bit) then return false, "wrong-race" end
    end
    if classes > 0 then
        if read(lib.RequireContract, 4) ~= true then return false, "class-contract-unavailable" end
        local e = ordinary(lib.Enum, "table")
        local classKeys = e and ordinary(e.classKeys, "table")
        local ok, _, rawToken = pcall(_G.UnitClass, "player")
        local token = ok and ordinary(rawToken, "string") or nil
        local bit = classKeys and token and number(classKeys[token])
        if not bit then return false, "class-unavailable" end
        if not containsBit(classes, bit) then return false, "wrong-class" end
    end
    local function completedQuest(id)
        local _, done = questState(id)
        return done
    end
    local function activeQuest(id)
        local active = questState(id)
        return active
    end
    local function activeOrCompletedQuest(id)
        local active, done = questState(id)
        if active == nil or done == nil then return nil end
        return active or done
    end
    local group, groupKnown = fact("preQuestGroup")
    local single, singleKnown = fact("preQuestSingle")
    if not groupKnown or not singleKnown then return false, "prerequisite-read-unavailable" end
    if not checkIDArray(group, completedQuest, "all")
        or not checkIDArray(single, completedQuest, "any") then
        return false, "missing-prerequisite"
    end
    local exclusives, exclusiveKnown = fact("exclusiveTo")
    if not exclusiveKnown then return false, "exclusive-read-unavailable" end
    if exclusives ~= nil and not checkIDArray(exclusives, function(id)
        local active = activeOrCompletedQuest(id)
        if active == nil then return nil end
        return not active
    end, "all") then return false, "exclusive-quest-state" end
    for _, spec in ipairs({
        {"parentQuest", activeQuest, false},
        {"nextQuestInChain", activeOrCompletedQuest, true},
        {"availableUntilCompleted", completedQuest, true},
        {"availableStartingWith", activeOrCompletedQuest, false},
        {"disabledByQuest", activeQuest, true},
        {"breadcrumbForQuestId", activeOrCompletedQuest, true},
    }) do
        local value, known = optionalNumber(spec[1])
        if not known then return false, "chain-data-unavailable" end
        if value ~= 0 then
            if not validQuestID(value) then return false, "invalid-chain-id" end
            local state = spec[2](value)
            if state == nil or state == spec[3] then
                return false, "chain-condition-" .. spec[1]
            end
        end
    end
    -- These requirements need additional verified player/session context.
    -- No general quest marker can be asserted from their historical data.
    for _, name in ipairs({"requiredSkill", "requiredMinRep", "requiredMaxRep",
        "requiredRanks"}) do
        local value, known = fact(name)
        if not known then return false, "conditional-read-" .. name end
        if value ~= nil then
            -- An explicitly empty ranks list is also unrestricted; other
            -- populated conditional requirements are not modeled here.
            if name ~= "requiredRanks" or type(value) ~= "table"
                or #value ~= 0 then
                return false, "conditional-" .. name
            end
        end
    end
    for _, name in ipairs({"requiredSpell", "requiredSpecialization"}) do
        local value, known = optionalNumber(name)
        if not known or value ~= 0 then
            return false, "conditional-" .. name
        end
    end
    local flags, flagsKnown = optionalNumber("specialFlags")
    if not flagsKnown or flags ~= 0 then return false, "conditional-special-flags" end
    -- QuestFlags encode ordinary quest *features* as well as restrictions.
    -- Common Classic bits such as SHARABLE (8) are not proof of a conditional
    -- offer and must not exclude a presently eligible quest. Deny any bit
    -- whose ordinary, non-eligibility meaning has not been corroborated,
    -- including recurring (daily/weekly), unavailable, and auto-accept flags.
    local questFlags, questFlagsKnown = optionalNumber("questFlags")
    if not questFlagsKnown then return false, "conditional-quest-flags" end
    if questFlags < 0 or questFlags ~= math.floor(questFlags) then
        return false, "conditional-quest-flags"
    end
    local remainingFlags = questFlags
    for _, bit in ipairs({1, 2, 4, 8, 32, 64, 256, 512}) do
        if math.floor(questFlags / bit) % 2 == 1 then
            remainingFlags = remainingFlags - bit
        end
    end
    if remainingFlags ~= 0 then return false, "conditional-quest-flags" end
    local category, categoryKnown = optionalNumber("zoneOrSort")
    if not categoryKnown then return false, "quest-category-unavailable" end
    local requiredHoliday = HOLIDAY_QUEST_SORT[category]
    if requiredHoliday then
        -- A current-day matching holiday is required for DB-only inference.
        -- GetNearbyRows promotes ordinary native offers before this path.
        local active, reason = calendarHolidayActive(requiredHoliday)
        if active ~= true then return false, reason end
    elseif category == -22 then
        -- "Seasonal" alone does not say which holiday. Requiring only any
        -- active holiday could show Winter Veil during Lunar Festival.
        -- Keep native current-offer priority rather than guessing.
        return false, "seasonal-holiday-identity-unknown"
    end
    return true, "player-requirements-satisfied"
end

-- P0504: exact NPC *observed* without native available offers. This is
-- a temporary negative fact about this player/session, never a QuestieDB
-- history edit. All progression/zone invalidations reopen eligibility.
local function currentOrdinaryNPCID()
    if type(_G.UnitGUID) ~= "function" then return nil end
    local guid = read(_G.UnitGUID, "npc")
    guid = ordinary(guid, "string")
    if not guid then return nil end
    local raw = guid:match("^Creature%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)%-")
    local id = raw and tonumber(raw)
    return id and id > 0 and id == math.floor(id) and id or nil
end

function Nearby:ObserveNativeAvailableQuests(event)
    if not self.moduleEnabled then return end
    local id = currentOrdinaryNPCID()
    if not id then return end
    local absent
    if event == "GOSSIP_SHOW" then
        local api = ordinary(_G.C_GossipInfo, "table")
        local fn = api and api.GetAvailableQuests
        if type(fn) == "function" then
            local ok, rows = pcall(fn)
            rows = ok and ordinary(rows, "table") or nil
            if rows then
                local okFirst, first = pcall(function() return rows[1] end)
                if okFirst and ordinary(first) ~= nil then
                    absent = false
                elseif okFirst and first == nil then
                    absent = true
                end
            end
        end
    elseif event == "QUEST_GREETING" then
        local fn = _G.GetNumAvailableQuests
        if type(fn) == "function" then
            local ok, value = pcall(fn)
            value = ok and number(value) or nil
            if value and value >= 0 and value <= 24
                and value == math.floor(value) then
                absent = value == 0
            end
        end
    end
    if absent == nil then return end
    self.observedNoOfferNPCIDs = self.observedNoOfferNPCIDs or {}
    self.observedNoOfferNPCIDs[id] = absent or nil
    self.observedNoOfferLastNPCID = id
    self.observedNoOfferLastReason = absent and event .. "-no-offers"
        or event .. "-has-offers"
end

function Nearby:InvalidateEligibility(reason)
    self.observedNoOfferNPCIDs = {}
    self.observedNoOfferLastReason = "invalidated-" .. tostring(reason or "unknown")
    self.questEligibilityCache = {}
    self.questEligibilityCacheCount = 0
    self.questEligibilityLastInvalidation = reason or "initialize"
end

function Nearby:EligibilityForQuest(questID)
    questID = validQuestID(questID)
    if not questID then return false, "invalid-quest-id" end
    local today = calendarDayKey()
    if today and self.questEligibilityCalendarDay
        and today ~= self.questEligibilityCalendarDay then
        self:InvalidateEligibility("calendar-day-changed")
    end
    if today then self.questEligibilityCalendarDay = today end
    if type(self.questEligibilityCache) ~= "table" then
        self:InvalidateEligibility("implicit")
    end
    self.questEligibilityChecksThisRefresh = self.questEligibilityChecksThisRefresh or 0
    local cached = self.questEligibilityCache[questID]
    if cached then return cached[1], cached[2] end
    if self.questEligibilityChecksThisRefresh >= MAX_QUEST_ELIGIBILITY_CHECKS_PER_REFRESH
        or self.questEligibilityCacheCount >= MAX_QUEST_ELIGIBILITY_CACHE then
        self.questEligibilityLimited = true
        return false, "bounded-check-limit"
    end
    self.questEligibilityChecksThisRefresh = self.questEligibilityChecksThisRefresh + 1
    local allowed, reason = independentlyEligible(questID)
    self.questEligibilityCache[questID] = {allowed, reason}
    self.questEligibilityCacheCount = self.questEligibilityCacheCount + 1
    return allowed, reason
end

-- QuestieDB publishes canonical Forever UiMapID -> AreaID data as a Lua
-- source string. Only parse numeric pairs: never execute third-party source.
local function readAreaMap(lib)
    local support = ordinary(lib.Support, "table")
    local get = support and support.Get
    local zones = read(get, "ZoneDB")
    zones = ordinary(zones, "table")
    local private = zones and ordinary(zones.private, "table")
    local source = private and ordinary(private.uiMapIdToAreaId, "string")
    if not source or not source:match("^%s*return%s*{") then
        return nil
    end
    local result, count = {}, 0
    for map, area in source:gmatch("%[(%d+)%]%s*=%s*(%d+)") do
        map, area = tonumber(map), tonumber(area)
        if map and area and map > 0 and area > 0 and not result[map] then
            result[map] = area
            count = count + 1
        end
    end
    return count >= 40 and result or nil, count
end

-- Retain ordinary map ancestry for diagnosis. The provider's supported
-- canonical mappings remain the *only* authority for accepting an AreaID.
-- Never guess an AreaID from continent/floor similarity or native pin state.
local function getCurrentZone(mapping)
    local mapApi = _G.C_Map
    if not mapApi or type(mapApi.GetBestMapForUnit) ~= "function" then
        return nil, nil, "map-api-unavailable", nil, "api-unavailable"
    end
    local current = number(read(mapApi.GetBestMapForUnit, "player"))
    if not current then
        return nil, nil, "current-map-unavailable", nil, "current-unavailable"
    end
    local leaf, chain, seen = current, {}, {}
    local stop = "depth-limit"
    for _ = 1, MAX_MAP_PARENT_DEPTH do
        chain[#chain + 1] = tostring(current) -- already ordinary number
        if mapping[current] then
            return current, mapping[current], nil, leaf,
                table.concat(chain, ">")
        end
        if seen[current] then stop = "cycle"; break end
        seen[current] = true
        local info = ordinary(read(mapApi.GetMapInfo, current), "table")
        if not info then stop = "map-info-unavailable"; break end
        local parent = number(info.parentMapID)
        if not parent or parent <= 0 then
            stop = "no-parent"
            break
        end
        if parent == current then stop = "self-parent"; break end
        current = parent
    end
    return nil, nil, "map-not-in-provider-zone-table", leaf,
        table.concat(chain, ">") .. ":" .. stop
end

function Nearby:StopIndex()
    if self.frame then self.frame:SetScript("OnUpdate", nil) end
    self.scanning = false
    self.ids = nil
    self.npc = nil
end

function Nearby:Unavailable(reason)
    self:StopIndex()
    self.complete = false
    self.rows = {}
    self.serviceRows = {}
    self.serviceEnabled = false
    self.serviceStatus = reason
    self.serviceNearby = 0
    self.serviceNearbyKinds = 0
    self.mapID = nil
    self.areaID = nil
    self.areaMapping = nil
    self.state = reason
end

function Nearby:StartIndex(reason)
    if not self.moduleEnabled then return end
    self.lastTrigger = reason
    self.requestedMap = nil
    self.mapTrace = nil
    self.mappingEntries = 0
    self.resolutionFailure = nil
    local lib = ordinary(_G.LibQuestieDB, "table")
    local npc = ordinary(_G.NpcDB, "table")
    if not lib or not npc or type(lib.RequireContract) ~= "function"
        or read(lib.RequireContract, 1) ~= true then
        self:Unavailable("provider-unavailable-or-incompatible")
        return
    end
    local mode = ordinary(lib.readMode, "string")
    local flavor
    if mode == "baked" then
        local addon = _G.C_AddOns
        local metadata = addon and addon.GetAddOnMetadata or _G.GetAddOnMetadata
        flavor = read(metadata, "QuestieDB", "X-Flavor")
    elseif mode == "source" then
        local info = ordinary(lib.flavor, "table")
        flavor = info and ordinary(info.name, "string") or nil
    end
    if flavor ~= "Forever" then
        self:Unavailable("forever-flavor-unverified")
        return
    end
    if type(npc.GetAllIds) ~= "function" or type(npc.zoneID) ~= "function"
        or type(npc.questStarts) ~= "function" or type(npc.spawns) ~= "function"
        or type(npc.name) ~= "function" then
        self:Unavailable("npc-reader-unavailable")
        return
    end
    local mapping, count = readAreaMap(lib)
    self.mappingEntries = count or 0
    if not mapping then
        self:Unavailable("provider-map-table-unavailable")
        return
    end
    local map, area, failure, leaf, chain = getCurrentZone(mapping)
    self.requestedMap = leaf
    self.mapTrace = chain
    self.resolutionFailure = failure
    if not map then
        self:Unavailable(failure)
        return
    end
    if self.mapID == map and self.areaID == area
        and (self.complete or self.scanning) then return end
    self:StopIndex()
    -- Contract 1 preserves the proven quest-giver feed. Contract 4 only
    -- authorizes the additional NPC role flags and active-flavor enum.
    self.serviceEnabled = false
    self.serviceStatus = "contract4-unavailable"
    self.serviceRoleMasks = {}
    if type(npc.npcFlags) == "function" and read(lib.RequireContract, 4) == true then
        local enums = ordinary(lib.Enum, "table")
        local roles = enums and ordinary(enums.npcFlags, "table")
        if roles then
            for _, role in ipairs(SERVICE_ROLES) do
                local mask = number(roles[role.flag])
                if mask and mask > 0 and mask == math.floor(mask)
                    and mask < 2147483648 then
                    -- A single bit is required to avoid ambiguous category tests.
                    local check = mask
                    while check > 1 and check % 2 == 0 do check = check / 2 end
                    if check == 1 then self.serviceRoleMasks[role.kind] = mask end
                end
            end
            self.serviceEnabled = next(self.serviceRoleMasks) ~= nil
            self.serviceStatus = self.serviceEnabled and "indexing" or "service-masks-unavailable"
        else
            self.serviceStatus = "service-enum-unavailable"
        end
    end
    local ids = ordinary(read(npc.GetAllIds), "table")
    if not ids then self.state = "npc-id-list-unavailable"; return end
    self.npc = npc
    self.ids = ids -- provider-owned read-only list; never modify.
    self.idCount = #ids
    self.scanIndex = 1
    self.scanned = 0
    self.zoneNPCs = 0
    self.questNPCs = 0
    self.questIDTruncated = false
    self.truncated = false
    self.rows = {}
    self.serviceRows = {}
    self.serviceCategoryCached = {}
    for _, role in ipairs(SERVICE_ROLES) do self.serviceCategoryCached[role.kind] = 0 end
    self.serviceTruncated = false
    self.serviceNearby = 0
    self.serviceNearbyKinds = 0
    self.mapID = map
    self.areaID = area
    self.areaMapping = mapping
    self.complete = false
    self.scanning = true
    self.state = "indexing"
    self.lastTrigger = reason
    self.frame:SetScript("OnUpdate", function() self:ScanChunk() end)
end

function Nearby:ScanChunk()
    if not self.scanning or not self.moduleEnabled then return end
    local npc = self.npc
    local last = math.min(self.scanIndex + IDS_PER_FRAME - 1, self.idCount)
    for idx = self.scanIndex, last do
        self.scanned = self.scanned + 1
        local id = number(self.ids[idx])
        if id and id > 0 and number(read(npc.zoneID, id)) == self.areaID then
            self.zoneNPCs = self.zoneNPCs + 1
            local quests = ordinary(read(npc.questStarts, id), "table")
            local startQuestID = quests and number(quests[1])
            local questIDs, questSeen = {}, {}
            if quests then
                for qi = 1, MAX_QUEST_IDS_PER_NPC do
                    local qid = number(quests[qi])
                    if qid == nil then break end
                    if qid > 0 and qid == math.floor(qid) and not questSeen[qid] then
                        questSeen[qid] = true
                        questIDs[#questIDs + 1] = qid
                    end
                end
                if ordinary(quests[MAX_QUEST_IDS_PER_NPC + 1]) ~= nil then
                    self.questIDTruncated = true
                end
            end
            if #questIDs > 0 then self.questNPCs = self.questNPCs + 1 end

            -- A service is a service regardless of the NPC's quest history.
            -- Only the optional v4 capability uses npcFlags; v1 quest indexing
            -- continues unchanged if that contract or enum is unavailable.
            local serviceKind
            if self.serviceEnabled then
                local bits = number(read(npc.npcFlags, id))
                if bits and bits >= 0 and bits == math.floor(bits) then
                    for _, role in ipairs(SERVICE_ROLES) do
                        local mask = self.serviceRoleMasks[role.kind]
                        if mask and bits % (mask * 2) >= mask then
                            serviceKind = role.kind
                            break -- one preferred service category per NPC
                        end
                    end
                end
            end

            if #questIDs > 0 or serviceKind then
                local spawns = ordinary(read(npc.spawns, id), "table")
                local here = spawns and ordinary(spawns[self.areaID], "table")
                if here then
                    local name = ordinary(read(npc.name, id), "string") or "Unknown NPC"
                    for j = 1, MAX_SPAWNS_PER_NPC do
                        local row = ordinary(here[j], "table")
                        if not row then break end
                        local x, y = number(row[1]), number(row[2])
                        if x and y and x >= 0 and x <= 100 and y >= 0 and y <= 100 then
                            -- Quest and service histories coexist in the index;
                            -- only the compass's native offer gate may promote
                            -- a historical quest row into an active glyph.
                            if #questIDs > 0 then
                                if #self.rows < MAX_CACHED_SPAWNS then
                                    self.rows[#self.rows + 1] = {
                                        x = x / 100, y = y / 100,
                                        npcID = id, name = name,
                                        questID = questIDs[1], questIDs = questIDs,
                                        potential = true,
                                    }
                                else
                                    self.truncated = true
                                end
                            end
                            if serviceKind and j <= MAX_SERVICE_SPAWNS_PER_NPC then
                                local count = self.serviceCategoryCached[serviceKind]
                                if count < MAX_SERVICE_SPAWNS_PER_CATEGORY then
                                    self.serviceRows[#self.serviceRows + 1] = {
                                        x = x / 100, y = y / 100,
                                        npcID = id, name = name,
                                        serviceKind = serviceKind, potential = true,
                                    }
                                    self.serviceCategoryCached[serviceKind] = count + 1
                                else
                                    self.serviceTruncated = true
                                end
                            elseif serviceKind and j > MAX_SERVICE_SPAWNS_PER_NPC then
                                self.serviceTruncated = true
                            end
                        end
                    end
                    if ordinary(here[MAX_SPAWNS_PER_NPC + 1], "table") then
                        if #questIDs > 0 then self.truncated = true end
                        if serviceKind then self.serviceTruncated = true end
                    end
                end
            end
        end
    end
    self.scanIndex = last + 1
    if self.scanIndex <= self.idCount then return end
    self.complete = true
    self.state = self.truncated and "ready-partial" or "ready"
    if self.serviceEnabled then
        self.serviceStatus = self.serviceTruncated and "ready-partial" or "ready"
    end
    self:StopIndex() -- finite build; no extra provider scan or periodic polling.
end

local function readVector(value)
    value = ordinary(value)
    if value == nil then return nil, nil end
    local x, y
    if type(value.GetXY) == "function" then
        local ok
        ok, x, y = pcall(value.GetXY, value)
        if not ok then return nil, nil end
    else
        x, y = value.x, value.y
    end
    return number(x), number(y)
end

function Nearby:GetNearbyRows(map, px, py, width, height, currentQuestOffers)
    self.serviceNearby = 0
    self.serviceNearbyKinds = 0
    self.questEligibilityChecksThisRefresh = 0
    self.questEligibilityQualifiedNPCs = 0
    self.questEligibilityRejectedNPCs = 0
    self.questEligibilityLimited = false
    self.questEligibilityLastReason = "none"
    self.questEligibilityLastQuestID = nil
    self.questEligibilityLastNPCID = nil
    self.questEligibilityClosestRejectedNPCID = nil
    self.questEligibilityClosestRejectedQuestID = nil
    self.questEligibilityClosestRejectedReason = "none"
    self.questEligibilityFirstQualifiedNPCID = nil
    self.questEligibilityFirstQualifiedQuestID = nil
    if not self.complete or not self.mapID then return {}, self.state end
    -- A map transition invalidates old-zone presentation immediately, even
    -- before the registered map event has built the next zone's index.
    local current, currentArea = getCurrentZone(self.areaMapping)
    if current ~= self.mapID or currentArea ~= self.areaID then
        return {}, "map-changing"
    end
    -- On a subzone, project from the provider's canonical parent map using
    -- that map's own player position and world size, never mixed map frames.
    if map ~= self.mapID then
        local api = _G.C_Map
        if not api then return {}, "canonical-map-api-unavailable" end
        local position = read(api.GetPlayerMapPosition, self.mapID, "player")
        px, py = readVector(position)
        local getSize = api.GetMapWorldSize
        if type(getSize) ~= "function" then return {}, "canonical-world-size-unavailable" end
        local ok, w, h = pcall(getSize, self.mapID)
        width, height = ok and w or nil, ok and h or nil
    end
    px, py, width, height = number(px), number(py), number(width), number(height)
    if not px or not py or not width or not height or width <= 0 or height <= 0 then
        return {}, "position-unavailable"
    end
    local hits = {}
    for i = 1, #self.rows do
        local item = self.rows[i]
        local dx = (item.x - px) * width
        local dy = (item.y - py) * height
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist <= LOCAL_RADIUS_YARDS then
            hits[#hits + 1] = {
                dxYards = dx, dyYards = dy, name = item.name,
                    sourceX = item.x, sourceY = item.y,
                npcID = item.npcID, questID = item.questID,
                questIDs = item.questIDs,
                distanceYards = dist, potential = true,
            }
        end
    end
    table.sort(hits, function(a,b)
        if a.distanceYards == b.distanceYards then return a.npcID < b.npcID end
        return a.distanceYards < b.distanceYards
    end)
    self.nearbyCount = #hits
    local unique, seen = {}, {}
    -- Preserve the original eight-NPC cap, but prevent eight *historical*
    -- NPCs from excluding a farther/currently native-confirmed giver.
    if type(currentQuestOffers) == "table" then
        for i=1,#hits do
            local row = hits[i]
            if not seen[row.npcID] then
                local ids = row.questIDs
                if type(ids) == "table" then
                    for qi=1,math.min(#ids,MAX_QUEST_IDS_PER_NPC) do
                        local id = ids[qi]
                        if type(id) == "number" and currentQuestOffers[id] == true then
                            seen[row.npcID] = true
                            unique[#unique + 1] = row
                            break
                        end
                    end
                end
                if #unique >= MAX_NEARBY then break end
            end
        end
    end
    -- Native positions/offer matches win first. For native-feed gaps, a
    -- separate player-state eligibility check may promote a QuestieDB NPC,
    -- but database history alone remains insufficient.
    if #unique < MAX_NEARBY then
        for i = 1, #hits do
            local row = hits[i]
            if not seen[row.npcID] then
                local ids = row.questIDs
                local confirmed
                local observedNoOffer = self.observedNoOfferNPCIDs
                    and self.observedNoOfferNPCIDs[row.npcID] == true
                if not observedNoOffer and type(ids) == "table" then
                    for qi=1,math.min(#ids,MAX_QUEST_IDS_PER_NPC) do
                        local id = ids[qi]
                        local allowed, reason = self:EligibilityForQuest(id)
                        self.questEligibilityLastReason = reason
                        self.questEligibilityLastQuestID = id
                        self.questEligibilityLastNPCID = row.npcID
                        if not allowed and self.questEligibilityClosestRejectedNPCID == nil then
                            self.questEligibilityClosestRejectedNPCID = row.npcID
                            self.questEligibilityClosestRejectedQuestID = id
                            self.questEligibilityClosestRejectedReason = reason
                        end
                        if allowed then confirmed = id; break end
                    end
                end
                if confirmed then
                    row.questID = confirmed
                    row.providerEligible = true
                    seen[row.npcID] = true
                    unique[#unique + 1] = row
                    self.questEligibilityQualifiedNPCs = self.questEligibilityQualifiedNPCs + 1
                    if self.questEligibilityFirstQualifiedNPCID == nil then
                        self.questEligibilityFirstQualifiedNPCID = row.npcID
                        self.questEligibilityFirstQualifiedQuestID = confirmed
                    end
                    if #unique >= MAX_NEARBY then break end
                else
                    self.questEligibilityRejectedNPCs = self.questEligibilityRejectedNPCs + 1
                    if observedNoOffer then
                        self.questEligibilityLastReason = "native-visit-no-offers"
                        self.questEligibilityLastNPCID = row.npcID
                    end
                end
            end
        end
    end
    -- Preserve the original discovery/diagnostic pool even when eligibility
    -- cannot be evaluated: Compass will continue to exclude unproven quests.
    if #unique < MAX_NEARBY then
        for i = 1, #hits do
            local row = hits[i]
            if not seen[row.npcID] then
                seen[row.npcID] = true
                unique[#unique + 1] = row
                if #unique >= MAX_NEARBY then break end
            end
        end
    end
    local serviceHits = {}
    if self.serviceEnabled then
        for i = 1, #self.serviceRows do
            local item = self.serviceRows[i]
            local dx = (item.x - px) * width
            local dy = (item.y - py) * height
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist <= LOCAL_RADIUS_YARDS then
                serviceHits[#serviceHits + 1] = {
                    dxYards = dx, dyYards = dy, name = item.name,
                    sourceX = item.x, sourceY = item.y,
                    npcID = item.npcID, serviceKind = item.serviceKind,
                    distanceYards = dist, potential = true,
                }
            end
        end
    end
    self.serviceNearby = #serviceHits
    local kinds = {}
    for _, hit in ipairs(serviceHits) do kinds[hit.serviceKind] = true end
    local count = 0
    for _ in pairs(kinds) do count = count + 1 end
    self.serviceNearbyKinds = count
    -- Flight masters retain first choice among services in the capped pool.
    -- This ordering does not change native POI or accepted quest lanes.
    table.sort(serviceHits, function(a, b)
        local first = SERVICE_PRIORITY[a.serviceKind] or 99
        local second = SERVICE_PRIORITY[b.serviceKind] or 99
        if first ~= second then return first < second end
        if a.distanceYards == b.distanceYards then return a.npcID < b.npcID end
        return a.distanceYards < b.distanceYards
    end)
    local services, seenService, perKind = {}, {}, {}
    for i = 1, #serviceHits do
        local row = serviceHits[i]
        local count = perKind[row.serviceKind] or 0
        if not seenService[row.npcID] and count < MAX_NEARBY_PER_SERVICE_KIND then
            seenService[row.npcID] = true
            perKind[row.serviceKind] = count + 1
            services[#services + 1] = row
            if #services >= MAX_NEARBY_SERVICES then break end
        end
    end
    return unique, self.state, services
end

function Nearby:GetDebugStatus()
    return {
        state = self.state, map = self.mapID, area = self.areaID,
        requestedMap = self.requestedMap, mapTrace = self.mapTrace,
        mappingEntries = self.mappingEntries,
        resolutionFailure = self.resolutionFailure,
        lastTrigger = self.lastTrigger,
        complete = self.complete == true, scanned = self.scanned or 0,
        ids = self.idCount or 0, zoneNPCs = self.zoneNPCs or 0,
        questNPCs = self.questNPCs or 0, spawns = #self.rows,
        questIDTruncated = self.questIDTruncated == true,
        eligibilityQualified = self.questEligibilityQualifiedNPCs or 0,
        eligibilityRejected = self.questEligibilityRejectedNPCs or 0,
        eligibilityLimited = self.questEligibilityLimited == true,
        eligibilityCache = self.questEligibilityCacheCount or 0,
        eligibilityChecks = self.questEligibilityChecksThisRefresh or 0,
        eligibilityLastReason = self.questEligibilityLastReason or "none",
        eligibilityLastQuestID = self.questEligibilityLastQuestID,
        eligibilityLastNPCID = self.questEligibilityLastNPCID,
        eligibilityClosestRejectedNPCID = self.questEligibilityClosestRejectedNPCID,
        eligibilityClosestRejectedQuestID = self.questEligibilityClosestRejectedQuestID,
        eligibilityClosestRejectedReason = self.questEligibilityClosestRejectedReason,
        eligibilityFirstQualifiedNPCID = self.questEligibilityFirstQualifiedNPCID,
        eligibilityFirstQualifiedQuestID = self.questEligibilityFirstQualifiedQuestID,
        eligibilityLastInvalidation = self.questEligibilityLastInvalidation,
        observedNoOfferLastNPCID = self.observedNoOfferLastNPCID,
        observedNoOfferLastReason = self.observedNoOfferLastReason,

        nearby = self.nearbyCount or 0, truncated = self.truncated == true,
        radius = LOCAL_RADIUS_YARDS,
        serviceEnabled = self.serviceEnabled == true,
        serviceStatus = self.serviceStatus or "not-started",
        serviceCached = #(self.serviceRows or {}),
        serviceNearby = self.serviceNearby or 0,
        serviceNearbyKinds = self.serviceNearbyKinds or 0,
        serviceRoleCount = (function()
            local count = 0
            for _ in pairs(self.serviceRoleMasks or {}) do count = count + 1 end
            return count
        end)(),
        serviceFlightCached = self.serviceCategoryCached and self.serviceCategoryCached.flight or 0,
        serviceInnCached = self.serviceCategoryCached and self.serviceCategoryCached.inn or 0,
        serviceRepairCached = self.serviceCategoryCached and self.serviceCategoryCached.repair or 0,
        serviceTruncated = self.serviceTruncated == true,
        coverage = "provider-canonical-zone-primary-NPCs-only",
    }
end

function Nearby:OnInitialize()
    self.moduleEnabled = false
    self.rows = {}
    self.state = "not-started"
    self:InvalidateEligibility("initialize")
    self.serviceRows = {}
    self.serviceStatus = "not-started"
    self.serviceEnabled = false
    self.serviceNearby = 0
    self.frame = CreateFrame("Frame")
    self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.frame:RegisterEvent("PLAYER_MAP_CHANGED")
    self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self.frame:RegisterEvent("GOSSIP_SHOW")
    self.frame:RegisterEvent("QUEST_GREETING")
    for _, event in ipairs({"QUEST_LOG_UPDATE", "QUEST_ACCEPTED", "QUEST_REMOVED",
        "QUEST_TURNED_IN", "PLAYER_LEVEL_UP", "UPDATE_FACTION",
        "SKILL_LINES_CHANGED", "SPELLS_CHANGED",
        "CALENDAR_UPDATE_EVENT_LIST"}) do
        self.frame:RegisterEvent(event)
    end
    self.frame:SetScript("OnEvent", function(_, event)
        if event == "GOSSIP_SHOW" or event == "QUEST_GREETING" then
            self:ObserveNativeAvailableQuests(event)
            return
        end
        self:InvalidateEligibility(event)
        if self.moduleEnabled and (event == "PLAYER_ENTERING_WORLD"
            or event == "PLAYER_MAP_CHANGED" or event == "ZONE_CHANGED_NEW_AREA") then
            self:StartIndex(event)
        end
    end)
end

function Nearby:OnEnable()
    self.moduleEnabled = true
    self:StartIndex("enable")
end

function Nearby:OnDisable()
    self:InvalidateEligibility("disabled")
    self.moduleEnabled = false
    self:StopIndex()
    self.complete = false
    self.rows = {}
    self.serviceRows = {}
    self.serviceEnabled = false
    self.serviceNearby = 0
    self.serviceStatus = "disabled"
    self.state = "disabled"
end
