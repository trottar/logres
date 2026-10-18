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
    local self = { root = root, objectiveText = objectiveText, slots = {} }
    for i = 1, MAX_CARDS do
        local slot = CreateFrame("Frame", nil, root)
        slot:SetSize(SLOT_WIDTH, SLOT_HEIGHT)
        slot:SetPoint(
            "TOPLEFT", root, "TOPLEFT",
            46 + ((i - 1) % 2) * 274,
            -235 - math.floor((i - 1) / 2) * SLOT_PITCH
        )
        slot:EnableMouse(false)
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
        slot.icon = icon
        slot.iconBorder = iconBorder
        slot.label = label
        slot.count = count
        slot:Hide()
        self.slots[i] = slot
    end
    return self
end

function Visual:Reset()
    for i = 1, MAX_CARDS do
        self.slots[i]:Hide()
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
    for i = 1, n do
        local card = cards[i]
        local slot = self.slots[i]
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
