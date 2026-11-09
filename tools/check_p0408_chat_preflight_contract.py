#!/usr/bin/env python3
"""P0408: next checkpoints and runtime scope remain deterministic."""

from pathlib import Path
import runpy
import tempfile

import build_patch_zip as builder
import chat_change as chat

tools = Path(__file__).resolve().parent
historical = runpy.run_path(str(tools / "check_p0381_integrated_gameplay_contract.py"))


def refused(fn, expected, error_type):
    try:
        fn()
    except error_type as error:
        assert expected in str(error), error
    else:
        raise AssertionError(f"Expected refusal: {expected}")


checkpoint = historical["current_checkpoint"]
verify_roadmap = historical["check_roadmap_checkpoint"]
future = "# Current State\n\n## Current Work Item\n\n**P9999** Example\n"
assert checkpoint(future) == "P9999"
history = (tools.parent / "docs/ROADMAP.md").read_text(encoding="utf-8")
verify_roadmap("fixture", "## P9999 \u2014 Next checkpoint\n\n" + history, "P9999")
refused(lambda: verify_roadmap("fixture", history, "P9999"), "CURRENT checkpoint P9999", AssertionError)
missing = ("## P9999 \u2014 Next checkpoint\n\n" + history).replace("## P0406 \u2014", "## Removed \u2014", 1)
refused(lambda: verify_roadmap("fixture", missing, "P9999"), "lost checkpoint history: P0406", AssertionError)
refused(lambda: checkpoint("**P9999** outside the work section\n"), "missing Current Work Item", AssertionError)

runtime = {"files": [{"path": "Logres/Quest/OptionModel.lua"}]}
refused(lambda: chat.require_runtime_opt_in(runtime, False), "--allow-runtime", chat.Refused)
chat.require_runtime_opt_in(runtime, True)
chat.require_runtime_opt_in({"files": [{"path": "docs/ROADMAP.md"}]}, False)

with tempfile.TemporaryDirectory(prefix="logres-check-report-") as directory:
    candidate = Path(directory)
    checkers = [candidate / name for name in ("check_a.py", "check_b.py", "check_c.py")]
    for checker, source in zip(checkers, ("raise SystemExit('alpha')\n", "pass\n", "raise SystemExit('omega')\n")):
        checker.write_text(source, encoding="utf-8")
    try:
        builder.run_candidate_checks(candidate, checkers)
    except builder.Refused as error:
        message = str(error)
        for token in ("1/3 passed", "check_a.py", "alpha", "check_c.py", "omega"):
            assert token in message, message
    else:
        raise AssertionError("Both failing checks must be reported")
    builder.run_candidate_checks(candidate, [checkers[1]])

print("P0408 future checkpoint, missing history, runtime opt-in and all-error report: PASS")
