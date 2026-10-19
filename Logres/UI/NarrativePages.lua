-- P0262 N2: source-independent NPC narrative pagination and visual page rail.
-- No native reads, actions, protected changes, timers, or camera hooks.
local _, Logres = ...
local Pages = {}
Logres.NPCNarrativePages = Pages

local function appendPage(pages, text)
    if text == "" then
        return
    end

    pages[#pages + 1] = text
end

local function addParagraphWords(
    pages,
    current,
    paragraph,
    limit
)
    local prefix =
        current == "" and "" or "\n\n"

    for word in paragraph:gmatch("%S+") do
        local separator =
            current == "" and "" or " "
        local candidate

        if prefix ~= "" then
            candidate =
                current
                .. prefix
                .. word
            prefix = ""
        else
            candidate =
                current
                .. separator
                .. word
        end

        if #candidate > limit
            and current ~= ""
        then
            appendPage(pages, current)
            current = word
        else
            current = candidate
        end
    end

    return current
end

function Pages.Build(text, limit)
    if text == "" then
        return { "" }
    end

    local pages = {}
    local current = ""
    local sawParagraph = false

    for paragraph in (text .. "\n"):gmatch("(.-)\n") do
        if paragraph ~= "" then
            sawParagraph = true
            current = addParagraphWords(
                pages,
                current,
                paragraph,
                limit
            )
        end
    end

    if current ~= "" then
        appendPage(pages, current)
    end

    if not sawParagraph or #pages == 0 then
        pages[1] = text
    end

    return pages
end

function Pages.Paint(self, activeColor, inactiveColor)
    -- P0254: the guarded completion action sits inside the panel; retain
    -- paging at the lower right instead of covering the centered button.
    self.pageIndicator:ClearAllPoints()
    if self.completionActive then
        self.pageIndicator:SetPoint(
            "BOTTOMRIGHT", self.root, "BOTTOMRIGHT", -115, 17
        )
    elseif self.offerActionsEnabled
        and self.currentPage == #self.pages then
        -- Offers have TWO in-panel buttons. Keep paging on a separate
        -- rail above their right edges, never over either click region.
        self.pageIndicator:SetPoint(
            "BOTTOMRIGHT", self.root, "BOTTOMRIGHT", -115, 78
        )
    else
        self.pageIndicator:SetPoint(
            "BOTTOM", self.root, "BOTTOM", 0, 17
        )
    end
    local pageCount = #self.pages
    local current = self.currentPage

    if pageCount <= 1 then
        self.pageIndicator:Hide()
        self.previousButton:Hide()
        self.nextButton:Hide()
        return
    end

    self.pageIndicator:SetFormattedText(
        "%d / %d",
        current,
        pageCount
    )
    self.pageIndicator:Show()


    if current > 1 then
        self.previousTexture:SetVertexColor(
            activeColor[1],
            activeColor[2],
            activeColor[3],
            activeColor[4]
        )
        self.previousButton:Show()
    else
        self.previousTexture:SetVertexColor(
            inactiveColor[1],
            inactiveColor[2],
            inactiveColor[3],
            inactiveColor[4]
        )
        self.previousButton:Hide()
    end

    if current < pageCount then
        self.nextTexture:SetVertexColor(
            activeColor[1],
            activeColor[2],
            activeColor[3],
            activeColor[4]
        )
        self.nextButton:Show()
    else
        self.nextTexture:SetVertexColor(
            inactiveColor[1],
            inactiveColor[2],
            inactiveColor[3],
            inactiveColor[4]
        )
        self.nextButton:Hide()
    end
end

function Pages.ShowBody(self, index)
    self.bodyText:SetText(
        self.pages[index] or ""
    )
end

return Pages
