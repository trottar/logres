local _, Logres = ...

-- P0206 R3: P0206 R2 native PetActionBar reparenting was observed to break
-- Immersion OFF stock restoration and coincide with a protected-action error.
-- Retain the developer-panel controls and status, but quarantine the unsafe
-- trial. No stock PetActionBar parent, shown state or presentation is read or
-- mutated here. A future supported ownership mechanism requires new evidence.
local Candidate = Logres:RegisterModule("PetCombatCandidate", {autoEnable = true})

function Candidate:Request(enabled)
    if enabled == true then
        self.rejections = self.rejections + 1
        self.lastReason = "BLOCKED-p0206-r2-protected-and-restore-failure"
        return false, self.lastReason
    end
    self.lastReason = "quarantined-off-no-native-mutation"
    return true, self.lastReason
end

function Candidate:GetDebugStatus()
    return {
        requested = false,
        armed = false,
        pending = false,
        activations = 0,
        restores = 0,
        failures = 0,
        rejections = self.rejections,
        lastReason = self.lastReason,
        lastError = nil,
        lastEvent = self.lastEvent,
    }
end

function Candidate:OnInitialize()
    self.rejections = 0
    self.lastReason = "quarantined-default-off"
    self.lastEvent = "initialize"
end

function Candidate:OnEnable()
    self.lastEvent = "module-enable"
end
