-- P0276 R1: opt-in native trainer decoration trial, never a trainer replacement.
-- D-047: all trainer controls/selection/prices/Train remain Blizzard-owned.
-- Direct ClassTrainerFrame BACKGROUND/BORDER textures are snapshotted and
-- dimmed only during an explicit, guarded H trial; original alpha tokens are
-- returned to native setters without comparing, stringifying or interpreting.
local _, Logres = ...
local Skin = {}
Logres.NPCNativeTrainerSkin = Skin

local active, preview, hooked, retry
local trials, restores, failures = 0, 0, 0
local last = "stock"
local assetPieces = {}

local function ordinary(v)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, v)
    return ok and secret == false
end

local function method(obj, name)
    if not ordinary(obj) then return nil end
    local ok, f = pcall(function() return obj[name] end)
    if not ok or not ordinary(f) or type(f) ~= "function" then return nil end
    return f
end

local function read(obj, name)
    local fn = method(obj, name)
    if not fn then return nil, false end
    local ok, v = pcall(fn, obj)
    if not ok or not ordinary(v) then return nil, false end
    return v, true
end

local function unlocked()
    if type(InCombatLockdown) ~= "function" then return false end
    local ok, locked = pcall(InCombatLockdown)
    return ok and ordinary(locked) and locked == false
end

local function hidePaint(pieces)
    for i = 1, #pieces do
        pcall(function() pieces[i]:Hide() end)
    end
end

