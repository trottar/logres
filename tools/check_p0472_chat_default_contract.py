#!/usr/bin/env python3
"""P0472: chat SHOW by default; retain P0469 session override ownership."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
q=read('Logres/Immersion/QuietMode.lua')
c=read('Logres/Immersion/Controller.lua')
p=read('Logres/Dev/Panel.lua')
t=read('tools/test_p0469_panel_chat.lua')
assert 'self.manualOpen = true -- default stock chat shown; AUTO remains session-only' in q
assert 'self.manualOpen = false' not in q
assert 'and not Logres:GetModule("QuietMode").manualOpen' in c
assert 'quietMode.manualOpen = visible' in c
assert 'self:ReconcileQuietMode(policy, "manual-chat-access")' in c
assert '"Chat", command = "chat toggle"' in p
assert 'quiet.manualOpen and "SHOW" or "AUTO"' in p
assert "assert(Q.manualOpen==true,'fresh session must default to SHOW')" in t
assert "assert(C:SetChatVisible(false))" in t
assert "assert(C:SetChatVisible(true))" in t
assert "assert(Q.manualOpen==true,'reload must restore SHOW default')" in t
for banned in ('SetChatWindowShown(', 'RemoveAllMessageGroups(', 'RemoveAllChannels(', 'SetCVar(', 'SendChatMessage('):
 assert banned not in q
import re
version=re.search(r'^Logres.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'),re.M)
toc=re.search(r'^## Version: (\S+)$',read('Logres/Logres.toc'),re.M)
assert version and toc and version.group(1)==toc.group(1)
print('P0472 default Chat SHOW static contract PASS (WoW UNVERIFIED)')
