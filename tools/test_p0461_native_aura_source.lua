-- P0461 executable source-level behavior: protected native list remains
-- untouched despite a ready addon-world aura renderer. Tested off-client.
local root = assert(arg[1])
local function read(path)
    local file = assert(io.open(root .. "/" .. path, "rb"))
    local text = file:read("*a"); file:close(); return text
end
local function slice(src, before, after)
    local i = assert(src:find(before, 1, true), before)
    local j = assert(src:find(after, i + #before, true), after)
    return src:sub(i, j - 1)
end
local code = read("Logres/HUD/HUD.lua")
local statusCode = read("Logres/HUD/StatusAuras.lua")
local touched = {name=0, health=0, level=0, harmful=0, helpful=0}
local original = {}
local region = {}
for _, key in ipairs({"name", "health", "level", "harmful", "helpful"}) do
    local token = {} -- deliberately opaque restoration token
    original[key] = token
    region[key] = {
        GetAlpha=function() return token end,
        SetAlpha=function(_, new)
            touched[key] = touched[key] + 1
            if key == "harmful" or key == "helpful" then
                error("native aura list mutated: " .. key)
            end
            if key == "health" and region.failHealth then
                region.failHealth=false; error("refused-once") end
        end,
    }
end
local unitFrame = {name=region.name, HealthBarsContainer=region.health,
    LevelFrame=region.level,
    AurasFrame={DebuffListFrame=region.harmful, BuffListFrame=region.helpful}}
local anchor={UnitFrame=unitFrame}
local activeModule={moduleEnabled=true, worldEnemyNativeLanes={harmful={},helpful={}}}
local Logres={GetModule=function(_,name)
    if name == "StatusAuras" then return activeModule end
end}
local HUD={worldEnemyNativeClaim=nil, worldEnemyNativeAuraOwned=false,
    worldEnemyNativeAuraTransfers=0,worldEnemyNativeAuraRestores=0,
    worldEnemyNativeTransfers=0,worldEnemyNativeRestoreCount=0,
    worldEnemyNativeRestoreFailures=0}
local env={HUD=HUD,Logres=Logres,
    nativeDecorField=function(t,k) return t and t[k] or nil end,
    safeNativeDecor=function(v)
        return v and type(v.SetAlpha)=="function" and type(v.GetAlpha)=="function"
    end}
setmetatable(env,{__index=_G})
assert(load(slice(code,"function HUD:RestoreNativeEnemyDecor()",
    "-- P0459: every safely observed hostile"),"P0461-hud","t",env))()
local ok,why=HUD:ClaimNativeEnemyDecor(anchor)
assert(ok and why=="decor-owned")
assert(HUD.worldEnemyNativeAuraSourceCapable==true)
assert(HUD.worldEnemyNativeAuraOwned==false)
assert(HUD.worldEnemyNativeAuraTransfers==0)
assert(touched.name==1 and touched.health==1 and touched.level==1)
assert(touched.harmful==0 and touched.helpful==0)
assert(HUD:RestoreNativeEnemyDecor())
assert(touched.name==2 and touched.health==2 and touched.level==2)
assert(touched.harmful==0 and touched.helpful==0)
assert(HUD.worldEnemyNativeAuraSourceCapable==false)
-- Missing native list means do not suppress the screen aura fallback.
unitFrame.AurasFrame={BuffListFrame=region.helpful}
assert(HUD:ClaimNativeEnemyDecor(anchor))
assert(HUD.worldEnemyNativeAuraSourceCapable==false)
assert(HUD:RestoreNativeEnemyDecor())
-- Refusal after a partial health/name mutation still restores ordinary
-- name/health values and never captures/mutates stock aura lists.
region.failHealth=true
local success,reason=HUD:ClaimNativeEnemyDecor(anchor)
assert(success==false and reason=="native-decor-mutation-refused")
assert(HUD.worldEnemyNativeClaim==nil and touched.harmful==0)
region.failHealth=false
-- Screen handoff must require structural stock nameplate aura support.
local attach = slice(code,"function HUD:RefreshLiveWorldEnemy(event, eventUnit)",
    "function HUD:SetLiveWorldEnemy(enabled)")
local start=assert(attach:find("    if self.worldEnemyNativeAuraSourceCapable",1,true))
local finish=assert(attach:find("    self.worldEnemyScreenHandoffs",start,true))
local screenOwner=assert(load("return function(self,auras)\n"..
    attach:sub(start,finish-1).."end","P0461-screen","t",env))()
local screen={count=0,SetWorldEnemyScreenAuraHandoff=function(self,owned)
    assert(owned==true); self.count=self.count+1;return true
end}
HUD.worldEnemyNativeAuraSourceCapable=false
screenOwner(HUD,screen); assert(screen.count==0)
HUD.worldEnemyNativeAuraSourceCapable=true
screenOwner(HUD,screen); assert(screen.count==1)
-- The native world renderer can still be present in historical code,
-- but no longer invoked during live lane setup.
local created=0
local status={moduleEnabled=true,preview=false,
    last={target={harmfulRows={{icon="ordinary"}}, helpfulRows={{icon="ordinary"}}}},
    worldEnemyLiveRenderAttempts=0,worldEnemyLiveFailures=0}
local laneCalls=0
local envStatus={StatusAuras=status,Logres={NativeDebuffs={CreateWorldEnemyLanes=function()
    created=created+1;error("unproven duplicate native world renderer")
end},GetModule=function(_,name) if name=="HUD" then
    return {worldEnemyLiveVisible=true} end end},
    createLane=function() return {visible=0,root={IsShown=function()return false end}} end,
    renderLane=function(lane,rows,visible)
        assert(#rows==0 and visible==false)
        laneCalls=laneCalls+1
    end}
setmetatable(envStatus,{__index=_G})
assert(load(slice(statusCode,"function StatusAuras:CreateWorldEnemyLiveLanes(parent)",
    "function StatusAuras:RefreshWorldEnemyLiveSource(reason)"),
    "P0461-status","t",envStatus))()
local frames=status:CreateWorldEnemyLiveLanes({})
assert(frames and status.worldEnemyNativeLanes==nil)
assert(created==0 and status.worldEnemyNativeReason=="stock-nameplate-native-preserved")
assert(status:RefreshWorldEnemyLiveLanes())
assert(laneCalls==2 and status.worldEnemyLiveRenderLastResult=="stock-nameplate-native-delegated")
print("P0461 LUA PASS: selected native lists untouched, opaque restore and refusal, guarded screen fallback, duplicate lanes inactive")
