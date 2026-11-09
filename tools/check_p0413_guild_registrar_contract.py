#!/usr/bin/env python3
"""P0413 registrar presentation/source boundary; STATIC ONLY."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
def read(p): return (ROOT / p).read_text(encoding="utf-8")
def need(c, why):
    if not c: raise AssertionError("P0413 registrar " + why)

src = read("Logres/Quest/MerchantCatalogue.lua")
cmd = read("Logres/Core/Commands.lua")
panel = read("Logres/Dev/Panel.lua")
toc = read("Logres/Logres.toc")
boot = read("Logres/Core/Bootstrap.lua")
ledger = read("docs/memory/investigations/ISSUE_LEDGER.md")
# P0415 intentionally retires P0413/P0414 native-frame geometry. The
# dedicated P0415 contract owns the new adapter/parking and option pipeline.
if 'Logres.NPCGuildRegistrar = Registrar' in src:
    need('function Merchant.GuildGetAudit()' in src, 'registrar audit seam missing')
    need('function Merchant.GuildPreview()' in src, 'registrar preview seam missing')
    need('local function guildPaint(' not in src, 'retired service skin still loaded')
    need('P0413' in read('docs/memory/evidence/P0413_GUILD_REGISTRAR.md'), 'P0413 evidence lost')
    need('P0414' in read('docs/memory/evidence/P0414_REGISTRAR_VISUAL_REPAIR.md'), 'P0414 evidence lost')
    need('P0415' in read('tools/check_p0415_registrar_option_contract.py'), 'replacement contract absent')
    print('P0413 old registrar skin superseded by P0415 option adapter: PASS (STATIC)')
    raise SystemExit(0)
for required in (
    "local function guildPaint(owner, npc, sample)",
    'guildPaint(root, "Aldwin Laughlin", true)',
    "guildPaint(art, guildName(), false)",
    "function Merchant.GuildPreview()",
    "function Merchant.GuildGetAudit()",
    'member(_G, "GuildRegistrarFrame")',
    'member(_G, "GuildRegistrarGreetingFrame")',
    'member(_G, "GuildRegistrarPurchaseFrame")',
    'member(_G, "GuildRegistrarButton1")',
    'member(_G, "GuildRegistrarButton2")',
    'member(_G, "GuildRegistrarFramePurchaseButton")',
    'member(_G, "GuildRegistrarFrameEditBox")',
    'member(_G, "GuildRegistrarMoneyFrame")',
    'member(_G, "GuildRegistrarFrameBg")',
    'read(root, "IsShown") ~= true',
    'read(choices[1], "GetParent") ~= greeting',
    'ordinary(name)',
    'not mutable(root)',
    'guildRestore("registrar-apply-rollback")',
    'guildRestore("registrar-immersion-off")',
    'guildRestore("registrar-world-changed")',
    'guildRestore("registrar-closed")',
    'guildRestore("registrar-context-ended")',
    'guildRestore("registrar-viewport-changed")',
    '"GUILD_REGISTRAR_SHOW"', '"GUILD_REGISTRAR_CLOSED"',
    'if not unlocked() then',
    'guildStockOnly, guildResult = true, "registrar-art-unavailable"',
):
    need(required in src, "required safety/presentation route absent: " + required)
# Historical merchant preview fixture remains untouched and bounded by its own handler count.
merchant_preview = src.split('local function buildPreview()',1)[1].split('\nfunction Merchant.Preview()',1)[0]
need(merchant_preview.count(':SetScript("OnClick"') == 3, "merchant fixture inputs changed")
need('"Merchant / Registrar Preview",\n    "merchantpreview",\n    "P"' in cmd,
     "P action not preserved as the existing registration")
need('incident.snapshot.registrar = pickTraceStatus' in panel and
     'self.NPCMerchantCatalogue.GuildGetAudit()' in panel, "Report Bug audit missing")
need('L-042 | Guild registrar' in ledger and 'L-001 | Native gossip' in ledger,
     "new guild issue or old multi-quest issue lost")
for forbidden in ("BuyGuildCharter(", "TurnInGuildCharter(", "CloseGuildRegistrar(",
                  ":Click(", "SetParent(", "OnUpdate", "C_Timer.",
                  "SetAttribute(", 'SetScript("OnEvent"'):
    need(forbidden not in src, "native guild ownership or polling added: "+forbidden)
need('## Version:' in toc and 'Logres.VERSION = ' in boot, "runtime versions missing")
v = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', boot)
need(v is not None and b is not None and v.group(1) == b.group(1)
     and re.fullmatch(r'0\.0\.\d+-dev', v.group(1)), "version parity")
need('Quest\\MerchantCatalogue.lua' in toc, "native service owner unloaded")
need(len([x for x in toc.splitlines() if x.endswith('.lua')]) == 96,
     "unintended loaded-source count drift")
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', cmd)) == 122,
     "preview/action registration drift")
need('P0413' in read('docs/memory/CURRENT.md'), "current active work not tracked")
print("P0413 guild registrar native-backed safety and preview: PASS (STATIC)")
