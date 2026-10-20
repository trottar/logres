-- P0279: read-only, on-demand mapping probe and mouse-inert visual outline.
-- Never hide/move/dim a Blizzard region: Hide() removes Logres overlay only.
local _, Logres = ...
local Index = Logres.ServiceElementIndex
local Inspector = {}
Logres.MappingInspector = Inspector
local overlay, current

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function method(owner, key)
    if not ordinary(owner) then return nil end
    local ok, value = pcall(function() return owner[key] end)
    if not ok or not ordinary(value) or type(value) ~= "function" then return nil end
    return value
end

local function plain(owner, key)
    local f = method(owner, key)
    if not f then return nil, false end
    local ok, value = pcall(f, owner)
    if not ok or not ordinary(value) then return nil, false end
    return value, true
end

local function eligible(region)
    if not ordinary(region) or region == nil then return false end
    local protected, knownProtected = plain(region, "IsProtected")
    if not knownProtected or protected ~= false then return false end
    local shown, knownShown = plain(region, "IsShown")
    if not knownShown or shown ~= true then return false end
    local width, kw = plain(region, "GetWidth")
    local height, kh = plain(region, "GetHeight")
    return kw and kh and type(width) == "number" and type(height) == "number"
       and width > 2 and height > 2 and width < 1800 and height < 1800
end

-- P0279 R2: explain a FAILED existing owner eligibility test only.
-- Every metadata read uses the same guarded plain() method as eligible().
-- Return static reason codes only; no Blizzard metadata values are formatted.
-- This does not relax eligibility or walk/scrape the native parent hierarchy.
local function ownerGateFailure(owner)
    if not ordinary(owner) or owner == nil then
        return "native-owner-reference-unavailable"
    end
    local kind, hasKind = plain(owner, "GetObjectType")
    if not hasKind or type(kind) ~= "string" then
        return "native-owner-kind-unavailable"
    end
    if kind == "Texture" or kind == "FontString" then
        return "native-owner-not-frame"
    end
    local protected, hasProtected = plain(owner, "IsProtected")
    if not hasProtected then return "native-owner-protection-unavailable" end
    if protected ~= false then return "native-owner-protected" end
    local shown, hasShown = plain(owner, "IsShown")
    if not hasShown then return "native-owner-visibility-unavailable" end
    if shown ~= true then return "native-owner-not-shown" end
    local width, hasWidth = plain(owner, "GetWidth")
    local height, hasHeight = plain(owner, "GetHeight")
    if not hasWidth or not hasHeight
        or type(width) ~= "number" or type(height) ~= "number" then
        return "native-owner-dimensions-unavailable"
    end
    if width <= 2 or height <= 2 or width >= 1800 or height >= 1800 then
        return "native-owner-outside-size-gate"
    end
    return "native-owner-unverified-or-protected"
end

-- A native Texture/FontString is a Region, not a legal parent for a Frame.
-- Anchor to that Region, but parent only to its verified Frame owner so native
-- close automatically hides the mouse-inert highlight without any native write.
local function verifiedOverlayOwner(region)
    if not ordinary(region) or region == nil then
        return nil, "native-region-unverified-or-protected"
    end
    local kind, knownKind = plain(region, "GetObjectType")
    if not knownKind or type(kind) ~= "string" then
        return nil, "native-kind-unavailable"
    end
    if kind ~= "Texture" and kind ~= "FontString" then
        if not eligible(region) then
            return nil, "native-region-unverified-or-protected"
        end
        return region
    end
    -- For non-Frame regions, native protection is governed by their owner.
    -- A readable IsProtected on the region itself must not report true.
    local protected, hasProtection = plain(region, "IsProtected")
    if hasProtection and protected ~= false then
        return nil, "native-region-unverified-or-protected"
    end
    local shown, hasShown = plain(region, "IsShown")
    local width, hasWidth = plain(region, "GetWidth")
    local height, hasHeight = plain(region, "GetHeight")
    if not hasShown or shown ~= true or not hasWidth or not hasHeight
        or type(width) ~= "number" or type(height) ~= "number"
        or width <= 2 or height <= 2 or width >= 1800 or height >= 1800 then
        return nil, "native-region-unverified-or-protected"
    end
    local owner, hasOwner = plain(region, "GetParent")
    if not hasOwner then return nil, "native-owner-parent-unavailable" end
    if not ordinary(owner) or owner == nil then
        return nil, "native-owner-reference-unavailable"
    end
    -- Keep R1's eligibility decision exactly intact. Only report WHY a
    -- pre-existing refusal happened, with a one-shot scoped metadata read.
    if not eligible(owner) then return nil, ownerGateFailure(owner) end
    return owner
