local _, Logres = ...

local MAX_PET_SLOTS = 10
local MAX_STANCE_SLOTS = 10
local MAX_TOTEM_SLOTS = 8
local MAX_CHARGED_POINTS = 10
local MAX_RUNES = 6
local ERROR_TEXT_LIMIT = 96

local Probe = Logres:RegisterModule("ClassPetSpecialProbe", {
    autoEnable = true,
})

local EVENTS = {
    "PET_BAR_UPDATE",
    "PET_BAR_UPDATE_COOLDOWN",
    "PET_BAR_UPDATE_USABLE",
    "PET_UI_UPDATE",
    "UPDATE_SHAPESHIFT_FORMS",
    "UPDATE_SHAPESHIFT_FORM",
    "UPDATE_SHAPESHIFT_USABLE",
    "UPDATE_SHAPESHIFT_COOLDOWN",
    "PLAYER_TOTEM_UPDATE",
    "RUNE_POWER_UPDATE",
    "UNIT_DISPLAYPOWER",
    "UPDATE_POSSESS_BAR",
    "UPDATE_OVERRIDE_ACTIONBAR",
    "UPDATE_VEHICLE_ACTIONBAR",
    "UPDATE_EXTRA_ACTIONBAR",
    "PLAYER_SPECIALIZATION_CHANGED",
    "PLAYER_TALENT_UPDATE",
    "PLAYER_ENTERING_WORLD",
}

local UNIT_EVENTS = {
    { event = "UNIT_PET", unit = "player" },
    { event = "UNIT_POWER_FREQUENT", unit = "player" },
    { event = "UNIT_MAXPOWER", unit = "player" },
    { event = "UNIT_POWER_POINT_CHARGE", unit = "player" },
}

local CLASS_RESOURCE_ENUM = {
    DRUID = "ComboPoints",
    EVOKER = "Essence",
    MAGE = "ArcaneCharges",
    MONK = "Chi",
    PALADIN = "HolyPower",
    ROGUE = "ComboPoints",
    WARLOCK = "SoulShards",
}

local PET_EVENTS = {
    PET_BAR_UPDATE = true,
    PET_BAR_UPDATE_COOLDOWN = true,
    PET_BAR_UPDATE_USABLE = true,
    PET_UI_UPDATE = true,
    UNIT_PET = true,
}

local STANCE_EVENTS = {
    UPDATE_SHAPESHIFT_FORMS = true,
    UPDATE_SHAPESHIFT_FORM = true,
    UPDATE_SHAPESHIFT_USABLE = true,
    UPDATE_SHAPESHIFT_COOLDOWN = true,
}

local TOTEM_EVENTS = {
    PLAYER_TOTEM_UPDATE = true,
}

local RESOURCE_EVENTS = {
    RUNE_POWER_UPDATE = true,
    UNIT_POWER_FREQUENT = true,
    UNIT_MAXPOWER = true,
    UNIT_POWER_POINT_CHARGE = true,
    UNIT_DISPLAYPOWER = true,
}

local SPECIAL_EVENTS = {
    UPDATE_POSSESS_BAR = true,
    UPDATE_OVERRIDE_ACTIONBAR = true,
    UPDATE_VEHICLE_ACTIONBAR = true,
    UPDATE_EXTRA_ACTIONBAR = true,
}

local ALL_EVENTS = {
    PLAYER_SPECIALIZATION_CHANGED = true,
    PLAYER_TALENT_UPDATE = true,
    PLAYER_ENTERING_WORLD = true,
}

local function hasSecretChecker()
    return type(issecretvalue) == "function"
end

local function isSecret(value)
    if not hasSecretChecker() then
        return true
    end

    local ok, result = pcall(issecretvalue, value)

    if not ok then
        return true
    end

    return result == true
end

local function truncateText(value)
    if #value <= ERROR_TEXT_LIMIT then
        return value
    end

    return value:sub(1, ERROR_TEXT_LIMIT - 3) .. "..."
end

local function safeErrorText(value)
    if isSecret(value) then
        return "secret-error"
    end

    if value == nil then
        return "unknown-error"
    end

    local valueType = type(value)

    if valueType ~= "string" then
        return valueType .. "-error"
    end

    return truncateText(value)
end

local function newDomain(name)
    return {
        name = name,
        ordinaryFieldCount = 0,
        absentFieldCount = 0,
        secretSkipCount = 0,
        failureCount = 0,
        lastSecret = nil,
        lastFailure = nil,
    }
end

