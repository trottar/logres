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


def handoff_prompt(info):
    return f"""Continue Project Logres in ordinary Chat. Start in discussion mode: read the
handoff and current repository context, summarize the accepted state briefly,
then let me describe the next fix/change. Do not invent a task, emit a placeholder
patch, allocate a patch ID, or make changes until I ask to implement.

Repository: trottar/logres, main authoritative. GitHub is READ ONLY. I own all
commits/pushes. Verify current main before choosing a patch baseline and after
I say pushed. This kit describes {info['head']} (tree {info['head_tree']}),
source {info['runtime_source_version']}; it does not assert that main is unchanged.
Read docs/memory/AGENTS.md, CURRENT.md, relevant CURRENT-linked records,
handoffs/CURRENT_HANDOFF.md, investigations/ACTIVE.md and ISSUE_LEDGER.md,
roadmap/STATUS.md, active phase roadmap and docs/ROADMAP.md in that order.
Repository evidence outranks summaries. Preserve accepted runtime slices and
known failures. User acceptance is scoped, never exhaustive combat/taint proof.

This bundle contains LOGRES_AUTHOR_KIT.zip (tracked baseline only),
LOGRES_CONTEXT.json (checkout context), and a hash manifest. It contains no
machine-wide snapshot, untracked source, SavedVariables or fresh gameplay proof.
Verify kit/archive hashes and GitHub commit/tree. If main advanced or the local
checkout is dirty, diagnose the mismatch before authoring; never bypass guards.
For a fresh tracked-only kit use, from ~/Projects/logres:
python3 tools/chat_change.py author-context LOGRES_AUTHOR_KIT_<new-short-sha>.zip

For implementation use one coherent evidence-led change. Inspect actual images
individually, correlate events, and distinguish a missing/restricted source from
a presentation defect. Inspect relevant historical checkers before editing.
Use the canonical JSON+author-receipt route or canonical build_patch_zip.py
payload ZIP route, choosing exactly ONE apply route. Fully reconstruct the exact
candidate and run all real checkers, syntax/diff checks and applicable source
fixtures before release. Report missing execution tools and skipped fixtures;
static PASS is not client PASS. Follow PRE_HANDOFF_AUDIT.md and
patches/CHAT_TO_ZIP_WORKFLOW.md. Never hand off an unchecked code ZIP as ready.

Keep outputs at their actual saved paths; do not move them to Downloads.
Put exact checksum, apply AND git add/commit/push commands directly in the reply,
gate staging on explicit apply PASS and the current manifest, and verify staged
bytes against that exact ZIP/JSON. For runtime changes include the mandatory
_classic_beta_ deployment block plus the actual _forever_ client target, /reload
and precise validation/export. The runtime deployment block is:

cd ~/Projects/logres
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"
./tools/deploy_logres.sh "$ADDONS"
./tools/deploy_logres.sh "$WOW_ROOT/_forever_/Interface/AddOns"

Then /reload in the actual _forever_/Wow.exe client. Put deployment immediately
before in-game commands. Export via python3 tools/export_panel_diagnostics.py.
For tooling/docs-only changes say no WoW redeploy.
Report Bug captures normal diagnostics; do not repeat panel itineraries or ask
for files already supplied. Use Work only for persistent investigation that
actually needs it. Do not launch ChatGPT or another chat on my behalf.
"""


def export_handoff(output, info, archive):
    """Deterministic, tracked-only context bundle; never apply or run a checker."""
    if info.get("tracked_changes"):
        raise builder.Refused("Chat handoff requires a clean tracked checkout.")
    with tarfile.open(fileobj=BytesIO(archive)) as tar:
        if tar.pax_headers.get("comment") != info["head"]:
            raise builder.Refused("Handoff archive does not match its checkout commit.")
        toc = tar.extractfile("Logres/Logres.toc").read().decode("utf-8")
        match = re.search(r"^## Version: (\S+)$", toc, re.MULTILINE)
        if not match or match[1] != info["runtime_source_version"]:
            raise builder.Refused("Checkout version changed during handoff export.")
    with tempfile.TemporaryDirectory(prefix="logres-chat-handoff-") as folder:
        kit = Path(folder) / "LOGRES_AUTHOR_KIT.zip"
        export_context(kit, info, archive)
        metadata, _ = load_context(kit, info["head"])
        if metadata["checkers"] != info["checkers"]:
            raise builder.Refused("Checkout checker inventory changed during handoff export.")
        entries = {"LOGRES_AUTHOR_KIT.zip": kit.read_bytes(),
                   "LOGRES_CONTEXT.json": json_bytes(info),
                   "CHAT_HANDOFF.md": handoff_prompt(info).encode("utf-8")}
    manifest = {"schema": "logres-chat-handoff/v1", "repository": "trottar/logres",
                "baseline": info["head"], "baseline_tree": info["head_tree"],
                "runtime_source_version": info["runtime_source_version"],
                "github_verification": "required-in-chat",
                "files": {name: digest(data) for name, data in sorted(entries.items())}}
    entries["HANDOFF_MANIFEST.json"] = json_bytes(manifest)
    buffer = BytesIO()
    with zipfile.ZipFile(buffer, "w") as bundle:
        for name, data in sorted(entries.items()):
            bundle.writestr(zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0)), data,
                            compress_type=zipfile.ZIP_DEFLATED)
    data = buffer.getvalue()
    with output.open("xb") as target:
        target.write(data)
    return digest(data)
