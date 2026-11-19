#!/usr/bin/env python3
"""P0494 keybind plate/button owner + isolated activation contract."""
from pathlib import Path
import re,subprocess,shutil
R=Path(__file__).resolve().parents[1]
s=(R/'Logres/Actions/Button.lua').read_text()
c=(R/'Logres/Actions/Context.lua').read_text()
p=(R/'Logres/HUD/PetActionExecutionProbe.lua').read_text()
assert 'local hotkeyPlateBorder = button:CreateTexture(nil, "OVERLAY")' in s
assert 'local hotkeyPlateFill = button:CreateTexture(nil, "OVERLAY")' in s
assert 'local hotkeyText = button:CreateFontString(' in s
assert 'local feedbackFrame = CreateFrame("Frame", nil, UIParent)' in s
assert 'local activationFlash = feedbackFrame:CreateTexture' in s
assert 'local pressedOverlay = feedbackFrame:CreateTexture' in s
assert 'button.activationFeedbackFrame = feedbackFrame' in s
assert 'feedbackFrame:SetFrameStrata("BACKGROUND")' in s
assert 'feedbackFrame:EnableMouse(false)' in s
assert 'SetHotkeyLabel' in s and 'SetOverrideBindingClick' not in s
assert 'hotkeyPlateBorder:SetDrawLayer("OVERLAY", 0)' in s
assert 'hotkeyPlateFill:SetDrawLayer("OVERLAY", 1)' in s
assert 'hotkeyText:SetDrawLayer("OVERLAY", 2)' in s
assert 'driver:SetFrameRef(source .. "Feedback" .. index, feedback)' in c
assert 'self.secureFeedbackRefs = feedbackCount' in c
assert 'pet:ApplyContextOpacity(petAlpha, locked == true)' in c
assert 'button.activationFeedbackFrame:SetAlpha(alpha)' in p
assert not any(t in s for t in ('hotkeyPlateBorder = feedbackFrame:CreateTexture',
                               'hotkeyPlateFill = feedbackFrame:CreateTexture',
                               'hotkeyText = feedbackFrame:CreateFontString'))
a=(R/'Logres/Core/Bootstrap.lua').read_text()
t=(R/'Logres/Logres.toc').read_text()
assert re.search(r'Logres.VERSION = "(.*?)"',a).group(1)==re.search(r'## Version: (\S+)',t).group(1)
assert 'P0494' in (R/'docs/memory/CURRENT.md').read_text()
assert 'L-055' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert (R/'docs/memory/evidence/P0494_KEYBIND_BUTTON_OWNER.md').is_file()
assert 'P0494_KEYBIND_BUTTON_OWNER.md' in (R/'docs/memory/patches/PATCH_INDEX.md').read_text()
engine=shutil.which('texlua') or shutil.which('lua')
if engine: subprocess.run([engine,str(R/'tools/test_p0494_keybind_button_owner.lua')],cwd=R,check=True)
else: print('P0494 actual-source Lua fixture DEFERRED')
print('P0494 metadata ownership contract: PASS')
