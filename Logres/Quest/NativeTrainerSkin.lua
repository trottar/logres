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
    Logres.PanelSurface.Hide(pieces)
end

-- P/live share one trainer configuration and the exact common panel painter.
local trainerConfig = Logres.PanelConfigs.trainer
local function createPaint(owner, width, height)
    local pieces = Logres.PanelSurface.Paint(owner, trainerConfig.surface, width, height)
    if pieces then
        for index = 1, #pieces do
            assetPieces[pieces[index]] = true
        end
    end
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
    -- Always hide addon-owned ScrollBox ornament before native alpha restoration.
    Logres.NPCTrainerComponents.Disable()
    Logres.NPCTrainerMotif.Disable()
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
    local pieces = createPaint(frame, width, height)
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
    -- Require real Forever ScrollBox/row proof; no partial black-only skin.
    local motifOK, motifReason = Logres.NPCTrainerMotif.Enable(frame)
    if not motifOK then
        local restored = Skin.Disable("motif-deferred")
        if not restored then return fail("motif-and-stock-restore-failed") end
        last = "motif-deferred-" .. motifReason
        return false, last
    end
    -- Supplement the verified motif with style on available mapped controls.
    -- Missing controls remain native and are reported as partial, not patched around.
    Logres.NPCTrainerComponents.Enable(frame)
    trials = trials + 1
    last = "native-scroll-motif-active"
    return true, last
end

function Skin.Preview()
    if preview and preview:IsShown() then
        preview:Hide()
        return true, "synthetic-preview-hidden"
    end
    if not preview then
        local visual = trainerConfig.preview
        local ok, root = pcall(function()
            local surface = CreateFrame("Frame", nil, UIParent)
            surface:SetSize(visual.width, visual.height)
            surface:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)
            surface:SetFrameStrata(visual.strata)
            surface:EnableMouse(visual.mouse)
            surface:Hide()
            local painted = createPaint(surface, visual.width, visual.height)
            if not painted then error("preview-painter-failed") end
            -- P0281: P shows the entire declared landscape composition.
            -- Native H path above is unchanged and remains strictly Blizzard-owned.
            local landscapeOK = Logres.NPCTrainerLandscape.Preview(surface)
            if not landscapeOK then error("trainer-landscape-preview-failed") end
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
        components=Logres.NPCTrainerComponents.GetAudit(),
        result=last, nativeTransactions=0, geometryWrites=0}
end
return Skin
