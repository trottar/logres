#!/usr/bin/env python3
"""P0452 evidence identity, capture versions and export provenance."""

import importlib.util
import json
from pathlib import Path
import tempfile
import zipfile

R = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("logres_evidence_export", R/"tools/export_panel_diagnostics.py")
exporter = importlib.util.module_from_spec(spec)
spec.loader.exec_module(exporter)


def capture(identifier, version):
    return f'''LogresDiagnosticsDB = {{
["incidents"] = {{
{{
["id"] = {identifier},
["session"] = 12,
["time"] = 1794441600,
["version"] = "{version}",
["screenshot"] = "failed",
}},
}},
}}
'''.encode()


with tempfile.TemporaryDirectory(prefix="p0452-evidence-") as directory:
    root = Path(directory)
    live = root/"_forever_/WTF/Account/Fixture/SavedVariables/Logres.lua"
    live.parent.mkdir(parents=True)
    deployed = root/"_forever_/Interface/AddOns/Logres/Logres.toc"
    deployed.parent.mkdir(parents=True)
    deployed.write_text("## Version: fixture-new\n")
    output = root/"LOGRES_DIAGNOSTICS_LATEST.lua"
    bundle = root/"LOGRES_BUG_REPORT_LATEST.zip"
    first = capture(50, "fixture-old")
    live.write_bytes(first)
    output.write_bytes(first)
    report = exporter.build_bundle(root, output, bundle, live)
    provenance = report["provenance"]
    assert provenance["latest_capture_version"] == "fixture-old"
    assert provenance["deployed_forever_version"] == "fixture-new"
    assert provenance["deployed_vs_capture"] == "different"
    assert provenance["previous_export"] is None
    summary = exporter.inspect_evidence(bundle)
    assert summary["latest_incident"]["id"] == 50
    assert summary["diagnostics_sha256"] == exporter.capture_summary(first)["diagnostics_sha256"]

    report = exporter.build_bundle(root, output, bundle, live)
    assert report["provenance"]["previous_export"] == {
        "diagnostics_identical": True, "latest_incident_identical": True}
    assert any("unchanged" in warning for warning in report["warnings"])
    second = capture(51, "fixture-new")
    live.write_bytes(second)
    output.write_bytes(second)
    report = exporter.build_bundle(root, output, bundle, live)
    assert report["provenance"]["previous_export"] == {
        "diagnostics_identical": False, "latest_incident_identical": False}
    assert report["provenance"]["deployed_vs_capture"] == "match"
    assert exporter.capture_summary(b"LogresDiagnosticsDB = {}")["latest_capture_version"] is None

    deployed.unlink()
    report = exporter.build_bundle(root, output, bundle, live)
    assert report["provenance"]["source_vs_deployed"] == "unknown"
    assert report["provenance"]["deployed_vs_capture"] == "unknown"
    corrupted = root/"corrupted.zip"
    with zipfile.ZipFile(bundle) as good, zipfile.ZipFile(corrupted, "w") as bad:
        for name in good.namelist():
            data = good.read(name)
            if name == "LOGRES_DIAGNOSTICS_LATEST.lua":
                data += b"\n"
            bad.writestr(name, data)
    try:
        exporter.inspect_evidence(corrupted)
    except ValueError as error:
        assert "hash disagrees" in str(error)
    else:
        raise AssertionError("Mismatched evidence pair must refuse")

assert "--inspect" in (R/"tools/export_panel_diagnostics.py").read_text()
print("P0452 duplicate incidents, capture/deployment separation, absent versions and hash mismatch: PASS")

# Verify the standalone delivery route against the same index bytes.
from hashlib import sha256
import chat_change as chat
import build_patch_zip as builder

with tempfile.TemporaryDirectory(prefix="p0452-staged-zip-") as directory:
    repo = Path(directory).resolve()
    path = "docs/fixture.md"
    data = b"verified payload\n"
    spec = {
        "id": "P9999", "title": "Staged ZIP fixture", "baseline": "1" * 40,
        "hashes": {path: (None, sha256(data).hexdigest())},
        "checkers": [], "version": "fixture", "runtime": False,
    }
    archive = repo/"P9999.zip"
    archive.write_bytes(builder.zip_bytes(
        {path: data}, spec, (R/"tools/patch_applier_template.py.in").read_text()))
    manifest = ("P9999 Staged ZIP fixture\nVerified baseline: " + "1" * 40
                + "\nChanged paths:\ndocs/fixture.md\nP9999_MANIFEST.txt\n").encode()
    index = {path: data, "P9999_MANIFEST.txt": manifest}
    original_git = chat.git
    def fake_git(root, *args):
        assert root == repo
        if args == ("rev-parse", "--show-toplevel"):
            return str(repo).encode()
        if args == ("rev-parse", "--verify", "HEAD"):
            return b"1" * 40
        if args == ("diff", "--cached", "--name-only", "--no-renames", "-z"):
            return b"".join(name.encode() + b"\0" for name in index)
        if args[:1] == ("show",):
            return index[args[1][1:]]
        assert args == ("diff", "--cached", "--check"), args
        return b""
    chat.git = fake_git
    try:
        chat.verify_zip_staged(repo, archive)
        index[path] = b"wrong bytes\n"
        try:
            chat.verify_zip_staged(repo, archive)
        except chat.Refused as error:
            assert "Staged bytes differ" in str(error)
        else:
            raise AssertionError("Wrong staged bytes must refuse")
        index[path] = data
        index["docs/unrelated.md"] = b"local work\n"
        try:
            chat.verify_zip_staged(repo, archive)
        except chat.Refused as error:
            assert "Staged paths differ" in str(error)
        else:
            raise AssertionError("Unrelated staged paths must refuse")
    finally:
        chat.git = original_git
print("P0452 standalone ZIP staged-byte and unrelated-path refusal: PASS")
