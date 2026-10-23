-- P0265: source-independent visual option list shared by future NPC models.
-- The view sends only authored ordinals to a separately gated controller.
local _, Logres = ...
local Visual = {}
Logres.NPCOptionList = Visual
local GOLD = "Interface\\Buttons\\WHITE8x8"
local PAGE_SIZE = 6
local ROW_TOP = 233
local ROW_PITCH = 43
local SLOT_HEIGHT = 34
local PAGER_TOP = 391
local NAV_TOP = 423
local PANEL_HEIGHT = 467
-- Last row ends at 353; pager at 391; nav ends at 451.
assert(ROW_TOP + 2 * ROW_PITCH + SLOT_HEIGHT + 24 <= PAGER_TOP)
assert(PAGER_TOP + 24 <= NAV_TOP)
assert(NAV_TOP + 28 + 12 <= PANEL_HEIGHT)

function Visual.New(root)
    local self = setmetatable({ root = root, slots = {}, currentOptions = {},
        page = 1, active = false }, { __index = Visual })
    local frame = CreateFrame("Frame", nil, root)
    frame:SetAllPoints(root)
    frame:EnableMouse(false)
    frame:Hide()
    self.frame = frame
    for i = 1, PAGE_SIZE do
        local slot = CreateFrame("Button", nil, frame)
        slot:SetSize(266, 34)
        slot:SetPoint("TOPLEFT", frame, "TOPLEFT",
            46 + ((i - 1) % 2) * 278, -ROW_TOP - math.floor((i - 1) / 2) * ROW_PITCH)
        slot:RegisterForClicks("LeftButtonUp")
        local wash = slot:CreateTexture(nil, "BACKGROUND")
        wash:SetAllPoints(slot)
        wash:SetTexture(GOLD)
        local line = slot:CreateTexture(nil, "BORDER")
        line:SetTexture(GOLD)
        line:SetHeight(1)
        line:SetPoint("BOTTOMLEFT", slot, "BOTTOMLEFT", 0, 0)
        line:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 0, 0)
        local label = slot:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetPoint("LEFT", slot, "LEFT", 10, 0)
        label:SetSize(246, 28)
        label:SetJustifyH("LEFT")
        label:SetWordWrap(true)
        slot.label, slot.wash, slot.line = label, wash, line
        slot:SetScript("OnEnter", function(button)
            if button.optionEnabled then
                button.wash:SetVertexColor(0.26, 0.19, 0.09, 0.93)
            end
        end)
        slot:SetScript("OnLeave", function(button)
            self:Paint(button)
        end)
        slot:SetScript("OnClick", function(button)
            if self.active and button.optionEnabled and self.onChoose then
                self.onChoose(button.optionIndex)
            end
        end)
        slot:Hide()
        self.slots[i] = slot
    end
    local function navigation(label, x, callback)
        local button = CreateFrame("Button", nil, frame)
        button:SetSize(125, 28)
        button:SetPoint("TOP", frame, "TOP", x, -NAV_TOP)
        button:RegisterForClicks("LeftButtonUp")
        local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetAllPoints(button)
        text:SetText(label)
        text:SetTextColor(0.96, 0.78, 0.43, 1)
        button.label = text
        button:SetScript("OnClick", function()
            if self.active and callback() then return end
        end)
        button:Hide()
        return button
    end
    self.previous = navigation("< Previous", -170, function()
        return self.onPage and self.onPage(-1)
    end)
    self.next = navigation("Next >", 170, function()
        return self.onPage and self.onPage(1)
    end)
    self.back = navigation("< Back", 0, function()
        return self.onBack and self.onBack()
    end)
    -- Back and Goodbye share a stable 24-high header rail on opposite sides.
    -- The narrative paginator and option paging controls remain at the bottom.
    -- Do not anchor Back to NAV_TOP: that overlaps the narrative 1 / N rail.
    self.back:ClearAllPoints()
    self.back:SetSize(78, 24)
    self.back:SetPoint("TOPLEFT", frame, "TOPLEFT", 45, -12)
    local backRule = self.back:CreateTexture(nil, "ARTWORK")
    backRule:SetTexture(GOLD)
    backRule:SetHeight(1)
    backRule:SetPoint("BOTTOMLEFT", self.back, "BOTTOMLEFT", 5, 0)
    backRule:SetPoint("BOTTOMRIGHT", self.back, "BOTTOMRIGHT", -5, 0)
    backRule:SetVertexColor(0.77, 0.60, 0.32, 0.72)
    self.back:SetScript("OnEnter", function()
        self.back.label:SetTextColor(1.00, 0.87, 0.56, 1)
    end)
    self.back:SetScript("OnLeave", function()
        self.back.label:SetTextColor(0.96, 0.78, 0.43, 1)
    end)
    local pager = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    pager:SetPoint("TOP", frame, "TOP", 0, -PAGER_TOP)
    pager:SetTextColor(0.72, 0.61, 0.42, 1)
    pager:Hide()
    self.pager = pager
    return self
