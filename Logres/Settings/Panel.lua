local _, Logres = ...

-- P0238: a limited player-facing shell for already accepted preferences.
-- All state flows through the existing preference publisher and controller.
local SettingsPanel = Logres:RegisterModule("SettingsPanel", {
    OnInitialize = function(self)
        local frame = CreateFrame("Frame", "LogresSettingsPanel", UIParent)
        frame:SetSize(430, 264)
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 44)
        frame:SetFrameStrata("DIALOG")
        frame:SetClampedToScreen(true)
        frame:EnableMouse(true)
        frame:Hide()
        self.frame = frame

        local backdrop = frame:CreateTexture(nil, "BACKGROUND")
        backdrop:SetAllPoints(frame)
        backdrop:SetColorTexture(0.035, 0.032, 0.027, 0.97)
        local topRule = frame:CreateTexture(nil, "BORDER")
        topRule:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -8)
        topRule:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -14, -8)
        topRule:SetHeight(1)
        topRule:SetColorTexture(0.44, 0.35, 0.20, 0.95)

        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", frame, "TOPLEFT", 22, -21)
        title:SetText("Logres Settings")
        local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -8)
        close:SetScript("OnClick", function() frame:Hide() end)

        local intro = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        intro:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -9)
        intro:SetText("Current gameplay preferences")

        local immersionLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        immersionLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 22, -92)
        immersionLabel:SetText("Immersion")
        local immersionHint = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        immersionHint:SetPoint("TOPLEFT", immersionLabel, "BOTTOMLEFT", 0, -5)
        immersionHint:SetText("World-first presentation and native fallbacks")
        local immersionButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        immersionButton:SetSize(102, 27)
        immersionButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -22, -88)
        immersionButton:SetScript("OnClick", function()
            Logres:SetPreference("immersionEnabled",
                not Logres:GetPreference("immersionEnabled"), "settings-panel")
            self:Refresh()
        end)
        self.immersionButton = immersionButton

        local activeLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        activeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 22, -158)
        activeLabel:SetText("Active Quest")
        local activeHint = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        activeHint:SetPoint("TOPLEFT", activeLabel, "BOTTOMLEFT", 0, -5)
        activeHint:SetText("Optional single-quest ambient presentation")
        local activeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        activeButton:SetSize(102, 27)
        activeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -22, -154)
        activeButton:SetScript("OnClick", function()
            Logres:SetPreference("activeQuestEnabled",
                not Logres:GetPreference("activeQuestEnabled"), "settings-panel")
            self:Refresh()
        end)
        self.activeButton = activeButton

        local footer = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        footer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 22, 18)
        footer:SetText("Changes persist. Additional options remain under development.")
        self:Refresh()
    end,
    OnEnable = function(self)
        self:SubscribePreferences(function() self:Refresh() end)
    end,
    OnDisable = function(self)
        if self.frame then self.frame:Hide() end
    end,
})

function SettingsPanel:Refresh()
    if not self.immersionButton or not self.activeButton then return end
    self.immersionButton:SetText(Logres:GetPreference("immersionEnabled") and "ON" or "OFF")
    self.activeButton:SetText(Logres:GetPreference("activeQuestEnabled") and "ON" or "OFF")
end

function SettingsPanel:Toggle()
    if not self:IsEnabled() or not self.frame then return false end
    if self.frame:IsShown() then
        self.frame:Hide()
    else
        self:Refresh()
        self.frame:Show()
    end
    return true
end

function Logres:ToggleSettingsPanel()
    return SettingsPanel:Toggle()
end