end

local function resolve(entry)
    if type(entry.nativePath) ~= "string" then return nil, "UNMAPPED" end
    local parts = {}
    for part in entry.nativePath:gmatch("[^.]+") do parts[#parts + 1] = part end
    if #parts < 1 or #parts > 5 then return nil, "invalid-path" end
    local ok, region = pcall(function() return _G[parts[1]] end)
    if not ok or not ordinary(region) or region == nil then
        return nil, "native-root-unavailable"
    end
    for i = 2, #parts do
        local part = parts[i]
        if part == "*" then
            -- A recycled ScrollBox row has no stable index or guaranteed kind.
            -- Resolve only its parent until an independent runtime identity probe.
            return nil, "dynamic-row-identity-unverified"
        end
        local found, value = pcall(function() return region[part] end)
        if not found or not ordinary(value) or value == nil then
            return nil, "native-field-unavailable"
        end
        region = value
    end
    return region
end

local function getOverlay()
    if overlay then return overlay end
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetFrameStrata(Index.overlay.strata)
    frame:EnableMouse(false)
    frame:Hide()
    local fill = frame:CreateTexture(nil, "BACKGROUND")
    fill:SetAllPoints(frame)
    local c = Index.overlay.fill
    fill:SetColorTexture(c[1], c[2], c[3], c[4])
    local function edge(a, b, horizontal)
        local line = frame:CreateTexture(nil, "OVERLAY")
        local c = Index.overlay.border
        line:SetColorTexture(c[1], c[2], c[3], c[4])
        line:SetPoint(a, frame, a, 0, 0)
        line:SetPoint(b, frame, b, 0, 0)
        if horizontal then line:SetHeight(Index.overlay.lineWidth)
        else line:SetWidth(Index.overlay.lineWidth) end
    end
    edge("TOPLEFT", "TOPRIGHT", true)
    edge("BOTTOMLEFT", "BOTTOMRIGHT", true)
    edge("TOPLEFT", "BOTTOMLEFT", false)
    edge("TOPRIGHT", "BOTTOMRIGHT", false)
    overlay = frame
    return frame
end

function Inspector.Entries()
    return Index.rows
end

function Inspector.Hide()
    if overlay then
        overlay:Hide()
        overlay:ClearAllPoints()
        -- Restore only the addon-owned overlay's original parent.
        overlay:SetParent(UIParent)
    end
    current = nil
    return true, "highlight-off"
end

function Inspector.Highlight(id)
    Inspector.Hide()
    local entry = Index.byId[id]
    if not entry then return false, "unknown-index" end
    if type(InCombatLockdown) ~= "function" then return false, "lockdown-api-unavailable" end
    local ok, locked = pcall(InCombatLockdown)
    if not ok or not ordinary(locked) or locked ~= false then
        return false, "combat-deferred"
    end
    local region, reason = resolve(entry)
    if not region then return false, reason end
    local owner, ownerReason = verifiedOverlayOwner(region)
    if not owner then return false, ownerReason end
    local frame = getOverlay()
    local anchored = pcall(function()
        -- Native owners (Frame/Button) can parent addon art. A Texture or
        -- FontString is used as an ANCHOR only, never as a Frame parent.
        -- Native close hides the outline; no native hook or write.
        frame:SetParent(owner)
        frame:ClearAllPoints()
        frame:SetAllPoints(region)
        frame:SetFrameStrata(Index.overlay.strata)
        frame:Show()
    end)
    if not anchored then
        Inspector.Hide()
        return false, "overlay-anchor-deferred"
    end
    current = id
    return true, "highlight-visible"
end

function Inspector.Active()
    return current
end
return Inspector
