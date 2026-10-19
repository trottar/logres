-- P0265: authored, source-independent NPC option fixtures.
-- No live gossip reads, frame calls, service transactions or native mutations.
local _, Logres = ...
local Model = {}
Logres.NPCOptionModel = Model

local function entry(label, nextNode, enabled, reason, action)
    return { label = label, nextNode = nextNode,
        enabled = enabled ~= false, reason = reason, action = action }
end

local detailed = "Beyond the northern ridge, a narrow pass follows the old stone road. "
    .. "Travelers once sheltered near the fallen watchtower, but now the trail is quiet. "
    .. "A messenger left lanterns to mark the safe approach. Follow them through the trees, "
    .. "past the broken arch, and turn back at the flooded bridge. "
    .. "If the pass is closed, return to the village and ask the quartermaster for directions. "
    .. "The patrol was last seen beyond the ruined wall where the river cuts the valley. "
    .. "Take care when the light fades, and do not mistake the southern trail for the road home."

local function branching()
    return {
        title = "At the Crossroads", start = "welcome", previewOnly = true,
        nodes = {
            welcome = { title = "At the Crossroads",
                body = "Greetings, traveler. What would you like to know?",
                options = {
                    entry("Tell me about this place", "history"),
                    entry("Which road leads north?", "directions"),
                    entry("What services are nearby?", "services"),
                    entry("A guarded passage", "locked", false, "Requires a permit"),
                    entry("Farewell", nil, true, nil, "goodbye"),
                } },
            history = { title = "The Old Watch", body = detailed,
                options = { entry("Where should I travel?", "directions") } },
            directions = { title = "The Northern Road",
                body = "Follow the lanterns past the watchtower. The flooded bridge is impassable.",
                options = { entry("Tell me more", "history") } },
            services = { title = "Village Services",
                body = "Native merchant, trainer and inn windows remain available from their NPCs.",
                options = { entry("Where is the inn?", "inn"), entry("Return to the road", "directions") } },
            inn = { title = "The Inn",
                body = "Ask the innkeeper directly to set a home location; this sample does not bind you.",
                options = {} },
        },
    }
end

local function services()
    return {
        title = "Town Services", start = "services", previewOnly = true,
        nodes = {
            services = { title = "Town Services",
                body = "Choose a service to read its description. All transactions remain native.",
                options = {
                    entry("Merchant and supplies", "merchant"),
                    entry("Class trainer", "trainer"),
                    entry("Innkeeper", "inn"),
                    entry("Flight routes", "flight"),
                    entry("Equipment repairs", "repair"),
                    entry("Bank storage", "bank"),
                    entry("Auction services", "auction"),
                } },
            merchant = { title = "Merchant", body = "Browsing, buying and selling remain in Blizzard's merchant UI.", options = {} },
            trainer = { title = "Trainer", body = "Learning and spending remain in Blizzard's trainer UI.", options = {} },
            inn = { title = "Innkeeper", body = "Home binding and confirmation remain in Blizzard's UI.", options = {} },
            flight = { title = "Flight Master", body = "Route selection and travel stay in the native flight map.", options = {} },
            repair = { title = "Repairs", body = "Repair costs and confirmation stay in the merchant interface.", options = {} },
            bank = { title = "Bank", body = "Inventory movement and bank tab access stay in the native interface.", options = {} },
            auction = { title = "Auction House", body = "Searching, bidding and buying stay in the native auction interface.", options = {} },
        },
    }
end

local function overflow()
    local choices = {}
    for i = 1, 11 do
        choices[i] = entry("Road sign " .. i .. " - directions", "note" .. i)
    end
    local nodes = {
        index = { title = "The Guidebook",
            body = "Eleven choices require multiple option pages. Use the lower arrows.",
            options = choices },
    }
    for i = 1, 11 do
        nodes["note" .. i] = { title = "Road Sign " .. i,
            body = "You chose road sign " .. i .. ". Return to see all choices.", options = {} }
    end
    return { title = "The Guidebook", start = "index", previewOnly = true, nodes = nodes }
end

local function locked()
    return {
        title = "Restricted Passages", start = "gate", previewOnly = true,
        nodes = {
            gate = { title = "Restricted Passages",
                body = "Unavailable actions show their requirement and cannot be activated.",
                options = {
                    entry("Enter the fortress", "fortress", false, "Requires a permit"),
                    entry("Cross the ferry", "ferry", false, "Requires a fare"),
                    entry("Ask about the local road", "road"),
                    entry("Leave the watch", nil, true, nil, "goodbye"),
                } },
            road = { title = "Local Road", body = "The main road is open to all travelers.", options = {} },
        },
    }
end

function Model.Preview(mode)
    if mode == "branching" then return branching() end
    if mode == "services" then return services() end
    if mode == "overflow" then return overflow() end
    if mode == "locked" then return locked() end
    return nil, "unknown-option-preview"
end

-- A future guarded native adapter must produce this plain envelope; this
-- module does not inspect or select live gossip and never claims ownership.
function Model.FromValidated(title, start, nodes)
    return { title = title, start = start, nodes = nodes, previewOnly = false }
end

return Model
