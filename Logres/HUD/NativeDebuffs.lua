local _, Logres = ...

-- P0183: addon-owned placement, Blizzard-owned secure aura rendering.
-- Never read, classify or enumerate restricted aura payloads in Lua.
local Native = {}
Logres.NativeDebuffs = Native
local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

function Native.StockPlayerHarmful()
    local root = _G.DebuffFrame
    if ordinary(root) and root ~= nil then return root end
end

local function restoreStockPlacement(state)
    local saved = state.stockPlacement
    if not saved then return true end
    local checked, protected = pcall(saved.root.IsProtected, saved.root)
    if not checked or not ordinary(protected) or protected ~= false then return false end
    local ok, _, relative = pcall(saved.root.GetPoint, saved.root, 1)
    if not ok or not ordinary(relative) then return false end
    if relative == saved.anchor then
        ok = pcall(function()
            saved.root:ClearAllPoints()
            for _, p in ipairs(saved.points) do
                saved.root:SetPoint(p[1], p[2], p[3], p[4], p[5])
            end
        end)
        if not ok then
            pcall(saved.root.SetPoint, saved.root, "BOTTOM", saved.anchor, "CENTER", 0, 0)
            return false
        end
    end
    state.stockPlacement = nil
    return true
end

local function placeStockPlayerHarmful(state, active)
    if not active then
        state.stockPlacementAttempted = false
        state.stockPlacementReason = restoreStockPlacement(state) and "stock-default"
            or "stock-anchor-restore-deferred"
        return
    end
    local root = Native.StockPlayerHarmful()
    if not root or state.stockPlacementAttempted then return end
    state.stockPlacementAttempted = true
    state.stockPlacementReason = "stock-default"
    local anchor = type(Logres.Layout.GetAnchor) == "function" and Logres.Layout.GetAnchor("playerHarmful")
    if not anchor or type(root.IsProtected) ~= "function" or type(root.GetNumPoints) ~= "function"
        or type(root.GetPoint) ~= "function" or type(root.ClearAllPoints) ~= "function"
        or type(root.SetPoint) ~= "function" then return end
    local checked, protected = pcall(root.IsProtected, root)
    if not checked or not ordinary(protected) or protected ~= false then return end
    local counted, count = pcall(root.GetNumPoints, root)
    if not counted or not ordinary(count) or type(count) ~= "number"
        or count < 1 or count > 8 or count ~= math.floor(count) then return end
    local points = {}
    for i = 1, count do
        local captured, p, relative, rp, x, y = pcall(root.GetPoint, root, i)
        if not captured then return end
        points[i] = {p, relative, rp, x, y}
    end
    local moved = pcall(function()
        root:ClearAllPoints()
        root:SetPoint("BOTTOM", anchor, "CENTER", 0, 0)
    end)
    if not moved then
        local restored = pcall(function()
            root:ClearAllPoints()
            for _, p in ipairs(points) do root:SetPoint(p[1], p[2], p[3], p[4], p[5]) end
        end)
        if not restored then
            pcall(root.SetPoint, root, "TOPRIGHT", UIParent, "TOPRIGHT", -260, -95)
        end
        return
    end
    state.stockPlacement = {root = root, anchor = anchor, points = points}
    state.stockPlacementReason = "stock-player-lane-requested"
end

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
    frame:SetFrameStrata("BACKGROUND")
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

function Native.SetActive(state, active, placementEvent)
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
        if not active or placementEvent then placeStockPlayerHarmful(state, active) end
        for unit, frame in pairs(state.frames) do
            local visible = active and (unit ~= "player" or Native.StockPlayerHarmful() == nil)
            frame:SetEnabled(visible)
            frame:SetShown(visible)
            if visible then frame:UpdateAllAuras() end
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
