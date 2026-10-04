local _, Logres = ...

local ContextVisual = {}
Logres.ContextVisual = ContextVisual

local style =
    (Logres.Theme and Logres.Theme.contextMessage) or {}
local variants = style.variants or {}
local colors = style.colors or {}
local assets = style.assets or {}

local DEFAULT_VARIANTS = {
    xp = {
        width = 360,
        height = 38,
        textWidth = 330,
        lineWidth = 138,
        lineHeight = 8,
        lineOffset = 7,
        diamondSize = 10,
        glowSize = 34,
        font = "GameFontNormalLarge",
    },
    objective = {
        width = 520,
        height = 54,
        textWidth = 500,
        lineWidth = 205,
        lineHeight = 8,
        lineOffset = 7,
        diamondSize = 10,
        glowSize = 38,
        font = "GameFontHighlight",
    },
}

local DEFAULT_NORMAL = {
    text = { 0.88, 0.78, 0.54, 0.96 },
    line = { 0.58, 0.42, 0.22, 0.78 },
    diamond = { 0.82, 0.58, 0.20, 0.96 },
    glow = { 0.84, 0.55, 0.14, 0.24 },
}

local DEFAULT_COMPLETE = {
    text = { 1.00, 0.86, 0.48, 1.00 },
    line = { 0.84, 0.58, 0.20, 0.94 },
    diamond = { 1.00, 0.70, 0.24, 1.00 },
    glow = { 1.00, 0.58, 0.12, 0.58 },
}

local function resolveVariant(name)
    return variants[name]
        or DEFAULT_VARIANTS[name]
        or DEFAULT_VARIANTS.objective
end

local function setTextureColor(texture, color)
    texture:SetVertexColor(
        color[1],
        color[2],
        color[3],
        color[4]
    )
end

function ContextVisual.SetComplete(surface, complete)
    if not surface then
        return
    end

    local palette
    if complete then
        palette = colors.complete or DEFAULT_COMPLETE
    else
        palette = colors.normal or DEFAULT_NORMAL
    end

    surface.text:SetTextColor(
        palette.text[1],
        palette.text[2],
        palette.text[3],
        palette.text[4]
    )

    setTextureColor(surface.leftLine, palette.line)
    setTextureColor(surface.rightLine, palette.line)
    setTextureColor(surface.diamond, palette.diamond)
    setTextureColor(surface.glow, palette.glow)

    if complete then
        surface.glow:Show()
    else
        surface.glow:Hide()
    end

    surface.complete = complete and true or false
end

function ContextVisual.Create(parent, name, variant)
    local spec = resolveVariant(variant)

    local root = CreateFrame("Frame", name, parent)
    root:SetSize(spec.width, spec.height)
    root:EnableMouse(false)

    local text = root:CreateFontString(
        name and (name .. "Text") or nil,
        "OVERLAY",
        spec.font or "GameFontHighlight"
    )
    text:SetPoint("TOP", root, "TOP", 0, 0)
    text:SetWidth(spec.textWidth)
    text:SetJustifyH("CENTER")
    text:SetJustifyV("TOP")
    text:SetShadowColor(0, 0, 0, 0.92)
    text:SetShadowOffset(1, -1)
    text:ClearText()

    local leftLine = root:CreateTexture(nil, "ARTWORK")
    leftLine:SetTexture(
        assets.line or "Interface\\Buttons\\WHITE8x8"
    )
    leftLine:SetSize(spec.lineWidth, spec.lineHeight)
    leftLine:SetPoint(
        "RIGHT",
        root,
        "BOTTOM",
        -(spec.diamondSize * 0.72),
        spec.lineOffset
    )

    local rightLine = root:CreateTexture(nil, "ARTWORK")
    rightLine:SetTexture(
        assets.line or "Interface\\Buttons\\WHITE8x8"
    )
    rightLine:SetSize(spec.lineWidth, spec.lineHeight)
    rightLine:SetPoint(
        "LEFT",
        root,
        "BOTTOM",
        spec.diamondSize * 0.72,
        spec.lineOffset
    )
    rightLine:SetTexCoord(1, 0, 0, 1)

    local glow = root:CreateTexture(nil, "ARTWORK")
    glow:SetTexture(
        assets.glow or "Interface\\Buttons\\WHITE8x8"
    )
    glow:SetSize(spec.glowSize, spec.glowSize)
    glow:SetPoint(
        "CENTER",
        root,
        "BOTTOM",
        0,
        spec.lineOffset
    )
    glow:SetBlendMode("ADD")
    glow:Hide()

    local diamond = root:CreateTexture(nil, "OVERLAY")
    diamond:SetTexture(
        assets.diamond or "Interface\\Buttons\\WHITE8x8"
    )
    diamond:SetSize(spec.diamondSize, spec.diamondSize)
    diamond:SetPoint(
        "CENTER",
        root,
        "BOTTOM",
        0,
        spec.lineOffset
    )

    local surface = {
        root = root,
        text = text,
        leftLine = leftLine,
        rightLine = rightLine,
        diamond = diamond,
        glow = glow,
        variant = variant,
        complete = false,
    }

    ContextVisual.SetComplete(surface, false)
    return surface
end