local function ordinaryField(owner, value, expectedType, label)
    if isSecret(value) then
        owner.secretSkipCount = owner.secretSkipCount + 1
        owner.lastSecret = label
        return nil, "secret"
    end

    if value == nil then
        owner.absentFieldCount = owner.absentFieldCount + 1
        return nil, "absent"
    end

    local valueType = type(value)

    if expectedType and valueType ~= expectedType then
        owner.failureCount = owner.failureCount + 1
        owner.lastFailure = label .. ":unexpected-" .. valueType
        return nil, "invalid"
    end

    owner.ordinaryFieldCount = owner.ordinaryFieldCount + 1
    return value, "ordinary"
end

local function call(owner, label, api, ...)
    if type(api) ~= "function" then
        owner.failureCount = owner.failureCount + 1
        owner.lastFailure = label .. ":api-unavailable"
        return false, nil
    end

    local ok, a, b, c, d, e, f, g, h, i = pcall(api, ...)

    if not ok then
        owner.failureCount = owner.failureCount + 1
        owner.lastFailure = label .. ":" .. safeErrorText(a)
        return false, nil
    end

    return true, a, b, c, d, e, f, g, h, i
end

local function boolText(value)
    if value == nil then
        return "-"
    end

    return value and "true" or "false"
end

local function valueText(value)
    if value == nil then
        return "-"
    end

    return tostring(value)
end

local function apiPresence()
    return {
        secretChecker = hasSecretChecker(),
        petBar = type(PetHasActionBar) == "function",
        petInfo = type(GetPetActionInfo) == "function",
        petCooldown = type(GetPetActionCooldown) == "function",
        petUsable = type(GetPetActionSlotUsable) == "function",
        stanceCount = type(GetNumShapeshiftForms) == "function",
        stanceInfo = type(GetShapeshiftFormInfo) == "function",
        stanceCooldown = type(GetShapeshiftFormCooldown) == "function",
        totemCount = type(GetNumTotemSlots) == "function",
        totemInfo = type(GetTotemInfo) == "function",
        totemTime = type(GetTotemTimeLeft) == "function",
        totemDismissibility = type(GetTotemCannotDismiss) == "function",
        unitClass = type(UnitClass) == "function",
        unitPowerType = type(UnitPowerType) == "function",
        unitPower = type(UnitPower) == "function",
        unitPowerMax = type(UnitPowerMax) == "function",
        chargedPoints = type(GetUnitChargedPowerPoints) == "function",
        specialization = C_SpecializationInfo
            and type(C_SpecializationInfo.GetSpecialization) == "function"
            or false,
        runeCooldown = type(GetRuneCooldown) == "function",
        possess = C_ActionBar
            and type(C_ActionBar.IsPossessBarVisible) == "function"
            or false,
        vehicle = C_ActionBar
            and type(C_ActionBar.HasVehicleActionBar) == "function"
            or false,
        vehicleIndex = C_ActionBar
            and type(C_ActionBar.GetVehicleBarIndex) == "function"
            or false,
        override = C_ActionBar
            and type(C_ActionBar.HasOverrideActionBar) == "function"
            or false,
        overrideIndex = C_ActionBar
            and type(C_ActionBar.GetOverrideBarIndex) == "function"
            or false,
        tempShapeshift = C_ActionBar
            and type(C_ActionBar.HasTempShapeshiftActionBar) == "function"
            or false,
        tempShapeshiftIndex = C_ActionBar
            and type(C_ActionBar.GetTempShapeshiftBarIndex) == "function"
            or false,
        extra = C_ActionBar
            and type(C_ActionBar.HasExtraActionBar) == "function"
            or false,
    }
end

local function apiReady(api)
    for key, available in pairs(api) do
        if available ~= true then
            return false, key
        end
    end

    return true, nil
end

