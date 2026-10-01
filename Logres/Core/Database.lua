local _, Logres = ...

local DEFAULTS = {
    schema = 1,
    settings = {
        debug = true,
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

function Logres:InitializeDatabase()
    if type(LogresDB) ~= "table" then
        LogresDB = {}
    end

    applyDefaults(LogresDB, DEFAULTS)

    local version, build, _, interfaceVersion = GetBuildInfo()

    LogresDB.meta.loadCount = (tonumber(LogresDB.meta.loadCount) or 0) + 1
    LogresDB.meta.lastClientVersion = version
    LogresDB.meta.lastBuild = build
    LogresDB.meta.lastInterface = interfaceVersion

    self.db = LogresDB
    return LogresDB
end
