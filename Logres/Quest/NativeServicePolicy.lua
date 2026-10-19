-- P0269: D-047 native-backed NPC service ownership. Policy only.
-- Never reads or mutates Blizzard frames, inventories, prices or protected inputs.
local _, Logres = ...
local Policy = {}
Logres.NPCNativeServicePolicy = Policy

-- Frames are source hints for future guarded styling feasibility, NOT
-- demonstrated client availability, permission to modify, or input routes.
local FAMILIES = {
    { key = "merchant", native = "MerchantFrame", controls = "buy/sell/buyback/quantity" },
    { key = "repairs", native = "MerchantFrame", controls = "individual/repair-all" },
    { key = "sell-junk", native = "MerchantFrame", controls = "native sale; bulk junk shortcut unverified" },
    { key = "trainer", native = "ClassTrainerFrame", controls = "learn/filter/prerequisites" },
    { key = "flight", native = "FlightMapFrame", controls = "destinations/fares/travel" },
    { key = "bank", native = "BankFrame", controls = "inventory/tabs" },
    { key = "auction", native = "AuctionHouseFrame", controls = "search/bid/buyout/sell" },
}

function Policy.GetFamilies()
    local copy = {}
    for index = 1, #FAMILIES do
        local family = FAMILIES[index]
        copy[index] = {
            key = family.key, native = family.native,
            controls = family.controls, ownership = "Blizzard",
            presentation = "native-unchanged",
            styling = "unverified", positioning = "unverified",
        }
    end
    return copy
end

function Policy.GetAudit()
    -- The existing Logres State is addon-owned, already normalized, and does
    -- not identify individual service families. Do NOT infer one from its
    -- generic interaction type or an NPC proximity marker.
    local state = Logres:GetState()
    return {
        mode = "native-stock",
        source = "addon-owned-state",
        interacting = state and state.interacting == true or false,
        interactionType = state and state.interactionType or 0,
        families = #FAMILIES,
        serviceIdentity = "not-observed",
        nativeTransactions = "Blizzard-owned",
        visualIntegration = "deferred-capability-proof",
        mutationCalls = 0,
    }
end
return Policy
