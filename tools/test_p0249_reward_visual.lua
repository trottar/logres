local function widget()
  local obj = {}
  setmetatable(obj,{__index=function(t,k)
    if k == 'CreateTexture' or k == 'CreateFontString' then
      return function() return widget() end
    end
    if k == 'SetText' then
      return function(self,x) self.lastText=x end
    end
    if k == 'SetHeight' then
      return function(self,x) self.height=x end
    end
    if k == 'SetTexture' then
      return function(self,x) self.texture=x end
    end
    return function() end
  end})
  return obj
end
local namespace = {}
_G.CreateFrame = function(...) return widget() end
local chunk=assert(loadfile(arg[1]))
chunk('Logres',namespace)
local root,footer=widget(),widget()
local instance=namespace.QuestRewardVisual.New(root,footer)
assert(type(instance.Reset)=='function','instance Reset missing')
assert(type(instance.Present)=='function','instance Present missing')
instance:Reset()
assert(root.height==320,'Reset root height')
local cards={{kind='reward',name='Test Potion',quantity=3,icon='myicon'}, {kind='choice',name='Choose Gloves',quantity=1,icon='myicon2'}}
assert(instance:Present(cards,'50 XP | 7s')==true,'Present return')
assert(instance.slots[1].label.lastText=='Test Potion','name missing')
assert(instance.slots[1].count.lastText=='x3','quantity missing')
assert(instance.slots[2].label.lastText=='CHOICE  Choose Gloves','choice label missing')
assert(instance.slots[2].count.lastText=='','choice count incorrect')
assert(footer.lastText=='50 XP | 7s','footer missing')
instance:Reset()
assert(root.height==320,'Reset after render')
print('PASS P0249 Lua instance dispatch and two-card render/reset')
