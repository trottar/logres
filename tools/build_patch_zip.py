#!/usr/bin/env python3
"""Build a guarded Logres patch ZIP from an exact baseline and reviewed text diff."""

import argparse
from hashlib import sha256
import io
import os
from pathlib import Path
import pprint
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import zipfile


ENV = dict(os.environ, GIT_OPTIONAL_LOCKS="0", PYTHONDONTWRITEBYTECODE="1")
SAFE_PATH = re.compile(r"(?:Logres|docs|tools)/(?:[A-Za-z0-9_.-]+/)*[A-Za-z0-9_.-]+|README\.md")


class Refused(Exception):
    pass


def command(*args, cwd, data=None, check=True, isolated=False):
    env = ENV if not isolated else {key: value for key, value in ENV.items() if not key.startswith("GIT_")}
    result = subprocess.run(args, cwd=cwd, input=data, env=env, capture_output=True)
    if check and result.returncode:
        detail = (result.stderr or result.stdout).decode(errors="replace").strip()
        raise Refused(detail or f"{args[0]} exited with status {result.returncode}")
    return result


def safe_path(name):
    return bool(SAFE_PATH.fullmatch(name)) and not (
        {".", "..", ".git"} & {part.lower() for part in name.split("/")}
    )


def stage_patch(baseline, candidate, patch, allowed):
    """Apply only in the candidate shadow and return its exact changed bytes."""
    if not allowed or any(not safe_path(name) for name in allowed):
        raise Refused("Every allowed path must be an explicit repo-relative file.")
    stats = command("git", "apply", "--no-index", "--numstat", "-z", "-",
                    cwd=candidate, data=patch, isolated=True).stdout
    names = set()
    for row in stats.rstrip(b"\0").split(b"\0"):
        fields = row.split(b"\t", 2)
        if len(fields) != 3 or not fields[0].isdigit() or not fields[1].isdigit():
            raise Refused("Supply a Git unified diff of text files.")
        name = fields[2].decode("utf-8")
        if not safe_path(name) or name in names:
            raise Refused(f"Unsupported or repeated patch path: {name}")
        names.add(name)
    if names != allowed:
        raise Refused(f"Diff paths do not match --path. Extra: {sorted(names - allowed)}. "
                      f"Missing: {sorted(allowed - names)}.")

    for name in sorted(names):
        before = baseline / name
        if not before.parent.is_dir() or before.resolve() != before:
            raise Refused(f"Unsupported baseline path or missing directory: {name}")
    command("git", "apply", "--no-index", "--check", "--whitespace=error-all", "-",
            cwd=candidate, data=patch, isolated=True)
    command("git", "apply", "--no-index", "--whitespace=error-all", "-",
            cwd=candidate, data=patch, isolated=True)

    changed = command("git", "diff", "--no-index", "--no-renames", "--name-only", "-z",
                      baseline.name, candidate.name, cwd=baseline.parent, check=False, isolated=True)
    if changed.returncode != 1 or changed.stderr:
        raise Refused("Unable to verify the staged file list.")
    staged = {name.decode("utf-8").partition("/")[2] for name in changed.stdout.split(b"\0") if name}
    if staged != names:
        raise Refused("Staged files differ from the allowlist.")

    files, hashes = {}, {}
    for name in sorted(names):
        before, after = baseline / name, candidate / name
        if after.resolve() != after or not after.is_file():
            raise Refused(f"Only text-file additions and edits are supported: {name}")
        old = before.read_bytes() if before.is_file() else None
        new = after.read_bytes()
        if new == old:
            raise Refused(f"Path has no content change: {name}")
        execute = before.stat().st_mode & 0o111 if old is not None else 0
        if after.stat().st_mode & 0o111 != execute:
            raise Refused(f"File mode changes are unsupported: {name}")
        if not new.endswith(b"\n") or b"\r" in new or b"\0" in new or new.startswith(b"\xef\xbb\xbf"):
            raise Refused(f"Expected UTF-8 text with LF endings and a final newline: {name}")
        new.decode("utf-8")
        files[name] = new
        hashes[name] = (sha256(old).hexdigest() if old is not None else None, sha256(new).hexdigest())

    diff = command("git", "diff", "--no-index", "--check", str(baseline), str(candidate),
                   cwd=candidate, check=False, isolated=True)
    if diff.returncode not in (0, 1) or diff.stdout or diff.stderr:
        raise Refused((diff.stdout + diff.stderr).decode(errors="replace") or "Diff check failed.")
    return files, hashes