-- The SAME painter is used by synthetic P preview and the guarded live trial.
-- No buttons, input fields, mock currencies or training actions are created.
local function paint(owner, width, height)
    local theme = Logres.Theme and Logres.Theme.questDialogue
    local assets = theme and theme.assets
    if not assets or type(assets.panel) ~= "string"
        or type(assets.divider) ~= "string" then return nil end
    local pieces = {}
    local ok = pcall(function()
        local cut = 40
        local ww = {cut, width - 2 * cut, cut}
        local hh = {cut, height - 2 * cut, cut}
        local xx = {0, cut, width - cut}
        local yy = {0, cut, height - cut}
        local uu = {0, cut / theme.width, 1 - cut / theme.width, 1}
        local vv = {0, cut / theme.height, 1 - cut / theme.height, 1}
        for row = 1, 3 do
            for col = 1, 3 do
                local tex = owner:CreateTexture(nil, "BACKGROUND", nil, -7)
                pieces[#pieces + 1] = tex
                assetPieces[tex] = true -- do not mistake addon art for stock regions
                tex:Hide()
                tex:SetTexture(assets.panel)
                tex:SetSize(ww[col], hh[row])
                tex:SetPoint("TOPLEFT", owner, "TOPLEFT", xx[col], -yy[row])
                tex:SetTexCoord(uu[col], uu[col+1], vv[row], vv[row+1])
            end
        end
        local divider = owner:CreateTexture(nil, "BACKGROUND", nil, -6)
        pieces[#pieces + 1] = divider
        assetPieces[divider] = true
        divider:Hide()
        divider:SetTexture(assets.divider)
        divider:SetSize(width - 72, 18)
        divider:SetPoint("TOP", owner, "TOP", 0, -52)
    end)
    if not ok then hidePaint(pieces); return nil end
    return pieces
end

local function stockDecorations(frame)
    local count, countKnown = read(frame, "GetNumRegions")
    local get = method(frame, "GetRegions")
    if not countKnown or type(count) ~= "number" or count < 1
        or count > 64 or count ~= math.floor(count) or not get then
        return nil, "native-region-count-unavailable"
    end
    local ok, regions = pcall(function() return {get(frame)} end)
    if not ok then return nil, "native-regions-unavailable" end
    local snapshot = {}
    for i = 1, count do
        local region = regions[i]
        if ordinary(region) and region ~= nil and not assetPieces[region] then
            local kind, knownKind = read(region, "GetObjectType")
            local layer, knownLayer = read(region, "GetDrawLayer")
            -- Root-only decorative layers; no child regions, icons, labels,
            -- selections, scrollboxes, edit boxes or button surfaces.
            if knownKind and knownLayer and kind == "Texture"
                and (layer == "BACKGROUND" or layer == "BORDER") then
                local getAlpha = method(region, "GetAlpha")
                local setAlpha = method(region, "SetAlpha")
                if not getAlpha or not setAlpha then
                    return nil, "native-decoration-alpha-unavailable"
                end
                local got, alpha = pcall(getAlpha, region)
                -- Alpha is an OPAQUE restoration token. Never inspect it.
                if not got then return nil, "native-decoration-snapshot-failed" end
                snapshot[#snapshot + 1] = {region=region, set=setAlpha, token=alpha}
            end
        end
    end
    if #snapshot < 1 or #snapshot > 24 then
        return nil, "no-bounded-root-decoration-candidates"
    end
    return snapshot
end

local function restoration(snapshot)
    local good = true
    for i = 1, #snapshot do
        local item = snapshot[i]
        if not pcall(item.set, item.region, item.token) then good = false end
    end
    return good
end

local function fail(why)
    failures = failures + 1
    last = why
    return false, why
end

function Skin.Disable(reason)
    if not active then last = "stock"; return true, last end
    hidePaint(active.paint)
    if not unlocked() then
        active.pending = true
        retry:RegisterEvent("PLAYER_REGEN_ENABLED")
        last = "restore-deferred-combat"
        return false, last
    end
    if not restoration(active.decorations) then
        active.pending = true
        retry:RegisterEvent("PLAYER_REGEN_ENABLED")
        return fail("native-decoration-restoration-failed")
    end
    active = nil
    retry:UnregisterEvent("PLAYER_REGEN_ENABLED")
    restores = restores + 1
    last = reason or "restored"
    return true, last
end

retry = CreateFrame("Frame")
retry:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_ENABLED" and active and active.pending then
        Skin.Disable("combat-restored")
    end
end)

function Skin.Enable()
    if active and active.pending then return false, "restoration-pending" end
    if active then return true, "skin-already-active" end
    if not unlocked() then return false, "combat-deferred" end
    local state = Logres:GetState()
    if not state or state.interacting ~= true or state.interactionType ~= 7 then
        return false, "open-native-trainer-required"
    end
    local got, frame = pcall(function() return _G.ClassTrainerFrame end)
    if not got or not ordinary(frame) or frame == nil then
        return false, "trainer-frame-unavailable"
    end
    local isProtected, knownProtected = read(frame, "IsProtected")
    local shown, knownShown = read(frame, "IsShown")
    if not knownProtected or isProtected ~= false
        or not knownShown or shown ~= true then
        return false, "trainer-not-shown-or-protected"
    end
    local width, knownWidth = read(frame, "GetWidth")
    local height, knownHeight = read(frame, "GetHeight")
    if not knownWidth or not knownHeight or type(width) ~= "number"
        or type(height) ~= "number" or width < 260 or width > 1000
        or height < 280 or height > 1000 then
        return false, "trainer-geometry-not-supported"
    end
    local decorations, why = stockDecorations(frame)
    if not decorations then return false, why end
    local pieces = paint(frame, width, height)
    if not pieces then return fail("quest-art-painter-unavailable") end
    if not hooked then
        local hook = method(frame, "HookScript")
        if not hook or not pcall(hook, frame, "OnHide", function()
            if active then Skin.Disable("trainer-closed") end
        end) then
            hidePaint(pieces)
            return fail("native-close-restoration-hook-unavailable")
        end
        hooked = true
    end
    -- Prepare exact rollback state BEFORE making the first native change.
    active = {frame=frame, decorations=decorations, paint=pieces, pending=false}
    for i = 1, #decorations do
        if not pcall(decorations[i].set, decorations[i].region, 0) then
            local restored = Skin.Disable("activation-rolled-back")
            if not restored then return fail("activation-and-restore-failed") end
            return fail("native-decoration-alpha-rejected")
        end
    end
    for i = 1, #pieces do
        if not pcall(function() pieces[i]:Show() end) then
            Skin.Disable("art-activation-rolled-back")
            return fail("quest-art-show-failed")
        end
    end
    trials = trials + 1
    last = "native-root-skin-active"
    return true, last
end

function Skin.Preview()
    if preview and preview:IsShown() then
        preview:Hide()
        return true, "synthetic-preview-hidden"
    end
    if not preview then
        local ok, root = pcall(function()
            local surface = CreateFrame("Frame", nil, UIParent)
            surface:SetSize(560, 430)
            surface:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            surface:SetFrameStrata("DIALOG")
            surface:EnableMouse(false)
            surface:Hide()
            local painted = paint(surface, 560, 430)
            if not painted then error("preview-painter-failed") end
            for i = 1, #painted do painted[i]:Show() end
            local title = surface:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            title:SetPoint("TOP", surface, "TOP", 0, -20)
            title:SetText("TRAINER / PANEL ART")
            title:SetTextColor(0.94, 0.83, 0.60, 1)
            local note = surface:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            note:SetPoint("CENTER", surface, "CENTER", 0, 0)
            note:SetText("Visual fixture only — native trainer controls remain Blizzard-owned")
            note:SetTextColor(0.92, 0.89, 0.81, 0.97)
            return surface
        end)
        if not ok or not root then return fail("preview-construction-failed") end
        preview = root
    end
    preview:Show()
    return true, "synthetic-preview-visible"
end

function Skin.GetAudit()
    return {active=active ~= nil, pending=active and active.pending == true or false,
        nativeDecorations=active and #active.decorations or 0,
        trials=trials, restores=restores, failures=failures,
        preview=preview and preview:IsShown() or false,
        result=last, nativeTransactions=0, geometryWrites=0}
end
return Skin
