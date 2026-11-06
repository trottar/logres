#!/usr/bin/env python3
"""P0383 addon-owned input hierarchy isolation and fail-open lifecycle."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
s=(r/'Logres/Quest/Dialogue.lua').read_text()
c=(r/'Logres/Quest/CompletionControl.lua').read_text()
e=(r/'docs/memory/evidence/P0383_COMPLETION_HIT_SURFACE.md').read_text()
assert 'local offerActionRoot =\n        CreateFrame(\n            "Frame",\n            nil,\n            UIParent\n        )' in s
assert s.count('offerActionRoot:SetFrameStrata("HIGH")') == 1
assert 'local ownedLevel = readOwnedFrameValue(root, "GetFrameLevel")' in s
assert 'if ownedLevel then offerActionRoot:SetFrameLevel(ownedLevel + 8) end' in s
assert 'if self.offerActionRoot then self.offerActionRoot:Hide() end' in s
assert 'root:SetFrameStrata("HIGH")' in s and 'root:EnableMouse(false)' in s
assert 'self.offerActionRoot:SetPoint(\n        "TOP", self.root, "BOTTOM"' in s
for owner in ('self.offerActionRoot:EnableMouse(true)', 'self.offerActionRoot:EnableMouse(false)',
              'self.acceptButton:EnableMouse(true)', 'self:UpdateProgressPagePresentation()',
              'owner:HandleProgressContinue()', 'owner:HandleCompletionAction()'):
    assert owner in s,owner
assert 'self.actionRoot:EnableMouse(true)' in c
assert 'self.actionRoot:EnableMouse(false)' in c
assert 'pcall(_G.QuestRewardCompleteButton_OnClick)' in c
assert 'pcall(CompleteQuest)' not in c
for bad in ('GetMouseFocus(', 'GetMouseFoci(', 'SetScript("OnUpdate"'):
    assert bad not in s[s.index('-- P0383: isolate the same live'):s.index('local declineButton =')],bad
for t in ('2797','L-005','UNCONFIRMED','claimCalls=0','WoW UNVERIFIED'):
    assert t in e, t
import re
toc=(r/'Logres/Logres.toc').read_text()
boot=(r/'Logres/Core/Bootstrap.lua').read_text()
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'Logres\.VERSION = "([^"]+)"',boot)
assert a and b and a.group(1)==b.group(1)
print('P0383 isolated completion hit surface: PASS (STATIC ONLY, WoW UNVERIFIED)')
