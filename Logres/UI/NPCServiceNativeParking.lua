-- P0306: capability-gated, whole-root stock NPC presentation parking.
-- Native roots remain SHOWN for Blizzard source APIs and transactions. Only
-- position is changed; no alpha-only invisible click regions are left behind.
-- The saved native anchors are opaque restoration tokens, never inspected.
-- This service-neutral mechanism is deliberately authorized ONLY for class
-- trainers until other NPC families earn independent source/runtime proof.
local _, Logres = ...
local Parking = {}
Logres.NPCServiceNativeParking = Parking

local permitted = {trainer={native="ClassTrainerFrame", interactionType=7}}
local parked, pendingExit = nil, false
local attempts, parks, restores, deferrals, failures = 0, 0, 0, 0, 0
local last = "stock-visible"
local hooked = {}
local retry = CreateFrame("Frame")

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function method(owner, key)
    if not ordinary(owner) then return nil end
    local ok, fn = pcall(function() return owner[key] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end

local function read(owner, key)
    local fn = method(owner, key)
    if not fn then return nil end
    local ok, value = pcall(fn, owner)
    if not ok or not ordinary(value) then return nil end
    return value
end

local function unlocked()
    if type(InCombatLockdown) ~= "function" then return false end
    local ok, value = pcall(InCombatLockdown)
    return ok and ordinary(value) and value == false
end

local function defer(why)
    deferrals = deferrals + 1
    last = why
    return false, why
end

local function capture(root)
    local count = read(root, "GetNumPoints")
    local getPoint = method(root, "GetPoint")
    if type(count) ~= "number" or count < 1 or count > 8
        or count ~= math.floor(count) or not getPoint then return nil end
    local points = {}
    for index = 1, count do
        local ok, p, relative, rp, x, y = pcall(getPoint, root, index)
        if not ok then return nil end
        -- Do NOT check or format any p/relative/rp/x/y: opaque native tokens.
        points[index] = {p, relative, rp, x, y}
    end
    return points
end

local function restoreAnchors(state)
    return pcall(function()
        state.clear(state.root)
        for i = 1, #state.points do
            local token = state.points[i]
            state.set(state.root, token[1], token[2], token[3], token[4], token[5])
        end
    end)
end

function Parking.Restore(reason)
    if not parked then
        last = reason or "stock-unchanged"
        return true, last
    end
    if not unlocked() then
        parked.pending = true
        retry:RegisterEvent("PLAYER_REGEN_ENABLED")
        return defer("stock-restore-deferred-combat")
    end
    if not restoreAnchors(parked) then
        failures = failures + 1
        parked.pending = true
        retry:RegisterEvent("PLAYER_REGEN_ENABLED")
        return defer("stock-restore-failed-retry-pending")
    end
    parked = nil
    retry:UnregisterEvent("PLAYER_REGEN_ENABLED")
    pendingExit = false
    restores = restores + 1
    last = reason or "stock-anchors-restored"
    return true, last
end

-- Invoked when Logres must be dismissed but a combat-locked native frame
-- cannot yet be safely restored. Keep Logres visible until restoration.
function Parking.DeferExit()
    if not parked then return false end
    pendingExit = true
    parked.pending = true
    retry:RegisterEvent("PLAYER_REGEN_ENABLED")
    return true
end

retry:SetScript("OnEvent", function(_, event)
    if event ~= "PLAYER_REGEN_ENABLED" or not parked or not parked.pending then
        return
    end
    local shouldClose = pendingExit
    local restored = Parking.Restore("regen-stock-restored")
    if restored and shouldClose and Logres.NPCTrainerLiveTrial then
        Logres.NPCTrainerLiveTrial.Disable("deferred-stock-restored")
    end
end)

local function placementConflict()
    local trial = Logres.NPCNativeServicePlacementTrial
    if trial and type(trial.GetAudit) == "function" then
        local ok, audit = pcall(trial.GetAudit)
        if not ok or type(audit) ~= "table" or audit.pending
            or audit.active ~= "none" or audit.autoEnabled then return true end
    end
    local skin = Logres.NPCNativeTrainerSkin
    if skin and type(skin.GetAudit) == "function" then
        local ok, audit = pcall(skin.GetAudit)
        if not ok or type(audit) ~= "table"
            or audit.active or audit.pending then return true end
    end
    return false
end

-- P0314: one-shot native profession capability. It cannot be left armed
-- after an exception, and only the caller's installed Blizzard UI fallback
-- authorizes parking; all native safety checks still run inside Park.
local professionPermit = false
function Parking.ParkProfession(key)
    if key ~= "trainer" or parked then
        return defer("profession-park-not-ready")
    end
    professionPermit = true
    local called, accepted, reason = pcall(Parking.Park, key)
    professionPermit = false
    if not called then return defer("profession-park-call-rejected") end
    return accepted, reason
end

function Parking.Park(key)
    attempts = attempts + 1
    local spec = permitted[key]
    if not spec then return defer("service-not-authorized") end
    if parked then
        if parked.key == key and not parked.pending then return true, "already-parked" end
        return defer("other-park-or-restoration-pending")
    end
    if not unlocked() then return defer("combat-or-secret-deferred") end
    local state = Logres:GetState()
    if not state or state.interacting ~= true
        or state.interactionType ~= spec.interactionType then
        return defer("not-in-native-service-session")
    end
    -- P0308: shared painting is not purchase authorization. For profession
    -- trainers Logres may render a read-only view, but the stock
    -- transaction window MUST remain on-screen until the specialized
    -- training adapter has been proven. Never park an unknown family.
    local okProfession, family = pcall(function() return _G.IsTradeskillTrainer end)
    if not okProfession or not ordinary(family)
        or type(family) ~= "function" then
        return defer("trainer-family-api-unavailable-stock-retained")
    end
    local okFamily, profession = pcall(family)
    if not okFamily or not ordinary(profession)
        or type(profession) ~= "boolean" then
        return defer("profession-or-unknown-stock-retained")
    end
    -- Class trainers use the original unarmed route. Profession trainers
    -- require a single armed call after Logres has attached Blizzard UI.
    if profession == true and not professionPermit then
        return defer("profession-or-unknown-stock-retained")
    end
    if placementConflict() then return defer("native-placement-conflict") end
    local okRoot, root = pcall(function() return _G[spec.native] end)
    if not okRoot or not ordinary(root) or root == nil
        or read(root, "IsProtected") ~= false
        or read(root, "IsShown") ~= true then
        return defer("native-root-not-safe-and-shown")
    end
    local clear, set = method(root, "ClearAllPoints"), method(root, "SetPoint")
    local hook = method(root, "HookScript")
    local points = capture(root)
    if not clear or not set or not hook or not points or not ordinary(UIParent) then
        return defer("native-anchor-or-hook-capability-absent")
    end
    if not hooked[key] then
        -- Native closure can precede the shared session's state notification.
        -- Restore the actual saved anchors and release Logres afterwards.
        local attached = pcall(hook, root, "OnHide", function()
            if parked and parked.key == key then
                local restored = Parking.Restore("native-trainer-closed")
                if restored and Logres.NPCTrainerLiveTrial then
                    Logres.NPCTrainerLiveTrial.Disable("native-context-ended")
                elseif not restored then
                    Parking.DeferExit()
                end
            end
        end)
        if not attached then return defer("native-hide-restore-hook-unavailable") end
        hooked[key] = true
    end
    -- Snapshot and rollback state BEFORE the first native mutation. Its right
    -- edge is to the LEFT of UIParent's bottom-left; no native child hit region
    -- remains over the playable screen. Keep IsShown true for native APIs.
    parked = {key=key, root=root, points=points, clear=clear, set=set, pending=false}
    local moved = pcall(function()
        clear(root)
        set(root, "TOPRIGHT", UIParent, "BOTTOMLEFT", -64, -64)
    end)
    if not moved then
        failures = failures + 1
        local restored = Parking.Restore("park-activation-rolled-back")
        if not restored then Parking.DeferExit() end
        return defer(restored and "park-rejected-stock-restored"
            or "park-rejected-restore-pending")
    end
    parks = parks + 1
    last = "native-offscreen-requested-unverified"
    return true, last
end

function Parking.GetAudit()
    return {parked=parked ~= nil, pending=parked and parked.pending or false,
        pendingExit=pendingExit, key=parked and parked.key or "none",
        attempts=attempts, parks=parks, restores=restores,
        deferrals=deferrals, failures=failures, last=last,
        nativeShownPreserved=true, nativeVisibilityWrites=0}
end

return Parking
