local _, Logres = ...

-- P0226: optional QuestieDB read-only compatibility sample; this never feeds Compass.
local Probe = Logres:RegisterModule("QuestieDBLocationProbe", { autoEnable = true })
local LOCH_MODAN_UI_MAP = 1432
local LOCH_MODAN_AREA_ID = 38
local MAX_GOSSIP_OFFERS = 8
local MAX_QUEST_START_NPCS = 6
local MAX_SPAWNS = 12

local function ordinary(value, kind)
    if type(issecretvalue) ~= "function" then
        return nil
    end
    local ok, secret = pcall(issecretvalue, value)
    if not ok or secret ~= false then
        return nil
    end
    if kind and type(value) ~= kind then
        return nil
    end
    return value
end

local function ordinaryNumber(value)
    value = ordinary(value, "number")
    if value == nil or value ~= value or value == math.huge or value == -math.huge then
        return nil
    end
    return value
end

local function readNpcID()
    if type(UnitGUID) ~= "function" then
        return nil
    end
    for _, unit in ipairs({ "npc", "target" }) do
        local ok, raw = pcall(UnitGUID, unit)
        local guid = ok and ordinary(raw, "string") or nil
        if guid then
            local id = tonumber(guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-"))
            if id and id > 0 then
                return id
            end
        end
    end
    return nil
end

function Probe:CaptureGossip(reason)
    self.gossipCaptures = self.gossipCaptures + 1
    self.gossipReason = reason
    self.gossipNPCID = readNpcID()
    self.gossipIDs = {}
    local nav = Logres:GetModule("NavigationSourceProbe")
    self.gossipMapID = ordinaryNumber(nav.currentMapID)
    if not C_GossipInfo or type(C_GossipInfo.GetAvailableQuests) ~= "function" then
        self.gossipStatus = "gossip-api-unavailable"
        return
    end
    local ok, raw = pcall(C_GossipInfo.GetAvailableQuests)
    local offers = ok and ordinary(raw, "table") or nil
    if not offers then
        self.gossipStatus = "gossip-data-unavailable"
        return
    end
    for i = 1, MAX_GOSSIP_OFFERS do
        local row = ordinary(offers[i], "table")
        if not row then
            break
        end
        local id = ordinaryNumber(row.questID)
        if id and id > 0 then
            self.gossipIDs[#self.gossipIDs + 1] = id
        end
    end
    self.gossipStatus = #self.gossipIDs > 0 and "observed-offer" or "no-offers-observed"
end

local function acceptedQuestNegative(nav)
    local questID = ordinaryNumber(nav.superTrackedQuestID)
    if not questID then
        -- Existing QuestMap rows already label accepted quests from native state.
        local rows = ordinary(nav.questMapRows, "table")
        if rows then
            for index = 1, 8 do
                local row = ordinary(rows[index], "table")
                if not row then break end
                if ordinary(row.role, "string") == "quest" then
                    questID = ordinaryNumber(row.questID)
                    if questID then break end
                end
            end
        end
    end
    if not questID or type(C_QuestLog) ~= "table"
        or type(C_QuestLog.IsOnQuest) ~= "function" then
        return "not-sampled"
    end
    local ok, onQuest = pcall(C_QuestLog.IsOnQuest, questID)
    onQuest = ok and ordinary(onQuest, "boolean") or nil
    if onQuest == true then
        return "accepted-quest-excluded"
    end
    return "not-established"
end

-- Other QuestieDB consumers (Questie, PlateSmith) inspect the provider's public
-- global directly. Separate TOC load state and packaged metadata from that global;
-- addon registration is not proof that its Lua initialization succeeded.
local function readAddonValue(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn, ...)
    return ok and ordinary(value) or nil
end

local function addonFacts(probe)
    local api = _G.C_AddOns
    local infoFn = api and api.GetAddOnInfo or _G.GetAddOnInfo
    local loadedFn = api and api.IsAddOnLoaded or _G.IsAddOnLoaded
    local metadataFn = api and api.GetAddOnMetadata or _G.GetAddOnMetadata
    local info = readAddonValue(infoFn, "QuestieDB")
    probe.addonRegistered = type(infoFn) ~= "function" and "unknown"
        or info ~= nil and "yes" or "no"
    local loaded = readAddonValue(loadedFn, "QuestieDB")
    probe.addonLoaded = type(loadedFn) ~= "function" and "unknown"
        or loaded == true and "yes" or loaded == false and "no" or "unknown"
    probe.addonFlavor = readAddonValue(metadataFn, "QuestieDB", "X-Flavor")
    probe.addonMode = readAddonValue(metadataFn, "QuestieDB", "X-Mode")
    probe.addonVersion = readAddonValue(metadataFn, "QuestieDB", "Version")
end

function Probe:CaptureManual()
    self.manualCount = self.manualCount + 1
    self.provider = "not-installed"
    self.positive = "deferred"
    self.negative = "not-sampled"
    self.nearestYards = nil
    self.matchedNPC = nil
    self.mapStatus = "unknown"
    self.contract = "not-checked"
    self.flavor = nil
    self.mode = nil
    addonFacts(self)
    local db = ordinary(_G.LibQuestieDB, "table")
    self.provider = db and "library-present-unverified" or "api-unavailable"
    self.gossipSample = self.gossipIDs[1]

    local nav = Logres:GetModule("NavigationSourceProbe")
    nav:CaptureManual()
    self.negative = acceptedQuestNegative(nav)
    -- Provider readiness is independent of location or gossip; never call a
    -- Source-only expansion field proof for a packaged Baked database.
    if not db then
        return self:GetDebugStatus()
    end
    if type(db.RequireContract) ~= "function" then
        self.provider = "missing-contract-check"
        return self:GetDebugStatus()
    end
    local ok, accepted = pcall(db.RequireContract, 1)
    accepted = ok and ordinary(accepted, "boolean") or nil
    if accepted ~= true then
        self.provider = "contract-rejected"
        return self:GetDebugStatus()
    end
    self.provider = "contract-compatible"
    self.contract = "1"
    local indicator = ordinary(db.ModeIndicator, "table")
    if not indicator or type(indicator.GetStatus) ~= "function" then
        self.provider = "flavor-status-unavailable"
        return self:GetDebugStatus()
    end
    local modeOK, rawMode = pcall(indicator.GetStatus)
    local status = modeOK and ordinary(rawMode, "table") or nil
    self.mode = status and ordinary(status.mode, "string") or nil
    local sourceExpansion = status and ordinary(status.expansion, "string") or nil
    if self.mode == "baked" then
        -- generate.lua emits X-Flavor; read/baked.lua selects by this metadata.
        self.flavor = ordinary(self.addonFlavor, "string")
    elseif self.mode == "source" then
        self.flavor = sourceExpansion
    end
    if not self.flavor or self.flavor:lower() ~= "forever" then
        self.provider = "forever-flavor-unverified"
        return self:GetDebugStatus()
    end
    local quest = ordinary(_G.QuestDB, "table")
    local npc = ordinary(_G.NpcDB, "table")
    if not quest or not npc or type(quest.startedBy) ~= "function"
        or type(npc.spawns) ~= "function" then
        self.provider = "public-readers-unavailable"
        return self:GetDebugStatus()
    end
    local uiMap = ordinaryNumber(nav.currentMapID)
    local playerX = ordinaryNumber(nav.playerX)
    local playerY = ordinaryNumber(nav.playerY)
    local width = ordinaryNumber(nav.mapWidth)
    local height = ordinaryNumber(nav.mapHeight)
    local radius = ordinaryNumber(nav.viewRadius)
    if uiMap ~= LOCH_MODAN_UI_MAP or self.gossipMapID ~= uiMap then
        self.mapStatus = "unvalidated-map-or-stale-gossip"
        return self:GetDebugStatus()
    end
    if not playerX or not playerY or not width or not height or not radius
        or width <= 0 or height <= 0 or radius <= 0 then
        self.mapStatus = "ordinary-geometry-unavailable"
        return self:GetDebugStatus()
    end
    self.mapStatus = "1432-to-38-audited"

    if not self.gossipSample or not self.gossipNPCID then
        self.positive = "gossip-or-npc-identity-unavailable"
        return self:GetDebugStatus()
    end
    local got, rawStarts = pcall(quest.startedBy, self.gossipSample)
    local starts = got and ordinary(rawStarts, "table") or nil
    local npcStarts = starts and ordinary(starts[1], "table") or nil
    if not npcStarts then
        self.positive = "quest-start-npc-list-unavailable"
        return self:GetDebugStatus()
    end
    local candidateFound = false
    for i = 1, MAX_QUEST_START_NPCS do
        local id = ordinaryNumber(npcStarts[i])
        if not id then break end
        if id == self.gossipNPCID then
            candidateFound = true
            local spawnOK, rawSpawns = pcall(npc.spawns, id)
            local spawns = spawnOK and ordinary(rawSpawns, "table") or nil
            local areaRows = spawns and ordinary(spawns[LOCH_MODAN_AREA_ID], "table") or nil
            if areaRows then
                for j = 1, MAX_SPAWNS do
                    local entry = ordinary(areaRows[j], "table")
                    if not entry then break end
                    local px = ordinaryNumber(entry[1])
                    local py = ordinaryNumber(entry[2])
                    if px and py and px >= 0 and px <= 100 and py >= 0 and py <= 100 then
                        local dx = (px / 100 - playerX) * width
                        local dy = (py / 100 - playerY) * height
                        local yards = math.sqrt(dx * dx + dy * dy)
                        if not self.nearestYards or yards < self.nearestYards then
                            self.nearestYards = yards
                            self.matchedNPC = id
                        end
                    end
                end
            end
            break
        end
    end
    if not candidateFound then
        self.positive = "npc-not-in-database-quest-starts"
    elseif self.nearestYards and self.nearestYards <= radius then
        self.positive = "observed-offer-npc-and-nearby-spawn-match"
    else
        self.positive = "observed-offer-but-no-nearby-spawn"
    end
    return self:GetDebugStatus()
end

function Probe:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled == true,
        gossipCaptures = self.gossipCaptures,
        gossipStatus = self.gossipStatus,
        gossipNPCID = self.gossipNPCID,
        gossipSample = self.gossipSample,
        gossipMapID = self.gossipMapID,
        manualCount = self.manualCount,
        provider = self.provider,
        addonRegistered = self.addonRegistered,
        addonLoaded = self.addonLoaded,
        addonFlavor = self.addonFlavor,
        addonMode = self.addonMode,
        addonVersion = self.addonVersion,
        contract = self.contract,
        mode = self.mode,
        flavor = self.flavor,
        mapStatus = self.mapStatus,
        positive = self.positive,
        negative = self.negative,
        matchedNPC = self.matchedNPC,
        nearestYards = self.nearestYards,
    }
end

function Probe:OnInitialize()
    self.moduleEnabled = false
    self.manualCount = 0
    self.gossipCaptures = 0
    self.gossipStatus = "not-observed"
    self.gossipIDs = {}
    self.provider = "not-tested"
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("GOSSIP_SHOW")
    frame:RegisterEvent("QUEST_GREETING")
    frame:SetScript("OnEvent", function(_, event)
        if self.moduleEnabled then
            self:CaptureGossip(event)
        end
    end)
    self.eventFrame = frame
end

function Probe:OnEnable()
    self.moduleEnabled = true
end

function Probe:OnDisable()
    self.moduleEnabled = false
end
