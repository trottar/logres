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
    self.liveReadOnly = false
    self.model, self.nodeKey = nil, nil
    self.mode, self.optionPage = nil, 1
    self.history = {}
    self.lastResult = "inactive"
    self.visual:Clear()
end

function Session:Gate()
    local d = self.dialogue
    return self.active and d.moduleEnabled and d.immersionEnabled
        and d.presentationShown
        and ((self.liveReadOnly and d.lastPresentationReason == "npc-options-read-only")
            or (not self.liveReadOnly and d.offerActionPreview
                and d.lastPresentationReason == "npc-options-preview"))
        and not d.completionActive
end

function Session:Render()
    local node = self.model and self.model.nodes[self.nodeKey]
    if not node then self.lastResult = "missing-node"; return false end
    local d = self.dialogue
    local presentationReason = self.liveReadOnly
        and "npc-options-read-only" or "npc-options-preview"
    local ok, state = d:PresentText(
        node.title or self.model.title, node.body or "", "",
        presentationReason, false, false, not self.liveReadOnly)
    if not ok or state ~= "shown" then return false end
    d.root:SetHeight(467)
    local choices = node.options or {}
    if #choices == 0 then
        -- A text-only/quest-only gossip stage needs only narrative art.
        -- No empty options grid or invented clickable quest control.
        self.visual:Clear()
    else
        self.visual:Present(choices, self.optionPage, #self.history > 0, {
            choose = function(index) self:Choose(index) end,
            back = function() return self:Back() end,
            page = function(delta) return self:MovePage(delta) end,
        }, self.liveReadOnly)
        if self.liveReadOnly then
            self.visual:SetLiveSelectable(Logres.NPCGossipChoice.CanSelect())
            self.visual:SetQuestSelectable(
                Logres.NPCGossipQuestChoice.CanSelect("available"),
                Logres.NPCGossipQuestChoice.CanSelect("active"))
        end
    end
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

-- P0317: same view as P previews, but live source rows cannot be clicked.
function Session:StartReadOnly(model)
    if not model or model.previewOnly ~= false or not model.nodes
        or not model.nodes[model.start] then return false, "invalid-live-gossip-model" end
    local node = model.nodes[model.start]
    if type(node.options) ~= "table" then
        return false, "live-gossip-options-invalid"
    end
    -- No choices is valid when this NPC has actual, validated narrative text.
    if #node.options == 0 and (type(node.body) ~= "string" or node.body == "") then
        return false, "empty-live-gossip-stage"
    end
    for index = 1, #node.options do
        local option = node.options[index]
        if type(option) ~= "table" or option.enabled ~= false then
            return false, "live-option-not-inert"
        end
    end
    self:Reset()
    self.model = model
    self.mode = "live-read-only"
    self.nodeKey = model.start
    self.liveReadOnly = true
    self.active = true
    if not self:Render() then self:Reset(); return false, "render-failed" end
    return true, "shown"
end

function Session:Choose(index)
    -- Live gameplay dispatch belongs to a separate, source-revalidating
    -- controller; previews retain their original inert native boundary.
    if self.liveReadOnly then
        if not self:Gate() then
            self.blocked = self.blocked + 1
            return false, "inactive-live-option"
        end
        local node = self.model.nodes[self.nodeKey]
        local option = node and node.options and node.options[index]
        local ok, reason
        if type(option) == "table" and option.questKind then
            ok, reason = Logres.NPCGossipQuestChoice.Activate(self.model, index)
        else
            ok, reason = Logres.NPCGossipChoice.Activate(self.model, index)
        end
        if ok then
            self.clicks = self.clicks + 1
        else
            self.blocked = self.blocked + 1
        end
        self.lastResult = reason
        return ok, reason
    end
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
    local ok = self:Render()
    if not ok then return false, "render-failed" end
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
    return { active = self.active, mode = self.mode, liveReadOnly = self.liveReadOnly,
        node = self.nodeKey, optionPage = self.optionPage,
        depth = #self.history, clicks = self.clicks, branches = self.branches,
        backs = self.backCount, rootReturns = self.rootReturns,
        goodbyes = self.goodbyes, backVisible = self.visual.back:IsShown(),
        pageMoves = self.pageMoves,
        blocked = self.blocked, lastResult = self.lastResult,
        nativeActions = 0 }
end
return Session
