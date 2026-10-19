-- P0271: EXPLICIT, reversible native merchant/trainer placement trial only.
-- D-047: Blizzard owns native controls, transaction logic and camera.
-- This is NOT an automatic skin/ownership/suppression/transaction layer.
local _, Logres = ...
local Trial = {}
Logres.NPCNativeServicePlacementTrial = Trial

local CANDIDATES = {
    [5] = { key = "merchant", name = "MerchantFrame" },
    [7] = { key = "trainer", name = "ClassTrainerFrame" },
}
local active
local hooks = {}
local restorePending = false
local starts, restores, failures, autoRestores = 0, 0, 0, 0
local lastResult = "not-attempted"
local retryFrame

local function ordinary(v)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, v)
    return ok and secret == false
end

local function safeMethod(frame, name)
    local ok, method = pcall(function() return frame[name] end)
    if not ok or not ordinary(method) or type(method) ~= "function" then
        return nil
    end
    return method
end

local function unlocked()
    if type(InCombatLockdown) ~= "function" then return false end
    local ok, value = pcall(InCombatLockdown)
    return ok and ordinary(value) and value == false
end

local function finish(result, failure)
    lastResult = result
    if failure == true then failures = failures + 1 end
    return false, result
end

-- Guarded geometry restoration is the ONLY native geometry read. Individual
-- GetPoint fields are opaque restoration tokens: never inspect, compare,
-- format, classify, serialize or branch on any of their values.
local function capture(frame)
    local countMethod = safeMethod(frame, "GetNumPoints")
    local readMethod = safeMethod(frame, "GetPoint")
    if not countMethod or not readMethod then return nil end
    local ok, count = pcall(countMethod, frame)
    if not ok or not ordinary(count) or type(count) ~= "number"
        or count < 1 or count > 8 or count ~= math.floor(count)
    then return nil end
    local points = {}
    for index = 1, count do
        local good, p, relative, rp, x, y = pcall(readMethod, frame, index)
        if not good then return nil end
        points[index] = { p, relative, rp, x, y }
    end
    return points
end

local function setAnchors(frame, points)
    local clear = safeMethod(frame, "ClearAllPoints")
    local set = safeMethod(frame, "SetPoint")
    if not clear or not set then return false end
    local ok = pcall(function()
        clear(frame)
        for i = 1, #points do
            local token = points[i]
            set(frame, token[1], token[2], token[3], token[4], token[5])
        end
    end)
    return ok
end

function Trial.Restore(reason)
    if not active then
        restorePending = false
        if retryFrame then retryFrame:UnregisterEvent("PLAYER_REGEN_ENABLED") end
        return true, "stock-unchanged"
    end
    if not unlocked() then
        restorePending = true
        if retryFrame then retryFrame:RegisterEvent("PLAYER_REGEN_ENABLED") end
        return false, "combat-restore-deferred"
    end
    if not setAnchors(active.frame, active.anchors) then
        restorePending = true
        if retryFrame then retryFrame:RegisterEvent("PLAYER_REGEN_ENABLED") end
        return finish("restoration-failed-stock-still-accessible", true)
    end
    if reason == "native-hide" then autoRestores = autoRestores + 1 end
    active = nil
    restorePending = false
    if retryFrame then retryFrame:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    restores = restores + 1
    lastResult = reason or "restored"
    return true, lastResult
end

-- Event is subscribed ONLY when a restoration is pending. No polling.
retryFrame = CreateFrame("Frame")
retryFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_ENABLED" and restorePending then
        Trial.Restore("combat-ended")
    end
end)

function Trial.Toggle()
    if active then return Trial.Restore("manual-restore") end
    if not unlocked() then return finish("combat-deferred", false) end
    local state = Logres:GetState()  -- addon-owned normalized state only
    local candidate = state and state.interacting == true
        and CANDIDATES[state.interactionType] or nil
    if not candidate then return finish("no-supported-open-service", false) end
    local okFrame, frame = pcall(function() return _G[candidate.name] end)
    if not okFrame or not ordinary(frame) or frame == nil then
        return finish("frame-unavailable", false)
    end
    local protect = safeMethod(frame, "IsProtected")
    local shown = safeMethod(frame, "IsShown")
    local set = safeMethod(frame, "SetPoint")
    local clear = safeMethod(frame, "ClearAllPoints")
    local hook = safeMethod(frame, "HookScript")
    if not protect or not shown or not set or not clear or not hook
        or not ordinary(UIParent)
    then return finish("native-api-unavailable", false) end
    local okProtected, protected = pcall(protect, frame)
    local okShown, visible = pcall(shown, frame)
    if not okProtected or not ordinary(protected) or protected ~= false
        or not okShown or not ordinary(visible) or visible ~= true
    then return finish("native-visibility-or-protection-deferred", false) end
    local points = capture(frame)
    if not points then return finish("native-anchor-snapshot-deferred", false) end
    if not hooks[candidate.key] then
        local hooked = pcall(hook, frame, "OnHide", function()
            if active and active.key == candidate.key then
                Trial.Restore("native-hide")
            end
        end)
        if not hooked then return finish("native-hide-hook-rejected", false) end
        hooks[candidate.key] = true
    end
    -- Full native frame + every native child/input stays intact. Only whole-
    -- frame anchors move, on an explicit developer TEST action, out of combat.
    local moved = pcall(function()
        clear(frame)
        set(frame, "CENTER", UIParent, "CENTER", 0, 0)
    end)
    if not moved then
        if not setAnchors(frame, points) then
            active = { frame = frame, anchors = points, key = candidate.key }
            restorePending = true
            retryFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
            return finish("move-failed-restoration-pending", true)
        end
        return finish("move-rejected-restored", true)
    end
    active = { frame = frame, anchors = points, key = candidate.key }
    starts = starts + 1
    lastResult = "trial-centered-" .. candidate.key
    return true, lastResult
end

function Trial.GetAudit()
    return { active = active and active.key or "none",
        starts = starts, restores = restores, failures = failures,
        autoRestores = autoRestores, pending = restorePending,
        result = lastResult, nativeTransactions = 0,
        styling = "unchanged", scope = "manual-merchant-trainer-only" }
end
return Trial
