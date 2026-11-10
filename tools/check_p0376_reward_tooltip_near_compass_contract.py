#!/usr/bin/env python3
"""P0376: read-only reward item hover and near-quest marker center/hysteresis."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p:(R/p).read_text(encoding='utf-8')
C=read('Logres/Navigation/Compass.lua')
D=read('Logres/Quest/Dialogue.lua')
V=read('Logres/Quest/RewardVisual.lua')
LEDGER=read('docs/memory/investigations/ISSUE_LEDGER.md')
CURRENT=read('docs/memory/CURRENT.md')
HANDOFF=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
XP=read('docs/memory/evidence/P0376_REWARD_TOOLTIP_NEAR_COMPASS.md')
TOC=read('Logres/Logres.toc')
BOOT=read('Logres/Core/Bootstrap.lua')
def need(ok,msg):
    if not ok: raise AssertionError('P0376: '+msg)

# Distances remain sourced only from guarded native map/ordinary source positions.
for token in ('local function ordinaryFocusedDistance(distance)',
              'isSecret(distance)', 'math.floor(yards + 0.5)',
              'label:SetText(name .. " - " .. text)',
              'local previousNearQuest = self.nearQuestCenterKeys or {}',
              'local nearQuestCenterKeys = {}',
              'local questLinked = role=="quest" or',
              'local centered = questLinked and (distance<=3 or (wasNear and distance<4))',
              'if centered then relative=0 end',
              'self.nearQuestCenterKeys = nearQuestCenterKeys',
              'reserveMarkerBearing(candidate.x, markerWidth, occupied)',
              'glyph:SetPoint("CENTER", self.frame, "CENTER", candidate.x, TAPE_Y)'):
    need(token in C,'source-safe near-center path missing: '+token)
need('"~" .. tostring(math.floor(yards + 0.5))' not in C,'old approximation tilde retained')
need('if not cap or distance>cap then return end' in C,'zero-yard center path missing')

# Real item metadata is plain, checked, and read-only. View never reaches native claim.
for token in ('local function ordinaryQuestRewardLink(kind, index)',
              'pcall(GetQuestItemLink, kind, index)',
              'if not ok or isSecret(link) or type(link)~="string" then return nil end',
              'if not isSecret(itemID) and type(itemID)=="number"',
              'card.itemLink = ordinaryQuestRewardLink(kind,index)',
              'card.itemLink = ordinaryQuestRewardLink("reward",1)',
              'itemID = safeItemID,'):
    need(token in D,'guarded item identity missing: '+token)
for token in ('local function showRewardTooltip(button)',
              'pcall(tooltip.SetOwner,tooltip,button,"ANCHOR_RIGHT")',
              'pcall(tooltip.SetHyperlink,tooltip,button.itemLink)',
              'pcall(tooltip.SetItemByID,tooltip,button.itemID)',
              'pcall(GameTooltip_ShowCompareItem,tooltip,true)',
              'slot.itemID = card.itemID', 'slot.itemLink = card.itemLink',
              'slot:EnableMouse(interactive)', 'slot:EnableMouse(true)',
              'self.previewChoiceHandler and button.choiceIndex',
              'self:PaintPreviewChoices()'):
    need(token in V,'read-only hover path or preview gate missing: '+token)
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'QuestRewardCompleteButton_OnClick(',
                  'C_GossipInfo.Select(', 'SetScript("OnUpdate"', 'C_Timer.',
                  'HideUIPanel(', 'RegisterStateDriver('):
    need(forbidden not in V,'unsafe native mutation/polling in reward view: '+forbidden)
need(V.count('slot:SetScript("OnClick", function(button)')==1,
     'reward view click routing must stay preview-gated')
need('L-035' in LEDGER and 'L-038' in LEDGER and 'L-027' in LEDGER,
     'canonical issue rows missing')
need('New Recipe Learned!' in XP and 'L-027' in XP and 'UNVERIFIED' in XP,
     'screenshot intake / unresolved state missing')
need('L-031' in CURRENT and 'P0376' in CURRENT and 'P0374' in CURRENT,
     'CURRENT state continuity missing')
need('P0376' in HANDOFF and 'docs/memory/investigations/ISSUE_LEDGER.md' in HANDOFF,
     'handoff ledger-first continuity missing')
need(len(CURRENT.encode()) < 9800 and len(HANDOFF.encode()) < 8000,
     'canonical memory byte limit exceeded')
a=re.search(r'^## Version: (0\.0\.\d+-dev)$',TOC,re.M)
b=re.search(r'^Logres.VERSION = "(0\.0\.\d+-dev)"$',BOOT,re.M)
need(a and b and a.group(1)==b.group(1),'runtime version parity')
print('P0376 passive reward tooltip / 3yd quest center: PASS (STATIC ONLY, WoW UNVERIFIED)')
