local _, Logres = ...

local function boolText(value)
    return value and "true" or "false"
end

local function printStatus()
    local state = Logres.State
    local db = Logres.db
    local _, _, _, interfaceVersion = GetBuildInfo()

    print(string.format(
        "Logres %s: loadCount=%s revision=%s context=%s combat=%s pvp=%s instance=%s/%s interface=%s",
        tostring(Logres.VERSION),
        tostring(db and db.meta and db.meta.loadCount or "?"),
        tostring(state and state.revision or "?"),
        tostring(state and state.context or "unknown"),
        boolText(state and state.combat),
        boolText(state and state.pvpFlagged),
        boolText(state and state.inInstance),
        tostring(state and state.instanceType or "unknown"),
        tostring(interfaceVersion)
    ))
end

local function printHelp()
    print("Logres development commands:")
    print("  /logres status")
    print("  /logres debug on")
    print("  /logres debug off")
end

SLASH_LOGRES1 = "/logres"
SlashCmdList.LOGRES = function(message)
    local command, argument = (message or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")

    if command == "" or command == "status" then
        printStatus()
        return
    end

    if command == "debug" then
        if not Logres.db then
            print("Logres: database is not initialized yet.")
            return
        end

        if argument == "on" then
            Logres.db.settings.debug = true
            print("Logres: development messages enabled.")
            return
        elseif argument == "off" then
            Logres.db.settings.debug = false
            print("Logres: development messages disabled.")
            return
        end
    end

    printHelp()
end
