-- Actual production Dialogue, narrative pager, and native suppression adapter.
local root = arg[0]:gsub('tools/test_p0513_incomplete_progress.lua$', '')
local modules, journal = {}, {}
local Logres = {
    Theme={panelSurface={colors={}},questOfferControls={colors={},y=0,height=38}},
    PanelConfigs={quest={presentation={height=330, colors={pageActive={1,1,1,1},pageInactive={1,1,1,1}}}}},
}
function Logres:RegisterModule(name) local m={};modules[name]=m;return m end
function Logres:GetModule(name) return modules[name] end
function Logres:TraceEvent(domain, action, fields) journal[#journal+1]={action=action,fields=fields} end
local secret = {}
function issecretvalue(value) return value == secret end
local combat, ready, questID, missing, secretRow, money, quantity = false,false,92742,false,false,0,1
local continueCalls, closeCalls, bags = 0,0,0
function InCombatLockdown() return combat end
function GetQuestID() return questID end
function GetTitleText() return 'Testing the Wells' end
function GetProgressText() return 'Did you collect the samples?' end
function IsQuestCompletable() return ready end
function GetNumQuestItems() return 3 end
function GetQuestMoneyToGet() return money end
function GetQuestItemInfo(kind,index)
    assert(kind=='required')
    if secretRow and index==2 then return secret, nil, 1 end
    if missing and index==2 then return nil end
    return ({'Jansen Stead Water Sample','Molsen Farm Water Sample','Well Water Sample Kit'})[index],nil,quantity,nil,nil,400+index
end
function GetItemCount(id, bank, uses)
    assert(id>=401 and id<=403 and bank==false and uses==false)
    return bags
end
function CloseQuest()
    assert(QuestFrame.alpha==0.8 and QuestFrame.mouse, 'stock restored before native close')
    closeCalls=closeCalls+1
end
function QuestProgressCompleteButton_OnClick() continueCalls=continueCalls+1 end
local timers={}
C_Timer={After=function(n,fn) timers[#timers+1]=fn end}
local function frame()
    local f={shown=true,alpha=0.8,mouse=true,protected=false,level=5,children={}}
    function f:IsShown()return self.shown end
    function f:IsEnabled()return self.enabled end
    function f:IsProtected()return self.protected end
    function f:GetChildren()return table.unpack(self.children) end
    function f:GetAlpha()return self.alpha end
    function f:SetAlpha(a)self.alpha=a end
    function f:IsMouseEnabled()return self.mouse end
    function f:EnableMouse(v)self.mouse=v end
    function f:Hide()self.shown=false end
    function f:Show()self.shown=true end
    function f:SetHeight(v)self.height=v end
    function f:GetFrameLevel()return self.level end
    function f:SetFrameLevel(v)self.level=v end
    function f:ClearAllPoints()end
    function f:SetPoint(...)self.point={...} end
    function f:ClearText()self.text=nil end
    function f:SetText(v)self.text=v end
    function f:SetFormattedText(fmt,...)self.text=fmt:format(...) end
    function f:SetVertexColor(...)end
    return f
end
QuestFrame=frame();QuestFrameProgressPanel=frame();QuestFrameCompleteButton=frame()
local extra=frame();extra.mouse=false
QuestFrame.children={QuestFrameProgressPanel,QuestFrameCompleteButton,extra}
QuestFrameCompleteButton.enabled=false
assert(loadfile(root..'Logres/UI/NarrativePages.lua'))('Logres',Logres)
assert(loadfile(root..'Logres/Quest/OfferStockSuppression.lua'))('Logres',Logres)
assert(loadfile(root..'Logres/Quest/Dialogue.lua'))('Logres',Logres)
local Dialogue=modules.QuestDialogue
local stock=modules.QuestOfferStockSuppression
local function fresh()
    QuestFrame.alpha=0.8;QuestFrame.mouse=true;QuestFrame.shown=true
    QuestFrameProgressPanel.mouse=true;QuestFrameProgressPanel.shown=true
    QuestFrameCompleteButton.mouse=true;QuestFrameCompleteButton.shown=true
    QuestFrameCompleteButton.enabled=ready;extra.mouse=false;extra.protected=false
    local d=setmetatable({moduleEnabled=true,immersionEnabled=true,progressEventCount=0,
        progressSkippedCount=0,progressShownCount=0,presentationCount=0,suppressedCount=0,
        presentationGeneration=0,progressContinueSerial=0,goodbyeClicks=0,
        eventRegistration={QUEST_LOG_UPDATE=true,PLAYER_REGEN_DISABLED=true},
        pages={},currentPage=0,root=frame(),offerActionRoot=frame(),acceptButton=frame(),declineButton=frame(),
        pageIndicator=frame(),previousButton=frame(),nextButton=frame(),previousTexture=frame(),nextTexture=frame(),
        titleText=frame(),bodyText=frame(),objectiveHeader=frame(),objectiveText=frame(),offerActionFeedback=frame(),
        RequestStockOfferSuppression=function()return false,'fixture-stock-offer-unowned' end,
    },{__index=Dialogue})
    d.acceptButton.label=frame()
    return d
end
local function assertNative()
    assert(QuestFrame.alpha==0.8 and QuestFrame.mouse and QuestFrameProgressPanel.mouse and QuestFrameCompleteButton.mouse)
    assert(extra.mouse==false, 'original false input token preserved')
end
local d=fresh();d:HandleQuestProgress()
assert(d.progressActive and d.progressOwned and d.progressReadOnly and d.presentationShown)
assert(d.lastProgressReason=='logres-incomplete-progress-owned')
assert(QuestFrame.alpha==0 and not QuestFrame.mouse and not QuestFrameCompleteButton.mouse)
local text=table.concat(d.pages,' ')
assert(text:find('Testing the Wells',1,true)==nil) -- title rendered separately
assert(d.titleText.text=='Testing the Wells')
assert(text:find('Did you collect the samples?',1,true))
assert(text:find('1 x Jansen Stead Water Sample (bags: 0)',1,true))
assert(text:find('1 x Molsen Farm Water Sample (bags: 0)',1,true))
assert(text:find('1 x Well Water Sample Kit (bags: 0)',1,true))
assert(text:find('Not ready to turn in.',1,true))
d:SetPage(#d.pages)
assert(d.acceptButton.label.text=='View in Blizzard' and d.offerActionRoot.shown and not d.declineButton.shown)
assert(not d.progressContinuePending and #timers==0)
d:CheckIncompleteProgressChanged('QUEST_LOG_UPDATE')
assert(d.progressOwned and QuestFrame.alpha==0, 'unchanged event cannot dismiss/recapture')
assert(d:HandleProgressContinue());assertNative();assert(not d.presentationShown and not d.progressReadOnly)
assert(continueCalls==0 and closeCalls==0 and #timers==0)
-- Goodbye invokes the existing native cancel/close API only after restoration.
d=fresh();d:HandleQuestProgress();assert(d:Goodbye());assertNative();assert(closeCalls==1 and continueCalls==0)
-- Ready/changed/combat or unknown requirement sources fail open, never dispatch Continue.
d=fresh();d:HandleQuestProgress();ready=true;QuestFrameCompleteButton.enabled=true
d:CheckIncompleteProgressChanged('QUEST_LOG_UPDATE');assertNative();assert(not d.progressReadOnly)
ready=false
d=fresh();d:HandleQuestProgress();bags=2;d:CheckIncompleteProgressChanged('BAG_UPDATE_DELAYED');assertNative();assert(not d.presentationShown)
bags=0
d=fresh();d:HandleQuestProgress();combat=true;d:CheckIncompleteProgressChanged('PLAYER_REGEN_DISABLED');assertNative();combat=false
missing=true;d=fresh();d:HandleQuestProgress();assertNative();assert(not d.presentationShown and not d.progressOwned);missing=false
secretRow=true;d=fresh();d:HandleQuestProgress();assertNative();assert(not d.presentationShown and not d.progressOwned);secretRow=false
ready=secret;d=fresh();d:HandleQuestProgress();assertNative();assert(not d.presentationShown and not d.progressOwned);ready=false
money=124;d=fresh();d:HandleQuestProgress();assert(table.concat(d.pages,' '):find('Required money: 0g 1s 24c.',1,true));d:HidePresentation('fixture');assertNative();money=0
-- A protected descendant prevents suppression even with valid source data.
d=fresh();extra.protected=true;d:HandleQuestProgress();assertNative();assert(not d.presentationShown and not d.progressOwned)
-- Ready path still owns Continue and enters its original single native handoff.
ready=true;d=fresh();d:HandleQuestProgress();assert(d.progressOwned and not d.progressReadOnly)
assert(d.acceptButton.label.text=='Continue' and QuestFrame.alpha==0)
assert(d:HandleProgressContinue());assert(continueCalls==1 and d.progressContinuePending and #timers==1)
timers[1]();assertNative();assert(not d.presentationShown)
print('P0513 actual-source incomplete progress: PASS (requirements, ownership, fallback, Goodbye, secret/protected, changes, original Continue)')
