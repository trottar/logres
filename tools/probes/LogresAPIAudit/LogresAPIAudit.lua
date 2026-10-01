local addonName = ...

local frame = CreateFrame("Frame")
local MAX_SNAPSHOTS = 300

local function pack(...)
    return { n = select("#", ...), ... }
end

local vignetteCurve
local vignetteCurveStatus = {
    available = false,
    ok = false,
}

local function initializeVignetteCurve()
    if not C_CurveUtil or type(C_CurveUtil.CreateCurve) ~= "function" then
        vignetteCurveStatus.error = "C_CurveUtil.CreateCurve unavailable"
        return
    end

    vignetteCurveStatus.available = true
    local ok, curveOrError = pcall(C_CurveUtil.CreateCurve)
    if not ok or not curveOrError then
        vignetteCurveStatus.error = tostring(curveOrError):sub(1, 300)
        return
    end

    local curve = curveOrError
    local points = {
        {0.00, 1.00},
        {0.15, 0.95},
        {0.30, 0.70},
        {0.50, 0.30},
        {0.70, 0.00},
        {1.00, 0.00},
    }

    for _, point in ipairs(points) do
        local pointOK, pointError = pcall(curve.AddPoint, curve, point[1], point[2])
        if not pointOK then
            vignetteCurveStatus.error = tostring(pointError):sub(1, 300)
            return
        end
    end

    vignetteCurve = curve
    vignetteCurveStatus.ok = true
end

initializeVignetteCurve()

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end
    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function cleanScalar(value)
    if value == nil then
        return nil
    end
    if isSecret(value) then
        return "<secret>"
    end
    local t = type(value)
    if t == "string" or t == "number" or t == "boolean" then
        return value
    end
    return "<" .. t .. ">"
end

local function callRecord(label, func, ...)
    if type(func) ~= "function" then
        return {
            label = label,
            available = false,
            ok = false,
            error = "function unavailable",
        }
    end

    local packed = pack(pcall(func, ...))
    local ok = packed[1]
    local record = {
        label = label,
        available = true,
        ok = ok and true or false,
    }

    if not ok then
        -- Error text should not contain API secret values. Keep it bounded.
        record.error = tostring(packed[2]):sub(1, 300)
        return record
    end

    record.returns = {}
    for i = 2, packed.n do
        local value = packed[i]
        record.returns[#record.returns + 1] = {
            present = value ~= nil,
            secret = value ~= nil and isSecret(value) or false,
            value = cleanScalar(value),
        }
    end
    return record
end

local function restrictionStates()
    local result = {}
    if not C_RestrictedActions
        or type(C_RestrictedActions.GetAddOnRestrictionState) ~= "function"
        or not Enum
        or not Enum.AddOnRestrictionType
    then
        result.available = false
        return result
    end

    result.available = true
    local names = {
        "Combat",
        "Encounter",
        "ChallengeMode",
        "PvPMatch",
        "Map",
        "Chat",
    }

    for index, name in ipairs(names) do
        local enumValue = Enum.AddOnRestrictionType[name]
        if enumValue ~= nil then
            result[name] = callRecord(
                "restriction:" .. name,
                C_RestrictedActions.GetAddOnRestrictionState,
                enumValue
            )
        else
            result[name] = {
                available = false,
                ok = false,
                error = "enum unavailable",
            }
        end
    end
    return result
end

local displayProbe = CreateFrame("Frame", nil, UIParent)
displayProbe:SetSize(1, 1)
displayProbe:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
displayProbe:SetAlpha(0.001)

local alphaProbe = displayProbe:CreateTexture(nil, "BACKGROUND")
alphaProbe:SetAllPoints(displayProbe)
alphaProbe:SetColorTexture(1, 0, 0, 1)

local barProbe = CreateFrame("StatusBar", nil, displayProbe)
barProbe:SetAllPoints(displayProbe)
barProbe:SetMinMaxValues(0, 1)
barProbe:SetStatusBarTexture("Interface/Buttons/WHITE8x8")

local textProbe = displayProbe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textProbe:SetPoint("CENTER")

