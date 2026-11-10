"""Portable author preflight for the Logres Chat change runner."""

from hashlib import sha256
from io import BytesIO
import json
from pathlib import Path
import re
import tarfile
import tempfile
import zipfile

import build_patch_zip as builder


CONTEXT = "LOGRES_AUTHOR_CONTEXT.json"
ARCHIVE = "baseline.tar"
KIT_SCHEMA = "logres-author-context/v1"
RECEIPT_SCHEMA = "logres-author-receipt/v1"


def digest(data):
    return sha256(data).hexdigest()


def json_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode("utf-8")


def receipt_path(package):
    return package.with_suffix(".author.json")


def export_context(output, info, archive):
    with tarfile.open(fileobj=BytesIO(archive)) as source:
        checkers = sorted(member.name.split("/")[1] for member in source
                          if member.isfile() and re.fullmatch(r"tools/check_[^/]*[.]py", member.name))
    metadata = {
        "schema": KIT_SCHEMA,
        "repository": "trottar/logres",
        "head": info["head"],
        "head_tree": info["head_tree"],
        "checkers": checkers,
        "archive_sha256": digest(archive),
    }
    with zipfile.ZipFile(output, "x") as kit:
        for name, data in ((CONTEXT, json_bytes(metadata)), (ARCHIVE, archive)):
            info = zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0))
            kit.writestr(info, data, compress_type=zipfile.ZIP_DEFLATED)


def load_context(path, head):
    with zipfile.ZipFile(path) as kit:
        if sorted(kit.namelist()) != sorted((CONTEXT, ARCHIVE)):
            raise builder.Refused("Author kit must contain exactly its metadata and baseline archive.")
        metadata = json.loads(kit.read(CONTEXT))
        archive = kit.read(ARCHIVE)
    if (not isinstance(metadata, dict) or metadata.get("schema") != KIT_SCHEMA
            or metadata.get("repository") != "trottar/logres" or metadata.get("head") != head
            or not re.fullmatch(r"[0-9a-f]{40}", str(metadata.get("head_tree")))):
        raise builder.Refused("Author kit repository, baseline or tree does not match the draft.")
    if metadata.get("archive_sha256") != digest(archive):
        raise builder.Refused("Author kit baseline archive hash mismatch.")
    return metadata, archive


def release_receipt(package, raw, tree, archive, bundle, checked):
    return {
        "schema": RECEIPT_SCHEMA,
        "id": package["id"],
        "baseline": package["baseline"],
        "baseline_tree": tree,
        "archive_sha256": digest(archive),
        "package_sha256": digest(raw),
        "zip_sha256": digest(bundle),
        "checkers_passed": checked,
        "changed_paths": sorted(change["path"] for change in package["files"]),
    }


def verify_package(receipt, package, raw):
    if not isinstance(receipt, dict) or receipt.get("schema") != RECEIPT_SCHEMA:
        raise builder.Refused("Invalid author receipt schema.")
    if (receipt.get("id"), receipt.get("baseline"), receipt.get("package_sha256")) != (
        package["id"], package["baseline"], digest(raw),
    ):
        raise builder.Refused("Author receipt does not match the exact draft bytes and baseline.")


def verify_receipt(receipt, expected):
    if type(receipt.get("checkers_passed")) is not int or receipt != expected:
        raise builder.Refused("Author receipt does not match the local tree, candidate ZIP or checker count.")


def check(kit, package, raw, make_diff):
    head = package["baseline"]
    metadata, archive = load_context(kit, head)
    with tempfile.TemporaryDirectory(prefix="logres-author-") as folder:
        baseline = Path(folder) / "baseline"
        with tarfile.open(fileobj=BytesIO(archive)) as tar:
            if tar.pax_headers.get("comment") != head:
                raise builder.Refused("Author archive is missing its exact Git commit marker.")
            members = tar.getmembers()
            if any(not member.isfile() and not member.isdir() for member in members):
                raise builder.Refused("Author archive must contain regular files and directories only.")
            if len({member.name for member in members}) != len(members):
                raise builder.Refused("Author archive contains repeated paths.")
            tar.extractall(baseline, filter="data")
        checkers = sorted(path.name for path in (baseline / "tools").glob("check_*.py"))
        if not checkers or checkers != metadata.get("checkers"):
            raise builder.Refused("Author kit baseline checker inventory mismatch.")

        originals = {}
        for change in package["files"]:
            name = change["path"]
            path = baseline / name
            if not path.parent.is_dir() or path.resolve() != path or path.is_dir():
                raise builder.Refused(f"Unsafe path or missing parent directory: {name}")
            originals[name] = path.read_bytes().decode("utf-8") if path.is_file() else None
        patch = make_diff(package, originals).encode("utf-8")
        bundle, checked = builder.prepare_bundle(
            baseline, patch, set(originals), package["id"], package["title"],
            head, check_candidate=True,
        )
    return release_receipt(package, raw, metadata["head_tree"], archive, bundle, checked)
