# P0029 Slash Fallback Regression — 2026-10-01

Status: FIXED IN P0032
Detected: source inspection during C.2 preparation

## Symptom

P0029 introduced a shared command output function:

```lua
local function emit(message)
```

The panel supplies an output sink, so panel diagnostics worked.

The ordinary no-sink fallback was accidentally generated as:

```lua
emit(message)
```

inside `emit()` itself.

That path would recurse indefinitely instead of printing to chat.

## Why B.6 passed

B.6 was performed through the developer panel.

With an active output sink, `emit()` returned through the sink before reaching
the defective fallback.

Therefore:
- the user-observed panel success was real;
- the fallback regression remained latent.

## Fix

P0032 restores:

```lua
print(message)
```

as the no-sink fallback.

`check_dev_panel_contract.py` now:
- requires the print fallback;
- rejects an `emit(message)` self-call inside the emit function.

## Classification

Real runtime-code regression discovered before user-visible slash-path failure.

This is not a WoW API restriction.

It is a shared-output-routing implementation defect.
