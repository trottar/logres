local _, Logres = ...

local CURRENT_SCHEMA = 3

local DEFAULTS = {
    schema = CURRENT_SCHEMA,
    settings = {
        debug = true,
        immersionEnabled = true,
        activeQuestEnabled = true,
    },
    meta = {
        loadCount = 0,
    },
}

local function applyDefaults(target, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            applyDefaults(target[key], value)
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

local function migrateDatabase(db)
    local schema = tonumber(db.schema)

    if schema == nil then
        -- The only pre-schema data Logres can have at this stage came from the
        -- Phase 0/early Phase A database shape, which is treated as schema 1.
        schema = next(db) == nil and CURRENT_SCHEMA or 1
    end

    if schema < 1 then
        error("LogresDB schema is invalid: " .. tostring(schema))
    end

    if schema > CURRENT_SCHEMA then
        error(string.format(
            "LogresDB schema %s is newer than supported schema %s",
            tostring(schema),
            tostring(CURRENT_SCHEMA)
        ))
    end

    if schema < 2 then
        if type(db.settings) ~= "table" then
            db.settings = {}
        end

        if db.settings.immersionEnabled == nil then
            db.settings.immersionEnabled = true
        end

        schema = 2
    end

    if schema < 3 then
        if type(db.settings) ~= "table" then
            db.settings = {}
        end

        if db.settings.activeQuestEnabled == nil then
            db.settings.activeQuestEnabled = true
        end

        schema = 3
    end

    db.schema = schema
end

function Logres:InitializeDatabase()
    if type(LogresDB) ~= "table" then
        LogresDB = {}
    end

    migrateDatabase(LogresDB)
    applyDefaults(LogresDB, DEFAULTS)

    local version, build, _, interfaceVersion = GetBuildInfo()

    LogresDB.meta.loadCount = (tonumber(LogresDB.meta.loadCount) or 0) + 1
    LogresDB.meta.lastClientVersion = version
    LogresDB.meta.lastBuild = build
    LogresDB.meta.lastInterface = interfaceVersion

    self.db = LogresDB
    return LogresDB
end
