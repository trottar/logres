#!/usr/bin/env python3
"""P0425: native Merchant Buyback geometry + seven-row trainer compact contract."""
import re
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
read = lambda rel: (ROOT / rel).read_text(encoding='utf-8')
config = read('Logres/Quest/TrainerPanelConfig.lua')
merchant = read('Logres/Quest/MerchantCatalogue.lua')
landscape = read('Logres/Quest/TrainerLandscape.lua')
trainer = read('Logres/Quest/TrainerLiveTrial.lua')
issues = read('docs/memory/investigations/ISSUE_LEDGER.md')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
errors = []
def need(ok, why):
    if not ok: errors.append(why)

merchant_cfg = config.split('    merchant = {', 1)[1].split('    -- P0425:', 1)[0]
trainer_cfg = config.split('    landscape = {', 1)[1].split('    motif = {', 1)[0]
need('width = 800, height = 625' in merchant_cfg, 'approved merchant shell width/height changed')
need('tabY = 128' in merchant_cfg, 'two native merchant tabs not raised')
need('buybackItemX = 592, buybackItemY = 405' in merchant_cfg, 'buyback item anchor not above footer')
need('footerRuleY = 468' in merchant_cfg, 'merchant divider moved unexpectedly')
for token in (
    'or not anchor(plan, tab, "TOPLEFT", frame, "TOPLEFT", 38, -visual.tabY)',
    'or not anchor(plan, secondTab, "LEFT", tab, "RIGHT", 6, 0)',
    'local buyback = member(_G, "MerchantBuyBackItem")',
    'read(buyback, "GetParent") ~= frame',
    'or not anchor(plan, buyback, "TOPLEFT", frame, "TOPLEFT",',
    'visual.buybackItemX, -visual.buybackItemY)',
    'tab:SetPoint("TOPLEFT", frame, "TOPLEFT", 38 + (i - 1) * 86, -visual.tabY)',
    'for i = live.applied, 1, -1 do',
    'pcall(live.plan[i].undo)',
    'not unlocked() or not context(Logres:GetState())',
    'stockOnly, result = true, "stock-layout-unsupported"',
):
    need(token in merchant, 'merchant native rollback/position token missing: '+token)
for forbidden in ('BuybackItem(', 'BuyMerchantItem(', 'SetParent(', 'C_Timer.', 'SetScript("OnUpdate"'):
    need(forbidden not in merchant, 'merchant introduced native calls or polling: '+forbidden)
need('width = 820, height = 660, maxRows = 7' in config, 'compact 7-row trainer dimensions changed')
need('preview = {\n        width = 820, height = 660,' in config,
     'trainer live and synthetic root not compact together')
for token in (
    'left = {x=32, y=102, w=222, h=352}',
    'status = {x=40, y=422, w=205, h=19}',
    'list = {x=268, y=102, w=520, h=352, top=6, pitch=46, rowHeight=46}',
    'detail = {x=33, y=483, w=480, h=137}',
    'reagents = {x=532, y=483, w=252}',
    'funds = {x=533, y=569}',
    'trainAll = {x=532, y=593, w=140, h=31}',
    'train = {x=680, y=593, w=110, h=31}',
):
    need(token in config, 'trainer geometry missing: '+token)
# Full seven-row fit including icon/text and scrollbar.
need(102 + 6 + 6*46 + 46 <= 102 + 352,
     'seven trainer rows exceed compact catalogue')
need(268 + 520 <= 820 - 28, 'trainer list outside compact right gutter')
need(32 + 222 + 14 <= 268, 'trainer sidebar/list collide')
need(483 + 137 <= 660 - 30, 'trainer detail panel exceeds footer')
need(680 + 110 <= 820 - 24 and 593 + 31 <= 660 - 30,
     'trainer train action outside compact shell')
need('text(selected, view.selected.name, 70, 2, 400, 30,' in landscape,
     'selected trainer title overlaps reagents at compact width')
need('text(selected, view.selected.requirement, 70, 32, 390, 24,' in landscape,
     'selected trainer requirements overlap reagents')
need('local visual = Logres.PanelConfigs.trainer.preview' in trainer and
     'Logres.NPCTrainerLandscape.Render(root, model)' in trainer and
     'Logres.NPCServiceNativeParking.Park' in trainer and
     'Trial.Disable("native-purchase-deferred")' in trainer,
     'trainer native action/stock recovery changed')
for path in ('docs/memory/CURRENT.md','docs/memory/PRE_HANDOFF_AUDIT.md',
             'docs/ROADMAP.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/investigations/ACTIVE.md',
             'docs/memory/patches/PATCH_INDEX.md',
             'docs/memory/evidence/P0425_NPC_COMPACT_ALIGNMENT.md',
             'docs/design/layout/NPC_COMPACT_V2.md'):
    need('P0425' in read(path), 'P0425 durable memory missing: '+path)
need('L-003' in issues and 'L-033' in issues and 'P0425' in issues,
     'merchant/trainer issue evidence missing')
vt=re.search(r'(?m)^## Version: ([^\s]+)$',toc)
vb=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(vt is not None and vb is not None and vt.group(1)==vb.group(1),
     'TOC/Bootstrap runtime version parity missing')
print('P0425 Merchant buyback and compact trainer contract')
for e in errors: print('ERROR:',e)
if errors: raise SystemExit(1)
print('PASS: native tab/button positions recoverable; compact trainer retains seven rows and stock fallback')
