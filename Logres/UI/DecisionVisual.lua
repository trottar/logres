-- P0263 N3: reusable Logres decision BUTTON VISUALS only.
-- No quest source reads, native UI mutation, interaction actions or camera hooks.
local _, Logres = ...
local Visual = {}
Logres.NPCDecisionVisual = Visual

local function setOfferVisual(button, color)
    button.label:SetTextColor(
        color[1],
        color[2],
        color[3],
        color[4]
    )
    button.rule:SetVertexColor(
        color[1],
        color[2],
        color[3],
        color[4]
    )
end

-- Caller owns click routing, view owns only the button and cosmetic feedback.
function Visual.CreateButton(parent, kind, label, styleValue, colorValue, assets)
    local button = CreateFrame(
        "Button",
        nil,
        parent
    )
    button:SetSize(
        styleValue("buttonWidth"),
        styleValue("buttonHeight")
    )
    button:EnableMouse(true)
    button:RegisterForClicks("LeftButtonUp")

    local text = button:CreateFontString(
        nil,
        "OVERLAY",
        styleValue("font")
    )
    text:SetPoint("CENTER", button, "CENTER", 0, 3)
    text:SetText(label)
    text:SetJustifyH("CENTER")
    text:SetShadowColor(0, 0, 0, 0.90)
    text:SetShadowOffset(1, -1)

    local rule = button:CreateTexture(
        nil,
        "ARTWORK"
    )
    rule:SetTexture(
        assets.rule
        or "Interface\\Buttons\\WHITE8x8"
    )
    rule:SetSize(
        styleValue("buttonWidth"),
        12
    )
    rule:SetPoint(
        "TOP",
        text,
        "BOTTOM",
        0,
        -2
    )

    button.label = text
    button.rule = rule
    button.kind = kind

    local normalColor =
        (kind == "accept" or kind == "complete")
        and colorValue("accept")
        or colorValue("decline")

    setOfferVisual(button, normalColor)

    button:SetScript("OnEnter", function()
        setOfferVisual(
            button,
            colorValue("hover")
        )
    end)

    button:SetScript("OnLeave", function()
        setOfferVisual(
            button,
            normalColor
        )
    end)

    button:SetScript("OnMouseDown", function()
        setOfferVisual(
            button,
            colorValue("pressed")
        )
    end)

    button:SetScript("OnMouseUp", function()
        setOfferVisual(
            button,
            colorValue("hover")
        )
    end)

    return button
end

return Visual
