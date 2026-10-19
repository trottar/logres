#!/usr/bin/env python3
"""P0268 historical proof is retained; P0269 retires its misleading runtime demo."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
read=lambda x:(R/x).read_text(encoding='utf-8')
e=[]
def need(condition,message):
 if not condition:e.append(message)
# Historical evidence is durable even when a prototype is retired.
need((R/'docs/memory/evidence/P0268_MULTI_SERVICE_CATALOGUE.md').is_file(),
    'P0268 evidence must remain durable')
need((R/'docs/memory/patches/P0268_MULTI_SERVICE_CATALOGUE.md').is_file(),
    'P0268 patch record must remain durable')
t=read('Logres/Logres.toc');c=read('Logres/Core/Commands.lua')
need('Quest\\ServiceCatalogModel.lua' not in t,'retired P0268 model must not load')
for key in ('npcCatalogMerchant','npcCatalogTrainer','npcCatalogFlight','npcCatalogUnavailable'):
 need('"'+key+'"' not in c,'retired gallery action: '+key)
need('Logres.NPCServiceCatalogModel' not in read('Logres/Quest/Dialogue.lua'),
    'no active production dispatcher to catalogue replacement')
need('choice.action == "preview-confirm"' not in read('Logres/Quest/OptionSession.lua'),
    'synthetic service confirmation removed')
need('Quest\\NativeServicePolicy.lua' in t,'native-first authority now loaded')
print('P0268 archival evidence and P0269 retirement contract')
for x in e:print('ERROR:',x)
if e: raise SystemExit(1)
print('PASS: historical P0268 evidence retained, synthetic service UI retired')