def zip_bytes(files, spec, template):
    patch_id = spec["id"]
    token = "__PATCH_SPEC__"
    if template.count(token) != 1:
        raise Refused("The applier template must contain one patch metadata slot.")
    applier = template.replace(token, pprint.pformat(spec, width=100, sort_dicts=True))
    compile(applier, f"{patch_id}_APPLY.py", "exec")
    readme = (
        f"{patch_id} {spec['title']}\n"
        f"Exact baseline {spec['baseline']}\n\n"
        f"From the Logres checkout, extract this ZIP and run python3 {patch_id}_APPLY.py.\n"
        "The applier verifies the patch, runs the full checker suite twice, "
        "writes a manifest, and rolls back patch files if a check fails.\n"
        + ("Runtime files changed. Follow the patch's client deployment instructions.\n"
           if spec["runtime"] else "No WoW redeploy is required.\n")
    )
    entries = {f"{patch_id}_PAYLOAD/{name}": data for name, data in files.items()}
    entries[f"{patch_id}_APPLY.py"] = applier.encode("utf-8")
    entries[f"{patch_id}_README.txt"] = readme.encode("utf-8")
    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, "w", compression=zipfile.ZIP_STORED) as archive:
        for name, data in sorted(entries.items()):
            info = zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0))
            info.create_system = 3
            info.external_attr = 0o100644 << 16
            archive.writestr(info, data)
    with zipfile.ZipFile(buffer) as archive:
        if archive.testzip() is not None or {name: archive.read(name) for name in archive.namelist()} != entries:
            raise Refused("ZIP readback failed.")
    return buffer.getvalue()


def run_candidate_checks(candidate, checkers):
    failures = []
    for checker in checkers:
        result = command(sys.executable, str(checker), cwd=candidate, check=False, isolated=True)
        if result.returncode:
            output = (result.stdout + result.stderr).decode(errors="replace").strip()
            failures.append(f"{checker.name}:\n{output}")
    if failures:
        passed = len(checkers) - len(failures)
        raise Refused(f"Candidate checks: {passed}/{len(checkers)} passed.\n" + "\n\n".join(failures))


def prepare_bundle(baseline, patch, paths, patch_id, title, head, *, check_candidate):
    """Build the same candidate from an exact archive in WSL or in Chat."""
    candidate = baseline.with_name("candidate")
    shutil.copytree(baseline, candidate)
    files, hashes = stage_patch(baseline, candidate, patch, paths)
    version = re.search(r"^## Version: (\S+)$", (candidate / "Logres/Logres.toc").read_text(encoding="utf-8"),
                        re.MULTILINE)
    if not version:
        raise Refused("Candidate TOC is missing its version.")
    checkers = sorted((candidate / "tools").glob("check_*.py"))
    if not checkers:
        raise Refused("Candidate is missing the repository checker suite.")
    if check_candidate:
        run_candidate_checks(candidate, checkers)
        if any((candidate / name).read_bytes() != content for name, content in files.items()):
            raise Refused("A checker changed patch content.")
    spec = {"id": patch_id, "title": title, "baseline": head, "hashes": hashes,
            "checkers": [p.name for p in checkers], "version": version[1],
            "runtime": any(name.startswith("Logres/") for name in files)}
    template = Path(__file__).with_name("patch_applier_template.py.in").read_text(encoding="utf-8")
    payload = zip_bytes(files, spec, template)
    return payload, len(checkers)


def build(repo, args, *, announce=True, check_candidate=True):
    if not re.fullmatch(r"P[0-9]{4}", args.id) or not re.fullmatch(r"[0-9a-f]{40}", args.baseline):
        raise Refused("Use a P00XX patch ID and the full lowercase 40-character baseline commit.")
    if not args.title or len(args.title) > 100 or not args.title.isprintable():
        raise Refused("Use a one-line title up to 100 characters.")
    if len(set(args.path)) != len(args.path):
        raise Refused("Each --path must appear once.")
    if args.output.exists() or args.output.is_symlink():
        raise Refused(f"Output already exists: {args.output}")
    head = command("git", "rev-parse", "--verify", "HEAD", cwd=repo).stdout.decode().strip()
    if head != args.baseline:
        raise Refused(f"Expected baseline HEAD {args.baseline}, found {head}.")
    tar_data = command("git", "archive", "--format=tar", args.baseline, cwd=repo).stdout
    with tempfile.TemporaryDirectory(prefix="logres-build-patch-") as folder:
        baseline = Path(folder) / "baseline"
        with tarfile.open(fileobj=io.BytesIO(tar_data)) as archive:
            archive.extractall(baseline, filter="data")
        payload, checked = prepare_bundle(
            baseline, args.patch.read_bytes(), set(args.path),
            args.id, args.title, head, check_candidate=check_candidate,
        )
    with args.output.open("xb") as output:
        output.write(payload)
    if announce and check_candidate:
        print(f"{checked}/{checked} STATIC PASS in candidate shadow")
    if announce:
        print(f"{sha256(payload).hexdigest()}  {args.output}")
    return checked


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("patch", type=Path)
    parser.add_argument("--id", required=True)
    parser.add_argument("--baseline", required=True)
    parser.add_argument("--title", required=True)
    parser.add_argument("--path", required=True, action="append")
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        build(Path(__file__).resolve().parents[1], args)
    except (Refused, OSError, UnicodeError, tarfile.TarError, SyntaxError, zipfile.BadZipFile) as error:
        parser.exit(1, f"REFUSED: {error}\n")


if __name__ == "__main__":
    main()
