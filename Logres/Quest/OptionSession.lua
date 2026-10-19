-- P0265: preview-only branching option session/controller.
-- Every click is an authored fixture ordinal; no native gossip/quest actions.
local _, Logres = ...
local Session = {}
Logres.NPCOptionSession = Session

function Session.New(dialogue, visual)
    return setmetatable({ dialogue = dialogue, visual = visual,
        active = false, mode = nil, nodeKey = nil, optionPage = 1,
        history = {}, clicks = 0, branches = 0, backCount = 0,
        rootReturns = 0, goodbyes = 0,
        pageMoves = 0, blocked = 0, lastResult = "inactive" },
        { __index = Session })
end

function Session:Reset()
    self.active = false
    self.model, self.nodeKey = nil, nil
    self.mode, self.optionPage = nil, 1
    self.history = {}
    self.lastResult = "inactive"
    self.visual:Clear()
end

function Session:Gate()
    local d = self.dialogue
    return self.active and d.moduleEnabled and d.immersionEnabled
        and d.presentationShown and d.offerActionPreview
        and d.lastPresentationReason == "npc-options-preview"
        and not d.completionActive
end

function Session:Render()
    local node = self.model and self.model.nodes[self.nodeKey]
    if not node then self.lastResult = "missing-node"; return false end
    local d = self.dialogue
    local ok, state = d:PresentText(
        node.title or self.model.title, node.body or "", "",
        "npc-options-preview", false, false, true)
    if not ok or state ~= "shown" then return false end
    d.root:SetHeight(467)
    local choices = node.options or {}
    self.visual:Present(choices, self.optionPage, #self.history > 0, {
        choose = function(index) self:Choose(index) end,
        back = function() return self:Back() end,
        page = function(delta) return self:MovePage(delta) end,
    })
    d:UpdatePageControls()
    self:OnNarrativePageChanged()
    self.lastResult = "shown"
    return true
end

function Session:Start(mode, model)
    if not model or model.previewOnly ~= true or not model.nodes
        or not model.nodes[model.start] then return false, "invalid-option-model" end
    self:Reset()
    self.model = model
    self.mode = mode
    self.nodeKey = model.start
    self.active = true
    if not self:Render() then self:Reset(); return false, "render-failed" end
    return true, "shown"
end

function Session:Choose(index)
    if not self:Gate() then
        self.blocked = self.blocked + 1
        return false, "inactive-option-preview"
    end
    local node = self.model.nodes[self.nodeKey]
    local choice = node and node.options and node.options[index]
    if type(index) ~= "number" or index ~= math.floor(index)
        or not choice or choice.enabled == false
    then
        self.blocked = self.blocked + 1
        self.lastResult = "blocked-choice"
        return false, "blocked-choice"
    end
    -- Authored farewell is one action: invoke the SAME safe universal exit,
    -- not an empty intermediary narrative requiring a second Goodbye click.
    if choice.action == "goodbye" then
        self.clicks = self.clicks + 1
        return self.dialogue:Goodbye()
    end
    if type(choice.nextNode) ~= "string"
        or not self.model.nodes[choice.nextNode]
    then
        self.blocked = self.blocked + 1
        self.lastResult = "blocked-choice"
        return false, "blocked-choice"
    end
    if #self.history >= 12 then return false, "history-limit" end
    self.clicks = self.clicks + 1
    self.branches = self.branches + 1
    self.history[#self.history + 1] = { node = self.nodeKey, page = self.optionPage }
    self.nodeKey = choice.nextNode
    self.optionPage = 1
    self:Render()
    return true, "branch-shown"
end

function Session:Back()
    if not self:Gate() or #self.history == 0 then return false end
    local parent = table.remove(self.history)
    local previousNode, previousPage = self.nodeKey, self.optionPage
    self.nodeKey, self.optionPage = parent.node, parent.page
    local ok = self:Render()
    if not ok then
        self.nodeKey, self.optionPage = previousNode, previousPage
        self.history[#self.history + 1] = parent
        self.lastResult = "back-render-failed"
        return false
    end
    self.backCount = self.backCount + 1
    if self.nodeKey == self.model.start then
        self.rootReturns = self.rootReturns + 1
    end
    self.lastResult = self.nodeKey == self.model.start and "root-restored" or "back-shown"
    return true
end

function Session:Goodbye()
    if not self:Gate() then
        self.blocked = self.blocked + 1
        return false, "inactive-option-preview"
    end
    self.goodbyes = self.goodbyes + 1
    -- Dialogue:HidePresentation restores native quest/offer ownership first.
    self.dialogue:HidePresentation("goodbye")
    self.lastResult = "goodbye"
    return true, "closed"
end

function Session:MovePage(delta)
    if not self:Gate() or (delta ~= 1 and delta ~= -1) then return false end
    local node = self.model.nodes[self.nodeKey]
    local total = math.max(1, math.ceil(#(node.options or {}) / 6))
    local target = self.optionPage + delta
    if target < 1 or target > total then return false end
    self.optionPage = target
    self.pageMoves = self.pageMoves + 1
    self:Render()
    return true
end

function Session:OnNarrativePageChanged()
    if not self.active then return end
    local d = self.dialogue
    self.visual:SetPageVisible(d.currentPage == #d.pages)
end

function Session:Debug()
    return { active = self.active, mode = self.mode,
        node = self.nodeKey, optionPage = self.optionPage,
        depth = #self.history, clicks = self.clicks, branches = self.branches,
        backs = self.backCount, rootReturns = self.rootReturns,
        goodbyes = self.goodbyes, backVisible = self.visual.back:IsShown(),
        pageMoves = self.pageMoves,
        blocked = self.blocked, lastResult = self.lastResult,
        nativeActions = 0 }
end
return Session