end

function Visual:Paint(button)
    if button.optionEnabled or self.displayOnly then
        button.wash:SetVertexColor(0.12, 0.10, 0.075, 0.80)
        button.line:SetVertexColor(0.77, 0.60, 0.32, 0.75)
        button.label:SetTextColor(0.94, 0.82, 0.60, 1)
    else
        button.wash:SetVertexColor(0.09, 0.09, 0.09, 0.65)
        button.line:SetVertexColor(0.28, 0.26, 0.23, 0.6)
        button.label:SetTextColor(0.57, 0.54, 0.49, 1)
    end
end

function Visual:Clear()
    self.active = false
    self.onChoose, self.onBack, self.onPage = nil, nil, nil
    self.canBack, self.totalPages = false, 1
    self.currentOptions = {}
    for i = 1, PAGE_SIZE do
        self.slots[i].optionEnabled = false
        self.slots[i].optionVisible = false
        self.slots[i]:EnableMouse(false)
        self.slots[i]:Hide()
    end
    self.previous:Hide()
    self.next:Hide()
    self.back:Hide()
    self.pager:Hide()
    self.frame:Hide()
end

function Visual:Present(options, page, canBack, callbacks, displayOnly)
    self:Clear()
    self.active = true
    self.currentOptions = options
    self.displayOnly = displayOnly == true
    self.page = page
    self.canBack = canBack == true
    self.onChoose, self.onBack, self.onPage = callbacks.choose, callbacks.back, callbacks.page
    local total = math.max(1, math.ceil(#options / PAGE_SIZE))
    self.totalPages = total
    if page < 1 or page > total then self:Clear(); return false end
    local offset = (page - 1) * PAGE_SIZE
    for i = 1, PAGE_SIZE do
        local option = options[offset + i]
        local slot = self.slots[i]
        slot.optionVisible = option ~= nil
        if option then
            slot.optionIndex = offset + i
            slot.optionEnabled = option.enabled ~= false
            local label = option.label
            if not slot.optionEnabled and not self.displayOnly then
                label = label .. " [LOCKED]\n" .. (option.reason or "Unavailable")
            end
            slot.label:SetText(label)
            slot:EnableMouse(slot.optionEnabled)
            self:Paint(slot)
            slot:Show()
        end
    end
    if total > 1 then
        self.pager:SetFormattedText("Options %d / %d", page, total)
        self.pager:Show()
        if page > 1 then self.previous:Show() end
        if page < total then self.next:Show() end
    end
    if canBack then self.back:Show() end
    self.frame:Show()
    return true
end

-- P0318: live-native clickability is separate from authored preview enabled.
-- The view never selects gameplay actions itself; the session delegates.
function Visual:SetLiveSelectable(enabled)
    self.liveSelectable = enabled == true and self.displayOnly == true
    for i = 1, PAGE_SIZE do
        local slot = self.slots[i]
        local option = self.currentOptions[slot.optionIndex]
        slot.optionEnabled = self.liveSelectable and slot.optionVisible == true
            and type(option) == "table" and option.gossipStatus == 0
        slot:EnableMouse(slot.optionEnabled)
        if slot.optionVisible then self:Paint(slot) end
    end
end

-- Quest links use a separately gated native selector; they are never
-- enabled merely because a gossip option or preview row is clickable.
function Visual:SetQuestSelectable(available, active)
    self.questAvailable = available == true and self.displayOnly == true
    self.questActive = active == true and self.displayOnly == true
    for i = 1, PAGE_SIZE do
        local slot = self.slots[i]
        local option = self.currentOptions[slot.optionIndex]
        if slot.optionVisible and type(option) == "table" and option.questKind then
            slot.optionEnabled = (option.questKind == "available" and self.questAvailable)
                or (option.questKind == "active" and self.questActive)
            slot:EnableMouse(slot.optionEnabled)
            self:Paint(slot)
        end
    end
end

function Visual:SetPageVisible(show)
    if not self.active then return end
    local showChoices = show == true
    for i = 1, PAGE_SIZE do
        local slot = self.slots[i]
        local visible = showChoices and slot.optionVisible == true
        slot:SetShown(visible)
        slot:EnableMouse(visible and slot.optionEnabled == true)
    end
    self.pager:SetShown(showChoices and self.totalPages > 1)
    self.previous:SetShown(showChoices and self.page > 1)
    self.next:SetShown(showChoices and self.page < self.totalPages)
    -- Back is a navigation escape, not an NPC option. It stays visible
    -- during long narratives; the option list itself waits for final page.
    self.back:SetShown(self.canBack == true)
    self.frame:Show()
end
return Visual
