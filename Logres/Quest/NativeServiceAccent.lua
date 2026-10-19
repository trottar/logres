-- P0274: addon-owned additive accent for native merchant/trainer windows only.
-- D-047: NEVER replace Blizzard controls, set their textures, mutate inputs or transact.
-- Gossip remains native stock fallback pending guarded live Logres dialogue adapter.
local _, Logres = ...
local Accent = {}
Logres.NPCNativeServiceAccent = Accent

local root
local visible = false
local shows, hides, failures = 0, 0, 0
local lastResult = "not-shown"

local function construct()
    if root then return true end
    local style = Logres.Theme and Logres.Theme.nativeServiceAccent
    if type(style) ~= "table" then
        failures = failures + 1
        lastResult = "accent-theme-unavailable"
        return false
    end
    local ok, created = pcall(function()
        -- Addon-owned UIParent child. Never parent/reparent into a Blizzard frame.
        local surface = CreateFrame("Frame", nil, UIParent)
        surface:SetSize(116, 8)
        surface:EnableMouse(false)
        local rule = surface:CreateTexture(nil, "ARTWORK")
        rule:SetSize(105, 2)
        rule:SetPoint("TOPLEFT", surface, "TOPLEFT", 0, -3)
        rule:SetColorTexture(unpack(style.rule))
        local seal = surface:CreateTexture(nil, "ARTWORK")
        seal:SetSize(6, 6)
        seal:SetPoint("LEFT", rule, "RIGHT", 2, 0)
        seal:SetColorTexture(unpack(style.seal))
        surface:Hide()
        return surface
    end)
    if not ok then
        failures = failures + 1
        lastResult = "accent-create-deferred"
        return false
    end
    root = created
    return true
end

function Accent.Hide()
    if root and visible then
        root:Hide()
        root:ClearAllPoints()
        hides = hides + 1
    end
    visible = false
    lastResult = "hidden"
    return true
end

function Accent.Show(frame, key)
    -- No reason to style temporary native gossip: future D-046 live renderer owns it.
    if key ~= "merchant" and key ~= "trainer" then
        Accent.Hide()
        return false, "native-gossip-stock"
    end
    if type(issecretvalue) ~= "function" then
        failures = failures + 1
        lastResult = "secret-api-absent"
        return false, lastResult
    end
    local okSecret, isSecret = pcall(issecretvalue, frame)
    if not okSecret or isSecret ~= false then
        failures = failures + 1
        lastResult = "frame-secret-or-unknown"
        return false, lastResult
    end
    if not construct() then return false, lastResult end
    local ok = pcall(function()
        if visible then root:Hide() end
        root:ClearAllPoints()
        -- Anchors only an addon-owned, mouse-disabled decorative surface.
        root:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -54)
        root:Show()
    end)
    if not ok then
        Accent.Hide()
        failures = failures + 1
        lastResult = "accent-anchor-rejected"
        return false, lastResult
    end
    visible = true
    shows = shows + 1
    lastResult = "shown-" .. key
    return true, lastResult
end

function Accent.GetAudit()
    return { mode = visible and "additive" or "stock",
        shows = shows, hides = hides, failures = failures,
        lastResult = lastResult, nativeMutations = 0,
        ownership = "addon-art-only", mouse = false }
end
return Accent
