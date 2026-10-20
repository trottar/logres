-- P0277: one configurable Logres panel surface painter, shared across views.
-- Rendering only: creates addon-owned art; never owns native interaction.
local _, Logres = ...
local Surface = {}
Logres.PanelSurface = Surface

function Surface.Hide(pieces)
    if not pieces then return end
    for index = 1, #pieces do
        pcall(function() pieces[index]:Hide() end)
    end
end

-- The caller supplies the entire presentation recipe (art, geometry, layers).
-- No quest/trainer-specific positioning, color or sizing belongs here.
function Surface.Paint(owner, config, width, height)
    if not owner or type(config) ~= "table"
        or type(width) ~= "number" or type(height) ~= "number"
        or width <= 0 or height <= 0 then
        return nil, "invalid-panel-config"
    end
    local bg, rule = config.background, config.divider
    if type(bg) ~= "table" or type(rule) ~= "table"
        or type(bg.texture) ~= "string" or type(rule.texture) ~= "string" then
        return nil, "missing-panel-art"
    end
    local pieces = {}
    local ok = pcall(function()
        if bg.mode == "stretch" then
            local panel = owner:CreateTexture(nil, bg.layer, nil, bg.sublevel)
            pieces[#pieces + 1] = panel
            panel:Hide()
            panel:SetAllPoints(owner)
            panel:SetTexture(bg.texture)
        elseif bg.mode == "nine-slice" then
            local cut = bg.corner
            assert(type(cut) == "number" and cut > 0
                and width > 2 * cut and height > 2 * cut)
            local sizesX = {cut, width - 2 * cut, cut}
            local sizesY = {cut, height - 2 * cut, cut}
            local positionsX = {0, cut, width - cut}
            local positionsY = {0, cut, height - cut}
            local uvX = {0, cut / bg.referenceWidth,
                1 - cut / bg.referenceWidth, 1}
            local uvY = {0, cut / bg.referenceHeight,
                1 - cut / bg.referenceHeight, 1}
            for row = 1, 3 do
                for col = 1, 3 do
                    local panel = owner:CreateTexture(nil, bg.layer, nil, bg.sublevel)
                    pieces[#pieces + 1] = panel
                    panel:Hide()
                    panel:SetTexture(bg.texture)
                    panel:SetSize(sizesX[col], sizesY[row])
                    panel:SetPoint("TOPLEFT", owner, "TOPLEFT",
                        positionsX[col], -positionsY[row])
                    panel:SetTexCoord(uvX[col], uvX[col + 1],
                        uvY[row], uvY[row + 1])
                end
            end
        else
            error("unsupported-panel-paint-mode")
        end
        local divider = owner:CreateTexture(nil, rule.layer, nil, rule.sublevel)
        pieces[#pieces + 1] = divider
        divider:Hide()
        divider:SetTexture(rule.texture)
        divider:SetSize(width - rule.horizontalInset, rule.height)
        divider:SetPoint("TOP", owner, "TOP", rule.x, rule.y)
    end)
    if not ok then
        Surface.Hide(pieces)
        return nil, "panel-painter-failed"
    end
    for index = 1, #pieces do pieces[index]:Show() end
    return pieces
end
return Surface
