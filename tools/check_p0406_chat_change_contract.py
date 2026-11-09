#!/usr/bin/env python3
"""P0406 contract for structured changes and exact local guard checks."""

import json
from pathlib import Path
import tempfile

import chat_change as change


def refused(fn, fragment):
    try:
        fn()
    except change.Refused as error:
        assert fragment in str(error), error
    else:
        raise AssertionError(f"Expected refusal: {fragment}")


receipt = {
    "schema": "logres-change/v1",
    "id": "P9999",
    "baseline": "0" * 40,
    "title": "Test exact local changes",
    "files": [
        {"path": "docs/test.md", "edits": [
            {"before": "old\n", "after": "first\n"},
            {"before": "first\n", "after": "final\n"},
        ]},
        {"path": "docs/new.md", "create": "new file\n"},
    ],
}
package = change.parse_change(json.dumps(receipt).encode())
diff = change.make_diff(package, {"docs/test.md": "old\n", "docs/new.md": None})
assert "+final\n" in diff and "+first\n" not in diff
assert "new file mode 100644" in diff
assert diff == change.make_diff(dict(package, files=list(reversed(package["files"]))),
                                {"docs/test.md": "old\n", "docs/new.md": None})
refused(lambda: change.make_diff(package, {"docs/test.md": "old\nold\n", "docs/new.md": None}),
        "ambiguous")
refused(lambda: change.make_diff(package, {"docs/test.md": "unrelated\n", "docs/new.md": None}),
        "absent")
refused(lambda: change.make_diff(package, {"docs/test.md": "old\n", "docs/new.md": "exists\n"}),
        "already exists")
refused(lambda: change.parse_change(b'{"schema":"a","schema":"b"}'), "Duplicate JSON key")
refused(lambda: change.parse_change(json.dumps(dict(receipt, files=[{"path": "tools/../outside", "create": "x\n"}])).encode()),
        "Unsafe or repeated")
refused(lambda: change.parse_change(json.dumps(dict(receipt, command="git push")).encode()),
        "exactly")
refused(lambda: change.parse_change(json.dumps(dict(receipt, files=[{"path": "docs/new.md", "create": "x\r\n"}])).encode()),
        "LF endings")
refused(lambda: change.parse_change(json.dumps(dict(receipt, files=receipt["files"] * 2)).encode()),
        "Unsafe or repeated")

original_git = change.git
with tempfile.TemporaryDirectory(prefix="logres-chat-contract-") as folder:
    repo = Path(folder).resolve()
    (repo / "docs").mkdir()
    (repo / "tools").mkdir()
    (repo / "Logres").mkdir()
    (repo / "Logres/Logres.toc").write_bytes(b"## Version: 9.8.7-fixture\n")
    (repo / "docs/test.md").write_bytes(b"old\n")
    status = b""
    head = b"0" * 40
    calls = []

    def fake_git(root, *args):
        assert root == repo
        calls.append(args)
        outputs = {
            ("rev-parse", "--show-toplevel"): str(repo).encode(),
            ("rev-parse", "--verify", "HEAD"): head,
            ("rev-parse", "HEAD^{tree}"): b"1" * 40,
            ("rev-parse", "--abbrev-ref", "HEAD"): b"main",
            ("status", "--porcelain=v1", "-z", "--no-renames", "--untracked-files=no"): status,
            ("ls-files", "--others", "--exclude-standard", "-z"): b"docs/local.md\0PRIVATE.txt\0",
            ("--version",): b"git version 2.0",
            ("show", f"{head.decode()}:docs/test.md"): b"old\n",
        }
        return outputs[args]

    change.git = fake_git
    try:
        context = change.context(repo)
        assert context["head"] == head.decode() and context["branch"] == "main"
        assert context["untracked_patchable_paths"] == ["docs/local.md"]
        assert context["tracked_changes"] == [] and context["runtime_source_version"] == "9.8.7-fixture"
        assert change.prepared_diff(repo, package) == diff
        status = b" M docs/test.md\0"
        assert change.context(repo)["tracked_changes"] == [{"state": " M", "path": "docs/test.md"}]
        refused(lambda: change.prepared_diff(repo, package), "Tracked changes")
        status = b""
        head = b"2" * 40
        refused(lambda: change.prepared_diff(repo, package), "Expected HEAD")
        head = b"0" * 40
        (repo / "docs/new.md").write_bytes(b"local content\n")
        refused(lambda: change.prepared_diff(repo, package), "Create path already exists")
        assert (repo / "docs/test.md").read_bytes() == b"old\n"
    finally:
        change.git = original_git

print("P0406 strict package parsing, exact text anchors, scoped context and baseline refusals: PASS")
