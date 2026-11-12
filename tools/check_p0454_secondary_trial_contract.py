#!/usr/bin/env python3
"""P0454: opt-in single-secondary, basic-only source and safe native restore."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding="utf-8")
p = read("Logres/HUD/WorldTargetProbe.lua")
h = read("Logres/HUD/HUD.lua")
c = read("Logres/Core/Commands.lua")
d = read("Logres/Dev/Panel.lua")
obs = p[p.index("function Probe:ObserveSecondaryThreat("):p.index("function Probe:RunDevNameplateLifecycleStatus(")]
assert 'callOrdinary(UnitThreatSituation, "player", unit)' in obs
assert 'readBoolean(UnitDetailedThreatSituation, "player", unit)' in obs
assert 'local trialDecision = "unknown"' in obs
assert 'if status >= 2 then' in obs and 'trialDecision = "eligible"' in obs
assert 'trialDecision = "nonprimary"' in obs and 'trialDecision = "unqualified"' in obs
assert obs.index('trialDecision = "eligible"') < obs.index('if source.secret or detail.secret then')
assert 'if detail.secret then' in obs and 'primary ~= (detail.value == true)' in obs  # historical paired evidence retained
assert obs.count("return trialDecision") >= 8
for forbidden in ("SetPoint(","SetAlpha(","CreateFrame(","SetParent(","OnUpdate", "C_Timer.", "GetNamePlates(","UnitGUID("):
    assert forbidden not in obs, forbidden
assert 'local decision = self:ObserveSecondaryThreat(event, unit, observation)' in p
assert 'hud:ObserveSecondaryAggroTrial(event, unit, decision)' in p
anchor=p[p.index("function Probe:AcquireLiveEnemySecondaryAnchor("):p.index("-- Removal events must never reacquire",p.index("function Probe:AcquireLiveEnemySecondaryAnchor("))]
for item in ("ordinaryNameplateToken", 'readBoolean(UnitIsUnit, unit, "target")', "readEventNameplate(unit)","anchor.IsForbidden", "IsNamePlateUnitBehindCamera"):
    assert item in anchor,item
for forbidden in ("SetAlpha(","SetPoint(","SetParent(","UnitGUID("):
    assert forbidden not in anchor,forbidden
s = h[h.index("-- P0454: one developer-only 50% secondary"):h.index("function HUD:BuildLiveWorldEnemy()")]
for token in ("function HUD:BuildSecondaryAggroTrial()", "if not ordinaryOutOfCombat()",
              'frame:SetScale(0.5)', 'frame:SetAlpha(0.5)', "frame:EnableMouse(false)",
              "function HUD:RestoreNativeSecondaryEnemyDecor()",
              "self.worldEnemySecondaryTrialClaim = nil",
              "entry.region.SetAlpha, entry.region, entry.original",
              "function HUD:ClaimNativeSecondaryEnemyDecor(anchor)",
              'nativeDecorField(unitFrame, "name")',
              'nativeDecorField(unitFrame, "HealthBarsContainer")',
              "self:RestoreNativeSecondaryEnemyDecor()",
              "function HUD:HideSecondaryAggroTrial(reason)",
              "self.worldEnemySecondaryTrialUnit = nil",
              "function HUD:ObserveSecondaryAggroTrial(event, eventUnit, decision)",
              'if event == "NAME_PLATE_UNIT_REMOVED" then',
              'if decision ~= "eligible" or not ordinaryInCombat() then',
              "probe:AcquireLiveEnemySecondaryAnchor(unit)",
              'frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)',
              "self:ClaimNativeSecondaryEnemyDecor(anchor)",
              'self.worldEnemySecondaryTrialUnit = unit',
              '"secondary-threat-lost-or-unknown"'):
    assert token in s,token
assert 'GetPreferences().immersionEnabled ~= true' in s
# P0454 introduced the experimental arm; P0456 may suspend it after
# two real visual failures without removing the guarded trial machinery.
assert 'self.worldEnemySecondaryTrialArmed = false' in h
assert 'self.worldEnemySecondaryTrialArmed = false' in h
assert 'self:HideSecondaryAggroTrial("off")' in h
assert 'self:HideSecondaryAggroTrial("secondary-combat-ended")' in h
assert 'self:HideSecondaryAggroTrial("secondary-target-changed")' in h
assert 'self.secondaryValueEvents:RegisterEvent(event)' in h
assert 'self.secondaryValueEvents:UnregisterAllEvents()' in h
assert 'worldEnemySecondaryEnabled = false' in h # production not silently on
assert 'worldEnemySecondaryTrialVisible' in d and 'worldEnemySecondaryTrialRestoreFailures' in d
assert 'World Enemy secondary DEV trial:' in c
assert 'one opt-in secondary at 50%/50%' in c or 'secondary 50% visual trial SUSPENDED' in c
for name in ("docs/ROADMAP.md","docs/memory/roadmap/STATUS.md",
             "docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md",
             "docs/memory/investigations/ACTIVE.md"):
    body=read(name)
    assert "## P0454 —" in body and "## P0453 —" in body,name
assert read("docs/memory/CURRENT.md").find("P0454")>=0
assert any(line.startswith("# P0454:") for line in read("docs/memory/handoffs/CURRENT_HANDOFF.md").splitlines())
assert "P0453 #12307" in read("docs/memory/investigations/ISSUE_LEDGER.md")
assert "P0454" in read("docs/memory/patches/PATCH_INDEX.md")
assert "P0454" in read("docs/memory/PRE_HANDOFF_AUDIT.md")
assert re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc')).group(1) == re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua')).group(1)
print('P0454 PASS: basic-only opt-in single-secondary trial, native fallback and event-time restoration (STATIC)')