local function displayPathProbe(unit)
    local result = {
        unit = unit,
        health = {},
        power = {},
    }

    if type(UnitHealthPercent) == "function" then
        local hp = pack(pcall(UnitHealthPercent, unit))
        result.health.raw_ok = hp[1] and true or false
        if hp[1] then
            result.health.raw_secret = hp[2] ~= nil and isSecret(hp[2]) or false

            local okFmt, formatted = pcall(string.format, "%.0f%%", hp[2])
            result.health.format_ok = okFmt and true or false
            if okFmt then
                result.health.formatted_secret = isSecret(formatted)
                result.health.set_text_ok = pcall(textProbe.SetText, textProbe, formatted)
            end
        else
            result.health.raw_error = tostring(hp[2]):sub(1, 300)
        end

        if CurveConstants and CurveConstants.ZeroToOne then
            local h01 = pack(
                pcall(UnitHealthPercent, unit, true, CurveConstants.ZeroToOne)
            )
            result.health.zero_to_one_ok = h01[1] and true or false
            if h01[1] then
                result.health.zero_to_one_secret =
                    h01[2] ~= nil and isSecret(h01[2]) or false
                result.health.set_bar_ok =
                    pcall(barProbe.SetValue, barProbe, h01[2])
                result.health.set_alpha_ok =
                    pcall(alphaProbe.SetAlpha, alphaProbe, h01[2])
            else
                result.health.zero_to_one_error =
                    tostring(h01[2]):sub(1, 300)
            end
        else
            result.health.zero_to_one_ok = false
            result.health.zero_to_one_error = "CurveConstants.ZeroToOne unavailable"
        end


if vignetteCurve then
    local vignette = pack(
        pcall(UnitHealthPercent, unit, true, vignetteCurve)
    )
    result.health.vignette_curve_ok = vignette[1] and true or false
    if vignette[1] then
        result.health.vignette_curve_secret =
            vignette[2] ~= nil and isSecret(vignette[2]) or false
        result.health.vignette_set_bar_ok =
            pcall(barProbe.SetValue, barProbe, vignette[2])
        result.health.vignette_set_alpha_ok =
            pcall(alphaProbe.SetAlpha, alphaProbe, vignette[2])
    else
        result.health.vignette_curve_error =
            tostring(vignette[2]):sub(1, 300)
    end
else
    result.health.vignette_curve_ok = false
    result.health.vignette_curve_error =
        vignetteCurveStatus.error or "vignette curve unavailable"
end
    else
        result.health.raw_ok = false
        result.health.raw_error = "UnitHealthPercent unavailable"
    end

    if type(UnitPowerPercent) == "function" then
        local pp = pack(pcall(UnitPowerPercent, unit))
        result.power.raw_ok = pp[1] and true or false
        if pp[1] then
            result.power.raw_secret = pp[2] ~= nil and isSecret(pp[2]) or false
            local okFmt, formatted = pcall(string.format, "%.0f%%", pp[2])
            result.power.format_ok = okFmt and true or false
            if okFmt then
                result.power.formatted_secret = isSecret(formatted)
                result.power.set_text_ok = pcall(textProbe.SetText, textProbe, formatted)
            end
        else
            result.power.raw_error = tostring(pp[2]):sub(1, 300)
        end
    else
        result.power.raw_ok = false
        result.power.raw_error = "UnitPowerPercent unavailable"
    end

    return result
end

