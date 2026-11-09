#!/usr/bin/env python3
"""P0415 correct registrar to approved Quest/NPC option pipeline. STATIC only."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
def src(p): return (R/p).read_text(encoding="utf-8")
m=src("Logres/Quest/MerchantCatalogue.lua")
q=src("Logres/Quest/OptionSession.lua")
v=src("Logres/UI/OptionList.lua")
p=src("Logres/UI/NPCServiceNativeParking.lua")
s=src("Logres/UI/NPCServiceSession.lua")
model=src("Logres/Quest/OptionModel.lua")
d=src("Logres/Quest/Dialogue.lua")
ledger=src("docs/memory/investigations/ISSUE_LEDGER.md")
proof=src("docs/memory/evidence/P0415_REGISTRAR_OPTION_ADAPTER.md")
for t in (
 'Logres.NPCGuildRegistrar = Registrar',
 'Logres.NPCOptionModel.FromValidated(npc, "registrar",',
 'model.nativeService = "guild-registrar"',
 'd:ShowReadOnlyGossip(source.model)',
 'Logres.NPCServiceNativeParking.Park("guild-registrar")',
 'Logres.NPCServiceNativeParking.Restore("registrar-native-choice")',
 'Logres.NPCServiceSession.Dismiss("guild-registrar")',
 'local fresh, why = sample()',
 'pcall(fresh.buttons[index].script, fresh.buttons[index].frame, "LeftButton")',
 'function Registrar.Goodbye()',
 'function Registrar.Close(reason)',
 'function Registrar.PrepareDialogueExit(reason)',
 'function Merchant.GuildGetAudit()',
 'function Merchant.GuildPreview()',
 'Logres.NPCServiceSession.Register("guild-registrar", {',
 'nativeOwner="Blizzard", nativeControls="untouched"',
): assert t in m, t
for forbidden in ('local function guildPaint(', 'guildTextColor(',
                  'GuildRegistrarFrameBg', 'GuildRegistrarNpcNameFrame',
                  'anchor(plan, choices[1]', 'BuyGuildCharter(',
                  'TurnInGuildCharter(', 'SetParent(', 'OnUpdate', 'C_Timer.'):
    assert forbidden not in m, 'old registrar skin or native write remains: '+forbidden
assert 'self.model.nativeService == "guild-registrar"' in q
assert 'Logres.NPCGuildRegistrar.Activate(self.model, index)' in q
assert 'Logres.NPCGuildRegistrar.Goodbye()' in q
assert 'self.visual:SetServiceSelectable' in q
assert 'function Visual:SetServiceSelectable(allowed)' in v
assert 'option.serviceStatus == 0' in v
assert 'if mode == "guild-registrar" then return registrarFixture() end' in model
assert 'function Dialogue:ShowReadOnlyGossip(model)' in d
assert 'Logres.NPCGuildRegistrar.PrepareDialogueExit(' in d
assert 'registrar-stock-restoration-pending' in d
assert 'permitted["guild-registrar"] = {native="GuildRegistrarFrame", interactionType=11}' in p
assert 'if key == "trainer" then' in p  # retains original special family gate
assert 'Logres.NPCTrainerLiveTrial.Disable("deferred-stock-restored")' in p
assert 'Logres.NPCGuildRegistrar.OnNativeHidden()' in p
assert 'set(root, "TOPRIGHT", UIParent, "BOTTOMLEFT", -64, -64)' in p
assert 'Session.Register("trainer", {' in s
assert len(re.findall(r'Session.Register\("trainer",\s*\{', s)) == 1
assert len([a for a in src('Logres/Logres.toc').splitlines() if a.endswith('.lua')]) == 96
assert 'L-042 |' in ledger and '8350' in ledger and 'OPEN' in ledger
assert 'native-frame geometry' in proof and 'UNVERIFIED' in proof
assert 'P0415' in src('docs/memory/CURRENT.md')
toc_version = re.search(r'(?m)^## Version: (\S+)$', src('Logres/Logres.toc'))
bootstrap_version = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', src('Logres/Core/Bootstrap.lua'))
assert toc_version and bootstrap_version and toc_version.group(1) == bootstrap_version.group(1)
print('P0415 modular quest/NPC registrar option and native fail-open: PASS (STATIC)')
