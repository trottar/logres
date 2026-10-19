-- P0248: purely additive, non-interactive Logres quest reward presentation.
-- Reward identity and texture are supplied by QuestDialogue's guarded source.
local _, Logres = ...
local Visual = {}
Logres.QuestRewardVisual = Visual

local MAX_CARDS = 6
local SLOT_WIDTH = 256
local SLOT_HEIGHT = 34
local SLOT_PITCH = 42
local BASE_HEIGHT = 320
local GOLD = { 0.77, 0.60, 0.32, 0.95 }
local WHITE = "Interface\\Buttons\\WHITE8x8"

function Visual.New(root, objectiveText)
    local self = setmetatable(
        { root = root, objectiveText = objectiveText, slots = {} },
        { __index = Visual }
    )
    for i = 1, MAX_CARDS do
        local slot = CreateFrame("Button", nil, root)
        slot:SetSize(SLOT_WIDTH, SLOT_HEIGHT)
        slot:SetPoint(
            "TOPLEFT", root, "TOPLEFT",
            46 + ((i - 1) % 2) * 274,
            -235 - math.floor((i - 1) / 2) * SLOT_PITCH
        )
        -- Live rewards are passive. Only synthetic preview choices gain clicks.
        slot:EnableMouse(false)
        slot:RegisterForClicks("LeftButtonUp")
        local wash = slot:CreateTexture(nil, "BACKGROUND")
        wash:SetAllPoints(slot)
        wash:SetTexture(WHITE)
        wash:SetVertexColor(0.12, 0.10, 0.075, 0.72)
        local rule = slot:CreateTexture(nil, "BORDER")
        rule:SetTexture(WHITE)
        rule:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.32)
        rule:SetHeight(1)
        rule:SetPoint("BOTTOMLEFT", slot, "BOTTOMLEFT", 0, 0)
        rule:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 0, 0)
        local iconBorder = slot:CreateTexture(nil, "ARTWORK")
        iconBorder:SetTexture(WHITE)
        iconBorder:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.80)
        iconBorder:SetSize(32, 32)
        iconBorder:SetPoint("LEFT", slot, "LEFT", 1, 0)
        local icon = slot:CreateTexture(nil, "OVERLAY")
        icon:SetSize(28, 28)
        icon:SetPoint("CENTER", iconBorder, "CENTER", 0, 0)
        local label = slot:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetPoint("LEFT", slot, "LEFT", 41, 0)
        label:SetSize(174, 28)
        label:SetJustifyH("LEFT")
        label:SetJustifyV("MIDDLE")
        label:SetWordWrap(false)
        label:SetTextColor(0.90, 0.83, 0.67, 1)
        local count = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        count:SetPoint("RIGHT", slot, "RIGHT", -7, 0)
        count:SetSize(31, 25)
        count:SetJustifyH("RIGHT")
        count:SetTextColor(0.95, 0.75, 0.40, 1)
        slot.wash = wash
        slot.rule = rule
        slot:SetScript("OnEnter", function(button)
            if self.previewChoiceHandler and button.choiceIndex then
                button.wash:SetVertexColor(0.28, 0.21, 0.11, 0.90)
            end
        end)
        slot:SetScript("OnLeave", function()
            self:PaintPreviewChoices()
        end)
        slot:SetScript("OnClick", function(button)
            -- The view emits only an authored preview ordinal; it NEVER
            -- selects/claims an actual quest reward.
            if self.previewChoiceHandler and button.choiceIndex then
                self.previewChoiceHandler(button.choiceIndex)
            end
        end)
        slot.icon = icon
        slot.iconBorder = iconBorder
        slot.label = label
        slot.count = count
        slot:Hide()
        self.slots[i] = slot
    end
    return self
end

-- Cosmetic selection belongs to this shared reward renderer; the owning
-- quest controller decides whether preview interaction is permissible.
function Visual:PaintPreviewChoices()
    for i = 1, MAX_CARDS do
        local slot = self.slots[i]
        local interactive = self.previewChoiceHandler ~= nil
            and slot.choiceIndex ~= nil and slot:IsShown()
        slot:EnableMouse(interactive)
        local selected = interactive
            and slot.choiceIndex == self.previewSelectedChoice
        if selected then
            slot.wash:SetVertexColor(0.34, 0.23, 0.08, 0.96)
            slot.rule:SetVertexColor(1.00, 0.83, 0.42, 1.00)
            slot.label:SetText("SELECTED  " .. slot.choiceName)
            slot.label:SetTextColor(1.00, 0.86, 0.48, 1.00)
        else
            slot.wash:SetVertexColor(0.12, 0.10, 0.075, 0.72)
            slot.rule:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.32)
            if slot.choiceIndex then
                slot.label:SetText("CHOICE  " .. slot.choiceName)
            end
            slot.label:SetTextColor(0.90, 0.83, 0.67, 1)
        end
    end
end

function Visual:SetPreviewChoiceHandler(handler)
    if type(handler) ~= "function" then return false end
    self.previewChoiceHandler = handler
    self.previewSelectedChoice = nil
    self:PaintPreviewChoices()
    return true
end

function Visual:SelectPreviewChoice(index)
    if not self.previewChoiceHandler
        or type(index) ~= "number" or index < 1
        or index > (self.choiceCount or 0)
        or index ~= math.floor(index)
    then return false, "preview-choice-unavailable" end
    self.previewSelectedChoice = index
    self:PaintPreviewChoices()
    return true, "preview-choice-selected"
end

function Visual:Reset()
    self.previewChoiceHandler = nil
    self.previewSelectedChoice = nil
    self.choiceCount = 0
    for i = 1, MAX_CARDS do
        self.slots[i]:Hide()
        self.slots[i]:EnableMouse(false)
        self.slots[i].choiceIndex = nil
        self.slots[i].choiceName = nil
        self.slots[i].icon:SetTexture(nil)
    end
    self.root:SetHeight(BASE_HEIGHT)
    self.objectiveText:ClearAllPoints()
    self.objectiveText:SetPoint("TOP", self.root, "TOP", 0, -233)
end

function Visual:Present(cards, footer)
    self:Reset()
    local n = math.min(#cards, MAX_CARDS)
    if n == 0 then return false end
    local choiceIndex = 0
    for i = 1, n do
        local card = cards[i]
        local slot = self.slots[i]
        if card.kind == "choice" then
            choiceIndex = choiceIndex + 1
            slot.choiceIndex = choiceIndex
            slot.choiceName = card.name
        end
        slot.label:SetText((card.kind == "choice" and "CHOICE  " or "") .. card.name)
        slot.count:SetText(card.quantity > 1 and ("x" .. tostring(card.quantity)) or "")
        if card.icon then
            slot.icon:SetTexture(card.icon)
            slot.icon:Show()
            slot.iconBorder:Show()
        else
            slot.icon:Hide()
            slot.iconBorder:Hide()
        end
        slot:Show()
    end
    self.choiceCount = choiceIndex
    local rows = math.ceil(n / 2)
    -- Reserve room below the unchanged narrative body; no floating stock overlay.
    self.root:SetHeight(349 + rows * SLOT_PITCH)
    self.objectiveText:ClearAllPoints()
    self.objectiveText:SetPoint(
        "TOP", self.root, "TOP", 0, -247 - rows * SLOT_PITCH
    )
    self.objectiveText:SetText(footer)
    return true
end
