# P0434 — Reproduce author checks before releasing a Chat draft

Verified P0432 main `8a3815754a68d54a3e161675cb25cc08cbcf848e`.
P0433 draft SHA-256
`2394a92263c0c5790af53c6443d44786c749e855a491a1aec2914d41e6dcd986`.
It was rejected before candidate creation because the title had 103
characters. A title-only adjustment let the full suite run and refused
at 296/298. The developer panel checker matched a read-only HUD lookup
as though it reparented the panel. The candidate removed the required
P0425 history marker from CURRENT. Its edits also replaced two old active
P0427 pins with new P0433 pins. P0433 remains uninstalled.

The existing WSL refusal was correct. The release process lacked a
portable exact baseline for ordinary Chat and accepted a draft without
author evidence. Export a tracked Git archive bound to its commit, tree
and checksum. Use the same candidate builder and checker suite in the
portable author and WSL paths. Require the generated receipt in normal
Chat apply. Verify it against the exact draft bytes, tree, archive,
checker count and reconstructed candidate ZIP before the transactional
applier runs. The explicit local-author option retains the trusted local
workflow. A receipt is an integrity record and the local apply remains an
independent check.

Move P0426/P0427's historical assertions away from a frozen active patch.
The existing P0381 invariant still synchronizes CURRENT and all four
active roadmap headings. The developer panel contract still requires a
UIParent root and now checks reparenting instead of a read-only lookup.
Preserve the P0425 history requirement.

This patch changes infrastructure and memory. P0432 remains the combat
anchor evidence checkpoint. Enemy frame placement, aura spacing and
aggro policy remain separate feature work. No WoW redeploy is required.
