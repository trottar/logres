-- P0275: quest-art backdrop for opt-in native merchant/trainer placement.
-- D-047: standalone addon-owned art BEHIND native frames, not a native replacement.
-- The Blizzard window remains intact, including its opaque background and controls.
local _, Logres = ...
local Accent = {}
Logres.NPCNativeServiceAccent = Accent

local root, categoryLabel
local visible = false
local shows, hides, failures = 0, 0, 0
local lastResult = "not-shown"

local function construct()
    if root then return true end
    local style = Logres.Theme and Logres.Theme.nativeServiceAccent
    local questStyle = Logres.Theme and Logres.Theme.questDialogue
    local assets = questStyle and questStyle.assets
    if type(style) ~= "table" or type(assets) ~= "table"
        or type(assets.panel) ~= "string"
        or type(assets.divider) ~= "string"
    then
        failures = failures + 1
        lastResult = "quest-art-theme-unavailable"
        return false
    end

    local ok, created, label = pcall(function()
        -- Deliberately BACKGROUND strata: never cover the native window/input.
        local surface = CreateFrame("Frame", nil, UIParent)
        surface:SetSize(style.width, style.height)
        surface:SetFrameStrata("BACKGROUND")
        surface:SetFrameLevel(0)
        surface:EnableMouse(false)
        -- Fail closed on any partial art-construction error: no stray visible shell.
        surface:Hide()

        -- Nine slices of the EXACT quest panel art. Retains original corner
        -- geometry when extending the wide quest silhouette around a taller
        -- Blizzard merchant/trainer frame. All regions belong to the addon.
        local cut = style.corner
        local x = { 0, cut, style.width - cut }
        local y = { 0, cut, style.height - cut }
        local w = { cut, style.width - 2 * cut, cut }
        local h = { cut, style.height - 2 * cut, cut }
        local u = { 0, cut / questStyle.width,
            1 - cut / questStyle.width, 1 }
        local v = { 0, cut / questStyle.height,
            1 - cut / questStyle.height, 1 }
        for row = 1, 3 do
            for col = 1, 3 do
                local piece = surface:CreateTexture(nil, "BACKGROUND")
                piece:SetTexture(assets.panel)
                piece:SetSize(w[col], h[row])
                piece:SetPoint("TOPLEFT", surface, "TOPLEFT", x[col], -y[row])
                piece:SetTexCoord(u[col], u[col+1], v[row], v[row+1])
            end
        end
        local divider = surface:CreateTexture(nil, "ARTWORK")
        divider:SetTexture(assets.divider)
        divider:SetSize(style.width - 72, 18)
        divider:SetPoint("TOP", surface, "TOP", 0, -48)

        local text = surface:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("TOP", surface, "TOP", 0, -16)
        text:SetTextColor(unpack(style.label))
        surface:Hide()
        return surface, text
    end)
    if not ok or not created or not label then
        failures = failures + 1
        lastResult = "quest-art-create-deferred"
        return false
    end
    root, categoryLabel = created, label
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
    -- Gossip is NOT restyled; a separate guarded Logres live renderer is planned.
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
        -- Only addon-owned geometry; native frame and its child layout untouched.
        root:SetPoint("CENTER", frame, "CENTER", 0, 0)
        categoryLabel:SetText(key == "trainer" and "TRAINER" or "MERCHANT")
        root:Show()
    end)
    if not ok then
        Accent.Hide()
        failures = failures + 1
        lastResult = "quest-art-anchor-rejected"
        return false, lastResult
    end
    visible = true
    shows = shows + 1
    lastResult = "quest-shell-" .. key
    return true, lastResult
end

function Accent.GetAudit()
    return { mode = visible and "quest-shell" or "stock",
        shows = shows, hides = hides, failures = failures,
        lastResult = lastResult, nativeMutations = 0,
        ownership = "addon-art-only", mouse = false }
end
return Accent
