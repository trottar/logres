-- P0512: actual read-only item-preview module; synthetic Blizzard data.
issecretvalue = function(value) return false end
local namespace = {}
local chunk = assert(loadfile("Logres/Quest/NativeTrainerServiceProbe.lua"))
C_TooltipInfo = {GetHyperlink = function(link)
    assert(link:find("|Hitem:123:", 1, true))
    return {lines={
        {leftText="Novice Ardent's Sash"},
        {leftText="Binds when equipped"},
        {leftText="Waist", rightText="Cloth"},
        {leftText="12 Armor"},
        {leftText="+2 Stamina"},
        {leftText="Requires Level 5"},
        {leftText="Sell Price", rightText="2 Copper"},
    }}
end}
local requested = nil
C_Item = {RequestLoadItemDataByID = function(id) requested = id end}
local tooltip = {visible=false}
function tooltip:SetOwner(owner, where) assert(owner == "owned-hit" and where == "ANCHOR_RIGHT") end
function tooltip:SetHyperlink(link) assert(link:find("|Hitem:123:", 1, true)) end
function tooltip:Show() self.visible = true end
function tooltip:Hide() self.visible = false end
GameTooltip = tooltip
chunk("Logres", namespace)
local preview = assert(namespace.NPCTrainerItemPreview)
local link = "|cff00aaff|Hitem:123:0:0:0|h[Test Item]|h|r"
assert(preview.ItemID(link) == 123)
-- Native service tuple is the only identity-to-item bridge. Neither a
-- filtered position nor a similar spell/recipe name supplies the link.
namespace.GetState = function() return {interacting=true, interactionType=7} end
ClassTrainerFrame = {IsProtected=function() return false end,
    IsShown=function() return true end}
InCombatLockdown = function() return false end
GetNumTrainerServices = function() return 2 end
GetTrainerServiceInfo = function(index)
    if index == 1 then return "Novice Ardent's Sash", "available", 134, 1, "", "Tailoring" end
    return "Spell-only lesson", "used", 123, 1, "", "Enchanting"
end
GetTrainerServiceItemLink = function(index)
    if index == 1 then return link end
    return "|Hspell:123|h[Spell]|h"
end
GetTrainerServiceCost = function() return 100, false, nil end
GetTrainerServiceSkillReq = function() return "Tailoring", 50, true end
GetTrainerServiceDescription = function() return "Native lesson description" end
GetMoney = function() return 400 end
UnitName = function(unit) if unit == "npc" then return "Trainer" end end
local report = namespace.NPCNativeTrainerServiceProbe.Read()
assert(report.status == "service-row-shape-deferred", report.status)
assert(report.sample[1].itemLink == link)
assert(report.sample[2].itemLink == nil)
assert(report.sample[2].description == "Native lesson description")
local summary, status, id = preview.Summarize(link)
assert(status == "ready" and id == 123, status)
assert(summary:find("Waist  Cloth", 1, true))
assert(summary:find("12 Armor", 1, true))
assert(summary:find("+2 Stamina", 1, true))
assert(not summary:find("Binds when equipped", 1, true))
assert(not summary:find("Sell Price", 1, true))
assert(summary:find("Hover for complete item stats.", 1, true))
assert(preview.ShowTooltip("owned-hit", link) and tooltip.visible)
preview.HideTooltip()
assert(not tooltip.visible)
assert(preview.Request(123) and requested == 123)
assert(not preview.Request(-1) and not preview.Request(0.5))
assert(preview.ItemID("|Hspell:123|h[Wrong Type]|h") == nil)
assert(preview.ItemID("|Hitem:123456789012345|h[Invalid]|h") == nil)
assert(preview.Summarize("|Hspell:123|h[Wrong Type]|h") == nil)
C_TooltipInfo.GetHyperlink = function() error("not cached") end
local pending, state, pendingId = preview.Summarize(link)
assert(state == "loading" and pendingId == 123 and pending:find("loading", 1, true))
C_Item = nil
local uncacheable, noLoader = preview.Summarize(link)
assert(noLoader == "unavailable" and uncacheable:find("unavailable", 1, true))
C_TooltipInfo = nil
local unavailable, missing = preview.Summarize(link)
assert(missing == "api-unavailable" and unavailable:find("unavailable", 1, true))
local protected = link
issecretvalue = function(value) return value == protected end
assert(preview.ItemID(link) == nil)
assert(preview.Summarize(link) == nil)
print("P0512 trainer crafted-item source fixture PASS")
