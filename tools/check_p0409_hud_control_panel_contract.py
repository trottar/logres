#!/usr/bin/env python3
"""P0409: native-access controls moved entirely to DevPanel N; Report Bug HUD retained."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R/p).read_text(encoding='utf-8')
P = read('Logres/Dev/Panel.lua')
A = read('Logres/Immersion/NativeAccess.lua')
N = read('Logres/Immersion/NativeSurfaceReplacement.lua')
C = read('Logres/Core/Commands.lua')
U = read('Logres/Core/UIOwnershipAudit.lua')

def need(ok, reason):
    if not ok: raise AssertionError('P0409 ' + reason)

need('{ id = "N", title = "Native UI — Stock Access (HUD controls)" }' in P, 'dedicated tab absent')
need('local TAB_WIDTH = 46' in P and 'local TAB_GAP = 0' in P and
     12 * 46 <= 620 - 36, 'new tab width exceeds panel interior')
need('if self.activePhase == "N" then' in P and 'self.nativeAccessButtons[index] = button' in P,
     'nine panel button owners absent')
need('CreateFrame("Button", nil, self.buttonHost, "UIPanelButtonTemplate")' in P,
     'panel controls must be panel children, not UIParent')
expected = (
    ('Stock', 'nativeui all', 'all'),
    ('Map', 'nativeui navigation', 'navigation'),
    ('Quests', 'nativeui objectives', 'objectives'),
    ('XP', 'nativeui progress', 'progress'),
    ('Menu', 'nativeui menu', 'menu'),
    ('Cast', 'nativeui casts', 'casts'),
    ('Pet Stock', 'nativefallback pet', 'pet'),
    ('Buffs', 'nativefallback buffs', 'playerBuffs'),
    ('Target', 'nativefallback target', 'targetAuras'),
)
segment = P.split('local NATIVE_ACCESS_ACTIONS = {',1)[1].split('\n}',1)[0]
actual = re.findall(r'\{label = "([^"]+)", command = "([^"]+)", domain = "([^"]+)"\}', segment)
need(tuple(actual) == expected, 'exact nine label/handler/domain map changed')
need('self:RunCommand(entry.command)' in P and 'self:UpdateNativeAccessLabels()' in P,
     'panel click route/toggle label missing')
need('if command == "nativeui" then' in C and 'local ok, result = native:Toggle(domain)' in C,
     'original nativeui slash/handler changed')
need('if command == "nativefallback" then' in C and
     'local ok = native:Toggle(domain)' in C and
     '"playerBuffs"' in C and '"targetAuras"' in C,
     'fallback slash/handler absent')
need('function NativeAccess:Toggle(key)' in A and 'self.manualOpen[domain] = not everythingOpen' in A,
     'stock all toggle state changed')
need('function Native:Toggle(domain)' in N and 'trial:ToggleNativeAccess()' in N and
     'self.manual[domain] = not self.manual[domain]' in N,
     'pet/buffs/target original toggle state changed')
need('CreateFrame("Button", nil, dock)' not in A and
     'self.dock:Show()' not in A and 'dock:EnableMouse(false)' in A and
     'dock:Hide()' in A, 'old six HUD click regions remain')
need('CreateFrame("Button", nil, row)' not in N and
     'nativeAccessRow' not in N and 'self.buttons' not in N,
     'old three HUD click regions remain')
need('type(Logres.ToggleDevPanel) == "function"' in N,
     'stock aura restoration gate lost when controls relocated')
need('result.dockShown == false' in U, 'retired HUD diagnostic expectation stale')
need('CreateFrame("Button", "LogresBugReportButton", UIParent)' in P and
     'bugButton:SetFrameStrata("LOW")' in P and
     'bugButton:SetText("Report Bug")' in P and
     'bugButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")' in P,
     'gameplay report access/style missing')
need('bronze:SetTexture((skin.assets or {}).fallback)' in P and
     'bugButton:SetFontString(text)' in P, 'bronze skin/readable title missing')
click = P.split('bugButton:SetScript("OnClick", function(_, button)',1)[1].split('end)',1)[0]
need('if button == "RightButton" then' in click and
     'Logres:ToggleDevPanel()' in click and
     'Logres:CaptureBugIncident()' in click and 'Logres:DevPrint(' in click,
     'original left-click capture or new right-click panel access altered')
need('function Logres:CaptureBugIncident()' in P and 'pcall(Screenshot)' in P and
     'journal.pendingScreenshot = incident.id' in P,
     'screenshot/diagnostic persistence changed')
need('UIParent, "UIPanelButtonTemplate"' not in P,
     'Report Bug reverted to native button template')
need('self.frame:Hide()' in P and 'self.bugButton = bugButton' in P,
     'report control must survive panel closure')
toc = read('Logres/Logres.toc')
bootstrap = read('Logres/Core/Bootstrap.lua')
version = re.search(r'(?m)^## Version: (\S+)$', toc)
bootstrap_version = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', bootstrap)
need(version and bootstrap_version and version.group(1) == bootstrap_version.group(1),
     'TOC/Bootstrap version parity missing')
print('P0409 nine panel controls, no HUD hit regions, Report Bug: PASS (STATIC ONLY)')
