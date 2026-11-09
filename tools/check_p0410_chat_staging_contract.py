#!/usr/bin/env python3
"""P0410 staged-file coverage and checker-reference hints for Chat patches."""

from contextlib import redirect_stdout
import io
from pathlib import Path
import shlex
import tempfile

import chat_change as chat


def refused(fn, fragment):
    try:
        fn()
    except chat.Refused as error:
        assert fragment in str(error), error
    else:
        raise AssertionError(f"Expected refusal: {fragment}")


head = "1" * 40
package = {
    "id": "P9999", "baseline": head, "title": "Exact staged patch",
    "files": [
        {"path": "Logres/Quest/Fake.lua", "edits": [{"before": "old\n", "after": "new\n"}]},
        {"path": "tools/check_new.py", "create": "pass\n"},
    ],
}
expected = chat.manifest_paths(package)
assert expected == ["Logres/Quest/Fake.lua", "tools/check_new.py", "P9999_MANIFEST.txt"]
with tempfile.TemporaryDirectory(prefix="logres-stage-contract-") as directory:
    repo = Path(directory).resolve()
    (repo / "tools").mkdir()
    (repo / "tools/check_old.py").write_bytes(b"Logres/Quest/Fake.lua\n")
    (repo / "tools/check_unrelated.py").write_bytes(b"Logres/Core/Bootstrap.lua\n")
    assert chat.referenced_checkers(repo, package) == ["tools/check_old.py"]
    source = repo / "My Chat Changes.logres.json"
    assert shlex.split(chat.stage_command(package, source)) == [
        "git", "add", "--", *expected, "&&", "python3", "tools/chat_change.py",
        "verify-staged", str(source),
    ]

    def nul(paths):
        return b"".join(name.encode() + b"\0" for name in paths)

    staged = {
        ("rev-parse", "--show-toplevel"): str(repo).encode(),
        ("rev-parse", "--verify", "HEAD"): head.encode(),
        ("diff", "--cached", "--name-only", "--no-renames", "-z"): nul(expected),
        ("show", ":P9999_MANIFEST.txt"): (
            "P9999 Exact staged patch\nVerified baseline: " + head + "\nChanged paths:\n"
            + "\n".join(expected) + "\n").encode(),
        ("show", f"{head}:Logres/Quest/Fake.lua"): b"old\n",
        ("show", ":Logres/Quest/Fake.lua"): b"new\n",
        ("ls-tree", "--name-only", head, "--", "tools/check_new.py"): b"",
        ("show", ":tools/check_new.py"): b"pass\n",
        ("diff", "--cached", "--check"): b"",
    }

    def fake_git(root, *args):
        assert root == repo
        return staged[args]

    real_git = chat.git
    chat.git = fake_git
    try:
        with redirect_stdout(io.StringIO()) as output:
            chat.verify_staged(repo, package)
        assert "Ready to commit" in output.getvalue()
        key = ("diff", "--cached", "--name-only", "--no-renames", "-z")
        staged[key] = nul([expected[0], expected[-1], "docs/unrelated.md"])
        refused(lambda: chat.verify_staged(repo, package),
                "Missing: ['tools/check_new.py']. Extra: ['docs/unrelated.md']")
        staged[key] = nul(expected)
        staged[("show", ":Logres/Quest/Fake.lua")] = b"wrong\n"
        refused(lambda: chat.verify_staged(repo, package), "Staged file bytes differ")
        staged[("show", ":Logres/Quest/Fake.lua")] = b"new\n"
        staged[("show", ":P9999_MANIFEST.txt")] = b"P9999 Wrong title\n"
        refused(lambda: chat.verify_staged(repo, package), "does not match this package")
        staged[("rev-parse", "--verify", "HEAD")] = b"2" * 40
        refused(lambda: chat.verify_staged(repo, package), "Expected HEAD")
    finally:
        chat.git = real_git

print("P0410 exact staged files, mismatches, quoted command and checker references: PASS")
