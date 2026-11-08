#!/usr/bin/env python3
"""P0405 local Chat-to-ZIP contract and deterministic archive fixture."""

from hashlib import sha256
import importlib.util
from pathlib import Path
import shutil
import tempfile
import zipfile
import io

root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("logres_zip_builder", root / "tools/build_patch_zip.py")
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)
template = (root / "tools/patch_applier_template.py.in").read_text(encoding="utf-8")

CHANGE = b"""diff --git a/docs/fixture.md b/docs/fixture.md
--- a/docs/fixture.md
+++ b/docs/fixture.md
@@ -1 +1 @@
-before
+after
"""
NEW = b"""diff --git a/docs/new.md b/docs/new.md
new file mode 100644
--- /dev/null
+++ b/docs/new.md
@@ -0,0 +1 @@
+new file
"""
DELETE = b"""diff --git a/docs/fixture.md b/docs/fixture.md
deleted file mode 100644
--- a/docs/fixture.md
+++ /dev/null
@@ -1 +0,0 @@
-before
"""
MODE = b"""diff --git a/docs/fixture.md b/docs/fixture.md
old mode 100644
new mode 100755
"""
SYMLINK = NEW.replace(b"100644", b"120000")
for name in (".git/config", "docs/../file", "tools/.git/config", "/tmp/file", "docs\\fixture.md"):
    assert not builder.safe_path(name), name

with tempfile.TemporaryDirectory(prefix="p0405-") as directory:
    base = Path(directory) / "baseline"
    (base / "docs").mkdir(parents=True)
    (base / "docs/fixture.md").write_bytes(b"before\n")
    for index, (patch, allowed) in enumerate((
        (CHANGE, {"docs/wrong.md"}),
        (CHANGE + NEW, {"docs/fixture.md"}),
        (CHANGE.replace(b"-before", b"-outdated"), {"docs/fixture.md"}),
        (DELETE, {"docs/fixture.md"}),
        (MODE, {"docs/fixture.md"}),
        (SYMLINK, {"docs/new.md"}),
        (CHANGE.replace(b"+after", b"+after "), {"docs/fixture.md"}),
    )):
        candidate = base.with_name(f"refuse-{index}")
        shutil.copytree(base, candidate)
        try:
            builder.stage_patch(base, candidate, patch, allowed)
        except builder.Refused:
            pass
        else:
            raise AssertionError(f"Unexpected success in refusal case {index}")
        assert (base / "docs/fixture.md").read_bytes() == b"before\n"
        assert not (base / "docs/new.md").exists()
    candidate = base.with_name("candidate")
    shutil.copytree(base, candidate)
    files, hashes = builder.stage_patch(base, candidate, CHANGE + NEW, {"docs/new.md", "docs/fixture.md"})
    assert files == {"docs/fixture.md": b"after\n", "docs/new.md": b"new file\n"}
    assert hashes["docs/fixture.md"] == tuple(sha256(data).hexdigest() for data in (b"before\n", b"after\n"))
    assert hashes["docs/new.md"][0] is None

metadata = {"id": "P9999", "baseline": "0" * 40, "title": "Fixture", "hashes": hashes,
            "checkers": ["check_fixture.py"], "version": "1.2.3-fixture", "runtime": False}
first = builder.zip_bytes(files, metadata, template)
second = builder.zip_bytes(dict(reversed(list(files.items()))), metadata, template)
assert first == second
with zipfile.ZipFile(io.BytesIO(first)) as archive:
    assert archive.testzip() is None
    assert archive.namelist() == ["P9999_APPLY.py", "P9999_PAYLOAD/docs/fixture.md",
                                "P9999_PAYLOAD/docs/new.md", "P9999_README.txt"]
    assert b"No WoW redeploy is required." in archive.read("P9999_README.txt")
print("P0405 staged text, explicit scope, unsafe-input refusals and repeatable ZIP: PASS")
