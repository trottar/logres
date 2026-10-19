#!/usr/bin/env python3
"""P0256: every registered visual preview must live in the paginated P tab."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
C = (ROOT/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
P = (ROOT/'Logres/Dev/Panel.lua').read_text(encoding='utf-8')
TOC = (ROOT/'Logres/Logres.toc').read_text(encoding='utf-8')
BOOT = (ROOT/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
errors = []
pattern = re.compile(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([0A-HP])"\s*\)', re.S)
actions = pattern.findall(C)
required = {
    'actionFeedback','compassArtOn','compassArtOff','xpPreview',
    'objectiveProgressPreview','activeQuestPreviewNormal','activeQuestPreviewComplete',
    'activeQuestLive','questDialoguePreview','questNarrativePreviewShort',
    'questNarrativePreviewGeneric','questRewardPreviewSingle',
    'questRewardPreviewMulti','npcOptionBranching','npcOptionServices',
    'npcOptionOverflow','npcOptionLocked','npcCatalogMerchant',
    'npcCatalogTrainer','npcCatalogFlight','npcCatalogUnavailable','statusAuraPreviewOn','statusAuraPreviewOff',
    'playerHelpfulAuraPreview','hudPreviewOn','hudPreviewOff',
    'healthPreview100','healthPreview80','healthPreview70','healthPreview60',
    'healthPreview50','healthPreview40','healthPreview30','healthPreview20',
    'healthPreview15','healthPreview5','healthPreview0','healthPreviewLive',
}
found = {id_: (label,command,phase) for id_,label,command,phase in actions}
if len(found) != len(actions): errors.append('duplicate visual or diagnostic registry ID')
for id_ in sorted(required):
    value = found.get(id_)
    if not value or value[2] != 'P': errors.append(f'{id_}: must be registered in Previews tab')
if len(required) != 38: errors.append('unexpected baseline visual preview inventory')
if set(id_ for id_,label,cmd,phase in actions if phase=='P') != required:
    errors.append('P gallery has missing or unreviewed additional actions')
for id_,label,command,phase in actions:
    if phase!='P' and ('preview' in command or 'preview' in id_.lower() or 'preview' in label.lower()):
        errors.append(f'visual preview outside P tab: {id_}/{phase}')
    if phase=='P' and any(x in command for x in (
        'acceptprobe','declineprobe','immersion on','immersion off',
        'mainreplace on','mainreplace off','stockreplace on','stockreplace off',
        'bindings on','bindings off','petbardriver on','petbardriver off')):
        errors.append('gameplay-changing operation placed among visual previews: '+id_)
if len(actions) != 106: errors.append('unexpected total action registrations: '+str(len(actions)))
for token in (
    '{ id = "P", title = "Previews — All UI Areas" }',
    'local TAB_WIDTH = 52',
    'local PREVIEW_PAGE_SIZE = MAX_ACTIONS_PER_PHASE',
    'self.previewPage = 1',
    'function Panel:CreatePreviewPager(frame)',
    'function Panel:UpdatePreviewPager(total)',
    'function Panel:RefreshActionButtons()',
    'self.previewPrevious:SetScript("OnClick"',
    'self.previewNext:SetScript("OnClick"',
    'self.previewPageLabel:SetText(',
    'if self.activePhase == "P" then',
    'math.ceil(total / PREVIEW_PAGE_SIZE)',
    'local first = (self.previewPage - 1) * PREVIEW_PAGE_SIZE + 1',
    'local last = math.min(#visible, first + PREVIEW_PAGE_SIZE - 1)',
    'self:UpdatePreviewPager(#visible)',
):
    if token not in P: errors.append('preview panel missing: '+token)
if 'P = true,' not in C: errors.append('Commands registry does not authorize Preview tab')
if 'hudpreview on' not in C or 'hudpreview off' not in C:
    errors.append('existing HUD sample command not accessible through preview gallery')
if 'PHASES = set("0ABCDEFGHP")' not in (ROOT/'tools/check_dev_panel_contract.py').read_text(encoding='utf-8'):
    errors.append('original panel checker does not authorize P')
version_toc=re.search(r'^## Version: ([^\r\n]+)$',TOC,re.M)
version_boot=re.search(r'^Logres\.VERSION = "([^"]+)"',BOOT,re.M)
if not version_toc or not version_boot or version_toc.group(1)!=version_boot.group(1):
    errors.append('TOC/Bootstrap runtime-version parity mismatch')
print('P0256 unified visual preview gallery contract')
print('============================================')
for error in errors: print('ERROR:',error)
if errors: raise SystemExit(1)
print(f'PASS: {len(required)} existing preview actions on P, {len(actions)} total, 0 errors')
