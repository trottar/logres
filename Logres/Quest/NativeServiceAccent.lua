-- P0276: retired P0274/P0275 additive native-service art.
-- Archival evidence remains in docs/memory/evidence; the 640x540 shell
-- failed visual acceptance. Preserve this API for existing safe placement
-- restoration/audit callers, but do not create any UI or modify native frames.
local _, Logres = ...
local Accent = {}
Logres.NPCNativeServiceAccent = Accent

function Accent.Hide()
    return true
end

function Accent.Show(frame, key)
    -- Intentionally no-op. Do not reintroduce a decorative wrapper.
    return false, "retired-p0276-native-reskin-pending"
end

function Accent.GetAudit()
    return { mode = "retired", shows = 0, hides = 0, failures = 0,
        lastResult = "P0274-P0275-visual-rejected", nativeMutations = 0,
        ownership = "none", mouse = false }
end
return Accent
