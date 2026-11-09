#!/usr/bin/env python3
"""Export Logres checkout context or apply a structured Chat change in WSL."""

import argparse
from difflib import unified_diff
from hashlib import sha256
import importlib.util
import json
from pathlib import Path
import re
import shlex
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


def updated_text(change, original):
    path = change["path"]
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
    return new


def make_diff(package, originals):
    patch = []
    for change in sorted(package["files"], key=lambda entry: entry["path"]):
        path = change["path"]
        original = originals[path]
        new = updated_text(change, original)
        patch.append(f"diff --git a/{path} b/{path}\n")
        if original is None:
            patch.append("new file mode 100644\n")
        patch.extend(unified_diff(
            text_lines(original or ""), text_lines(new),
            fromfile="/dev/null" if original is None else f"a/{path}", tofile=f"b/{path}",
        ))
    return "".join(patch)


def package_head(repo, package):
    head = checkout_head(repo)
    if head != package["baseline"]:
        raise Refused(f"Expected HEAD {package['baseline']}, found {head}.")
    return head


def prepared_diff(repo, package):
    head = package_head(repo, package)
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


def referenced_checkers(repo, package):
    paths = [entry["path"].encode("utf-8") for entry in package["files"]
             if entry["path"].startswith("Logres/")]
    if not paths:
        return []
    directory = repo / "tools"
    if directory.resolve() != directory:
        raise Refused("Checker directory must stay inside the Logres repository.")
    matches = []
    for checker in sorted(directory.glob("check_*.py")):
        if checker.is_symlink() or not checker.is_file():
            continue
        contents = checker.read_bytes()
        if any(path in contents for path in paths):
            matches.append(checker.relative_to(repo).as_posix())
    return matches


def manifest_paths(package):
    return sorted(entry["path"] for entry in package["files"]) + [f"{package['id']}_MANIFEST.txt"]


def stage_command(package, source):
    stage = shlex.join(["git", "add", "--", *manifest_paths(package)])
    verify = shlex.join(["python3", "tools/chat_change.py", "verify-staged", str(source.resolve())])
    return f"{stage} && {verify}"


def diff_paths(repo, *args):
    output = git(repo, "diff", *args, "--name-only", "--no-renames", "-z")
    return {path.decode("utf-8") for path in output.split(b"\0") if path}


def verify_staged(repo, package):
    head = package_head(repo, package)
    expected = manifest_paths(package)
    staged = diff_paths(repo, "--cached")
    missing = set(expected) - staged
    extra = staged - set(expected)
    if missing or extra:
        raise Refused(f"Staged paths differ from the package. Missing: {sorted(missing)}. Extra: {sorted(extra)}.")

    manifest = expected[-1]
    lines = git(repo, "show", f":{manifest}").decode("utf-8").splitlines()
    if not lines or lines[0] != f"{package['id']} {package['title']}" or (
        f"Verified baseline: {head}" not in lines or lines.count("Changed paths:") != 1
        or lines[lines.index("Changed paths:") + 1:] != expected
    ):
        raise Refused(f"Staged {manifest} does not match this package.")

    different = []
    for change in package["files"]:
        path = change["path"]
        if "create" in change:
            if git(repo, "ls-tree", "--name-only", head, "--", path):
                raise Refused(f"Create path already exists at the baseline: {path}")
            original = None
        else:
            original = git(repo, "show", f"{head}:{path}").decode("utf-8")
        wanted = updated_text(change, original).encode("utf-8")
        if git(repo, "show", f":{path}") != wanted:
            different.append(path)
    if different:
        raise Refused(f"Staged file bytes differ from the package: {', '.join(sorted(different))}.")
    git(repo, "diff", "--cached", "--check")
    print(f"{package['id']} staged paths, package bytes, and manifest match. Ready to commit.")


def require_runtime_opt_in(package, allowed):
    if not allowed and any(entry["path"].startswith("Logres/") for entry in package["files"]):
        raise Refused("This package changes Logres runtime files. Use check to validate it. "
                      "If you intended a runtime change, apply with --allow-runtime.")


def build_bundle(repo, package, patch, work, *, check_candidate):
    patch_id = package["id"]
    diff = work / f"{patch_id}.patch"
    diff.write_bytes(patch.encode("utf-8"))
    bundle = work / f"{patch_id}.zip"
    checked = builder.build(repo, argparse.Namespace(
        id=patch_id, title=package["title"], baseline=package["baseline"],
        path=[entry["path"] for entry in package["files"]], patch=diff, output=bundle,
    ), announce=False, check_candidate=check_candidate)
    return bundle, checked


def check_change(repo, package, patch):
    with tempfile.TemporaryDirectory(prefix="logres-chat-check-") as directory:
        _, checked = build_bundle(repo, package, patch, Path(directory), check_candidate=True)
    print(f"CHECK {checked}/{checked} STATIC PASS. No patch files installed.")


def apply_change(repo, source, package, patch):
    patch_id = package["id"]
    output = source.with_name(f"{patch_id}.zip")
    if output.exists() or output.is_symlink():
        raise Refused(f"Output already exists: {output}")
    with tempfile.TemporaryDirectory(prefix="logres-chat-") as directory:
        work = Path(directory)
        # The applier owns PREWRITE and POSTWRITE.
        bundle, _ = build_bundle(repo, package, patch, work, check_candidate=False)

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
    print("To stage and verify this package before committing:")
    print(stage_command(package, source))


def main(repo=REPO):
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="operation", required=True)
    sub.add_parser("context", help="Print a read-only Logres checkout context receipt")
    sub.add_parser("review", help="Show the exact diff without running checkers").add_argument("package", type=Path)
    sub.add_parser("check", help="Run all checkers on a temporary candidate").add_argument("package", type=Path)
    sub.add_parser("verify-staged", help="Check the Git index against the exact package").add_argument("package", type=Path)
    apply = sub.add_parser("apply", help="Validate and apply a reviewed change")
    apply.add_argument("package", type=Path)
    apply.add_argument("--allow-runtime", action="store_true",
                       help="Explicitly allow this change to edit Logres runtime files")
    args = parser.parse_args()
    try:
        if args.operation == "context":
            print(json.dumps(context(repo), indent=2, sort_keys=True))
            return
        package = parse_change(args.package.read_bytes())
        if args.operation == "verify-staged":
            verify_staged(repo, package)
            return
        if args.operation == "apply":
            require_runtime_opt_in(package, args.allow_runtime)
        patch = prepared_diff(repo, package)
        if args.operation == "review":
            print("Diff only. Use check to run the checker suite.", file=sys.stderr)
            matches = referenced_checkers(repo, package)
            if matches:
                print("Checkers that directly reference changed runtime paths:", file=sys.stderr)
                for name in matches:
                    print(f"  {name}", file=sys.stderr)
            print(patch, end="")
        elif args.operation == "check":
            check_change(repo, package, patch)
        else:
            apply_change(repo, args.package, package, patch)
    except (Refused, OSError, UnicodeError, json.JSONDecodeError, SyntaxError,
            tarfile.TarError, zipfile.BadZipFile) as error:
        parser.exit(1, f"REFUSED: {error}\n")


if __name__ == "__main__":
    main()
