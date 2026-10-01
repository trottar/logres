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

    local _, build, _, interfaceVersion = GetBuildInfo()

    Logres:DevPrint(string.format(
        "%s loaded (build %s, interface %s, loadCount %s)",
        tostring(Logres.VERSION),
        tostring(build),
        tostring(interfaceVersion),
        tostring(Logres.db.meta.loadCount)
    ))
end)
