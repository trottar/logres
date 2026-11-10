#!/usr/bin/env python3
"""P0434 portable author preflight, receipt binding and refusal."""

from io import BytesIO
from pathlib import Path
import tarfile
import tempfile
import zipfile

import chat_author as author
import chat_change as chat


def refuses(action, message):
    try:
        action()
    except chat.Refused as error:
        assert message in str(error), error
    else:
        raise AssertionError(f"Expected refusal: {message}")


head, tree = "1" * 40, "2" * 40
package = {
    "schema": "logres-change/v1",
    "id": "P9999",
    "baseline": head,
    "title": "A" * 100,
    "files": [{"path": "docs/fixture.md", "edits": [{"before": "old\n", "after": "new\n"}]}],
}
raw = author.json_bytes(package)
assert chat.parse_change(raw) == package
refuses(lambda: chat.parse_change(author.json_bytes(dict(package, title="A" * 103))), "up to 100")

source = BytesIO()
with tarfile.open(fileobj=source, mode="w", format=tarfile.PAX_FORMAT,
                  pax_headers={"comment": head}) as tar:
    files = {
        "Logres/Logres.toc": b"## Version: 0.0.fixture\n",
        "docs/fixture.md": b"old\n",
        "tools/check_fixture.py": b"from pathlib import Path\nassert Path('docs/fixture.md').read_bytes() == b'new\\n'\n",
    }
    for name, data in files.items():
        member = tarfile.TarInfo(name)
        member.size = len(data)
        tar.addfile(member, BytesIO(data))
archive = source.getvalue()

with tempfile.TemporaryDirectory(prefix="logres-author-contract-") as folder:
    root = Path(folder)
    kit, repeat = root / "kit.zip", root / "repeat.zip"
    info = {"head": head, "head_tree": tree, "checkers": ["check_fixture.py", "check_local_untracked.py"],
            "untracked_patchable_paths": ["docs/local-private.md"]}
    author.export_context(kit, info, archive)
    author.export_context(repeat, info, archive)
    assert kit.read_bytes() == repeat.read_bytes()
    metadata, _ = author.load_context(kit, head)
    assert "untracked_patchable_paths" not in metadata
    assert metadata["checkers"] == ["check_fixture.py"]
    receipt = author.check(kit, package, raw, chat.make_diff)
    assert receipt["checkers_passed"] == 1
    assert receipt == author.check(kit, package, raw, chat.make_diff)
    author.verify_package(receipt, package, raw)
    author.verify_receipt(receipt, dict(receipt))
    refuses(lambda: author.verify_package(receipt, package, raw + b"\n"), "exact draft bytes")
    refuses(lambda: author.verify_receipt(receipt, dict(receipt, baseline_tree=head)), "local tree")
    refuses(lambda: author.verify_receipt(dict(receipt, checkers_passed=True), receipt), "checker count")
    refuses(lambda: author.load_context(kit, tree), "baseline or tree")

    broken = root / "broken.zip"
    with zipfile.ZipFile(broken, "x") as output:
        output.writestr(author.CONTEXT, author.json_bytes(metadata))
        output.writestr(author.ARCHIVE, archive + b"x")
    refuses(lambda: author.load_context(broken, head), "archive hash mismatch")

    failing = dict(package, files=[{"path": "docs/fixture.md",
                                  "edits": [{"before": "old\n", "after": "wrong\n"}]}])
    refuses(lambda: author.check(kit, failing, author.json_bytes(failing), chat.make_diff),
            "Candidate checks: 0/1 passed")
print("P0434 title boundary, portable candidate, deterministic kit, exact receipt and checker refusal: PASS")
