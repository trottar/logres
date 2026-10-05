local _, Logres = ...

local MAX_INDEX = 6
local SAMPLE_LIMIT = 2
local TEXT_LIMIT = 72

local Probe = Logres:RegisterModule("AuraStatusProbe", {
    autoEnable = true,
})

local PLAYER_FILTERS = {
    { id = "helpful", filter = "HELPFUL" },
    { id = "harmful", filter = "HARMFUL" },
    { id = "harmfulCC", filter = "HARMFUL|CROWD_CONTROL" },
    { id = "harmfulRaid", filter = "HARMFUL|RAID" },
    { id = "helpfulPlayer", filter = "HELPFUL|PLAYER" },
}

local TARGET_FILTERS = {
    { id = "helpful", filter = "HELPFUL" },
    { id = "harmful", filter = "HARMFUL" },
    { id = "harmfulPlayer", filter = "HARMFUL|PLAYER" },
    { id = "harmfulCC", filter = "HARMFUL|CROWD_CONTROL" },
    { id = "helpfulDispellable", filter = "HELPFUL|DISPELLABLE" },
    { id = "helpfulImportant", filter = "HELPFUL|IMPORTANT" },
    { id = "helpfulBigDefensive", filter = "HELPFUL|BIG_DEFENSIVE" },
}

