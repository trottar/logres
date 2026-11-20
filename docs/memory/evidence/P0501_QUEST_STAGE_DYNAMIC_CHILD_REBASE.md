# P0501 — L-002 guarded stage child-set rebase (2026-11-20)

## Authority and live evidence

P0500 GitHub main `e3eb5a7887858e6146fef184e5018fb368dd4fb8`, tree
`d4fb5794b4f94d54178bc8f70672f7e73e229d04` was verified before
work. Forever session186 on P0499 (`0.0.365-dev`) records two Quest83
Progress→Completion failures: #19422 rejected `bridge-subtree-changed`,
#19481 rejected `bridge-child-changed`; both transitions then reported
`completion-owned` (#19426 and #19485). The screenshots do not capture
subsecond native flashes, so these are **source-boundary evidence**, not
proof of visual failure. Earlier P0497 session183 confirms the original
stock restoration gap. P0500 session187 (`0.0.366-dev`) contains a compass
check without a new quest-stage replay. L-002 remains OPEN.

## Hypothesis, implementation and safety

P0498's exact child identity/order/count check rejects ordinary native
child population changes between `QUEST_FINISHED` and `QUEST_COMPLETE`.
The root and quest identity can remain stable while Blizzard changes its
native panel descendants. Rejecting them immediately restores the old
alpha and can briefly reveal stock before Logres owns the next stage.

P0501 retains the original pre-suppression opaque root alpha and native
child mouse-enabled tokens. At the immediately following same-quest
`QUEST_COMPLETE`, it first repeats old snapshot protection gating and
read-only captures the entire new native subtree. If unchanged, the old
exact-identity path remains. If changed, the current subtree is **also**
checked via `CanBridgeVisual` (ordinary nonprotected frames, no combat).
A 512-entry identity-deduplicated union retains original tokens for
existing frames, adds only genuinely new native child tokens, and becomes
the bridge restoration snapshot **before** suppression of current child
mouse input. That order guarantees that a partially failed suppress call
can restore old and new hit regions. The old opaque root alpha is never
inspected, compared, formatted or replaced with the newly captured
suppressed value. The root object must remain identical. No new overlay,
protected mutation, Blizzard frame Hide(), polling, timers or fabricated
mouse owner is introduced; existing bounded 0.05-second fail-open release
remains intact. The completion controller still checks each merged child
unprotected before taking ownership. Native `QuestRewardCompleteButton_OnClick`
is invoked only after stock restoration, unmodified.

**Refusals:** changed quest identity, missing/changed root, missing or
secret children, protected/unknown current child, oversized merged
subtree, failed suppression, missing completion stage, no supported
Logres action, interrupted timer or addon disable. These restore the
original + newly captured controls whenever available, without leaving
invisible Blizzard click regions. No claim-flash fix is asserted.

## Test and runtime gate

The actual-source P0498 Lua fixture now additionally tests a new child,
replaced child, unsafe protected child, partial suppress failure,
original opaque alpha conservation, restore before claim and fallback.
P0501 source contract protects exact owner/refusal/restore behavior and
version parity. Historical contract suite, Lua syntax, zip parity and
transactional negative tests are mandatory. The next Forever validation
must observe Quest Progress→Completion on normal play, choice and
no-choice claim, unsupported stock fallback and any Lua/taint errors.
A source PASS is not gameplay PASS. Preserve L-002 OPEN and L-055/L-058/
L-059 independently.
