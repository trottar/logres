local root=assert(arg[1])
local Logres={}
local SECRET=setmetatable({},{__tostring=function()error('opaque point inspected')end})
issecretvalue=function(v)return rawequal(v,SECRET)end
assert(loadfile(root..'/Logres/HUD/NativeDebuffs.lua'))('Logres',Logres)
local native=Logres.NativeDebuffs
assert(type(native.ClaimNameplateAuraLayout)=='function','missing reversible layout implementation')
local writes=0
local function region()
 local r={points={{'TOP',SECRET,'BOTTOM',SECRET,SECRET},{'LEFT',SECRET,'RIGHT',SECRET,SECRET}}}
 function r:IsProtected()return self.protected or false end
 function r:IsForbidden()return self.forbidden or false end
 function r:GetNumPoints()return self.secretCount and SECRET or #self.points end
 function r:GetPoint(i)if self.captureRefused then error('capture refused')end;return table.unpack(self.points[i],1,5)end
 function r:ClearAllPoints()writes=writes+1;self.points={}end
 function r:SetPoint(p,rel,rp,x,y)
  if self.failMove and p=='LEFT' and not rawequal(rel,SECRET) then error('placement refused')end
  if self.failRestore and rawequal(rel,SECRET)then error('restore refused')end
  writes=writes+1;self.points[#self.points+1]={p,rel,rp,x,y}
 end
 return r
end
local a,b,parent=region(),region(),{}
local claim,ok,why=native.ClaimNameplateAuraLayout(a,b,parent)
assert(ok,why);assert(a.points[1][1]=='RIGHT' and a.points[1][4]==-25)
assert(b.points[1][1]=='LEFT' and b.points[1][4]==25)
assert(native.RestoreNameplateAuraLayout(claim))
assert(#a.points==2 and rawequal(a.points[1][2],SECRET) and rawequal(a.points[1][4],SECRET))
print('PASS two native lists placed in +/-25 lanes; all original points restored opaquely')
for _,kind in ipairs({'protected','forbidden','secretCount','captureRefused'})do
 a,b=region(),region();a[kind]=true;local before=writes
 claim,ok=native.ClaimNameplateAuraLayout(a,b,parent)
 assert(not ok and claim==nil and writes==before,kind)
end
print('PASS protected/forbidden/secret-count/capture refusals perform zero writes')
a,b=region(),region();b.failMove=true
claim,ok,why=native.ClaimNameplateAuraLayout(a,b,parent)
assert(not ok and not claim and why=='native-aura-layout-refused-restored')
assert(#a.points==2 and #b.points==2)
print('PASS partial move failure restores BOTH lists')
a,b=region(),region();b.failMove=true;a.failRestore=true
claim,ok,why=native.ClaimNameplateAuraLayout(a,b,parent)
assert(not ok and claim and why=='native-aura-layout-restore-pending')
a.failRestore=false;assert(native.RestoreNameplateAuraLayout(claim))
print('PASS restoration refusal retains exact tokens for retry')
a,b=region(),region();a.points={};b.points={}
claim,ok=native.ClaimNameplateAuraLayout(a,b,parent)
assert(ok and native.RestoreNameplateAuraLayout(claim));assert(#a.points==0 and #b.points==0)
print('PASS original zero-anchor layout restored without inventing points')
a,b=region(),region();claim,ok=native.ClaimNameplateAuraLayout(a,b,parent);assert(ok)
a.protected=true;local before=writes
assert(not native.RestoreNameplateAuraLayout(claim));assert(writes>before)
a.protected=false;assert(native.RestoreNameplateAuraLayout(claim))
print('PASS capability lost during ownership defers that region and permits later restoration')
print('P0463 aura source tests PASS (ordinary fixtures; client appearance UNVERIFIED)')
