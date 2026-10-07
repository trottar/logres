local _, Logres = ...

-- Captured-profile predicate source:
-- mpstark/DynamicCam @ ae586a9c973c3f868c10440358d4a6e8c2fab5ff
local SOURCE_COMMIT = "ae586a9c973c3f868c10440358d4a6e8c2fab5ff"
local FISHING_SPELL_ID = 7620

local TELEPORT_SPELL_IDS = {
    556, 3561, 3562, 3563, 3565, 3566, 3567, 8690, 18960, 23442,
    23453, 26373, 32271, 32272, 33690, 35715, 36890, 36941, 41234,
    49358, 49359, 49844, 50977, 53140, 54406, 66238, 67833, 73324,
    75136, 88342, 88344, 89157, 89158, 89597, 89598, 94719, 120145,
    126755, 126892, 132621, 132627, 136508, 140295, 147985, 163830,
    168487, 168499, 171253, 175608, 176242, 176248, 189838, 192084,
    192085, 193669, 193753, 193759, 196079, 196080, 216016, 222695,
    223352, 223805, 224869, 225428, 225434, 225435, 225436, 225440,
    227334, 231504, 231505, 248906, 250796, 262100, 278244, 278559,
    281403, 281404, 285362, 285424, 286031, 286331, 286353, 291981,
    292764, 293840, 296687, 298068, 299083, 299084, 308742, 311643,
    311678, 311681, 311704, 311705, 311709, 311711, 311712, 311749,
    311897, 312372, 324031, 325624, 326064, 335671, 340200, 340767,
    342122, 344587, 345393, 346167, 346168, 346170, 346171, 346173,
    363799, 366945, 367013, 368788, 375357, 386379, 391042, 395277,
    398099, 401802, 410148, 412555, 418549, 420418, 422284, 426620,
    438606, 441154, 446540, 448126, 449508, 450410, 460271, 463481,
    1217281, 1220729, 1221356, 1221357, 1221359, 1221360, 1225967,
    1225969, 1233637, 1240219, 1242509, 1250878, 1255801, 1258476,
    1258484, 1259190, 1261979, 1265142, 1270311, 1270583, 1270814,
    1271410, 1273401,
}

local GATHERING_SPELL_IDS = {
    -- Mining.
    2575, 2576, 2656, 3564, 10248, 29354, 50310, 74517, 102161,
    158754, 195122, 265837, 265839, 265841, 265843, 265845, 265847,
    265849, 265851, 265853, 309835, 366260, 423341,

    -- Skinning.
    8613, 8617, 8618, 10768, 32678, 50305, 74522, 102216, 158756,
    194174, 195125, 205243, 265855, 265857, 265859, 265861, 265863,
    265865, 265867, 265869, 265871, 308569, 366259, 392440, 392445,
    423342,

    -- Herbalism.
    2366, 2368, 3570, 11993, 28695, 50300, 74519, 110413, 158745,
    195114, 265819, 265821, 265823, 265825, 265827, 265829, 265831,
    265834, 265835, 309780, 366252, 441327,
}

local NPC_INTERACTION_FRAMES = {
    "AuctionHouseFrame",
    "BagnonBankFrame1",
    "BankFrame",
    "ClassTrainerFrame",
    "GarrisonCapacitiveDisplayFrame",
    "GossipFrame",
    "GuildRegistrarFrame",
    "ImmersionFrame",
    "MerchantFrame",
    "PetStableFrame",
    "QuestFrame",
    "TabardFrame",
    "WardrobeFrame",
}

local NPC_INTERACTION_EXCLUDED_FRAMES = {
    "FlightMapFrame",
}

local function makeSet(values)
    local result = {}
    for index = 1, #values do
        result[values[index]] = true
    end
    return result
end

local TELEPORT_SPELLS = makeSet(TELEPORT_SPELL_IDS)
local GATHERING_SPELLS = makeSet(GATHERING_SPELL_IDS)

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function recordFailure(snapshot, label)
    snapshot.readFailures = snapshot.readFailures + 1
    if snapshot.lastError == nil then
        snapshot.lastError = label
    end
end

local function recordSecret(snapshot, label)
    snapshot.secretSkips = snapshot.secretSkips + 1
    if snapshot.lastSecretSource == nil then
        snapshot.lastSecretSource = label
    end
end

local function readBoolean(snapshot, label, func, ...)
    if type(func) ~= "function" then
        recordFailure(snapshot, label .. "-api-unavailable")
        return false
    end

    local ok, value = pcall(func, ...)
    if not ok then
        recordFailure(snapshot, label .. "-call-failed")
        return false
    end

    if isSecret(value) then
        recordSecret(snapshot, label)
        return false
    end

    return value and true or false
end

