#!/usr/bin/env python3
"""Export Logres checkout context or apply a structured Chat change in WSL."""

import argparse
from difflib import unified_diff
from hashlib import sha256
import importlib.util
import json
from pathlib import Path
import re
import shutil
import sys
import tarfile
import tempfile
import zipfile

import build_patch_zip as builder
from build_patch_zip import Refused


REPO = Path(__file__).resolve().parents[1]
PROTOCOL = "logres-change/v1"


def git(repo, *args):
    return builder.command("git", *args, cwd=repo).stdout


def checkout_head(repo):
    if Path(git(repo, "rev-parse", "--show-toplevel").decode().strip()).resolve() != repo:
        raise Refused("Use the Logres repository root.")
    return git(repo, "rev-parse", "--verify", "HEAD").decode().strip()


def tracked_status(repo):
    raw = git(repo, "status", "--porcelain=v1", "-z", "--no-renames", "--untracked-files=no")
    return [{"state": row[:2].decode("ascii"), "path": row[3:].decode("utf-8")}
            for row in raw.split(b"\0") if row]


def context(repo):
    head = checkout_head(repo)
    tracked = tracked_status(repo)
    untracked = git(repo, "ls-files", "--others", "--exclude-standard", "-z")
    paths = [row.decode("utf-8", errors="replace") for row in untracked.split(b"\0") if row]
    toc, tools = repo / "Logres/Logres.toc", repo / "tools"
    if toc.resolve() != toc or tools.resolve() != tools:
        raise Refused("Logres source paths must stay inside the repository.")
    version = re.search(r"^## Version: (\S+)$", toc.read_text(encoding="utf-8"), re.MULTILINE)
    if not version:
        raise Refused("Local TOC version is unavailable.")
    return {
        "schema": "logres-context/v1",
        "repository": "trottar/logres",
        "head": head,
        "head_tree": git(repo, "rev-parse", "HEAD^{tree}").decode().strip(),
        "branch": git(repo, "rev-parse", "--abbrev-ref", "HEAD").decode().strip(),
        "runtime_source_version": version[1],
        "python": ".".join(map(str, sys.version_info[:3])),
        "git": git(repo, "--version").decode().strip(),
        "tracked_changes": tracked,
        "untracked_patchable_paths": sorted(name for name in paths if builder.safe_path(name)),
        "checkers": sorted(path.name for path in tools.glob("check_*.py")),
    }


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise Refused(f"Duplicate JSON key: {key}")
        result[key] = value
    return result


def exact_keys(value, expected, description):
    if not isinstance(value, dict) or value.keys() != expected:
        raise Refused(f"{description} must contain exactly {', '.join(sorted(expected))}.")


def valid_text(text, description, allow_empty=False):
    if not isinstance(text, str) or (text and not text.endswith("\n")) or (
        not text and not allow_empty
    ) or "\r" in text or "\0" in text or text.startswith("\ufeff"):
        raise Refused(f"{description} must use UTF-8 text with LF endings.")
    text.encode("utf-8")


def parse_change(raw):
    package = json.loads(raw.decode("utf-8"), object_pairs_hook=unique_object)
    exact_keys(package, {"schema", "id", "baseline", "title", "files"}, "Change package")
    if package["schema"] != PROTOCOL:
        raise Refused(f"Expected schema {PROTOCOL}.")
    if not isinstance(package["id"], str) or not re.fullmatch(r"P[0-9]{4}", package["id"]):
        raise Refused("Use a four-digit patch ID such as P0407.")
    baseline = package["baseline"]
    if not isinstance(baseline, str) or not re.fullmatch(r"[0-9a-f]{40}", baseline):
        raise Refused("Use the full lowercase baseline commit.")
    title = package["title"]
    if not isinstance(title, str) or not 1 <= len(title) <= 100 or not title.isprintable():
        raise Refused("Use a one-line title up to 100 characters.")
    if not isinstance(package["files"], list) or not package["files"]:
        raise Refused("The change must include at least one file.")
    seen = set()
    for change in package["files"]:
        if not isinstance(change, dict):
            raise Refused("Each file change must be a JSON object.")
        create = "create" in change
        exact_keys(change, {"path", "create"} if create else {"path", "edits"}, "File change")
        path = change["path"]
        if not isinstance(path, str) or not builder.safe_path(path) or path in seen:
            raise Refused(f"Unsafe or repeated path: {path!r}")
        seen.add(path)
        if create:
            valid_text(change["create"], f"{path} content")
            continue
        if not isinstance(change["edits"], list) or not change["edits"]:
            raise Refused(f"{path} requires at least one edit.")
        for edit in change["edits"]:
            exact_keys(edit, {"before", "after"}, "Edit")
            valid_text(edit["before"], f"{path} before")
            valid_text(edit["after"], f"{path} after", allow_empty=True)
            if edit["before"] == edit["after"]:
                raise Refused(f"Empty change in {path}.")
    return package


