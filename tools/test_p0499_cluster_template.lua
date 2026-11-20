-- P0499 actual-source cluster constructor remains unchanged; independent
-- restricted handlers are assembled separately by ActionContext.
local path = arg[0]:gsub('tools/test_p0499_cluster_template.lua$', '')
local logres = {Theme = {action = {buttonSize=42, buttonGap=5}}}
local creations = {}
UIParent = {}
function CreateFrame(kind, name, parent, template)
    local root = {kind=kind, name=name, parent=parent, template=template}
    function root:SetSize(w, h) self.width=w;self.height=h end
    function root:SetPoint(...) self.point={...} end
    function root:SetFrameStrata(value) self.strata=value end
    function root:SetAlpha(value) self.alpha=value end
    creations[#creations+1] = root
    return root
end
assert(loadfile(path..'Logres/Actions/Button.lua'))('Logres', logres)
for _, bar in ipairs({'primary','secondary','utility','bar4','bar5','pet'}) do
    local root=logres.ActionButton.CreateCluster('LogresFixture'..bar, 2, 6, 17, -18, 0)
    assert(root.kind=='Frame' and root.parent==UIParent)
    assert(root.template==nil, 'original bar root constructor: '..bar)
    assert(root.width==89 and root.height==277, 'original layout footprint: '..bar)
    assert(root.alpha==0 and root.strata=='BACKGROUND', 'original visual style: '..bar)
end
assert(#creations==6,'no additional click surfaces')
print('P0499 actual-source unchanged cluster constructor: PASS')
