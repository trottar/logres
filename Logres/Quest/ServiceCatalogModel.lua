-- P0268: deterministic service quotes through the existing NPC option model.
-- All prices, availability and eligibility are invented PREVIEW FIXTURE data;
-- do not use this data for live NPCs, transactions or travel.
local _, Logres = ...
local Model = {}
Logres.NPCServiceCatalogModel = Model

local function entry(label, nextNode, enabled, reason, action)
    return { label = label, nextNode = nextNode,
        enabled = enabled ~= false, reason = reason, action = action }
end

-- One builder for three service families. This produces the same envelope
-- consumed by NPCOptionSession and NPCOptionList; no parallel UI is created.
local function catalog(family, title, description, rows)
    local nodes = {
        index = { title = title, body = description, options = {} },
    }
    for index = 1, #rows do
        local row = rows[index]
        local key = "item" .. index
        local allowed = row.available == true
        nodes.index.options[#nodes.index.options + 1] = entry(
            row.label .. " - " .. row.cost, key, allowed,
            row.reason or "Unavailable in this sample"
        )
        if allowed then
            local quote = key .. "quote"
            local result = key .. "done"
            nodes[key] = {
                title = row.label,
                body = row.detail .. "\n\nSample cost: " .. row.cost
                    .. ". This is a preview, not a real offer.",
                options = {
                    entry("Review preview confirmation", quote),
                },
            }
            nodes[quote] = {
                title = "Review: " .. row.label,
                body = "Sample " .. family .. " quote: " .. row.cost
                    .. ". No inventory, gold, training or travel will change.",
                options = {
                    entry("Confirm preview (no transaction)", result,
                        true, nil, "preview-confirm"),
                },
            }
            nodes[result] = {
                title = "Preview Complete",
                body = "This was only a " .. family
                    .. " simulation. No native action was invoked.",
                options = {},
            }
        end
    end
    nodes.index.options[#nodes.index.options + 1] =
        entry("Goodbye", nil, true, nil, "goodbye")
    return { title = title, start = "index", previewOnly = true,
        family = family, nodes = nodes }
end

local merchant = {
    { label = "Linen Bandage", cost = "6s", available = true,
      detail = "A simple adventurer's supply." },
    { label = "Travel Rations", cost = "15s", available = true,
      detail = "Food for the road." },
    { label = "Coarse Thread", cost = "9s", available = true,
      detail = "Basic crafting supplies." },
    { label = "Traveler's Lantern", cost = "32s", available = true,
      detail = "A light for the northern pass." },
    { label = "Heavy Cloak", cost = "2g 15s", available = false,
      reason = "Requires reputation", detail = "Restricted sample stock." },
    { label = "Healing Draught", cost = "48s", available = true,
      detail = "An example consumable." },
    { label = "Limited Map", cost = "1g", available = false,
      reason = "Sold out", detail = "Limited-stock example." },
    { label = "Wool Satchel", cost = "85s", available = true,
      detail = "An example carry bag." },
}
local trainer = {
    { label = "Defensive Stance", cost = "20s", available = true,
      detail = "Sample class technique description." },
    { label = "Quick Strike II", cost = "80s", available = true,
      detail = "Example of an improved ability." },
    { label = "Advanced Guard", cost = "1g 20s", available = false,
      reason = "Requires level 20", detail = "An unavailable example skill." },
    { label = "Weapon Expertise", cost = "60s", available = true,
      detail = "A basic training sample." },
    { label = "Heroic Discipline", cost = "3g", available = false,
      reason = "Prerequisite missing", detail = "An advanced example skill." },
    { label = "Field First Aid", cost = "15s", available = true,
      detail = "A sample general skill." },
}
local flights = {
    { label = "Northwatch", cost = "10s", available = true,
      detail = "A nearby fictional flight route." },
    { label = "Stonebridge", cost = "22s", available = true,
      detail = "An example middle-distance route." },
    { label = "Ironpass", cost = "45s", available = false,
      reason = "Flight point undiscovered", detail = "An undiscovered route." },
    { label = "Eastfield", cost = "18s", available = true,
      detail = "A local travel example." },
    { label = "Highlands", cost = "70s", available = false,
      reason = "Route not connected", detail = "An unconnected sample route." },
    { label = "South Ferry", cost = "32s", available = true,
      detail = "A fictional travel connection." },
    { label = "Coastwatch", cost = "49s", available = true,
      detail = "A longer example flight." },
}

function Model.Preview(mode)
    if mode == "merchant" then
        return catalog("merchant", "Merchant Catalogue",
            "Sample prices and stock; no purchase, sale or repair is possible.", merchant)
    elseif mode == "trainer" then
        return catalog("trainer", "Trainer Catalogue",
            "Sample costs and requirements; no skills can be learned here.", trainer)
    elseif mode == "flight" then
        return catalog("flight", "Flight Routes",
            "Sample destinations and fares; no travel can be started here.", flights)
    elseif mode == "unavailable" then
        return { title = "Service Unavailable", start = "index",
            previewOnly = true, family = "unavailable", nodes = {
                index = { title = "Service Unavailable",
                    body = "No supported service data is available. The native Blizzard service interface remains available and unchanged.",
                    options = { entry("Why unavailable?", "reason"),
                        entry("Goodbye", nil, true, nil, "goodbye") } },
                reason = { title = "Native Fallback",
                    body = "Logres never fabricates live service eligibility or disables native transactions when a source cannot be verified.",
                    options = {} },
            } }
    end
    return nil, "unknown-service-catalog-preview"
end

return Model