def change_text(source, edits, path):
    for index, edit in enumerate(edits, 1):
        before = edit["before"]
        matches = re.finditer(r"(?m)^(?=" + re.escape(before) + ")", source)
        match = next(matches, None)
        if match is None:
            raise Refused(f"{path} edit {index}: exact before block is absent.")
        if next(matches, None) is not None:
            raise Refused(f"{path} edit {index}: before block is ambiguous.")
        found = match.start()
        source = source[:found] + edit["after"] + source[found + len(before):]
    valid_text(source, f"{path} result")
    return source


def text_lines(text):
    return [line + "\n" for line in text.split("\n")[:-1]]


def make_diff(package, originals):
    patch = []
    for change in sorted(package["files"], key=lambda entry: entry["path"]):
        path = change["path"]
        original = originals[path]
        if "create" in change:
            if original is not None:
                raise Refused(f"Create path already exists: {path}")
            new = change["create"]
        else:
            if original is None:
                raise Refused(f"Edit path does not exist: {path}")
            valid_text(original, f"{path} baseline", allow_empty=True)
            new = change_text(original, change["edits"], path)
        if new == original:
            raise Refused(f"No net change in {path}.")
        patch.append(f"diff --git a/{path} b/{path}\n")
        if original is None:
            patch.append("new file mode 100644\n")
        patch.extend(unified_diff(
            text_lines(original or ""), text_lines(new),
            fromfile="/dev/null" if original is None else f"a/{path}", tofile=f"b/{path}",
        ))
    return "".join(patch)


def prepared_diff(repo, package):
    head = checkout_head(repo)
    if head != package["baseline"]:
        raise Refused(f"Expected HEAD {package['baseline']}, found {head}.")
    dirty = tracked_status(repo)
    if dirty:
        raise Refused("Tracked changes are present: " + ", ".join(row["path"] for row in dirty))
    originals = {}
    for change in package["files"]:
        name = change["path"]
        path = repo / name
        if path.resolve() != path or not path.parent.is_dir():
            raise Refused(f"Unsafe path or missing parent directory: {name}")
        if "create" in change:
            if path.exists() or path.is_symlink():
                raise Refused(f"Create path already exists: {name}")
            originals[name] = None
        else:
            blob = git(repo, "show", f"{head}:{name}")
            if not path.is_file() or path.read_bytes() != blob:
                raise Refused(f"Local file bytes differ from the baseline: {name}")
            originals[name] = blob.decode("utf-8")
    return make_diff(package, originals)


def apply_change(repo, source, package, patch):
    patch_id = package["id"]
    output = source.with_name(f"{patch_id}.zip")
    if output.exists() or output.is_symlink():
        raise Refused(f"Output already exists: {output}")
    with tempfile.TemporaryDirectory(prefix="logres-chat-") as directory:
        work = Path(directory)
        diff = work / f"{patch_id}.patch"
        diff.write_bytes(patch.encode("utf-8"))
        bundle = work / f"{patch_id}.zip"
        # The guarded applier below owns PREWRITE and POSTWRITE, so the
        # combined command avoids running a third identical candidate suite.
        builder.build(repo, argparse.Namespace(
            id=patch_id, title=package["title"], baseline=package["baseline"],
            path=[entry["path"] for entry in package["files"]], patch=diff, output=bundle,
        ), announce=False, check_candidate=False)

        # This archive was generated locally by the repository's trusted builder.
        with zipfile.ZipFile(bundle) as archive:
            archive.extractall(work)
        entrypoint = work / f"{patch_id}_APPLY.py"
        spec = importlib.util.spec_from_file_location("logres_guarded_apply", entrypoint)
        applier = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(applier)
        applier.configure_paths(repo, work / f"{patch_id}_PAYLOAD")

        with output.open("xb") as stream:
            try:
                with bundle.open("rb") as data:
                    shutil.copyfileobj(data, stream)
                stream.flush()
            except BaseException:
                stream.close()
                output.unlink(missing_ok=True)
                raise
        applied = False
        try:
            if applier.main():
                raise Refused("Guarded apply refused. See the reason above.")
            applied = True
        finally:
            if not applied:
                output.unlink(missing_ok=True)
    print(f"Verified ZIP {sha256(output.read_bytes()).hexdigest()}  {output}")


def main(repo=REPO):
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="operation", required=True)
    sub.add_parser("context", help="Print a read-only Logres checkout context receipt")
    for operation in ("review", "apply"):
        sub.add_parser(operation).add_argument("package", type=Path)
    args = parser.parse_args()
    try:
        if args.operation == "context":
            print(json.dumps(context(repo), indent=2, sort_keys=True))
            return
        package = parse_change(args.package.read_bytes())
        patch = prepared_diff(repo, package)
        if args.operation == "review":
            print(patch, end="")
        else:
            apply_change(repo, args.package, package, patch)
    except (Refused, OSError, UnicodeError, json.JSONDecodeError, SyntaxError,
            tarfile.TarError, zipfile.BadZipFile) as error:
        parser.exit(1, f"REFUSED: {error}\n")


if __name__ == "__main__":
    main()
