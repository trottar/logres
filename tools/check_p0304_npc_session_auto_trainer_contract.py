#!/usr/bin/env python3
"""P0304: service-neutral NPC lifecycle; auto trainer opens without native hiding."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding='utf-8')
s = read('Logres/UI/NPCServiceSession.lua')
v = read('Logres/Quest/TrainerLiveTrial.lua')
t = read('Logres/Quest/TrainerPurchaseTrial.lua')
c = read('Logres/UI/NPCServiceCatalogue.lua')
l = read('Logres/Quest/TrainerLandscape.lua')
toc = read('Logres/Logres.toc')
cur = read('docs/memory/CURRENT.md')
e = read('docs/memory/evidence/P0304_NPC_SESSION_AUTO_TRAINER.md')
prev = read('tools/check_p0303_npc_service_catalogue_contract.py')
problems = []
def need(cond, why):
    if not cond: problems.append(why)
for x in (
    'Logres.NPCServiceSession = Session',
    'function Session.Register(key, spec)',
    'function Session.TryOpen(key, reason)',
    'function Session.Reconcile(reason)',
    'function Session.Dismiss(key)',
    'function Session.GetAudit()',
    'function Session.GetAudit()',
    'Logres:SubscribeState(function()',
    'Logres:RegisterEvent("ADDON_LOADED", function(_, name)',
    'pcall(hook, root, "OnShow", function()',
    'Session.TryOpen(key, "native-onshow")',
    'if read(root, "IsProtected") ~= false then return nil end',
    'if not root or read(root, "IsShown") ~= true then',
    'if not spec or not spec.automatic or dismissed[key] or not matches(spec)',
    'local ok, shown = pcall(spec.open, reason or "native-shown")',
    'Session.Register("trainer", {',
    'interactionType=7, nativeFrame="ClassTrainerFrame"',
    'loadedAddon="Blizzard_TrainerUI", automatic=true',
    'open=function() return Logres.NPCTrainerLiveTrial.Toggle("on") end',
    'close=function(reason) return Logres.NPCTrainerLiveTrial.Disable(reason) end',
    'isVisible=function() return Logres.NPCTrainerLiveTrial.GetAudit().shown end',
    'nativePresentation="unchanged-stock-visible"',
): need(x in s, 'session lifecycle invariant missing: '+x)
need(s.count('Session.Register("trainer"') == 1, 'trainer registration must be single')
for forbidden in ('SetAlpha(', 'SetPoint(', 'SetParent(', 'HideUIPanel(',
    'ShowUIPanel(', 'ClearAllPoints(', 'EnableMouse(',
    'BuyTrainerService(', 'SelectTrainerService(', 'GetTrainerServiceInfo(',
    'SetScript("OnShow"', 'SetScript("OnUpdate"', 'C_Timer.',
    'hooksecurefunc(', 'DynamicCam', 'Camera\\'):
    need(forbidden not in s, 'shared lifecycle must not mutate native/UI/camera: '+forbidden)
for tok in (
    'function Trial.Disable(why)', 'browse.searchEdit:ClearFocus()',
    'if active then active:Hide(); active = nil end',
    'Logres.NPCServiceSession.Dismiss("trainer")',
    'why == "goodbye"', 'why == "trial-hidden"',
    'why == "native-purchase-requested-unconfirmed"',
    'why == "bulk-training-requested-unconfirmed"',
    'Logres.NPCServiceCatalogue.Filter(',
    'Logres.NPCServiceCatalogue.Window(',
    'Logres.NPCServiceCatalogue.Find(',
    'Logres.NPCTrainerPurchaseTrial.Attempt(',
    'Logres.NPCTrainerPurchaseTrial.AttemptAll(',
    'Trial.Disable("goodbye")',
): need(tok in v, 'trainer adapter/teardown regression: '+tok)
for x in ('function Catalogue.Filter(', 'function Catalogue.Window(',
          'function Catalogue.Find('):
    need(x in c, 'shared catalogue lost: '+x)
need('function Trial.AttemptAll(' in t and 'function Trial.Attempt(' in t,
     'single/bulk transaction guards unavailable')
need('return Landscape.Render(owner, Landscape.Fixture())' in l,
     'synthetic P fixture must remain inert')
need('P0303' in prev and 'NPCServiceCatalogue' in prev,
     'historical P0303 contract lost')
need('Quest\\TrainerComponents.lua\nQuest\\TrainerMotif.lua\nQuest\\TrainerLandscape.lua\nQuest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua' in toc,
     'trainer chain adjacency altered')
need('Quest\\NativeTrainerServiceProbe.lua\nUI\\NPCServiceCatalogue.lua\nQuest\\TrainerComponents.lua' in toc,
     'P0303 source/catelogue adjacency altered')
need('Core\\Lifecycle.lua\nUI\\NPCServiceSession.lua' in toc,
     'session must load after trainer and lifecycle without breaking prior adjacency')
for tok in ('P0303','P0304','PASS','UNVERIFIED','stock', 'default',
            'Goodbye','OnShow','gossip','merchant','flight'):
    need(tok.lower() in e.lower(), 'evidence missing '+tok)
headings = ('## Active Objective','## Current Work Item','## Verified State',
    '## Next Action','## Success Criteria','## Do Not Reopen Without New Evidence',
    '## Relevant References')
need(len(cur.encode('utf-8')) < 10000 and all(cur.splitlines().count(x)==1 for x in headings),
     'CURRENT.md missing mandatory heading or exceeds budget')
a = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1)==b.group(1)), 'runtime version mismatch')
print('P0304 event-driven NPC service session + default trainer entry contract')
for problem in problems: print('ERROR:', problem)
if problems: raise SystemExit(1)
print('PASS: shared lifecycle, bounded trainer auto entry, visit dismissal, stock visible, purchase unchanged')
