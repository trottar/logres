#!/usr/bin/env python3
"""P0412 exact text fragments and future issue registrations."""

from contextlib import redirect_stderr
import io
import json
from pathlib import Path
import runpy

import chat_change as chat

root = Path(__file__).resolve().parents[1]


def refused(fn, text, error_type=chat.Refused):
    try:
        fn()
    except error_type as error:
        assert text in str(error), error
    else:
        raise AssertionError(f"Expected refusal: {text}")


pin = "0." + "0.98765-dev"
package = chat.parse_change(json.dumps({
    "schema": "logres-change/v1", "id": "P9999", "baseline": "0" * 40,
    "title": "Exact fragment", "files": [
        {"path": "docs/sample.md", "edits": [{"before": "Prefix", "after": "Changed"}]},
        {"path": "tools/check_candidate.py", "create": f"VERSION = {pin!r}\n"},
    ],
}).encode())
with redirect_stderr(io.StringIO()) as warning:
    diff = chat.make_diff(package, {"docs/sample.md": "Prefix tail\n", "tools/check_candidate.py": None},
                          show_checker_warnings=True)
assert "+Changed tail\n" in diff
assert "CHECK WILL REFUSE tools/check_candidate.py" in warning.getvalue()
assert pin in warning.getvalue()
refused(lambda: chat.change_text("Prefix\nPrefix\n", package["files"][0]["edits"], "fixture"), "ambiguous")
refused(lambda: chat.change_text("xPrefix\n", package["files"][0]["edits"], "fixture"), "absent")
refused(lambda: chat.change_text("old\n", [{"before": "old\n", "after": "new"}], "fixture"), "end with LF")

for path, before, after in (
    ("Logres/Logres.toc", "## Version: a\n", "## Version: b\n"),
    ("Logres/Core/Bootstrap.lua", 'Logres.VERSION = "a"\n', 'Logres.VERSION = "b"\n'),
):
    assert chat.version_only({"path": path, "edits": [{"before": before, "after": after}]})
    assert not chat.version_only({"path": path, "edits": [{"before": before, "after": after + "other\n"}]})

ledger_checker = runpy.run_path(str(root / "tools/check_p0374_issue_ledger_contract.py"))
parse = ledger_checker["issue_rows"]
ledger = ledger_checker["ledger"]
number = len(parse(ledger)) + 1
new_row = f"| L-{number:03d} | Fixture | OPEN | Reported | Unverified | Source |\n"
assert parse(ledger + "\n" + new_row)[-1][0] == f"L-{number:03d}"
refused(lambda: parse(ledger + "\n" + new_row + new_row), "unique, ordered and consecutive", AssertionError)
gap = new_row.replace(f"L-{number:03d}", f"L-{number + 1:03d}")
refused(lambda: parse(ledger + "\n" + gap), "unique, ordered and consecutive", AssertionError)
refused(lambda: parse(ledger + "\n" + new_row.replace("OPEN", "UNKNOWN")),
        "canonical columns and status", AssertionError)
print("P0412 exact fragments, candidate warning, focused checker hints and extensible issue ledger: PASS")
