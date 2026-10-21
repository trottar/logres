-- P0278: addon-owned trainer scroll-surface and row accents.
-- Source technique: ElvUI Forever ScrollBox / ForEachFrame (independent implementation).
-- No Blizzard textures, controls, actions, strata, geometry or transaction state are written.
local _, Logres = ...
local Motif = {}
Logres.NPCTrainerMotif = Motif
local session
local audit = {attempts = 0, rows = 0, result = "not-attempted"}

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function method(owner, name)
    if not ordinary(owner) then return nil end
    local ok, value = pcall(function() return owner[name] end)
    if not ok or not ordinary(value) or type(value) ~= "function" then return nil end
    return value
end

local function unprotected(owner)
    local probe = method(owner, "IsProtected")
    if not probe then return false end
    local ok, protected = pcall(probe, owner)
    return ok and ordinary(protected) and protected == false
end

local function hidePieces(pieces)
    for index = 1, #pieces do
        pcall(function() pieces[index]:Hide() end)
    end
end

-- The same row motif is used by native ScrollBox rows and inert P fixtures.
local function paintRow(owner, recipe)
    local pieces = {}
    local ok = pcall(function()
        local wash = owner:CreateTexture(nil, "BACKGROUND", nil, recipe.rowWashSublevel)
        pieces[#pieces + 1] = wash
        wash:Hide()
        wash:SetTexture(recipe.solidTexture)
        local c = recipe.rowWash
        wash:SetVertexColor(c[1], c[2], c[3], c[4])
        wash:SetPoint("TOPLEFT", owner, "TOPLEFT", recipe.rowInset, -recipe.rowTopInset)
        wash:SetPoint("BOTTOMRIGHT", owner, "BOTTOMRIGHT", -recipe.rowInset, recipe.rowBottomInset)
        local rule = owner:CreateTexture(nil, "BORDER", nil, recipe.rowRuleSublevel)
        pieces[#pieces + 1] = rule
        rule:Hide()
        rule:SetTexture(recipe.solidTexture)
        local gold = recipe.rowRule
        rule:SetVertexColor(gold[1], gold[2], gold[3], gold[4])
        rule:SetHeight(recipe.rowRuleHeight)
        rule:SetPoint("BOTTOMLEFT", owner, "BOTTOMLEFT", recipe.rowInset, recipe.rowRuleY)
        rule:SetPoint("BOTTOMRIGHT", owner, "BOTTOMRIGHT", -recipe.rowInset, recipe.rowRuleY)
    end)
    if not ok then hidePieces(pieces); return nil end
    for i = 1, #pieces do pieces[i]:Show() end
    return pieces
end

-- Reuses the exact proven motif painter, but ONLY for an addon-owned fixture row.
function Motif.PaintFixtureRow(owner)
    return paintRow(owner, Logres.PanelConfigs.trainer.motif)
end

local function paintScroll(scroll, recipe)
    local pieces = {}
    local ok = pcall(function()
        local parchment = scroll:CreateTexture(nil, "ARTWORK", nil, recipe.scrollSublevel)
        pieces[#pieces + 1] = parchment
        parchment:Hide()
        parchment:SetTexture(recipe.panelTexture)
        parchment:SetAlpha(recipe.scrollAlpha)
        parchment:SetPoint("TOPLEFT", scroll, "TOPLEFT", recipe.scrollInset, -recipe.scrollTopInset)
        parchment:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", -recipe.scrollInset, recipe.scrollBottomInset)
        local border = scroll:CreateTexture(nil, "ARTWORK", nil, recipe.scrollRuleSublevel)
        pieces[#pieces + 1] = border
        border:Hide()
        border:SetTexture(recipe.solidTexture)
        local c = recipe.scrollRule
        border:SetVertexColor(c[1], c[2], c[3], c[4])
        border:SetHeight(recipe.scrollRuleHeight)
        border:SetPoint("TOPLEFT", scroll, "TOPLEFT", recipe.scrollInset, -recipe.scrollTopInset)
        border:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", -recipe.scrollInset, -recipe.scrollTopInset)
    end)
    if not ok then hidePieces(pieces); return nil end
    for i = 1, #pieces do pieces[i]:Show() end
    return pieces
end

function Motif.Disable()
    if not session then return true end
    for _, pieces in pairs(session.rows) do hidePieces(pieces) end
    hidePieces(session.surface)
    session = nil
    audit.result = "addon-art-hidden"
    return true
end

function Motif.Enable(trainer)
    Motif.Disable()
    audit.attempts = audit.attempts + 1
    audit.rows = 0
    local recipe = Logres.PanelConfigs.trainer.motif
    if not recipe or not unprotected(trainer) then
        audit.result = "native-trainer-unavailable"
        return false, audit.result
    end
    local okScroll, scroll = pcall(function() return trainer.ScrollBox end)
    if not okScroll or not ordinary(scroll) or scroll == nil or not unprotected(scroll) then
        audit.result = "forever-scrollbox-unavailable"
        return false, audit.result
    end
    -- ElvUI uses ScrollBox:ForEachFrame on Forever; this method may differ
    -- in another client. Unavailable means DEFER/stock, not guessed rows.
    local forEach = method(scroll, "ForEachFrame")
    if not forEach then
        audit.result = "scrollbox-row-iterator-unavailable"
        return false, audit.result
    end
    local surface = paintScroll(scroll, recipe)
    if not surface then
        audit.result = "scrollbox-surface-paint-failed"
        return false, audit.result
    end
    local trial = {surface = surface, rows = {}}
    local found = 0
    local rowsOK = pcall(forEach, scroll, function(row)
        if not ordinary(row) or row == nil or not unprotected(row) then return end
        if trial.rows[row] then return end
        local pieces = paintRow(row, recipe)
        if pieces then trial.rows[row] = pieces; found = found + 1 end
    end)
    if not rowsOK or found < 1 then
        for _, pieces in pairs(trial.rows) do hidePieces(pieces) end
        hidePieces(surface)
        audit.result = rowsOK and "no-stylable-scrollbox-rows" or "scrollbox-iterator-rejected"
        return false, audit.result
    end
    session = trial
    audit.rows = found
    audit.result = "scrollbox-and-rows-themed"
    return true, audit.result
end

-- Visual fixture: inert frames, no trainer actions, same row painter as live.
function Motif.Preview(owner)
    local recipe = Logres.PanelConfigs.trainer.motif
    local preview = recipe.preview
    local pieces = {}
    local ok = pcall(function()
        for index = 1, #preview.rows do
            local sampleFrame = CreateFrame("Frame", nil, owner)
            sampleFrame:EnableMouse(false)
            sampleFrame:SetSize(preview.width, preview.height)
            sampleFrame:SetPoint("TOP", owner, "TOP", preview.x, preview.rows[index])
            local sample = paintRow(sampleFrame, recipe)
            if not sample then error("preview-row-paint-failed") end
            for i = 1, #sample do pieces[#pieces + 1] = sample[i] end
        end
    end)
    if not ok then hidePieces(pieces); return false end
    return true
end

function Motif.GetAudit()
    return {active = session ~= nil, rows = audit.rows,
        attempts = audit.attempts, result = audit.result,
        nativeMutations = 0, transactions = 0}
end
return Motif
