#!/usr/bin/env python3
"""P0498 preserves native input and prevents only verified stage handoff flash."""
from pathlib import Path
root=Path(__file__).resolve().parents[1]
d=(root/'Logres/Quest/Dialogue.lua').read_text()
c=(root/'Logres/Quest/CompletionControl.lua').read_text()
a=(root/'Logres/Actions/Context.lua').read_text()
panel=(root/'Logres/Dev/Panel.lua').read_text()
errors=[]
def require(source,token,label):
    if token not in source: errors.append(f'{label}: {token}')
for token in (
 'function Dialogue:BeginProgressCompletionBridge()',
 'function Dialogue:ValidateProgressCompletionBridge(bridge)',
 'if not self.progressOwned or not self.progressContinuePending',
 'local questID, idError = readQuestID()',
 'pcall(module.CanBridgeVisual, module, snapshot)',
 'pcall(module.CaptureOfferPresentation, module)',
 'or #current.mouseFrames ~= #snapshot.mouseFrames',
 'current.mouseFrames[index].frame ~= snapshot.mouseFrames[index].frame',
 'self.progressCompletionBridge = bridge',
 'function Dialogue:EndProgressCompletionBridge(reason, adopted)',
 'self:EndProgressCompletionBridge("completion-unavailable")',
 'self:EndProgressCompletionBridge("immersion-off")',
 'self:EndProgressCompletionBridge("completion-presentation-exit")',
 'self:EndProgressCompletionBridge("dialogue-disabled")',
 'self:BeginProgressCompletionBridge()\n                self:ClearActiveDetail(',
 'self:ValidateProgressCompletionBridge(bridge)',
 'progressBridgeAdoptedCount = self.progressBridgeAdoptedCount',
 'progressBridgePending = self.progressCompletionBridge ~= nil',
 'self.completionControl:Activate()',
): require(d,token,'Dialogue')
for token in (
 'function Control:Activate()',
 'local progressBridge = self.dialogue.progressCompletionBridge',
 'progressBridge.questID ~= self.dialogue.lastQuestID',
 'local suppressOK = progressBridge ~= nil',
 'self:Restore("claim-invoked")',
 'pcall(_G.QuestRewardCompleteButton_OnClick)',
):require(c,token,'CompletionControl')
claim=c[c.index('function Control:Click()'):]
if claim.index('self:Restore("claim-invoked")') > claim.index('pcall(_G.QuestRewardCompleteButton_OnClick)'):
 errors.append('claim must restore native input first')
for token in (
 'self.disableEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")',
 'if event == "PLAYER_REGEN_DISABLED" then',
 'self.combatEnteredEvents = self.combatEnteredEvents + 1',
 'self.combatLeftEvents = self.combatLeftEvents + 1',
 'combatEventLastPolicy = self.combatEventLastPolicy',
 'combatEventLastDriver = self.combatEventLastDriver',
):require(a,token,'ActionContext')
for token in ('"combatEnteredEvents", "combatLeftEvents"',
              '"progressBridgeHeldCount", "progressBridgeAdoptedCount"',
              '"progressBridgeRestoreCount", "progressBridgePending"'):
 require(panel,token,'DevPanel incident snapshot')
require(a, 'if type(Logres.TraceEvent) == "function" then', 'optional action journal')
if 'RegisterStateDriver' not in a or 'UnregisterStateDriver' not in a:
 errors.append('secure alpha driver must remain present')
if 'OnUpdate' in a[a.index('if event == "PLAYER_REGEN_DISABLED" then'):a.index('OnEnable = function(self)')]:
 errors.append('combat telemetry must not poll')
import re
boot=(root/'Logres/Core/Bootstrap.lua').read_text()
toc=(root/'Logres/Logres.toc').read_text()
version=re.search(r'^Logres\.VERSION\s*=\s*"([^"\n]+)"',boot,re.M)
tocversion=re.search(r'^## Version: ([^\r\n]+)',toc,re.M)
if not version or not tocversion or version.group(1)!=tocversion.group(1):
 errors.append('Bootstrap and TOC version mismatch')
print('Logres P0498 stage bridge and action event contract')
for error in errors:print('ERROR:',error)
if errors:raise SystemExit(1)
print('PASS: 0 errors')
