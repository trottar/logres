# P0406 — Logres checkout context and one-command Chat changes

Verified GitHub main P0405 at 4aa464d1463dac5deb495bedefcea40ca05a2baa. The original P0405 builder passed local packaging, but the ordinary Chat handoff required an unfinished prompt, manual diff handling and a separate build and apply command. No ordinary Chat change reached that builder. The user rejected that workflow. The user operates ordinary Chat. Work builds and validates the local infrastructure.

## Contract

The repo-scoped context command reports HEAD, HEAD tree, branch, source version, tool versions, checker names, tracked status and candidate-path untracked names. It does not read or export the WoW installation, user folders, diagnostic bytes or credentials. Chat verifies GitHub independently and can infer source parity for a clean matching checkout. Tracked edits are reported and cause the runner to refuse. The current deployed client remains a separate evidence source.

Chat returns one strict JSON package with exact text edits or new-file contents. The local tool derives the file list, Git diff and ZIP itself. Whole-line anchors must match once, and all edits run in explicit order. Unknown fields, duplicate paths, stale or dirty baselines and local file collisions refuse. The runner reuses the P0405 builder, exact candidate suite and guarded applier. It leaves a reproducible ZIP beside the JSON and the normal manifest in the checkout.

## Validation boundary

The local trial exercises context, exact anchors, refusal, deterministic packaging and the real isolated apply with no Git ref writes. The user-owned ordinary Chat leg remains pending. No WoW runtime files changed.
