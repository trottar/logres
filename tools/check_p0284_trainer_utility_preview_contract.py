#!/usr/bin/env python3
"""P0284: bounded inert trainer utility fixtures, no new Blizzard ownership."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
read = lambda p: (root / p).read_text(encoding='utf8')
landscape = read('Logres/Quest/TrainerLandscape.lua')
config = read('Logres/Quest/TrainerPanelConfig.lua')
components = read('Logres/Quest/TrainerComponents.lua')
native = read('Logres/Quest/NativeTrainerSkin.lua')
toc = read('Logres/Logres.toc')
bootstrap = read('Logres/Core/Bootstrap.lua')
evidence = read('docs/memory/evidence/P0284_TRAINER_UTILITY_PREVIEW.md')
errors = []
def need(ok, why):
    if not ok:
        errors.append(why)

for token in (
    'filters = {label="Filters", mode="Categorize", categorized=true}',
    'funds = {label="Funds", gold="1", silver="20", copper="58"}',
    'trainAll = {label="Train All (1, 1s)", enabled=false}',
    'type(model.filters) ~= "table"',
    'type(model.funds) ~= "table"',
    'type(model.trainAll) ~= "table"',
    'boundedString(model.filters.label, 30)',
    'boundedString(model.filters.mode, 30)',
    'type(model.filters.categorized) ~= "boolean"',
    'boundedString(model.funds.gold, 10)',
    'boundedString(model.funds.silver, 10)',
    'boundedString(model.funds.copper, 10)',
    'boundedString(model.trainAll.label, 40)',
    'type(model.trainAll.enabled) ~= "boolean"',
    'text(owner, view.filters.label,',
    'text(owner, view.filters.mode,',
    'if view.filters.categorized then',
    'text(owner, view.funds.label,',
    'view.funds.gold .. "g"',
    'view.funds.silver .. "s"',
    'view.funds.copper .. "c"',
    'local trainAll = frame(owner,',
    'text(trainAll, view.trainAll.label,',
    'view.trainAll.enabled and p.goldText or p.muted',
    '{id="trainer.trainAll", target=trainAll}',
    'if not decorated or decorated.styled ~= 5 then',
    'Logres.NPCTrainerMotif.PaintFixtureRow(row, rowState)',
    'if rowState == "selected" then nameColor = p.goldText',
    'function Landscape.LiveCapability()',
    'native-reflow-and-transaction-fallback-unverified',
):
    need(token in landscape, 'fixture/model/render missing '+token)
for token in (
    'filters = {x=166, y=117, w=78, h=24}',
    'filterMode = {x=40, y=148}',
    'funds = {x=575, y=614}',
    'trainAll = {x=574, y=642, w=150, h=31}',
    '["trainer.trainAll"] =',
    'coinSilver =', 'coinCopper =',
    'width = 896, height = 712, maxRows = 7',
):
    need(token in config, 'style/geometry missing '+token)
for token in (
    'function Components.Render(model)',
    'if model.fixture == true and type(model.styles) == "table" then',
    'recipe = model.styles[item.id] or recipe',
    'function Components.Enable(trainer)',
):
    need(token in components, 'fixture-only recipe ownership missing '+token)
for token in (
    'Logres.NPCTrainerComponents.Enable(frame)',
    'Logres.NPCTrainerMotif.Enable(frame)',
    'pcall(item.set, item.region, item.token)',
    'Skin.Disable("trainer-closed")',
):
    need(token in native, 'native stock/fail-open behavior lost '+token)
for bad in (
    'ClassTrainerFrame', 'GetTrainerServiceInfo(', 'BuyTrainerService(',
    'BuyMerchantItem(', 'RepairAllItems(', 'SetParent(',
    'SetScript("OnUpdate"', 'hooksecurefunc(', 'C_GossipInfo.',
    'DynamicCam', 'SetScript("OnClick"',
):
    need(bad not in landscape, 'preview must not own native gameplay '+bad)
need('CreateFrame("Button"' not in landscape,
     'inert preview must not create an interactive utility Button')
version = re.search(r'(?m)^## Version: (\S+)$', toc)
boot = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', bootstrap)
need(bool(version and boot and version.group(1) == boot.group(1)),
     'version parity missing')
for token in ('P0283','P0284','VISUAL PASS','D-046','D-047','UNVERIFIED',
              'synthetic','Blizzard'):
    need(token in evidence, 'durable scope/status missing '+token)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff must cite authoritative CURRENT')
print('P0284 landscape trainer inert utility completeness contract')
for e in errors:
    print('ERROR:', e)
if errors:
    raise SystemExit(1)
print('PASS: filter, categorized mode, funds, Train All preview only; native H unchanged')
