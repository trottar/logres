local _, Logres = ...

-- P0230: zone-selecting, bounded QuestieDB NPC quest-start candidates.
-- Database spawns are historical possibilities, never confirmed quest offers.
local Nearby = Logres:RegisterModule("QuestieDBNearby", { autoEnable = true })
local LOCAL_RADIUS_YARDS = 50
local IDS_PER_FRAME = 96
local MAX_SPAWNS_PER_NPC = 32
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
            if startQuestID then self.questNPCs = self.questNPCs + 1 end

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

            if startQuestID or serviceKind then
                local spawns = ordinary(read(npc.spawns, id), "table")
                local here = spawns and ordinary(spawns[self.areaID], "table")
                if here then
                    local name = ordinary(read(npc.name, id), "string") or "Unknown NPC"
                    for j = 1, MAX_SPAWNS_PER_NPC do
                        local row = ordinary(here[j], "table")
                        if not row then break end
                        local x, y = number(row[1]), number(row[2])
                        if x and y and x >= 0 and x <= 100 and y >= 0 and y <= 100 then
                            -- Dual-role NPCs appear as their service type,
                            -- never as duplicate possible quest-giver glyphs.
                            if startQuestID and not serviceKind then
                                if #self.rows < MAX_CACHED_SPAWNS then
                                    self.rows[#self.rows + 1] = {
                                        x = x / 100, y = y / 100,
                                        npcID = id, name = name,
                                        questID = startQuestID, potential = true,
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
                        if startQuestID and not serviceKind then self.truncated = true end
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

function Nearby:GetNearbyRows(map, px, py, width, height)
    self.serviceNearby = 0
    self.serviceNearbyKinds = 0
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
                npcID = item.npcID, questID = item.questID,
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
    for i = 1, #hits do
        local row = hits[i]
        if not seen[row.npcID] then
            seen[row.npcID] = true
            unique[#unique + 1] = row
            if #unique >= MAX_NEARBY then break end
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
    self.serviceRows = {}
    self.serviceStatus = "not-started"
    self.serviceEnabled = false
    self.serviceNearby = 0
    self.frame = CreateFrame("Frame")
    self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.frame:RegisterEvent("PLAYER_MAP_CHANGED")
    self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self.frame:SetScript("OnEvent", function(_, event)
        if self.moduleEnabled then self:StartIndex(event) end
    end)
end

function Nearby:OnEnable()
    self.moduleEnabled = true
    self:StartIndex("enable")
end

function Nearby:OnDisable()
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
