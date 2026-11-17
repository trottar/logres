#!/usr/bin/env python3
"""Cheap preflight and deterministic discussion-first Chat handoff."""
from io import BytesIO
from pathlib import Path
import json,tarfile,tempfile,zipfile
import build_patch_zip as builder
import chat_author as author

def refuses(fn,part):
    try:fn()
    except builder.Refused as error:assert part in str(error),str(error)
    else:raise AssertionError('expected refusal: '+part)

head='1'*40;tree='2'*40
source=BytesIO()
with tarfile.open(fileobj=source,mode='w',format=tarfile.PAX_FORMAT,pax_headers={'comment':head})as tar:
    for name,data in {'Logres/Logres.toc':b'## Version: 1.2.3-fixture\n',
                      'docs/fixture.md':b'tracked\n','tools/check_fixture.py':b'raise AssertionError("must never run on export")\n'}.items():
        item=tarfile.TarInfo(name);item.size=len(data);tar.addfile(item,BytesIO(data))
archive=source.getvalue()
info={'head':head,'head_tree':tree,'runtime_source_version':'1.2.3-fixture',
      'checkers':['check_fixture.py'],'tracked_changes':[],
      'untracked_patchable_paths':['docs/private-local.md'],'branch':'main'}
with tempfile.TemporaryDirectory(prefix='p0467-chat-contract-')as folder:
    root=Path(folder);first=root/'one.zip';second=root/'two.zip'
    checksum=author.export_handoff(first,info,archive)
    assert checksum==author.export_handoff(second,dict(reversed(list(info.items()))),archive)
    assert first.read_bytes()==second.read_bytes()
    with zipfile.ZipFile(first)as bundle:
        assert bundle.testzip()is None
        assert set(bundle.namelist())=={'LOGRES_AUTHOR_KIT.zip','LOGRES_CONTEXT.json','CHAT_HANDOFF.md','HANDOFF_MANIFEST.json'}
        manifest=json.loads(bundle.read('HANDOFF_MANIFEST.json'))
        assert manifest['baseline']==head and manifest['baseline_tree']==tree
        assert manifest['github_verification']=='required-in-chat'
        for name,digest in manifest['files'].items():assert author.digest(bundle.read(name))==digest
        prompt=bundle.read('CHAT_HANDOFF.md').decode()
        assert 'Start in discussion mode' in prompt and 'until I ask to implement' in prompt
        assert 'ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"' in prompt
        assert '_forever_/Interface/AddOns' in prompt
        assert 'exact checksum, apply AND git add/commit/push commands directly' in prompt
        kit=root/'kit.zip';kit.write_bytes(bundle.read('LOGRES_AUTHOR_KIT.zip'))
        _,inside=author.load_context(kit,head)
        with tarfile.open(fileobj=BytesIO(inside))as tar:assert 'docs/private-local.md'not in tar.getnames()
    before=first.read_bytes()
    try:author.export_handoff(first,info,archive)
    except FileExistsError:pass
    else:raise AssertionError('existing output overwritten')
    assert first.read_bytes()==before
    refuses(lambda:author.export_handoff(root/'dirty.zip',dict(info,tracked_changes=[{'path':'docs/fixture.md'}]),archive),'clean tracked')
    assert not(root/'dirty.zip').exists()
    refuses(lambda:author.export_handoff(root/'head.zip',dict(info,head=tree),archive),'checkout commit')
    refuses(lambda:author.export_handoff(root/'version.zip',dict(info,runtime_source_version='other'),archive),'version changed')
    refuses(lambda:author.export_handoff(root/'inventory.zip',dict(info,checkers=[]),archive),'checker inventory')
    assert not(root/'inventory.zip').exists()
    c=root/'candidate';(c/'docs/memory/handoffs').mkdir(parents=True)
    current=c/'docs/memory/CURRENT.md';handoff=c/'docs/memory/handoffs/CURRENT_HANDOFF.md'
    current.write_bytes(b'a'*9799);handoff.write_bytes(b'a'*7999)
    builder.fast_candidate_preflight(c)
    current.write_bytes(b'a'*9800)
    refuses(lambda:builder.fast_candidate_preflight(c),'CURRENT.md is 9800 bytes')
    current.write_bytes(b'a'*9799);handoff.write_bytes(b'a'*8000)
    refuses(lambda:builder.fast_candidate_preflight(c),'CURRENT_HANDOFF.md is 8000 bytes')
    handoff.write_bytes(b'a'*7999);(c/'Logres/Core').mkdir(parents=True)
    (c/'Logres/Logres.toc').write_text('## Version: arbitrary-dynamic\n')
    (c/'Logres/Core/Bootstrap.lua').write_text('Logres.VERSION = "arbitrary-dynamic"\n')
    builder.fast_candidate_preflight(c)
    (c/'Logres/Core/Bootstrap.lua').write_text('Logres.VERSION = "other"\n')
    refuses(lambda:builder.fast_candidate_preflight(c),'runtime versions differ')
print('P0467 PASS: handoff determinism/hash/privacy/prompt/refusal and cheap memory/parity preflight; no Git mutation')
