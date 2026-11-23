-- P0511 actual-source focused tracker layout fixture, not an in-game PASS.
local root=assert(arg[1],"need repo path")
local modules={ QuestObjectiveProgress={ NormalizeObjectiveLabel=function(_,row) return row.text end } }
local L={Theme={}}
function L:RegisterModule(name,option)
 local t={};modules[name]=t;return t
end
function L:GetModule(name) return assert(modules[name],name) end
local env=setmetatable({issecretvalue=function(_)return false end},{__index=_G})
assert(loadfile(root.."/Logres/Quest/ActiveQuest.lua","t",env))(nil,L)
local A=modules.ActiveQuest
local function widget()
 local o={shown=false}
 function o:Show()self.shown=true end
 function o:Hide()self.shown=false end
 function o:SetText(s)self.text=s end
 function o:ClearText()self.text=nil end
 function o:SetHeight(h)self.height=h end
 function o:SetPoint(_,_,_,_,y)self.y=y end
 function o:ClearAllPoints()self.y=nil end
 function o:GetLineHeight()return 13 end
 function o:GetStringHeight()
  local n=math.ceil(#(self.text or "")/25)
  return math.max(1,math.min(5,n))*13
 end
 function o:SetTextColor() end
 function o:SetVertexColor() end
 function o:SetColorTexture() end
 function o:SetValue(v)self.value=v end
 function o:SetStatusBarColor() end
 return o
end
local function rowwidgets()
 local w={hit=widget(),hover=widget(),label=widget(),unknown=widget()}
 w.bar=widget();w.bar.status=widget();w.bar.leftDiamond=widget();w.bar.rightDiamond=widget()
 return w
end
A.root=widget();A.title=widget();A.ambient=widget();A.glyph=widget();A.divider=widget()
A.completionRule=widget();A.completionSeal=widget();A.cycleButton=widget();A.rows={}
for i=1,8 do A.rows[i]=rowwidgets() end
A.presentationCount=0
local function sample(n,required)
 return {text=string.rep("t",n),required=required or 2,fulfilled=1,finished=false}
end
local function render(rows)
 return assert(A:Render({title="long text fixture",preview=true,rows=rows,source="test"},"fixture"))
end
render({sample(95),sample(6,1),sample(125),sample(200)})
assert(A.rows[1].hit.height>42, "four-line row must expand")
assert(A.rows[2].hit.height==42,"short binary row must stay compact")
assert(A.rows[3].hit.height>A.rows[2].hit.height,"five-line row must expand")
assert(A.rows[4].label.height<=68, "long objective must cap at five 13px lines")
assert(A.rows[2].hit.y==A.rows[1].hit.y-A.rows[1].hit.height-6,"second row top must follow first")
assert(A.rows[3].hit.y==A.rows[2].hit.y-A.rows[2].hit.height-6,"third row must follow binary row")
local heightLong=A.root.height
render({sample(5),sample(7)})
assert(A.root.height<heightLong,"switching quest must shrink root")
assert(A.rows[1].hit.height==42 and A.rows[2].hit.height==42,"short rows should revert")
assert(not A.rows[3].hit.shown and not A.rows[4].label.shown,"previous rows must hide")
assert(A.rows[2].hit.y==A.rows[1].hit.y-48,"short row pitch restored")
render({})
assert(A.root.height==136,"no objectives uses existing min height")
print("P0511 actual-source PASS: bounded wrap, binary progress, adaptive height/anchors, shrink/reuse, empty")
