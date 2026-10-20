-- P0271-P0274: guarded native placement + addon-owned merchant/trainer ornament; gossip stock fallback.
-- D-047: Blizzard owns native controls, transaction logic and camera.
-- This is NOT an automatic skin/ownership/suppression/transaction layer.
local _, Logres = ...
local Trial = {}
Logres.NPCNativeServicePlacementTrial = Trial

local CANDIDATES = {
    [3] = { key = "gossip", name = "GossipFrame" },
    [5] = { key = "merchant", name = "MerchantFrame" },
    [7] = { key = "trainer", name = "ClassTrainerFrame" },
}
local active
local hooks = {}
local restorePending = false
local starts, restores, failures, autoRestores = 0, 0, 0, 0
local gossipStarts, gossipRestores = 0, 0
local lastResult = "not-attempted"
local retryFrame
local autoEnabled = false
local autoHooks = {}
local autoStarts, autoDeferred = 0, 0
local autoLast = "not-armed"

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
    -- Restore temporary native trainer decoration before native positioning.
    if Logres.NPCNativeTrainerSkin then
        pcall(function() Logres.NPCNativeTrainerSkin.Disable("placement-restore") end)
    end
    -- Remove all addon decoration first, even if native geometry must defer.
    if Logres.NPCNativeServiceAccent then
        pcall(function() Logres.NPCNativeServiceAccent.Hide() end)
    end
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
    if active.key == "gossip" then gossipRestores = gossipRestores + 1 end
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
    -- Full stock frame and all Blizzard controls stay intact. One guarded
    -- whole-frame anchor change per explicit test or opted-in NPC lifecycle.
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
    -- Fail open: artwork errors cannot revoke native service placement or input.
    if Logres.NPCNativeServiceAccent then
        pcall(function() Logres.NPCNativeServiceAccent.Show(frame, candidate.key) end)
    end
    starts = starts + 1
    if candidate.key == "gossip" then gossipStarts = gossipStarts + 1 end
    lastResult = "trial-centered-" .. candidate.key
    return true, lastResult
end

-- P0272/P0273: automatic layout is deliberately OFF until an explicit user TEST
-- action. This reuses Trial.Toggle's complete capture, native safety gates and
-- native OnHide restoration. Frame data/children and transactions stay Blizzard.
local function ensureAutoOnShow(candidate)
    if autoHooks[candidate.key] then return true end
    if not unlocked() then return false end
    local okFrame, frame = pcall(function() return _G[candidate.name] end)
    if not okFrame or not ordinary(frame) or frame == nil then return false end
    local protect = safeMethod(frame, "IsProtected")
    local hook = safeMethod(frame, "HookScript")
    if not protect or not hook then return false end
    local ok, protected = pcall(protect, frame)
    if not ok or not ordinary(protected) or protected ~= false then return false end
    local hooked = pcall(hook, frame, "OnShow", function()
        if autoEnabled then Trial.AutoReconcile("native-show") end
    end)
    if hooked then autoHooks[candidate.key] = true end
    return hooked
end

function Trial.AutoReconcile(reason)
    if not autoEnabled then return false, "auto-off" end
    local state = Logres:GetState() -- addon-owned interaction, not Blizzard visibility.
    local candidate = state and state.interacting == true
        and CANDIDATES[state.interactionType] or nil
    if active and (not candidate or active.key ~= candidate.key) then
        local restored, why = Trial.Restore("interaction-ended")
        if not restored then
            autoLast = why
            return false, why
        end
    end
    if not candidate then
        autoLast = "awaiting-supported-service"
        return false, autoLast
    end
    -- Hook a known native frame at most once. A lazy-load/early SHOW that
    -- cannot safely be observed is DEFERRED; never poll or force a re-show.
    ensureAutoOnShow(candidate)
    if active or restorePending then
        autoLast = "already-centered-or-restoring"
        return true, autoLast
    end
    local ok, why = Trial.Toggle()
    if ok then
        autoStarts = autoStarts + 1
    else
        autoDeferred = autoDeferred + 1
    end
    autoLast = why
    return ok, why
end

function Trial.SetAuto(enabled)
    if enabled ~= true then
        autoEnabled = false
        local ok, why = Trial.Restore("auto-disabled")
        autoLast = ok and "auto-off-stock-restored" or why
        return ok, autoLast
    end
    if autoEnabled then return true, "auto-already-on" end
    if not unlocked() then return false, "combat-arm-deferred" end
    autoEnabled = true
    -- Hook existing ordinary stock frames, including gossip, when available.
    -- Late-loaded frames are hooked only if a real state transition observes
    -- them, never via polling or periodic presentation reassertion.
    for _, candidate in pairs(CANDIDATES) do
        ensureAutoOnShow(candidate)
    end
    local ok, why = Trial.AutoReconcile("explicit-arm")
    return true, ok and "auto-on-centered" or "auto-on-" .. why
end

function Trial.ToggleAuto()
    return Trial.SetAuto(not autoEnabled)
end

-- The state engine publishes actual interaction transitions; no new native
-- transaction hook, timer, frame-loop or camera handler is introduced.
Logres:SubscribeState(function(state)
    if autoEnabled then
        Trial.AutoReconcile("addon-state-transition")
    end
end)

function Trial.GetAudit()
    return { accent = Logres.NPCNativeServiceAccent.GetAudit(),
        active = active and active.key or "none",
        starts = starts, restores = restores, failures = failures,
        autoRestores = autoRestores, pending = restorePending,
        result = lastResult, nativeTransactions = 0,
        styling = "unchanged", scope = "opt-in-gossip-merchant-trainer-only",
        gossipStarts = gossipStarts, gossipRestores = gossipRestores,
        autoEnabled = autoEnabled, autoStarts = autoStarts,
        autoDeferred = autoDeferred, autoLast = autoLast }
end
return Trial