local FIELD_SPECS = {
    { key = "name", label = "name" },
    { key = "icon", label = "icon" },
    { key = "applications", label = "stacks" },
    { key = "dispelName", label = "dispel" },
    { key = "duration", label = "duration" },
    { key = "expirationTime", label = "expires" },
    { key = "sourceUnit", label = "source" },
    { key = "isStealable", label = "steal" },
    { key = "spellId", label = "spell" },
    { key = "isBossAura", label = "boss" },
    { key = "isFromPlayerOrPlayerPet", label = "playerOrigin" },
    { key = "canActivePlayerDispel", label = "canDispel" },
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
    if #value <= TEXT_LIMIT then
        return value
    end

    return value:sub(1, TEXT_LIMIT - 3) .. "..."
end

local function scalarRecord(value)
    local secret = isSecret(value)

    if secret then
        return {
            present = true,
            secret = true,
        }
    end

    if value == nil then
        return {
            present = false,
            secret = false,
        }
    end

    local valueType = type(value)
    local record = {
        present = true,
        secret = false,
        valueType = valueType,
    }

    if valueType == "string" then
        record.value = truncateText(value)
    elseif valueType == "number"
        or valueType == "boolean"
    then
        record.value = value
    end

    return record
end

local function sanitizeAura(aura)
    local fields = {}
    local secretFieldCount = 0

    for index = 1, #FIELD_SPECS do
        local spec = FIELD_SPECS[index]
        local record = scalarRecord(aura[spec.key])
        fields[spec.key] = record

        if record.secret == true then
            secretFieldCount = secretFieldCount + 1
        end
    end

    return {
        fields = fields,
        secretFieldCount = secretFieldCount,
    }
end

local function apiPresence()
    return {
        secretChecker = hasSecretChecker(),
        predicate =
            C_Secrets
            and type(
                C_Secrets.ShouldUnitAuraIndexBeSecret
            ) == "function"
            or false,
        query =
            C_UnitAuras
            and type(
                C_UnitAuras.GetAuraDataByIndex
            ) == "function"
            or false,
        unitExists =
            type(UnitExists) == "function",
    }
end

local function readUnitExists(unit)
    local result = {
        available = type(UnitExists) == "function",
        ok = false,
        secret = false,
        exists = false,
    }

    if not result.available then
        return result
    end

    local ok, value = pcall(UnitExists, unit)
    result.ok = ok == true

    if not result.ok then
        return result
    end

    local secret = isSecret(value)
    result.secret = secret

    if secret then
        return result
    end

    result.exists = value == true
    return result
end

local function readAuraIndex(unit, index, filter)
    local result = {
        index = index,
        filter = filter,
        predicateAvailable =
            C_Secrets
            and type(
                C_Secrets.ShouldUnitAuraIndexBeSecret
            ) == "function"
            or false,
        queryAvailable =
            C_UnitAuras
            and type(
                C_UnitAuras.GetAuraDataByIndex
            ) == "function"
            or false,
        secretCheckerAvailable = hasSecretChecker(),
        predicateOK = false,
        queryOK = false,
        secretIndex = false,
        secretPredicateResult = false,
        predicateIndeterminate = false,
        secretPayload = false,
        empty = false,
        present = false,
    }

    if not result.secretCheckerAvailable
        or not result.predicateAvailable
        or not result.queryAvailable
    then
        result.deferred = "api-unavailable"
        return result
    end

    local predicateOK, predicateResult = pcall(
        C_Secrets.ShouldUnitAuraIndexBeSecret,
        unit,
        index,
        filter
    )
    result.predicateOK = predicateOK == true

    if not result.predicateOK then
        result.predicateFailed = true
        return result
    end

    local predicateResultSecret = isSecret(predicateResult)
    result.secretPredicateResult = predicateResultSecret

    if predicateResultSecret then
        return result
    end

    if predicateResult ~= false then
        if predicateResult == true then
            result.secretIndex = true
        else
            result.predicateIndeterminate = true
        end

        return result
    end

    local queryOK, aura = pcall(
        C_UnitAuras.GetAuraDataByIndex,
        unit,
        index,
        filter
    )
    result.queryOK = queryOK == true

    if not result.queryOK then
        result.queryFailed = true
        return result
    end

    local auraSecret = isSecret(aura)
    result.secretPayload = auraSecret

    if auraSecret then
        return result
    end

    if aura == nil then
        result.empty = true
        return result
    end

    local auraType = type(aura)

    if auraType ~= "table" then
        result.invalidPayloadType = auraType
        return result
    end

    result.present = true
    result.aura = sanitizeAura(aura)
    return result
end

local function newFieldStats()
    local stats = {}

    for index = 1, #FIELD_SPECS do
        local key = FIELD_SPECS[index].key
        stats[key] = {
            ordinary = 0,
            secret = 0,
            absent = 0,
        }
    end

    return stats
end

local function addAuraFieldStats(scan, aura)
    for index = 1, #FIELD_SPECS do
        local key = FIELD_SPECS[index].key
        local record = aura.fields[key]
        local stats = scan.fieldStats[key]

        if record.secret == true then
            stats.secret = stats.secret + 1
        elseif record.present == true then
            stats.ordinary = stats.ordinary + 1
        else
            stats.absent = stats.absent + 1
        end
    end

    local nameRecord = aura.fields.name

    if #scan.sampleNames < SAMPLE_LIMIT
        and nameRecord.secret ~= true
        and nameRecord.present == true
        and nameRecord.valueType == "string"
        and nameRecord.value ~= ""
    then
        scan.sampleNames[#scan.sampleNames + 1] =
            nameRecord.value
    end
end

local function scanFilter(unit, descriptor)
    local scan = {
        id = descriptor.id,
        filter = descriptor.filter,
        scanned = 0,
        ordinary = 0,
        secretIndices = 0,
        secretPredicateResults = 0,
        predicateIndeterminate = 0,
        secretPayloads = 0,
        secretFields = 0,
        predicateFailures = 0,
        queryFailures = 0,
        invalidPayloads = 0,
        empty = false,
        fieldStats = newFieldStats(),
        sampleNames = {},
    }

    for index = 1, MAX_INDEX do
        local result = readAuraIndex(
            unit,
            index,
            descriptor.filter
        )
        scan.scanned = scan.scanned + 1

        if result.predicateFailed == true then
            scan.predicateFailures =
                scan.predicateFailures + 1
        elseif result.secretPredicateResult == true then
            scan.secretPredicateResults =
                scan.secretPredicateResults + 1
        elseif result.secretIndex == true then
            scan.secretIndices =
                scan.secretIndices + 1
        elseif result.predicateIndeterminate == true then
            scan.predicateIndeterminate =
                scan.predicateIndeterminate + 1
        elseif result.queryFailed == true then
            scan.queryFailures =
                scan.queryFailures + 1
        elseif result.secretPayload == true then
            scan.secretPayloads =
                scan.secretPayloads + 1
        elseif result.empty == true then
            scan.empty = true
            break
        elseif result.present == true then
            scan.ordinary = scan.ordinary + 1
            scan.secretFields =
                scan.secretFields
                + result.aura.secretFieldCount
            addAuraFieldStats(scan, result.aura)
        elseif result.invalidPayloadType ~= nil then
            scan.invalidPayloads =
                scan.invalidPayloads + 1
        end
    end

    scan.failures =
        scan.predicateFailures
        + scan.queryFailures
        + scan.invalidPayloads
        + scan.predicateIndeterminate

    return scan
end

local function captureUnit(unit, filters)
    local capture = {
        unit = unit,
        exists = readUnitExists(unit),
        scans = {},
        ordinary = 0,
        secretSkips = 0,
        secretFields = 0,
        failures = 0,
    }

    if not capture.exists.available
        or not capture.exists.ok
        or capture.exists.secret
    then
        capture.deferred = "unit-existence-unproven"
        return capture
    end

    if not capture.exists.exists then
        capture.deferred = "unit-unavailable"
        return capture
    end

    for index = 1, #filters do
        local scan = scanFilter(unit, filters[index])
        capture.scans[#capture.scans + 1] = scan
        capture.ordinary =
            capture.ordinary + scan.ordinary
        capture.secretSkips =
            capture.secretSkips
            + scan.secretIndices
            + scan.secretPredicateResults
            + scan.secretPayloads
        capture.secretFields =
            capture.secretFields + scan.secretFields
        capture.failures =
            capture.failures + scan.failures
    end

    return capture
end

local function summarizeCapture(capture)
    local total = {
        ordinary = 0,
        secretSkips = 0,
        secretFields = 0,
        failures = 0,
    }

    for _, unitCapture in pairs(capture.units) do
        total.ordinary =
            total.ordinary
            + (unitCapture.ordinary or 0)
        total.secretSkips =
            total.secretSkips
            + (unitCapture.secretSkips or 0)
        total.secretFields =
            total.secretFields
            + (unitCapture.secretFields or 0)
        total.failures =
            total.failures
            + (unitCapture.failures or 0)
    end

    capture.total = total
end

function Probe:CaptureAll(reason)
    self.captureCount = self.captureCount + 1

    local capture = {
        reason = reason,
        units = {
            player = captureUnit(
                "player",
                PLAYER_FILTERS
            ),
            target = captureUnit(
                "target",
                TARGET_FILTERS
            ),
        },
    }

    summarizeCapture(capture)
    self.lastCapture = capture
    self.lastReason = reason
    return capture
end

function Probe:CaptureTarget(reason)
    self.captureCount = self.captureCount + 1

    local capture = self.lastCapture or {
        units = {},
    }

    capture.reason = reason
    capture.units.target = captureUnit(
        "target",
        TARGET_FILTERS
    )

    if capture.units.player == nil then
        capture.units.player = captureUnit(
            "player",
            PLAYER_FILTERS
        )
    end

    summarizeCapture(capture)
    self.lastCapture = capture
    self.lastReason = reason
    return capture
end

function Probe:CaptureManual()
    self.manualCount = self.manualCount + 1
    return self:CaptureAll("manual")
end

local function boolText(value)
    return value and "true" or "false"
end

local function metadataText(scan)
    local pieces = {}

    for index = 1, #FIELD_SPECS do
        local spec = FIELD_SPECS[index]
        local stats = scan.fieldStats[spec.key]

        pieces[#pieces + 1] = string.format(
            "%s:%s/%s",
            spec.label,
            tostring(stats.ordinary),
            tostring(stats.secret)
        )
    end

    return table.concat(pieces, " ")
end

local function sampleText(scan)
    if #scan.sampleNames == 0 then
        return "-"
    end

    return table.concat(scan.sampleNames, ", ")
end

function Probe:GetDiagnosticLines()
    local lines = {}
    local capture = self.lastCapture

    if not capture then
        return {
            "no capture available",
        }
    end

    for _, unit in ipairs({ "player", "target" }) do
        local unitCapture = capture.units[unit]

        if unitCapture.deferred then
            lines[#lines + 1] = string.format(
                "%s: DEFERRED (%s)",
                unit,
                tostring(unitCapture.deferred)
            )
        else
            for index = 1, #unitCapture.scans do
                local scan = unitCapture.scans[index]

                lines[#lines + 1] = string.format(
                    "%s %s [%s]: ordinary=%s secretIndex=%s secretPredicate=%s secretPayload=%s failures=%s empty=%s samples=%s",
                    unit,
                    scan.id,
                    scan.filter,
                    tostring(scan.ordinary),
                    tostring(scan.secretIndices),
                    tostring(scan.secretPredicateResults),
                    tostring(scan.secretPayloads),
                    tostring(scan.failures),
                    boolText(scan.empty),
                    sampleText(scan)
                )

                if scan.ordinary > 0
                    or scan.secretFields > 0
                then
                    lines[#lines + 1] = string.format(
                        "%s %s metadata ordinary/secret: %s",
                        unit,
                        scan.id,
                        metadataText(scan)
                    )
                end
            end
        end
    end

    return lines
end

function Probe:GetDebugStatus()
    local api = apiPresence()
    local capture = self.lastCapture
    local total = capture and capture.total or {
        ordinary = 0,
        secretSkips = 0,
        secretFields = 0,
        failures = 0,
    }

    local targetAvailable = false

    if capture
        and capture.units
        and capture.units.target
        and capture.units.target.exists
        and capture.units.target.exists.ok
        and not capture.units.target.exists.secret
    then
        targetAvailable =
            capture.units.target.exists.exists == true
    end

    return {
        moduleEnabled = self.moduleEnabled == true,
        captureCount = self.captureCount,
        manualCount = self.manualCount,
        lastReason = self.lastReason,
        unitAuraRegistered =
            self.eventRegistration.UNIT_AURA == true,
        targetChangedRegistered =
            self.eventRegistration.PLAYER_TARGET_CHANGED
                == true,
        enteringWorldRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD
                == true,
        unitAuraEvents =
            self.eventCounts.UNIT_AURA or 0,
        targetChangedEvents =
            self.eventCounts.PLAYER_TARGET_CHANGED or 0,
        enteringWorldEvents =
            self.eventCounts.PLAYER_ENTERING_WORLD or 0,
        secretCheckerAvailable = api.secretChecker,
        predicateAvailable = api.predicate,
        queryAvailable = api.query,
        unitExistsAvailable = api.unitExists,
        ordinaryAuraCount = total.ordinary,
        secretSkipCount = total.secretSkips,
        secretFieldCount = total.secretFields,
        failureCount = total.failures,
        targetAvailable = targetAvailable,
    }
end

function Probe:OnInitialize()
    self.moduleEnabled = false
    self.captureCount = 0
    self.manualCount = 0
    self.lastCapture = nil
    self.lastReason = nil
    self.eventCounts = {
        UNIT_AURA = 0,
        PLAYER_TARGET_CHANGED = 0,
        PLAYER_ENTERING_WORLD = 0,
    }
    self.eventRegistration = {
        UNIT_AURA = false,
        PLAYER_TARGET_CHANGED = false,
        PLAYER_ENTERING_WORLD = false,
    }

    local eventFrame = CreateFrame("Frame")

    self.eventRegistration.UNIT_AURA = pcall(
        eventFrame.RegisterUnitEvent,
        eventFrame,
        "UNIT_AURA",
        "player",
        "target"
    )
    self.eventRegistration.PLAYER_TARGET_CHANGED = pcall(
        eventFrame.RegisterEvent,
        eventFrame,
        "PLAYER_TARGET_CHANGED"
    )
    self.eventRegistration.PLAYER_ENTERING_WORLD = pcall(
        eventFrame.RegisterEvent,
        eventFrame,
        "PLAYER_ENTERING_WORLD"
    )

    eventFrame:SetScript("OnEvent", function(_, event)
        if self.moduleEnabled ~= true then
            return
        end

        self.eventCounts[event] =
            (self.eventCounts[event] or 0) + 1

        if event == "PLAYER_TARGET_CHANGED" then
            self:CaptureTarget(event)
            return
        end

        self:CaptureAll(event)
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
