#!/usr/bin/env python3
"""P0424: content-fit merchant profile with retained trainer/native ownership."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
read = lambda path: (ROOT / path).read_text(encoding='utf-8')
config = read('Logres/Quest/TrainerPanelConfig.lua')
merchant = read('Logres/Quest/MerchantCatalogue.lua')
trainer = read('Logres/Quest/TrainerLiveTrial.lua')
surface = read('Logres/UI/PanelSurface.lua')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
errors = []

def need(ok, reason):
    if not ok:
        errors.append(reason)

def number(key, source):
    found = re.search(r'\b' + key + r'\s*=\s*([\d.]+)', source)
    need(found is not None, 'missing numeric field: ' + key)
    return float(found.group(1)) if found else 0

profile = config.split('    merchant = {', 1)[1].split('    -- Approved landscape screenshot:', 1)[0]
need('width = 800, height = 625' in profile, 'compact merchant dimensions missing')
need('point = "TOP", relativePoint = "TOP", x = 0, y = -86' in profile,
     'merchant trainer-style top anchor changed')
need('strata = "DIALOG", mouse = false' in profile,
     'merchant layer/inert fixture changed')
need('sidebar = {x=32, y=102, w=222, h=352}' in profile,
     'compact sidebar geometry drift')
need('list = {x=268, y=102, w=500, h=352}' in profile,
     'compact catalogue geometry drift')
need('topRuleY = 85, footerRuleY = 468' in profile,
     'separator geometry drift')
need('footerTitleY = 484, footerNoteY = 514' in profile,
     'footer text geometry drift')
need('pagerY = 42' in profile, 'footer-relative pager not configured')
need('previewRowWidth = 192, previewNameWidth = 142' in profile,
     'compact two-column preview width constraint missing')
need('previewPriceWidth = 135' in profile,
     'preview price label width constraint missing')

# Exactly one global configuration is shared by the merchant adapter and trainer.
need('local config = Logres.PanelConfigs.trainer' in merchant and
     'local visual, style = config.merchant, config.landscape' in merchant and
     'local palette = style.palette' in merchant,
     'merchant did not use the service-specific compact profile with common palette')
need('local list, sidebar = visual.list, visual.sidebar' in merchant,
     'merchant did not reuse config coordinates')
need('local pagerCenter, pagerY, chevronGap = list.x + list.w / 2 - 28, visual.pagerY, 78' in merchant,
     'footer pagination no longer derives from compact geometry')
for token in (
    'Logres.PanelSurface.Paint(owner, config.surface, visual.width, visual.height)',
    'frame:SetSize(visual.width, visual.height)',
    'resize(plan, frame, visual.width, visual.height)',
    'wash(owner, 28, visual.footerRuleY, visual.width - 56, 1, palette.gold)',
    'label("Service controls", 42, visual.footerTitleY, 240, palette.goldText)',
    'label("Repairs and other services appear when offered.", 42, visual.footerNoteY, 440, palette.muted)',
    'row:SetSize(visual.previewRowWidth, 42)',
    'text(row, item[1], "GameFontHighlight", 45, 0, visual.previewNameWidth, palette.body)',
    'text(row, item[3], "GameFontHighlightSmall", 45, 18, visual.previewPriceWidth, palette.goldText)',
    'read(frame, "IsForbidden") == false', 'read(frame, "IsProtected") == false',
    'not unlocked() or not context(Logres:GetState())',
    'return type(w) == "number" and w >= visual.width',
    'or not resize(plan, frame, visual.width, visual.height)',
    'stockOnly, result = true, "stock-layout-unsupported"',
    'restore("stock-layout-restored")',
    'restore("immersion-off")',
    'for i = 1, 12 do',
):
    need(token in merchant, 'required compact/native safety token missing: ' + token)

# Original trainer screens are content-dense and retain their full geometry.
need('preview = {\n        width = 896, height = 712,' in config,
     'trainer/fixture preview dimensions were changed')
need('landscape = {\n        width = 896, height = 712, maxRows = 7,' in config,
     'trainer seven-row landscape dimensions were changed')
need('root:SetSize(visual.width, visual.height)' in trainer and
     'Logres.NPCTrainerLandscape.Render(root, model)' in trainer,
     'trainer live renderer ownership or sizes changed')
need('function Surface.Paint(owner, config, width, height)' in surface,
     'shared modular PanelSurface painter missing')

# Config-only bounds audit; live native child extents must be validated in WoW.
width, height = 800, 625
left_x, left_w = 32, 222
list_x, list_w, list_y, list_h = 268, 500, 102, 352
first_x, first_y = list_x + 22, list_y + 31
preview_second_x = first_x + 153 + 125
need(left_x + left_w + 14 <= list_x,
     'sidebar and two-column merchant catalogue overlap')
need(list_x + list_w <= width - 28,
     'catalogue wash extends too close to compact panel right edge')
need(preview_second_x + 192 <= list_x + list_w,
     'fixture second column extends beyond catalogue')
need(first_y + 5 * 52 + 42 < list_y + list_h,
     'six-row nominal merchant content would overflow list')
need(list_y + list_h < 468 < 484 < 514 < height - 42 - 14,
     'list, separator, footer labels, and pager vertical order changed')
need(height - 42 + 14 <= height - 20,
     'pager not fully inset from compact bottom edge')

for unsafe in ('BuyMerchantItem(', 'SellCursorItem(', 'PickupMerchantItem(',
               'BuybackItem(', 'RepairAllItems(', 'SetParent(',
               'C_Timer.', 'SetScript("OnUpdate"'):
    need(unsafe not in merchant, 'merchant introduced forbidden transaction/polling: ' + unsafe)
need('for i = live.applied, 1, -1 do' in merchant and
     'pcall(live.plan[i].undo)' in merchant,
     'native geometry restoration no longer reverses all mutations')
need('"PLAYER_REGEN_ENABLED"' in merchant,
     'combat restoration deferral lost')
need('## Version:' in toc and 'Logres.VERSION = "' in boot,
     'version markers missing')
vt = re.search(r'(?m)^## Version: ([^\s]+)$', toc)
vb = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', boot)
need(vt is not None and vb is not None and vt.group(1) == vb.group(1),
     'TOC/bootstrap version parity drift')

for path in (
    'docs/memory/CURRENT.md', 'docs/memory/PRE_HANDOFF_AUDIT.md',
    'docs/memory/roadmap/STATUS.md', 'docs/memory/investigations/ACTIVE.md',
    'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md', 'docs/ROADMAP.md',
    'docs/memory/patches/PATCH_INDEX.md',
    'docs/memory/evidence/P0424_COMPACT_MERCHANT_PROFILE.md',
    'docs/memory/patches/P0424_COMPACT_MERCHANT_PROFILE.md',
    'docs/design/layout/NPC_MERCHANT_COMPACT_V1.md',
):
    need('P0424' in read(path), 'P0424 continuity missing: ' + path)

print('P0424 compact merchant modular NPC service contract')
for err in errors:
    print('ERROR:', err)
if errors:
    raise SystemExit(1)
print('PASS: 800x625 native-backed merchant, trainer geometry preserved, safe restorable compact shell')