local function readCasting(snapshot)
    if type(UnitCastingInfo) ~= "function" then
        recordFailure(snapshot, "casting-api-unavailable")
        return nil, nil
    end

    local ok,
        _,
        _,
        _,
        startTimeMS,
        endTimeMS,
        _,
        _,
        _,
        spellID = pcall(UnitCastingInfo, "player")

    if not ok then
        recordFailure(snapshot, "casting-call-failed")
        return nil, nil
    end

    if isSecret(spellID) then
        recordSecret(snapshot, "casting-spell-id")
        return nil, nil
    end

    if spellID == nil then
        return nil, nil
    end

    if type(spellID) ~= "number" then
        recordFailure(snapshot, "casting-spell-id-invalid")
        return nil, nil
    end

    local duration
    local startSecret = isSecret(startTimeMS)
    local endSecret = isSecret(endTimeMS)

    if startSecret or endSecret then
        recordSecret(snapshot, "casting-time")
    elseif startTimeMS ~= nil and endTimeMS ~= nil then
        if type(startTimeMS) == "number"
            and type(endTimeMS) == "number"
            and endTimeMS >= startTimeMS
        then
            duration = (endTimeMS - startTimeMS) / 1000
        end
    end

    return spellID, duration
end

local function readFishingSpellName(snapshot)
    if type(GetSpellInfo) == "function" then
        local ok, name = pcall(GetSpellInfo, FISHING_SPELL_ID)
        if not ok then
            recordFailure(snapshot, "fishing-spell-name-call-failed")
            return nil
        end
        if isSecret(name) then
            recordSecret(snapshot, "fishing-spell-name")
            return nil
        end
        if name ~= nil and type(name) ~= "string" then
            recordFailure(snapshot, "fishing-spell-name-invalid")
            return nil
        end
        return name
    end

    if C_Spell and type(C_Spell.GetSpellName) == "function" then
        local ok, name = pcall(C_Spell.GetSpellName, FISHING_SPELL_ID)
        if not ok then
            recordFailure(snapshot, "fishing-spell-name-call-failed")
            return nil
        end
        if isSecret(name) then
            recordSecret(snapshot, "fishing-spell-name")
            return nil
        end
        if name ~= nil and type(name) ~= "string" then
            recordFailure(snapshot, "fishing-spell-name-invalid")
            return nil
        end
        return name
    end

    recordFailure(snapshot, "fishing-spell-name-api-unavailable")
    return nil
end

local function readFishing(snapshot)
    if type(UnitChannelInfo) ~= "function" then
        recordFailure(snapshot, "fishing-channel-api-unavailable")
        return false
    end

    local ok, channelName = pcall(UnitChannelInfo, "player")
    if not ok then
        recordFailure(snapshot, "fishing-channel-call-failed")
        return false
    end

    if isSecret(channelName) then
        recordSecret(snapshot, "fishing-channel-name")
        return false
    end

    if channelName == nil then
        return false
    end

    if type(channelName) ~= "string" then
        recordFailure(snapshot, "fishing-channel-name-invalid")
        return false
    end

    local fishingName = readFishingSpellName(snapshot)
    if fishingName == nil then
        return false
    end

    return channelName == fishingName
end

local function frameIsShown(snapshot, frameName)
    local frame = _G[frameName]
    if frame == nil then
        return false
    end

    local isShown = frame.IsShown
    if type(isShown) ~= "function" then
        return false
    end

    local ok, shown = pcall(isShown, frame)
    if not ok then
        recordFailure(snapshot, "interaction-frame-read-failed:" .. frameName)
        return false
    end

    if isSecret(shown) then
        recordSecret(snapshot, "interaction-frame-shown:" .. frameName)
        return false
    end

    return shown and true or false
end

local function readNPCInteraction(snapshot)
    for index = 1, #NPC_INTERACTION_EXCLUDED_FRAMES do
        if frameIsShown(snapshot, NPC_INTERACTION_EXCLUDED_FRAMES[index]) then
            return false
        end
    end

    local supportedFrameShown = false
    for index = 1, #NPC_INTERACTION_FRAMES do
        if frameIsShown(snapshot, NPC_INTERACTION_FRAMES[index]) then
            supportedFrameShown = true
            break
        end
    end

    if not supportedFrameShown then
        return false
    end

    return readBoolean(snapshot, "interaction-npc", UnitExists, "npc")
end

local Contexts = {
    sourceCommit = SOURCE_COMMIT,
    lastSnapshot = nil,
}

function Contexts:ReadSnapshot()
    local snapshot = {
        teleport = false,
        teleportDuration = nil,
        afk = false,
        gathering = false,
        interaction = false,
        fishing = false,
        secretSkips = 0,
        readFailures = 0,
        lastSecretSource = nil,
        lastError = nil,
    }

    local castSpellID, castDuration = readCasting(snapshot)
    if castSpellID ~= nil then
        if TELEPORT_SPELLS[castSpellID] then
            snapshot.teleport = true
            snapshot.teleportDuration = castDuration
        end

        if GATHERING_SPELLS[castSpellID] then
            snapshot.gathering = true
        end
    end

    snapshot.afk = readBoolean(snapshot, "afk", UnitIsAFK, "player")
    snapshot.interaction = readNPCInteraction(snapshot)
    snapshot.fishing = readFishing(snapshot)

    self.lastSnapshot = snapshot
    return snapshot
end

Logres.CameraProfileContexts = Contexts
