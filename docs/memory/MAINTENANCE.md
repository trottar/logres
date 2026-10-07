# Project Memory Maintenance Policy

The repository is the durable source of Project Logres continuity. Memory must not depend on a particular assistant, chat, model, or context window.

## Information classes

### Active state

`CURRENT.md` is the single authoritative resumable state. It answers:
- What is the active objective?
- What work item is active?
- What directly relevant state is verified?
- What is the exact next action?
- What defines success?
- What should not be reopened without new evidence?
- Where is supporting detail?

### Durable knowledge

`MEMORY.md`, `DESIGN_PRINCIPLES.md`, `architecture/`, and `decisions/` contain long-lived rules, invariants, boundaries, and accepted conclusions.

### Chronology

Dated files at the memory root and `patches/` preserve what happened over time.

### Canonical evidence

`evidence/` and `investigations/` preserve detailed source findings, runtime observations, experiments, and unresolved questions.

Active memory should point to evidence, not duplicate it wholesale.

## Startup reading policy

For substantial work:
1. read `AGENTS.md`;
2. read `CURRENT.md`;
3. read only CURRENT-linked records relevant to the task;
4. consult durable memory selectively;
5. load chronology/evidence only as needed.

Do not eagerly read the full hierarchy.

## Negative-result policy

Failures are required memory.

Every meaningful investigation or implementation records, where applicable:
- hypothesis/intent;
- what was attempted;
- evidence;
- what worked;
- what failed;
- regressions;
- rejected options;
- rollback state;
- unknowns;
- retry conditions;
- durable lesson.

A record that contains only success when meaningful failures occurred is incomplete.

Preserve superseded and falsified records. Mark the newer record authoritative instead of erasing the old one.

## Maintenance triggers

Perform memory maintenance when:
- more than one active objective appears;
- more than one next action appears authoritative;
- completed chronology accumulates in `CURRENT.md`;
- active files contradict one another;
- the same result is copied into several active files;
- a new session must read historical records merely to discover the next action;
- a major phase completes;
- a major design/technical direction changes.

Suggested size targets:
- `CURRENT.md`: ~2–8 KB; maintain before ~20 KB.
- `CURRENT_HANDOFF.md`: as small as practical; maintain before ~15 KB.
- `MEMORY.md`: curated; maintain before ~60 KB.

## Required maintenance procedure

1. Identify one active truth.
2. Verify canonical detailed records exist before shortening active memory.
3. Move chronology out of active state.
4. Promote reusable conclusions.
5. Replace copied detail with links/pointers.
6. Remove duplicated active statements.
7. Rewrite `CURRENT.md` as a clean bootstrap when needed.
8. Keep handoff small.
9. Run `python3 tools/check_memory_health.py`.

## Required CURRENT headings

`CURRENT.md` contains each heading exactly once:

```text
## Active Objective
## Current Work Item
## Verified State
## Next Action
## Success Criteria
## Do Not Reopen Without New Evidence
## Relevant References
```

The checker treats these as a schema.

The schema applies to actual Markdown heading lines. Inline prose, quoted text,
and code examples that mention a heading name are not headings and must not be
counted as duplicate schema entries. Generated patches must validate the fully
rendered candidate `CURRENT.md` against the heading-line schema before mutating
the real working tree.

## Patch/checkpoint memory rule

Any meaningful code or design patch updates the durable records affected by it in the same checkpoint.

At minimum ask:
- Did active state change?
- Was a decision made?
- Was an assumption falsified?
- Was an API boundary learned?
- Did anything fail?
- Is there a reusable lesson?
- Did roadmap status change?

## Safety of memory editing

Do not:
- destroy unique evidence;
- silently rewrite failed history as success;
- collapse uncertainty into a confident summary;
- overwrite an accepted decision without a superseding record;
- use maintenance as an excuse for unrelated code changes.

## Runtime validation instruction rule

When a patch changes files under `Logres/` and requires in-game validation, the handoff/instructions must repeat the concrete deployment block immediately before the in-game commands.

At minimum include:

```bash
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then include `/reload` before the validation commands.

Reason: repository state and installed WoW addon state are separate authorities. P0012 produced a false-negative command test when the new repository build had not yet been copied into the game AddOns directory.