local function mapState()
    local result = {}
    result.best_map = callRecord(
        "C_Map.GetBestMapForUnit",
        C_Map and C_Map.GetBestMapForUnit,
        "player"
    )

    local mapID
    if C_Map and type(C_Map.GetBestMapForUnit) == "function" then
        local ok, value = pcall(C_Map.GetBestMapForUnit, "player")
        if ok and value ~= nil and not isSecret(value) then
            mapID = value
        end
    end

    if mapID and C_Map and type(C_Map.GetPlayerMapPosition) == "function" then
        local ok, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
        result.position_call_ok = ok and true or false
        result.position_present = ok and pos ~= nil or false
        result.position_secret = ok and pos ~= nil and isSecret(pos) or false
        if ok and pos and type(pos.GetXY) == "function" then
            local xy = pack(pcall(pos.GetXY, pos))
            result.position_xy_ok = xy[1] and true or false
            if xy[1] then
                result.position_x_secret = xy[2] ~= nil and isSecret(xy[2]) or false
                result.position_y_secret = xy[3] ~= nil and isSecret(xy[3]) or false
                if not result.position_x_secret then result.position_x = cleanScalar(xy[2]) end
                if not result.position_y_secret then result.position_y = cleanScalar(xy[3]) end
            end
        end
    else
        result.position_call_ok = false
        result.position_present = false
        result.position_error = "no non-secret mapID"
    end

    result.facing = callRecord("GetPlayerFacing", GetPlayerFacing)
    return result
end

local function cameraState()
    local result = {
        zoom = callRecord("GetCameraZoom", GetCameraZoom),
        cvars = {},
    }

    local cvarGetter = (C_CVar and C_CVar.GetCVar) or GetCVar
    local cvars = {
        "cameraDistanceMaxZoomFactor",
        "cameraZoomSpeed",
        "cameraFov",
        "test_cameraOverShoulder",
        "test_cameraDynamicPitch",
        "test_cameraTargetFocusEnemyEnable",
        "test_cameraTargetFocusInteractEnable",
    }

    for _, name in ipairs(cvars) do
        result.cvars[name] = callRecord("cvar:" .. name, cvarGetter, name)
    end
    return result
end

local function targetState()
    return {
        exists = UnitExists("target") and true or false,
        level = callRecord("UnitLevel(target)", UnitLevel, "target"),
        classification = callRecord(
            "UnitClassification(target)",
            UnitClassification,
            "target"
        ),
        pvp = callRecord("UnitIsPVP(target)", UnitIsPVP, "target"),
        health_display = displayPathProbe("target"),
    }
end

local function castState(unit)
    return {
        casting = callRecord("UnitCastingInfo(" .. unit .. ")", UnitCastingInfo, unit),
        channel = callRecord("UnitChannelInfo(" .. unit .. ")", UnitChannelInfo, unit),
    }
end

local function chatState()
    return {
        messaging_lockdown = callRecord(
            "C_ChatInfo.InChatMessagingLockdown",
            C_ChatInfo and C_ChatInfo.InChatMessagingLockdown
        ),
    }
end

local function snapshot(reason)
    if not LogresAPIAuditDB then
        return
    end

    local version, build, date, interfaceVersion = GetBuildInfo()
    local inInstance, instanceType = IsInInstance()

    local row = {
        reason = reason or "manual",
        time = date and time and time() or nil,
        build = {
            version = cleanScalar(version),
            build = cleanScalar(build),
            interfaceVersion = cleanScalar(interfaceVersion),
            wowProjectID = cleanScalar(WOW_PROJECT_ID),
            wowProjectMainline = cleanScalar(WOW_PROJECT_MAINLINE),
            project_equals_mainline =
                WOW_PROJECT_ID ~= nil
                and WOW_PROJECT_MAINLINE ~= nil
                and WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
                or false,
        },
        state = {
            combat_lockdown = callRecord("InCombatLockdown", InCombatLockdown),
            pvp = callRecord("UnitIsPVP(player)", UnitIsPVP, "player"),
            inInstance = cleanScalar(inInstance),
            instanceType = cleanScalar(instanceType),
        },
        restrictions = restrictionStates(),
        vignette_curve_status = {
            available = vignetteCurveStatus.available,
            ok = vignetteCurveStatus.ok,
            error = vignetteCurveStatus.error,
        },
        player_display = displayPathProbe("player"),
        target = targetState(),
        casts = {
            player = castState("player"),
            target = castState("target"),
        },
        map = mapState(),
        chat = chatState(),
        camera = cameraState(),
        api_presence = {
            UnitHealthPercent = type(UnitHealthPercent) == "function",
            UnitPowerPercent = type(UnitPowerPercent) == "function",
            UnitLevel = type(UnitLevel) == "function",
            UnitClassification = type(UnitClassification) == "function",
            UnitCastingInfo = type(UnitCastingInfo) == "function",
            UnitChannelInfo = type(UnitChannelInfo) == "function",
            GetPlayerFacing = type(GetPlayerFacing) == "function",
            IsInInstance = type(IsInInstance) == "function",
            InCombatLockdown = type(InCombatLockdown) == "function",
            issecretvalue = type(issecretvalue) == "function",
            GetCameraZoom = type(GetCameraZoom) == "function",
            QuestNextWaypoint =
                C_QuestLog and type(C_QuestLog.GetNextWaypoint) == "function" or false,
            ChatLockdown =
                C_ChatInfo and type(C_ChatInfo.InChatMessagingLockdown) == "function" or false,
            RestrictedActions =
                C_RestrictedActions
                and type(C_RestrictedActions.GetAddOnRestrictionState) == "function"
                or false,
        },
    }

    table.insert(LogresAPIAuditDB.snapshots, row)
    while #LogresAPIAuditDB.snapshots > MAX_SNAPSHOTS do
        table.remove(LogresAPIAuditDB.snapshots, 1)
    end

    LogresAPIAuditDB.lastReason = reason
    LogresAPIAuditDB.schema = 1
