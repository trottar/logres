local addonName, Logres = ...

if type(Logres) ~= "table" then
    error("Logres: addon namespace table is unavailable")
end

Logres.NAME = addonName
Logres.VERSION = "0.0.8-dev"
Logres.DEVELOPMENT = true

local eventFrame = CreateFrame("Frame")
local eventHandlers = {}
local callbacks = {}

Logres.eventFrame = eventFrame

function Logres:RegisterEvent(event, handler)
    if type(event) ~= "string" or event == "" then
        error("Logres:RegisterEvent requires a non-empty event name")
    end
    if type(handler) ~= "function" then
        error("Logres:RegisterEvent requires a function handler")
    end

    local handlers = eventHandlers[event]
    if not handlers then
        handlers = {}
        eventHandlers[event] = handlers
        eventFrame:RegisterEvent(event)
    end

    handlers[#handlers + 1] = handler
end

function Logres:RegisterCallback(name, handler)
    if type(name) ~= "string" or name == "" then
        error("Logres:RegisterCallback requires a non-empty callback name")
    end
    if type(handler) ~= "function" then
        error("Logres:RegisterCallback requires a function handler")
    end

    local handlers = callbacks[name]
    if not handlers then
        handlers = {}
        callbacks[name] = handlers
    end

    handlers[#handlers + 1] = handler
end

function Logres:FireCallback(name, ...)
    local handlers = callbacks[name]
    if not handlers then
        return
    end

    for index = 1, #handlers do
        handlers[index](...)
    end
end

function Logres:DevPrint(message)
    if not self.DEVELOPMENT then
        return
    end

    if self.db and self.db.settings and self.db.settings.debug == false then
        return
    end

    print("|cffc9aa71Logres|r: " .. tostring(message))
end

eventFrame:SetScript("OnEvent", function(_, event, ...)
    local handlers = eventHandlers[event]
    if not handlers then
        return
    end

    for index = 1, #handlers do
        handlers[index](event, ...)
    end
end)
