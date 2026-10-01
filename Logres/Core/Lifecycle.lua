local addonName, Logres = ...

Logres:RegisterEvent("ADDON_LOADED", function(_, loadedAddon)
    if loadedAddon ~= addonName then
        return
    end

    Logres:InitializeDatabase()
end)

Logres:RegisterEvent("PLAYER_LOGIN", function()
    if not Logres.db then
        -- Defensive fallback for unusual load ordering.
        Logres:InitializeDatabase()
    end

    -- State.lua registers PLAYER_LOGIN before Lifecycle.lua, so the observed
    -- state snapshot is initialized before modules enter their lifecycle.
    Logres:InitializeModules()
    Logres:EnableDefaultModules()

    local _, build, _, interfaceVersion = GetBuildInfo()

    Logres:DevPrint(string.format(
        "%s loaded (build %s, interface %s, loadCount %s)",
        tostring(Logres.VERSION),
        tostring(build),
        tostring(interfaceVersion),
        tostring(Logres.db.meta.loadCount)
    ))
end)