end

local function printStatus()
    local count = LogresAPIAuditDB and #LogresAPIAuditDB.snapshots or 0
    local _, _, _, interfaceVersion = GetBuildInfo()
    local inInstance, instanceType = IsInInstance()
    print(
        string.format(
            "LogresAPIAudit: snapshots=%d interface=%s projectID=%s mainline=%s combat=%s pvp=%s instance=%s/%s",
            count,
            tostring(interfaceVersion),
            tostring(WOW_PROJECT_ID),
            tostring(WOW_PROJECT_MAINLINE),
            tostring(InCombatLockdown()),
            tostring(UnitIsPVP("player")),
            tostring(inInstance),
            tostring(instanceType)
        )
    )
end

SLASH_LOGRESAPIAUDIT1 = "/lapi"
SlashCmdList.LOGRESAPIAUDIT = function(msg)
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")
    if msg == "" or msg == "status" then
        printStatus()
    elseif msg == "snapshot" then
        snapshot("manual")
        print("LogresAPIAudit: snapshot recorded.")
        printStatus()
    elseif msg == "clear" then
        LogresAPIAuditDB.snapshots = {}
        print("LogresAPIAudit: snapshots cleared.")
    else
        print("LogresAPIAudit commands: /lapi status | snapshot | clear")
    end
end

local automaticEvents = {
    "PLAYER_LOGIN",
    "PLAYER_ENTERING_WORLD",
    "ZONE_CHANGED_NEW_AREA",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_FLAGS_CHANGED",
    "PLAYER_TARGET_CHANGED",
    "UNIT_SPELLCAST_START",
    "UNIT_SPELLCAST_STOP",
    "UNIT_SPELLCAST_CHANNEL_START",
    "UNIT_SPELLCAST_CHANNEL_STOP",
    "ADDON_RESTRICTION_STATE_CHANGED",
}

frame:RegisterEvent("ADDON_LOADED")
for _, event in ipairs(automaticEvents) do
    pcall(frame.RegisterEvent, frame, event)
end

frame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local loaded = ...
        if loaded ~= addonName then
            return
        end
        LogresAPIAuditDB = LogresAPIAuditDB or {}
        LogresAPIAuditDB.schema = 1
        LogresAPIAuditDB.snapshots = LogresAPIAuditDB.snapshots or {}
        print("LogresAPIAudit loaded. Use /lapi status or /lapi snapshot.")
        return
    end

    if not LogresAPIAuditDB then
        return
    end

    if event == "PLAYER_FLAGS_CHANGED" then
        local unit = ...
        if unit ~= "player" then
            return
        end
    elseif event:match("^UNIT_SPELLCAST") then
        local unit = ...
        if unit ~= "player" and unit ~= "target" then
            return
        end
    end

    snapshot(event)
end)
