#!/usr/bin/env python3
"""P0469 panel chat ownership and aura presentation; STATIC, client UNVERIFIED."""
from pathlib import Path
import os,re,shutil,subprocess
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
Q=read('Logres/Immersion/QuietMode.lua');C=read('Logres/Immersion/Controller.lua')
P=read('Logres/Dev/Panel.lua');CMD=read('Logres/Core/Commands.lua')
H=read('Logres/HUD/PlayerHelpfulAuras.lua');S=read('Logres/HUD/StatusAuras.lua')
assert '{label = "Chat", command = "chat toggle", domain = "chat"}' in P
assert 'Chat [' in P and 'quiet.manualOpen and "SHOW" or "AUTO"' in P
setter=C.split('function ImmersionController:SetChatVisible(visible)',1)[1].split('\nend\n',1)[0]
for s in ('type(visible) ~= "boolean"','not self:IsEnabled()', 'not quietMode:IsEnabled()',
          'quietMode.manualOpen = visible','self:ReconcileQuietMode(policy, "manual-chat-access")','if self.lastQuietError'):
 assert s in setter,s
for s in ('ReconcileActionReplacement','ReconcilePlayerFrame','ReconcileTargetFrame','ReconcileOverheadNames','SetCVar','GetAlpha','Hide(', 'Show('):
 assert s not in setter,s
assert 'self.manualOpen = false' in Q and Q.count('manualOpen = self.manualOpen == true')==2
assert C.count('and not Logres:GetModule("QuietMode").manualOpen')==2
assert 'and not quietMode.manualOpen' in Q
assert 'and not snapshot.quiet.manualOpen' in CMD
assert 'and not Logres:GetModule("QuietMode").manualOpen' in CMD
for s in ('if command == "chat" then','SetChatVisible(visible)','chat [on|off|auto|toggle|status]'):
 assert s in CMD,s
assert len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',CMD))==122
assert '            row * (iconSize + gap)' in H and '-row * (iconSize + gap)' not in H
assert 'Logres.Layout.Bind(root, "passiveStatus", "LEFT", "CENTER")' in H
assert 'local MAX_ICONS = 40' in H and 'local COLUMNS = 4' in H
gate=S.split('-- P0469: do not preview orphan',1)[1].split('if unit == "target" and self.worldTrialLanes',1)[0]
for s in ('self.preview and unit == "target"','preferences.screenSpaceEnemyFrameEnabled == false',
          'snapshot.harmfulRows = {}','snapshot.helpfulRows = {}','preview-target-frame-disabled'):
 assert s in gate,s
for s in ('L-052','L-053'):assert s in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'UNVERIFIED' in read('docs/memory/evidence/P0469_PANEL_CHAT_ACCESS.md')
lua=os.environ.get('LOGRES_LUA') or shutil.which('texlua') or shutil.which('lua')
if lua:
 subprocess.run([lua,str(R/'tools/test_p0469_panel_chat.lua'),str(R)],check=True,cwd=R)
 subprocess.run([lua,str(R/'tools/test_p0468_compatible_aura_grid.lua')],check=True,cwd=R)
else:print('Lua actual-source fixtures UNVERIFIED: interpreter unavailable')
print('P0469 panel chat + upward buff/preview contracts PASS (STATIC; WoW UNVERIFIED)')