local function readPet()
    local result = newDomain("pet")
    result.rows = {}
    result.scanned = 0
    result.occupied = 0
    result.active = 0
    result.autocastAllowed = 0
    result.autocastEnabled = 0
    result.usable = 0

    local okBar, rawHasBar = call(
        result,
        "PetHasActionBar",
        PetHasActionBar
    )

    if not okBar then
        return result
    end

    local hasBar, barState = ordinaryField(
        result,
        rawHasBar,
        "boolean",
        "pet.hasActionBar"
    )
    result.hasActionBar = hasBar

    if barState ~= "ordinary" then
        result.deferred = "pet-bar-state-unavailable"
        return result
    end

    if hasBar ~= true then
        result.deferred = "pet-action-bar-absent"
        return result
    end

    for slot = 1, MAX_PET_SLOTS do
        local row = { slot = slot }
        result.scanned = result.scanned + 1

        local okInfo,
            rawName,
            rawTexture,
            rawIsToken,
            rawIsActive,
            rawAutoCastAllowed,
            rawAutoCastEnabled,
            rawSpellID,
            rawChecksRange,
            rawInRange = call(
                result,
                "GetPetActionInfo",
                GetPetActionInfo,
                slot
            )

        if okInfo then
            row.name = ordinaryField(
                result,
                rawName,
                "string",
                "pet.name"
            )
            row.texture = ordinaryField(
                result,
                rawTexture,
                nil,
                "pet.texture"
            )
            row.isToken = ordinaryField(
                result,
                rawIsToken,
                "boolean",
                "pet.isToken"
            )
            row.isActive = ordinaryField(
                result,
                rawIsActive,
                "boolean",
                "pet.isActive"
            )
            row.autoCastAllowed = ordinaryField(
                result,
                rawAutoCastAllowed,
                "boolean",
                "pet.autoCastAllowed"
            )
            row.autoCastEnabled = ordinaryField(
                result,
                rawAutoCastEnabled,
                "boolean",
                "pet.autoCastEnabled"
            )
            row.spellID = ordinaryField(
                result,
                rawSpellID,
                "number",
                "pet.spellID"
            )
            row.checksRange = ordinaryField(
                result,
                rawChecksRange,
                "boolean",
                "pet.checksRange"
            )
            row.inRange = ordinaryField(
                result,
                rawInRange,
                "boolean",
                "pet.inRange"
            )
        end

        local okCooldown, rawStart, rawDuration, rawEnable = call(
            result,
            "GetPetActionCooldown",
            GetPetActionCooldown,
            slot
        )

        if okCooldown then
            row.cooldownStart = ordinaryField(
                result,
                rawStart,
                "number",
                "pet.cooldownStart"
            )
            row.cooldownDuration = ordinaryField(
                result,
                rawDuration,
                "number",
                "pet.cooldownDuration"
            )
            row.cooldownEnable = ordinaryField(
                result,
                rawEnable,
                nil,
                "pet.cooldownEnable"
            )
        end

        local okUsable, rawUsable = call(
            result,
            "GetPetActionSlotUsable",
            GetPetActionSlotUsable,
            slot
        )

        if okUsable then
            row.usable = ordinaryField(
                result,
                rawUsable,
                "boolean",
                "pet.usable"
            )
        end

        row.occupied = row.texture ~= nil
            or row.spellID ~= nil
            or row.name ~= nil

        if row.occupied then
            result.occupied = result.occupied + 1
        end
        if row.isActive == true then
            result.active = result.active + 1
        end
        if row.autoCastAllowed == true then
            result.autocastAllowed = result.autocastAllowed + 1
        end
        if row.autoCastEnabled == true then
            result.autocastEnabled = result.autocastEnabled + 1
        end
        if row.usable == true then
            result.usable = result.usable + 1
        end

        result.rows[#result.rows + 1] = row
    end

    return result
end

local function readStance()
    local result = newDomain("stance")
    result.rows = {}
    result.scanned = 0
    result.active = 0
    result.castable = 0
    result.truncated = false

    local okCount, rawCount = call(
        result,
        "GetNumShapeshiftForms",
        GetNumShapeshiftForms
    )

    if not okCount then
        return result
    end

    local count, countState = ordinaryField(
        result,
        rawCount,
        "number",
        "stance.count"
    )

    if countState ~= "ordinary" then
        result.deferred = "stance-count-unavailable"
        return result
    end

    count = math.max(0, math.floor(count))
    result.count = count
    result.scanned = math.min(count, MAX_STANCE_SLOTS)
    result.truncated = count > MAX_STANCE_SLOTS

    if result.scanned == 0 then
        result.deferred = "stance-unavailable"
        return result
    end

    for slot = 1, result.scanned do
        local row = { slot = slot }
        local okInfo,
            rawTexture,
            rawActive,
            rawCastable,
            rawSpellID = call(
                result,
                "GetShapeshiftFormInfo",
                GetShapeshiftFormInfo,
                slot
            )

        if okInfo then
            row.texture = ordinaryField(
                result,
                rawTexture,
                "number",
                "stance.texture"
            )
            row.active = ordinaryField(
                result,
                rawActive,
                "boolean",
                "stance.active"
            )
            row.castable = ordinaryField(
                result,
                rawCastable,
                "boolean",
                "stance.castable"
            )
            row.spellID = ordinaryField(
                result,
                rawSpellID,
                "number",
                "stance.spellID"
            )
        end

        local okCooldown, rawStart, rawDuration, rawEnable = call(
            result,
            "GetShapeshiftFormCooldown",
            GetShapeshiftFormCooldown,
            slot
        )

        if okCooldown then
            row.cooldownStart = ordinaryField(
                result,
                rawStart,
                "number",
                "stance.cooldownStart"
            )
            row.cooldownDuration = ordinaryField(
                result,
                rawDuration,
                "number",
                "stance.cooldownDuration"
            )
            row.cooldownEnable = ordinaryField(
                result,
                rawEnable,
                nil,
                "stance.cooldownEnable"
            )
        end

        if row.active == true then
            result.active = result.active + 1
        end
        if row.castable == true then
            result.castable = result.castable + 1
        end

        result.rows[#result.rows + 1] = row
    end

    return result
end

local function readTotem()
    local result = newDomain("totem")
    result.rows = {}
    result.scanned = 0
    result.active = 0
    result.dismissible = 0
    result.truncated = false

    local okCount, rawCount = call(
        result,
        "GetNumTotemSlots",
        GetNumTotemSlots
    )

    if not okCount then
        return result
    end

    local count, countState = ordinaryField(
        result,
        rawCount,
        "number",
        "totem.count"
    )

    if countState ~= "ordinary" then
        result.deferred = "totem-count-unavailable"
        return result
    end

    count = math.max(0, math.floor(count))
    result.count = count
    result.scanned = math.min(count, MAX_TOTEM_SLOTS)
    result.truncated = count > MAX_TOTEM_SLOTS

    for slot = 1, result.scanned do
        local row = { slot = slot }
        local okInfo,
            rawHaveTotem,
            rawName,
            rawStart,
            rawDuration,
            rawIcon,
            rawModRate,
            rawSpellID = call(
                result,
                "GetTotemInfo",
                GetTotemInfo,
                slot
            )

        local haveTotemState

        if okInfo then
            row.haveTotem, haveTotemState = ordinaryField(
                result,
                rawHaveTotem,
                "boolean",
                "totem.haveTotem"
            )
            row.name = ordinaryField(
                result,
                rawName,
                "string",
                "totem.name"
            )
            row.startTime = ordinaryField(
                result,
                rawStart,
                "number",
                "totem.startTime"
            )
            row.duration = ordinaryField(
                result,
                rawDuration,
                "number",
                "totem.duration"
            )
            row.icon = ordinaryField(
                result,
                rawIcon,
                "number",
                "totem.icon"
            )
            row.modRate = ordinaryField(
                result,
                rawModRate,
                "number",
                "totem.modRate"
            )
            row.spellID = ordinaryField(
                result,
                rawSpellID,
                "number",
                "totem.spellID"
            )
        end

        if haveTotemState == "ordinary"
            and row.haveTotem == true
        then
            result.active = result.active + 1

            local okTime, rawTimeLeft = call(
                result,
                "GetTotemTimeLeft",
                GetTotemTimeLeft,
                slot
            )

            if okTime then
                row.timeLeft = ordinaryField(
                    result,
                    rawTimeLeft,
                    "number",
                    "totem.timeLeft"
                )
            end

            local okDismiss, rawCannotDismiss = call(
                result,
                "GetTotemCannotDismiss",
                GetTotemCannotDismiss,
                slot
            )

            if okDismiss then
                row.cannotDismiss = ordinaryField(
                    result,
                    rawCannotDismiss,
                    "boolean",
                    "totem.cannotDismiss"
                )

                if row.cannotDismiss == false then
                    result.dismissible = result.dismissible + 1
                end
            end
        end

        result.rows[#result.rows + 1] = row
    end

    if result.active == 0 then
        result.deferred = "no-active-totems"
    end

    return result
end

local function classResourceType(classFilename)
    local enumKey = CLASS_RESOURCE_ENUM[classFilename]

    if not enumKey then
        return nil, nil
    end

    if type(Enum) ~= "table"
        or type(Enum.PowerType) ~= "table"
    then
        return nil, enumKey
    end

    local powerType = Enum.PowerType[enumKey]

    if type(powerType) ~= "number" then
        return nil, enumKey
    end

    return powerType, enumKey
end

local function readChargedPoints(result)
    result.chargedPointCount = 0
    result.chargedPoints = {}

    local okCharged, rawPoints = call(
        result,
        "GetUnitChargedPowerPoints",
        GetUnitChargedPowerPoints,
        "player"
    )

    if not okCharged then
        return
    end

    local points, pointsState = ordinaryField(
        result,
        rawPoints,
        "table",
        "resource.chargedPoints"
    )

    if pointsState ~= "ordinary" then
        result.chargedDeferred = pointsState
        return
    end

    for index = 1, MAX_CHARGED_POINTS do
        local rawPoint = points[index]

        if isSecret(rawPoint) then
            result.secretSkipCount = result.secretSkipCount + 1
            result.lastSecret = "resource.chargedPoint"
        elseif rawPoint == nil then
            return
        elseif type(rawPoint) ~= "number" then
            result.failureCount = result.failureCount + 1
            result.lastFailure =
                "resource.chargedPoint:unexpected-"
                .. type(rawPoint)
            return
        else
            result.ordinaryFieldCount = result.ordinaryFieldCount + 1
            result.chargedPointCount = result.chargedPointCount + 1
            result.chargedPoints[#result.chargedPoints + 1] = rawPoint
        end
    end

    result.chargedTruncated = true
end

local function readRunes(result, classFilename)
    result.runeRows = {}
    result.runeScanned = 0
    result.runeReady = 0

    if classFilename ~= "DEATHKNIGHT" then
        result.runesDeferred = "class-not-deathknight"
        return
    end

    for runeIndex = 1, MAX_RUNES do
        local row = { index = runeIndex }
        result.runeScanned = result.runeScanned + 1

        local okRune, rawStart, rawDuration, rawReady = call(
            result,
            "GetRuneCooldown",
            GetRuneCooldown,
            runeIndex
        )

        if okRune then
            row.start = ordinaryField(
                result,
                rawStart,
                "number",
                "rune.start"
            )
            row.duration = ordinaryField(
                result,
                rawDuration,
                "number",
                "rune.duration"
            )
            row.ready = ordinaryField(
                result,
                rawReady,
                "boolean",
                "rune.ready"
            )

            if row.ready == true then
                result.runeReady = result.runeReady + 1
            end
        end

        result.runeRows[#result.runeRows + 1] = row
    end
end

local function readResource()
    local result = newDomain("resource")

    local okClass,
        rawClassName,
        rawClassFilename,
        rawClassID = call(
            result,
            "UnitClass",
            UnitClass,
            "player"
        )

    local classState

    if okClass then
        result.className = ordinaryField(
            result,
            rawClassName,
            "string",
            "resource.className"
        )
        result.classFilename, classState = ordinaryField(
            result,
            rawClassFilename,
            "string",
            "resource.classFilename"
        )
        result.classID = ordinaryField(
            result,
            rawClassID,
            "number",
            "resource.classID"
        )
    end

    local okSpec, rawSpec = call(
        result,
        "C_SpecializationInfo.GetSpecialization",
        C_SpecializationInfo
            and C_SpecializationInfo.GetSpecialization
    )

    if okSpec then
        result.specialization = ordinaryField(
            result,
            rawSpec,
            "number",
            "resource.specialization"
        )
    end

    local okPrimary,
        rawPrimaryType,
        rawPrimaryToken = call(
            result,
            "UnitPowerType",
            UnitPowerType,
            "player",
            0
        )

    local primaryTypeState

    if okPrimary then
        result.primaryPowerType, primaryTypeState = ordinaryField(
            result,
            rawPrimaryType,
            "number",
            "resource.primaryPowerType"
        )
        result.primaryPowerToken = ordinaryField(
            result,
            rawPrimaryToken,
            "string",
            "resource.primaryPowerToken"
        )
    end

    if primaryTypeState == "ordinary" then
        local okPower, rawPower = call(
            result,
            "UnitPower(primary)",
            UnitPower,
            "player",
            result.primaryPowerType
        )

        if okPower then
            result.primaryPower = ordinaryField(
                result,
                rawPower,
                "number",
                "resource.primaryPower"
            )
        end

        local okMax, rawMax = call(
            result,
            "UnitPowerMax(primary)",
            UnitPowerMax,
            "player",
            result.primaryPowerType
        )

        if okMax then
            result.primaryPowerMax = ordinaryField(
                result,
                rawMax,
                "number",
                "resource.primaryPowerMax"
            )
        end
    end

    if classState ~= "ordinary" then
        result.selectedDeferred = "class-unavailable"
        result.runesDeferred = "class-unavailable"
        return result
    end

    local selectedType, selectedToken =
        classResourceType(result.classFilename)
    result.selectedPowerType = selectedType
    result.selectedPowerToken = selectedToken

    if selectedType == nil then
        result.selectedDeferred =
            selectedToken and "power-enum-unavailable"
            or "no-discrete-class-resource"
    else
        local okPower, rawPower = call(
            result,
            "UnitPower(class-resource)",
            UnitPower,
            "player",
            selectedType
        )

        if okPower then
            result.selectedPower = ordinaryField(
                result,
                rawPower,
                "number",
                "resource.selectedPower"
            )
        end

        local okMax, rawMax = call(
            result,
            "UnitPowerMax(class-resource)",
            UnitPowerMax,
            "player",
            selectedType
        )

        if okMax then
            result.selectedPowerMax = ordinaryField(
                result,
                rawMax,
                "number",
                "resource.selectedPowerMax"
            )
        end

        if selectedToken == "ComboPoints" then
            readChargedPoints(result)
        else
            result.chargedDeferred = "resource-not-combo-points"
        end
    end

    readRunes(result, result.classFilename)
    return result
end

local function readSpecialFlag(result, label, api)
    local ok, rawValue = call(result, label, api)

    if not ok then
        return nil, "failed"
    end

    return ordinaryField(
        result,
        rawValue,
        "boolean",
        label
    )
end

local function readSpecialIndex(result, label, api)
    local ok, rawValue = call(result, label, api)

    if not ok then
        return nil
    end

    return ordinaryField(
        result,
        rawValue,
        "number",
        label
    )
end

local function readSpecial()
    local result = newDomain("special")

    result.possess = readSpecialFlag(
        result,
        "C_ActionBar.IsPossessBarVisible",
        C_ActionBar and C_ActionBar.IsPossessBarVisible
    )

    local vehicle, vehicleState = readSpecialFlag(
        result,
        "C_ActionBar.HasVehicleActionBar",
        C_ActionBar and C_ActionBar.HasVehicleActionBar
    )
    result.vehicle = vehicle
    if vehicleState == "ordinary" and vehicle == true then
        result.vehicleIndex = readSpecialIndex(
            result,
            "C_ActionBar.GetVehicleBarIndex",
            C_ActionBar and C_ActionBar.GetVehicleBarIndex
        )
    end

    local override, overrideState = readSpecialFlag(
        result,
        "C_ActionBar.HasOverrideActionBar",
        C_ActionBar and C_ActionBar.HasOverrideActionBar
    )
    result.override = override
    if overrideState == "ordinary" and override == true then
        result.overrideIndex = readSpecialIndex(
            result,
            "C_ActionBar.GetOverrideBarIndex",
            C_ActionBar and C_ActionBar.GetOverrideBarIndex
        )
    end

    local temp, tempState = readSpecialFlag(
        result,
        "C_ActionBar.HasTempShapeshiftActionBar",
        C_ActionBar and C_ActionBar.HasTempShapeshiftActionBar
    )
    result.tempShapeshift = temp
    if tempState == "ordinary" and temp == true then
        result.tempShapeshiftIndex = readSpecialIndex(
            result,
            "C_ActionBar.GetTempShapeshiftBarIndex",
            C_ActionBar and C_ActionBar.GetTempShapeshiftBarIndex
        )
    end

    result.extra = readSpecialFlag(
        result,
        "C_ActionBar.HasExtraActionBar",
        C_ActionBar and C_ActionBar.HasExtraActionBar
    )

    return result
end

function Probe:Summarize()
    local total = {
        ordinaryFieldCount = 0,
        absentFieldCount = 0,
        secretSkipCount = 0,
        failureCount = 0,
        lastSecret = nil,
        lastFailure = nil,
    }

    for _, domain in ipairs({
        self.pet,
        self.stance,
        self.totem,
        self.resource,
        self.special,
    }) do
        if domain then
            total.ordinaryFieldCount =
                total.ordinaryFieldCount
                + (domain.ordinaryFieldCount or 0)
            total.absentFieldCount =
                total.absentFieldCount
                + (domain.absentFieldCount or 0)
            total.secretSkipCount =
                total.secretSkipCount
                + (domain.secretSkipCount or 0)
            total.failureCount =
                total.failureCount
                + (domain.failureCount or 0)

            if domain.lastSecret then
                total.lastSecret = domain.lastSecret
            end
            if domain.lastFailure then
                total.lastFailure = domain.lastFailure
            end
        end
    end

    self.total = total
end

function Probe:CaptureAll(reason)
    self.captureCount = self.captureCount + 1
    self.lastReason = reason
    self.pet = readPet()
    self.stance = readStance()
    self.totem = readTotem()
    self.resource = readResource()
    self.special = readSpecial()
    self:Summarize()
    return self:GetDebugStatus()
end

function Probe:CaptureDomain(domain, reason)
    self.captureCount = self.captureCount + 1
    self.lastReason = reason

    if domain == "pet" then
        self.pet = readPet()
    elseif domain == "stance" then
        self.stance = readStance()
    elseif domain == "totem" then
        self.totem = readTotem()
    elseif domain == "resource" then
        self.resource = readResource()
    elseif domain == "special" then
        self.special = readSpecial()
    else
        return self:CaptureAll(reason)
    end

    self:Summarize()
    return self:GetDebugStatus()
end

function Probe:CaptureManual()
    self.manualCount = self.manualCount + 1
    return self:CaptureAll("manual")
end

function Probe:GetDiagnosticLines()
    local lines = {}
    local pet = self.pet or newDomain("pet")
    local stance = self.stance or newDomain("stance")
    local totem = self.totem or newDomain("totem")
    local resource = self.resource or newDomain("resource")
    local special = self.special or newDomain("special")
    local total = self.total or newDomain("total")

    lines[#lines + 1] = string.format(
        "pet=bar:%s scanned:%s occupied:%s active:%s autocastAllowed:%s autocastEnabled:%s usable:%s deferred:%s ordinary:%s secret:%s failures:%s",
        boolText(pet.hasActionBar),
        valueText(pet.scanned),
        valueText(pet.occupied),
        valueText(pet.active),
        valueText(pet.autocastAllowed),
        valueText(pet.autocastEnabled),
        valueText(pet.usable),
        valueText(pet.deferred),
        valueText(pet.ordinaryFieldCount),
        valueText(pet.secretSkipCount),
        valueText(pet.failureCount)
    )

    for index = 1, #(pet.rows or {}) do
        local row = pet.rows[index]
        if row.occupied then
            lines[#lines + 1] = string.format(
                "pet[%s] active=%s autocast=%s/%s usable=%s spellID=%s cooldown=%s",
                valueText(row.slot),
                boolText(row.isActive),
                boolText(row.autoCastAllowed),
                boolText(row.autoCastEnabled),
                boolText(row.usable),
                valueText(row.spellID),
                valueText(row.cooldownDuration)
            )
        end
    end

    lines[#lines + 1] = string.format(
        "stance=count:%s scanned:%s active:%s castable:%s truncated:%s deferred:%s ordinary:%s secret:%s failures:%s",
        valueText(stance.count),
        valueText(stance.scanned),
        valueText(stance.active),
        valueText(stance.castable),
        boolText(stance.truncated),
        valueText(stance.deferred),
        valueText(stance.ordinaryFieldCount),
        valueText(stance.secretSkipCount),
        valueText(stance.failureCount)
    )

    for index = 1, #(stance.rows or {}) do
        local row = stance.rows[index]
        lines[#lines + 1] = string.format(
            "stance[%s] active=%s castable=%s spellID=%s cooldown=%s",
            valueText(row.slot),
            boolText(row.active),
            boolText(row.castable),
            valueText(row.spellID),
            valueText(row.cooldownDuration)
        )
    end

    lines[#lines + 1] = string.format(
        "totem=slots:%s scanned:%s active:%s dismissible:%s truncated:%s deferred:%s ordinary:%s secret:%s failures:%s",
        valueText(totem.count),
        valueText(totem.scanned),
        valueText(totem.active),
        valueText(totem.dismissible),
        boolText(totem.truncated),
        valueText(totem.deferred),
        valueText(totem.ordinaryFieldCount),
        valueText(totem.secretSkipCount),
        valueText(totem.failureCount)
    )

    for index = 1, #(totem.rows or {}) do
        local row = totem.rows[index]
        if row.haveTotem == true then
            lines[#lines + 1] = string.format(
                "totem[%s] spellID=%s duration=%s timeLeft=%s cannotDismiss=%s",
                valueText(row.slot),
                valueText(row.spellID),
                valueText(row.duration),
                valueText(row.timeLeft),
                boolText(row.cannotDismiss)
            )
        end
    end

    lines[#lines + 1] = string.format(
        "resource=class:%s spec:%s primary:%s(%s/%s) selected:%s(%s/%s) charged:%s runes:%s/%s selectedDeferred:%s runesDeferred:%s ordinary:%s secret:%s failures:%s",
        valueText(resource.classFilename),
        valueText(resource.specialization),
        valueText(resource.primaryPowerToken),
        valueText(resource.primaryPower),
        valueText(resource.primaryPowerMax),
        valueText(resource.selectedPowerToken),
        valueText(resource.selectedPower),
        valueText(resource.selectedPowerMax),
        valueText(resource.chargedPointCount),
        valueText(resource.runeReady),
        valueText(resource.runeScanned),
        valueText(resource.selectedDeferred),
        valueText(resource.runesDeferred),
        valueText(resource.ordinaryFieldCount),
        valueText(resource.secretSkipCount),
        valueText(resource.failureCount)
    )

    for index = 1, #(resource.runeRows or {}) do
        local row = resource.runeRows[index]
        lines[#lines + 1] = string.format(
            "rune[%s] ready=%s duration=%s",
            valueText(row.index),
            boolText(row.ready),
            valueText(row.duration)
        )
    end

    lines[#lines + 1] = string.format(
        "special=possess:%s vehicle:%s/%s override:%s/%s tempShapeshift:%s/%s extra:%s ordinary:%s secret:%s failures:%s",
        boolText(special.possess),
        boolText(special.vehicle),
        valueText(special.vehicleIndex),
        boolText(special.override),
        valueText(special.overrideIndex),
        boolText(special.tempShapeshift),
        valueText(special.tempShapeshiftIndex),
        boolText(special.extra),
        valueText(special.ordinaryFieldCount),
        valueText(special.secretSkipCount),
        valueText(special.failureCount)
    )

    lines[#lines + 1] = string.format(
        "total=ordinary:%s absent:%s secretSkips:%s failures:%s lastSecret:%s lastFailure:%s",
        valueText(total.ordinaryFieldCount),
        valueText(total.absentFieldCount),
        valueText(total.secretSkipCount),
        valueText(total.failureCount),
        valueText(total.lastSecret),
        valueText(total.lastFailure)
    )

    return lines
end

function Probe:GetDebugStatus()
    local api = apiPresence()
    local requiredAPIReady, missingAPI = apiReady(api)
    local total = self.total or newDomain("total")
    local eventRegistrationComplete = true
    local registeredEventCount = 0
    local expectedEventCount = #EVENTS + #UNIT_EVENTS

    for index = 1, #EVENTS do
        local event = EVENTS[index]
        if self.eventRegistration[event] == true then
            registeredEventCount = registeredEventCount + 1
        else
            eventRegistrationComplete = false
        end
    end

    for index = 1, #UNIT_EVENTS do
        local event = UNIT_EVENTS[index].event
        if self.eventRegistration[event] == true then
            registeredEventCount = registeredEventCount + 1
        else
            eventRegistrationComplete = false
        end
    end

    return {
        moduleEnabled = self.moduleEnabled == true,
        eventFrameReady = self.eventFrame ~= nil,
        secretCheckerAvailable = api.secretChecker,
        requiredAPIReady = requiredAPIReady,
        missingAPI = missingAPI,
        eventRegistrationComplete = eventRegistrationComplete,
        registeredEventCount = registeredEventCount,
        expectedEventCount = expectedEventCount,
        captureCount = self.captureCount,
        manualCount = self.manualCount,
        lastReason = self.lastReason,
        ordinaryFieldCount = total.ordinaryFieldCount,
        absentFieldCount = total.absentFieldCount,
        secretSkipCount = total.secretSkipCount,
        failureCount = total.failureCount,
        lastSecret = total.lastSecret,
        lastFailure = total.lastFailure,
        petHasActionBar = self.pet and self.pet.hasActionBar or nil,
        petScanned = self.pet and self.pet.scanned or 0,
        petOccupied = self.pet and self.pet.occupied or 0,
        stanceCount = self.stance and self.stance.count or nil,
        stanceScanned = self.stance and self.stance.scanned or 0,
        totemSlots = self.totem and self.totem.count or nil,
        activeTotems = self.totem and self.totem.active or 0,
        playerClass = self.resource and self.resource.classFilename or nil,
        selectedResource = self.resource and self.resource.selectedPowerToken or nil,
        runeScanned = self.resource and self.resource.runeScanned or 0,
        possess = self.special and self.special.possess or nil,
        vehicle = self.special and self.special.vehicle or nil,
        override = self.special and self.special.override or nil,
        tempShapeshift = self.special and self.special.tempShapeshift or nil,
        extra = self.special and self.special.extra or nil,
    }
end

function Probe:OnInitialize()
    self.moduleEnabled = false
    self.captureCount = 0
    self.manualCount = 0
    self.lastReason = nil
    self.eventCounts = {}
    self.eventRegistration = {}
    self.pet = nil
    self.stance = nil
    self.totem = nil
    self.resource = nil
    self.special = nil
    self.total = newDomain("total")

    local eventFrame = CreateFrame("Frame")

    for index = 1, #EVENTS do
        local event = EVENTS[index]
        self.eventCounts[event] = 0
        self.eventRegistration[event] = pcall(
            eventFrame.RegisterEvent,
            eventFrame,
            event
        )
    end

    for index = 1, #UNIT_EVENTS do
        local spec = UNIT_EVENTS[index]
        self.eventCounts[spec.event] = 0
        self.eventRegistration[spec.event] = pcall(
            eventFrame.RegisterUnitEvent,
            eventFrame,
            spec.event,
            spec.unit
        )
    end

    eventFrame:SetScript("OnEvent", function(_, event)
        if self.moduleEnabled ~= true then
            return
        end

        self.eventCounts[event] =
            (self.eventCounts[event] or 0) + 1

        if ALL_EVENTS[event] then
            self:CaptureAll(event)
        elseif PET_EVENTS[event] then
            self:CaptureDomain("pet", event)
        elseif STANCE_EVENTS[event] then
            self:CaptureDomain("stance", event)
        elseif TOTEM_EVENTS[event] then
            self:CaptureDomain("totem", event)
        elseif RESOURCE_EVENTS[event] then
            self:CaptureDomain("resource", event)
        elseif SPECIAL_EVENTS[event] then
            self:CaptureDomain("special", event)
        end
    end)

    self.eventFrame = eventFrame
end

function Probe:OnEnable()
    self.moduleEnabled = true
    self:CaptureAll("enable")
end

function Probe:OnDisable()
    self.moduleEnabled = false
end
