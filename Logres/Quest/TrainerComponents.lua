-- P0280: one component renderer used by deterministic P fixture and native H trial.
-- All runtime art is Logres-owned; no stock value, input, texture or geometry is edited.
local _, Logres = ...
local Components = {}
Logres.NPCTrainerComponents = Components
local config = Logres.PanelConfigs.trainer.components
local session
local audit = {attempts=0, styled=0, deferred=0, result="not-attempted"}

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

local function read(owner, key)
    local fn = method(owner, key)
    if not fn then return nil, false end
    local ok, value = pcall(fn, owner)
    if not ok or not ordinary(value) then return nil, false end
    return value, true
end

local function supported(owner, fixture)
    if not ordinary(owner) or owner == nil then return false end
    local kind, hasKind = read(owner, "GetObjectType")
    local protected, hasProtection = read(owner, "IsProtected")
    local shown, hasShown = read(owner, "IsShown")
    local width, hasWidth = read(owner, "GetWidth")
    local height, hasHeight = read(owner, "GetHeight")
    return hasKind and (kind == "Frame" or kind == "Button" or kind == "StatusBar")
        and hasProtection and protected == false and (fixture == true or (hasShown and shown == true))
        and hasWidth and hasHeight and type(width) == "number" and type(height) == "number"
        and width > 8 and width < 850 and height > 8 and height < 400
        and method(owner, "CreateTexture") ~= nil
end

local function hidePieces(pieces)
    if not pieces then return end
    for i = 1, #pieces do pcall(function() pieces[i]:Hide() end) end
end

local function painted(target, recipe)
    local create = method(target, "CreateTexture")
    if not create then return nil end
    local pieces = {}
    local ok = pcall(function()
        local fill = create(target, nil, "BACKGROUND", nil, recipe.fillSublevel)
        pieces[#pieces + 1] = fill
        fill:Hide()
        fill:SetTexture(config.solidTexture)
        local c = recipe.fill
        fill:SetVertexColor(c[1], c[2], c[3], c[4])
        fill:SetPoint("TOPLEFT", target, "TOPLEFT", recipe.inset, -recipe.inset)
        fill:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", -recipe.inset, recipe.inset)
        local edge = create(target, nil, "OVERLAY", nil, recipe.ruleSublevel)
        pieces[#pieces + 1] = edge
        edge:Hide()
        edge:SetTexture(config.solidTexture)
        local rule = recipe.rule
        edge:SetVertexColor(rule[1], rule[2], rule[3], rule[4])
        edge:SetHeight(recipe.ruleHeight)
        edge:SetPoint("BOTTOMLEFT", target, "BOTTOMLEFT", recipe.inset, recipe.ruleY)
        edge:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", -recipe.inset, recipe.ruleY)
    end)
    if not ok then hidePieces(pieces); return nil end
    for i = 1, #pieces do
        if not pcall(function() pieces[i]:Show() end) then
            hidePieces(pieces)
            return nil
        end
    end
    return pieces
end

-- Same model shape for both adapters: {elements={{id=<stable mapping>, target=<frame>}}}.
-- Renderer owns decoration only; preview text is synthetic, live text stays native.
function Components.Render(model)
    local result = {parts={}, styled=0, deferred=0}
    if type(model) ~= "table" or type(model.elements) ~= "table" then return nil end
    for i = 1, #model.elements do
        local item = model.elements[i]
        local recipe = config.styles[item.id]
        if not recipe or not supported(item.target, model.fixture == true) then
            result.deferred = result.deferred + 1
        else
            local pieces = painted(item.target, recipe)
            if pieces then
                result.parts[#result.parts + 1] = pieces
                result.styled = result.styled + 1
            else
                result.deferred = result.deferred + 1
            end
        end
    end
    return result
end

local function mappedTarget(id)
    local entry = Logres.ServiceElementIndex.byId[id]
    if not entry or type(entry.nativePath) ~= "string" then return nil end
    local parts = {}
    for part in entry.nativePath:gmatch("[^.]+") do parts[#parts + 1] = part end
    if #parts < 1 or #parts > 4 then return nil end
    local ok, target = pcall(function() return _G[parts[1]] end)
    if not ok or not ordinary(target) or target == nil then return nil end
    for i = 2, #parts do
        if parts[i] == "*" then return nil end
        ok, target = pcall(function() return target[parts[i]] end)
        if not ok or not ordinary(target) or target == nil then return nil end
    end
    return target
end

function Components.Disable()
    if session then
        for i = 1, #session.parts do hidePieces(session.parts[i]) end
        session = nil
    end
    audit.result = "addon-components-hidden"
    return true
end

function Components.Enable(trainer)
    Components.Disable()
    audit.attempts = audit.attempts + 1
    audit.styled, audit.deferred = 0, 0
    local rootProtected, hasRootProtection = read(trainer, "IsProtected")
    local rootShown, hasRootShown = read(trainer, "IsShown")
    if not ordinary(trainer) or not hasRootProtection or rootProtected ~= false
        or not hasRootShown or rootShown ~= true
        or type(InCombatLockdown) ~= "function" then
        audit.result = "trainer-capability-unavailable"
        return false, audit.result
    end
    local ok, locked = pcall(InCombatLockdown)
    if not ok or not ordinary(locked) or locked ~= false then
        audit.result = "combat-deferred"
        return false, audit.result
    end
    local model = {elements={}}
    for i = 1, #config.ids do
        local id = config.ids[i]
        model.elements[i] = {id=id, target=mappedTarget(id)}
    end
    local drawn = Components.Render(model)
    if not drawn then
        audit.result = "render-unavailable"
        return false, audit.result
    end
    session = drawn
    audit.styled, audit.deferred = drawn.styled, drawn.deferred
    audit.result = drawn.styled == #config.ids and "all-mapped-controls-themed"
        or (drawn.styled > 0 and "partial-mapped-controls-themed" or "no-stylable-controls")
    return drawn.styled > 0, audit.result
end

-- Inert fixture controls: no OnClick, native state reads or training action simulation.
-- The identical Render(model) path and recipes paint all four fixture controls.
function Components.Preview(owner)
    local view = {elements={}, fixture=true}
    local created = {}
    local ok = pcall(function()
        for i = 1, #config.ids do
            local id = config.ids[i]
            local spec = config.preview[id]
            local frame = CreateFrame("Frame", nil, owner)
            created[#created + 1] = frame
            frame:EnableMouse(false)
            frame:SetSize(spec.width, spec.height)
            frame:SetPoint("TOP", owner, "TOP", spec.x, spec.y)
            local label = frame:CreateFontString(nil, "OVERLAY", spec.font)
            label:SetPoint("CENTER", frame, "CENTER", 0, 0)
            label:SetText(spec.label)
            local c = spec.textColor
            label:SetTextColor(c[1], c[2], c[3], c[4])
            view.elements[i] = {id=id, target=frame}
        end
    end)
    if not ok then
        for i = 1, #created do pcall(function() created[i]:Hide() end) end
        return false
    end
    local drawn = Components.Render(view)
    if not drawn or drawn.styled ~= #config.ids then
        if drawn then
            for i = 1, #drawn.parts do hidePieces(drawn.parts[i]) end
        end
        for i = 1, #created do pcall(function() created[i]:Hide() end) end
        return false
    end
    return true
end

function Components.GetAudit()
    return {active=session ~= nil, attempts=audit.attempts,
        styled=audit.styled, deferred=audit.deferred, result=audit.result,
        nativeGeometryWrites=0, nativeTransactions=0}
end
return Components
