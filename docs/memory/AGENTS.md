---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Agent Operating Rules

## Authority

The repository is the durable source of Project Logres continuity.

Do not rely on assistant memory, chat history, or an earlier summary when the repository contains a more specific canonical record. Before restating a decision, API boundary, rejected approach, or architectural invariant, open the record that defines it.

Raw evidence and current source outrank later summaries when they disagree.

"Memory" in this project means `docs/memory/`. It does not mean assistant/product memory.

## Startup

For substantial work:

1. read `docs/memory/CURRENT.md`;
2. read only CURRENT-linked records relevant to the active task;
3. consult `docs/memory/MEMORY.md` selectively for durable rules/facts;
4. consult decisions, investigations, evidence, architecture, dated history, and handoffs only as needed;
5. inspect exact current source before modifying it.

Do not eagerly load the entire memory hierarchy.

## Development environment

Canonical development environment:
- Windows 11 host;
- WSL for source development, Git, scripting, and tooling;
- repository working tree in the WSL Linux filesystem, normally `~/Projects/logres`;
- WoW itself runs on Windows;
- deployment into the Windows WoW AddOns directory will be handled by an explicit script/configuration later.

Do not hard-code a user-specific Windows or WSL path in tracked source. Machine-specific deployment paths belong in ignored local configuration.

Project text files use LF line endings in the WSL working tree.

## Git control boundary

The user owns all commits and pushes.

Agents/assistants may:
- inspect repository state;
- design patches;
- generate files or archives;
- propose commit messages;
- analyze pushed GitHub state.

Agents/assistants must not:
- push;
- assume a commit or push happened;
- silently mutate the remote repository.

A checkpoint is not considered durable until the user has committed/pushed it and the resulting repository state has been verified.

## Development method

Prefer:

**one narrow question -> one targeted investigation/probe -> evidence -> explicit result -> one coherent patch**

Before modification:
1. inspect exact current state;
2. state the intended invariant or hypothesis;
3. make the smallest coherent change;
4. validate the relevant behavior;
5. update durable memory in the same work.

Avoid unrelated cleanup.

## Negative-result discipline

Failures are project knowledge.

Every meaningful experiment, probe, implementation attempt, design trial, or patch must record applicable negative results, including:
- failed approaches;
- rejected designs;
- unsupported APIs;
- regressions;
- partial successes;
- wrong assumptions;
- rollback causes;
- tests that failed;
- approaches abandoned for complexity, performance, restrictions, or aesthetics.

A negative result should state:
1. what was attempted;
2. why it was attempted;
3. what actually happened;
4. what evidence established the result;
5. whether the path is CLOSED, DEFERRED, or may be retried under stated conditions;
6. what future work should learn from it.

Do not delete or rewrite history merely because a later approach succeeds. Mark superseded records and point to the newer authority.

Absence of a failure section must not be used to imply success. When a validation run is clean, say explicitly that no failures were observed within its tested scope.

## Evidence and claims

Distinguish:
- **design intent** — what Logres is supposed to do;
- **API/source finding** — what documentation/source code says;
- **runtime evidence** — what WoW Forever actually did in a test;
- **decision** — what the project chooses;
- **inference** — a conclusion not directly measured.

A compile/load check is not runtime validation of behavior.

For API questions, prefer current primary documentation/source and record uncertainty. WoW Forever behavior that materially affects architecture should eventually be confirmed in-client where practical.

## Stable design boundaries

Do not casually violate settled design decisions for conventional UI convenience.

In particular:
- information suppression can be intentional;
- hidden enemy level/classification is not automatically a missing feature;
- no conventional player health bar is an identity-level design decision;
- action geometry is cluster-based, not a traditional long row;
- the compass belongs to immersion/world context and may disappear in instances;
- PvP is a state modifier that increases useful presentation without discarding the design language.

Open the relevant decision before changing one of these.

## Memory synchronization

A meaningful code patch is incomplete until relevant durable memory is synchronized.

Depending on scope, update:
- `CURRENT.md`;
- `MEMORY.md` for durable facts;
- a decision record;
- an investigation/evidence record;
- `LEARNINGS.md` for reusable lessons;
- `roadmap/STATUS.md`;
- the dated memory file;
- the patch record.

Do not duplicate full evidence into active memory. Point to canonical detail.

## Handoffs

`CURRENT.md` is authoritative.

`handoffs/CURRENT_HANDOFF.md` is a compact transfer note only and must never become a second append-only CURRENT file.

## Commands

Commands given to the user must be:
- copy/paste friendly;
- WSL-aware;
- explicit about the working directory when repository state matters.

Never ask the user to push on the assistant's behalf; the user performs commits/pushes by design.
