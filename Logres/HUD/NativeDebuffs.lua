local _, Logres = ...

-- P0183: addon-owned placement, Blizzard-owned secure aura rendering.
-- Never read, classify or enumerate restricted aura payloads in Lua.
local Native = {}
Logres.NativeDebuffs = Native

local harmfulStyle = (Logres.Theme and Logres.Theme.nativeHarmfulAuras) or {}
local ICON = harmfulStyle.iconSize or 25
local GAP = harmfulStyle.gap or 3
local MAX = harmfulStyle.maxIcons or 5
local INSET = harmfulStyle.iconInset or 2
local FRAME_COLOR = harmfulStyle.frameColor or { 0.94, 0.65, 0.50, 0.98 }

local function createContainer(unit, key, point, relativePoint, dx, dy)
    local frame = CreateFrame(
        "AuraContainer", nil, UIParent, "CustomAuraContainerTemplate"
    )
    frame:Hide()
    -- Target uses a compact 2-column native layout; player is 5 across.
    -- Native AuraContainer owns aura membership/texture updates and packing.
    local columns = unit == "target" and 2 or 5
    local width = columns * ICON + (columns - 1) * GAP
    local height = math.ceil(MAX / columns) * ICON
        + (math.ceil(MAX / columns) - 1) * GAP
    frame:SetSize(width, height)
    frame:SetFrameStrata("HIGH")
    frame:EnableMouse(false)
    Logres.Layout.Bind(frame, key, "CENTER", "CENTER")

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
            icon:SetPoint("TOPLEFT", button, "TOPLEFT", INSET, -INSET)
            icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -INSET, INSET)
            -- The native AuraButton sets the texture, even when the aura is
            -- restricted. No aura/icon value crosses into addon Lua.
            button:SetIcon(icon)
            local border = button:CreateTexture(nil, "OVERLAY")
            border:SetAllPoints(button)
            border:SetTexture(
                (harmfulStyle.assets and harmfulStyle.assets.frame)
                    or "Interface\\Buttons\\UI-Quickslot2"
            )
            border:SetVertexColor(
                FRAME_COLOR[1], FRAME_COLOR[2],
                FRAME_COLOR[3], FRAME_COLOR[4]
            )
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
            "player", "playerHarmful", "CENTER", "CENTER", 0, 0
        )
        frames.target = createContainer(
            "target", "targetHarmful", "CENTER", "CENTER", 0, 0
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
