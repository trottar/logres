local _, Logres = ...

-- P0183: addon-owned placement, Blizzard-owned secure aura rendering.
-- Never read, classify or enumerate restricted aura payloads in Lua.
local Native = {}
Logres.NativeDebuffs = Native

local WIDTH, ICON, GAP, MAX = 170, 30, 5, 5

local function createContainer(unit, key, point, relativePoint, dx, dy)
    local frame = CreateFrame(
        "AuraContainer", nil, UIParent, "CustomAuraContainerTemplate"
    )
    frame:Hide()
    frame:SetSize(WIDTH, ICON)
    frame:SetFrameStrata("HIGH")
    frame:EnableMouse(false)
    Logres.Layout.Bind(frame, key, point, relativePoint, dx, dy)

    frame:AddAuraGroup("LogresHarmful", "HARMFUL", {
        maxFrameCount = MAX,
        layout = {
            elementWidth = ICON,
            elementHeight = ICON,
            elementSpacing = GAP,
        },
        initializeFrame = function(button)
            button:SetSize(ICON, ICON)
            local icon = button:CreateTexture(nil, "ARTWORK")
            icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
            icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
            -- The native AuraButton sets the texture, even when the aura is
            -- restricted. No aura/icon value crosses into addon Lua.
            button:SetIcon(icon)
            local border = button:CreateTexture(nil, "OVERLAY")
            border:SetAllPoints(button)
            border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
            border:SetVertexColor(0.77, 0.31, 0.35, 1)
        end,
    })
    frame:SetUnit(unit)
    frame:SetEnabled(false)
    return frame
end

local function nativeReady()
    if type(CreateFrame) ~= "function"
        or not Logres.Layout or type(Logres.Layout.Bind) ~= "function"
    then
        return false
    end
    -- Forever's Blizzard_AuraContainer exports its custom templates globally.
    -- Loading a missing/unsupported optional dependency fails open.
    if C_AddOns and type(C_AddOns.IsAddOnLoaded) == "function"
        and C_AddOns.IsAddOnLoaded("Blizzard_AuraContainer") == true
    then
        return true
    end
    if C_AddOns and type(C_AddOns.LoadAddOn) == "function" then
        local ok, loaded = pcall(C_AddOns.LoadAddOn, "Blizzard_AuraContainer")
        return ok and loaded ~= false
    end
    if type(LoadAddOn) == "function" then
        local ok, loaded = pcall(LoadAddOn, "Blizzard_AuraContainer")
        return ok and loaded ~= false
    end
    return false
end

function Native.Create()
    if type(InCombatLockdown) == "function" and InCombatLockdown() then
        return nil, "combat-deferred"
    end
    if not nativeReady() then
        return nil, "native-unavailable"
    end
    local frames = {}
    local ok = pcall(function()
        frames.player = createContainer(
            "player", "playerReaction", "RIGHT", "LEFT", -100, 17
        )
        frames.target = createContainer(
            "target", "targetFallback", "LEFT", "RIGHT", 100, -17
        )
    end)
    if not ok then
        for _, frame in pairs(frames) do
            pcall(frame.SetEnabled, frame, false)
            pcall(frame.Hide, frame)
        end
        return nil, "native-setup-failed"
    end
    return { frames = frames, active = false }, nil
end

function Native.SetActive(state, active)
    if not state then return false, "unavailable" end
    active = active == true
    -- Do not mutate restricted native controls in combat. Existing Blizzard
    -- aura presentation remains untouched and available throughout.
    if type(InCombatLockdown) == "function" and InCombatLockdown() then
        if state.active == active then
            return true, "unchanged-in-combat"
        end
        return false, "combat-deferred"
    end
    local ok = pcall(function()
        for _, frame in pairs(state.frames) do
            frame:SetEnabled(active)
            frame:SetShown(active)
            if active then frame:UpdateAllAuras() end
        end
    end)
    if not ok then
        for _, frame in pairs(state.frames) do
            pcall(frame.SetEnabled, frame, false)
            pcall(frame.Hide, frame)
        end
        state.active = false
        return false, "native-update-failed"
    end
    state.active = active
    return true, active and "native-active" or "native-disabled"
end
