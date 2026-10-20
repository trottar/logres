-- P0279: indexed, declarative Logres-to-Blizzard service element catalogue.
-- Source-level candidates are NOT claims of Forever client availability.
-- No behavior, native method calls or coordinates live in this input file.
local _, Logres = ...
local rows = {}
local function add(id, service, role, label, nativePath, evidence)
    rows[#rows + 1] = {
        id = id, service = service, role = role, label = label,
        nativePath = nativePath, evidence = evidence,
        state = nativePath and "SOURCE_CANDIDATE" or "UNMAPPED",
    }
end
-- Desired layout: user-approved landscape trainer composition.
-- ElvUI Forever/Blizzard named references are candidates until in-client verified.
add("trainer.frame",       "trainer", "surface",     "Panel / border",       "ClassTrainerFrame",                   "ElvUI Forever")
add("trainer.title",       "trainer", "title",       "Trainer title",        "ClassTrainerFrameTitleText",           "Blizzard TrainerUI named candidate; client verify")
add("trainer.portrait",    "trainer", "portrait",    "Portrait",             "ClassTrainerFramePortrait",           "ElvUI Forever")
add("trainer.subtitle",    "trainer", "subtitle",    "Trainer profession",   nil,                                   "design-only")
add("trainer.search",      "trainer", "search",      "Search field",         nil,                                   "design-only")
add("trainer.categories",  "trainer", "category",    "Left category filter", nil,                                   "design-only")
add("trainer.filter",      "trainer", "filter",      "Native filter",        "ClassTrainerFrame.FilterDropdown",     "ElvUI Forever")
add("trainer.list",        "trainer", "list",        "Skill list",           "ClassTrainerFrame.ScrollBox",          "ElvUI Forever; P0278 runtime")
add("trainer.scrollbar",   "trainer", "scrollbar",   "Skill scrollbar",      "ClassTrainerFrame.ScrollBar",          "ElvUI Forever")
add("trainer.row",         "trainer", "row",         "Visible skill row",    "ClassTrainerFrame.ScrollBox.*",        "ElvUI Forever; row identity TBD")
add("trainer.selection",   "trainer", "selection",   "Selected skill",       "ClassTrainerFrameSkillStepButton",    "ElvUI Forever")
add("trainer.status",      "trainer", "status",      "Training rank bar",    "ClassTrainerStatusBar",               "ElvUI Forever")
add("trainer.detailIcon",  "trainer", "detail.icon", "Selected skill icon",  "ClassTrainerFrameSkillStepButton.icon", "ElvUI Forever skill-step icon; client verify")
add("trainer.reagents",    "trainer", "reagents",    "Reagent display",      nil,                                   "design-only")
add("trainer.price",       "trainer", "price",       "Money / cost",         "ClassTrainerFrame.money",              "ElvUI Forever")
add("trainer.train",       "trainer", "action.train","Train button",         "ClassTrainerTrainButton",            "ElvUI Forever")
add("trainer.trainAll",    "trainer", "action.all",  "Train all",            nil,                                   "addon / native source unverified")
add("trainer.close",       "trainer", "action.close","Close button",         "ClassTrainerFrameCloseButton",       "Blizzard named candidate")
-- Merchant: real item, buyback and repair ownership stays Blizzard-owned.
add("merchant.frame",     "merchant", "surface",     "Merchant panel",       "MerchantFrame",                    "ElvUI")
add("merchant.items",     "merchant", "item-list",   "Merchant item slot",   "MerchantItem1",                    "ElvUI")
add("merchant.buyback",   "merchant", "buyback",     "Buyback item",         "MerchantBuyBackItem",              "ElvUI")
add("merchant.money",     "merchant", "money",       "Player money",         "MerchantMoneyInset",               "ElvUI")
add("merchant.tabs",      "merchant", "tabs",        "Buy / buyback tabs",   "MerchantFrameTab1",                "ElvUI")
add("merchant.repair",    "merchant", "action.repair","Repair control",      "MerchantRepairAllButton",          "ElvUI")
add("merchant.filters",   "merchant", "filter",      "Stock item filter",    "MerchantFrame.FilterDropdown",    "ElvUI modern; client verify")
-- Flight path: never replace the route map or paid-travel action.
add("flight.frame",       "flight", "surface",        "Flight map frame",     "TaxiFrame",                       "ElvUI Classic")
add("flight.routes",      "flight", "travel.map",     "Route map",            "TaxiRouteMap",                    "ElvUI Classic")
add("flight.map",         "flight", "travel.mapArt",  "Map artwork",         "TaxiMap",                         "ElvUI Classic")
add("flight.close",       "flight", "action.close",   "Close control",       "TaxiCloseButton",                 "ElvUI Classic")
-- Future categories are intentionally indexed without invented child controls.
add("gossip.frame",       "gossip", "surface",        "NPC conversation",     "GossipFrame",                     "Logres NativeServiceCapabilities")
add("bank.frame",         "bank", "surface",          "Bank window",          "BankFrame",                       "Logres NativeServiceCapabilities")
add("auction.frame",      "auction", "surface",       "Auction window",       "AuctionHouseFrame",               "Logres NativeServiceCapabilities")
add("stable.frame",       "stable", "surface",        "Pet stable",           "PetStableFrame",                  "Logres NativeServiceCapabilities")
add("tabard.frame",       "tabard", "surface",        "Guild tabard",         "TabardFrame",                     "Logres NativeServiceCapabilities")

local byId = {}
for i = 1, #rows do
    assert(not byId[rows[i].id], "duplicate Logres service map ID")
    byId[rows[i].id] = rows[i]
end
-- Inspector presentation parameters are independent from native/UI design geometry.
local overlay = {
    strata = "TOOLTIP",
    fill = {0.90, 0.68, 0.22, 0.12},
    border = {1, 0.78, 0.24, 1},
    lineWidth = 2,
}
Logres.ServiceElementIndex = {rows = rows, byId = byId, overlay = overlay}
