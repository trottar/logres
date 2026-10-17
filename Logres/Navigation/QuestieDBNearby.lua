local _, Logres = ...

-- P0230: zone-selecting, bounded QuestieDB NPC quest-start candidates.
-- Database spawns are historical possibilities, never confirmed quest offers.
local Nearby = Logres:RegisterModule("QuestieDBNearby", { autoEnable = true })
local LOCAL_RADIUS_YARDS = 50
local IDS_PER_FRAME = 96
local MAX_SPAWNS_PER_NPC = 32
local MAX_CACHED_SPAWNS = 1024
local MAX_NEARBY = 8
local MAX_MAP_PARENT_DEPTH = 5

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
    return count >= 40 and result or nil
end

local function getCurrentZone(mapping)
    local mapApi = _G.C_Map
    if not mapApi or type(mapApi.GetBestMapForUnit) ~= "function" then
        return nil, nil, "map-api-unavailable"
    end
    local current = number(read(mapApi.GetBestMapForUnit, "player"))
    if not current then return nil, nil, "current-map-unavailable" end
    for _ = 1, MAX_MAP_PARENT_DEPTH do
        if mapping[current] then return current, mapping[current], nil end
        local info = ordinary(read(mapApi.GetMapInfo, current), "table")
        local parent = info and number(info.parentMapID)
        if not parent or parent == current then break end
        current = parent
    end
    return nil, nil, "map-not-in-provider-zone-table"
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
    self.mapID = nil
    self.areaID = nil
    self.areaMapping = nil
    self.state = reason
end

function Nearby:StartIndex(reason)
    if not self.moduleEnabled then return end
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
    local mapping = readAreaMap(lib)
    if not mapping then
        self:Unavailable("provider-map-table-unavailable")
        return
    end
    local map, area, failure = getCurrentZone(mapping)
    if not map then
        self:Unavailable(failure)
        return
    end
    if self.mapID == map and self.areaID == area
        and (self.complete or self.scanning) then return end
    self:StopIndex()
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
            if quests and number(quests[1]) then
                self.questNPCs = self.questNPCs + 1
                local spawns = ordinary(read(npc.spawns, id), "table")
                local here = spawns and ordinary(spawns[self.areaID], "table")
                if here then
                    local name = ordinary(read(npc.name, id), "string") or "Unknown NPC"
                    for j = 1, MAX_SPAWNS_PER_NPC do
                        local row = ordinary(here[j], "table")
                        if not row then break end
                        local x, y = number(row[1]), number(row[2])
                        if x and y and x >= 0 and x <= 100 and y >= 0 and y <= 100 then
                            if #self.rows < MAX_CACHED_SPAWNS then
                                self.rows[#self.rows + 1] = {
                                    x = x / 100, y = y / 100,
                                    npcID = id, name = name,
                                    questID = number(quests[1]), potential = true,
                                }
                            else
                                self.truncated = true
                            end
                        end
                    end
                    if ordinary(here[MAX_SPAWNS_PER_NPC + 1], "table") then
                        self.truncated = true
                    end
                end
            end
        end
    end
    self.scanIndex = last + 1
    if self.scanIndex <= self.idCount then return end
    self.complete = true
    self.state = self.truncated and "ready-partial" or "ready"
    self:StopIndex() -- finite build, no periodic reassertion or background scan.
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
    return unique, self.state
end

function Nearby:GetDebugStatus()
    return {
        state = self.state, map = self.mapID, area = self.areaID,
        complete = self.complete == true, scanned = self.scanned or 0,
        ids = self.idCount or 0, zoneNPCs = self.zoneNPCs or 0,
        questNPCs = self.questNPCs or 0, spawns = #self.rows,
        nearby = self.nearbyCount or 0, truncated = self.truncated == true,
        radius = LOCAL_RADIUS_YARDS,
        coverage = "provider-canonical-zone-primary-NPCs-only",
    }
end

function Nearby:OnInitialize()
    self.moduleEnabled = false
    self.rows = {}
    self.state = "not-started"
    self.frame = CreateFrame("Frame")
    self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.frame:RegisterEvent("PLAYER_MAP_CHANGED")
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
    self.state = "disabled"
end
