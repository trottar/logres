# P0172 — Native access dock and four-domain integration candidate

Baseline verified `26fa1ef7` / `0.0.87-dev`, date 2026-10-08. Candidate `0.0.88-dev`. **RUNTIME UNTESTED.**

Create `Logres/Immersion/NativeAccess.lua`, one high-strata anchored four-domain access dock plus all-open control, source-root transactional Hide/restore on Immersion ON/OFF, event-gated lazy root availability, combat gating, addon-owned evidence and `/logres nativeui` / `/logres nativeuicheck`. Add Phase H Native Access Check and Run All integration; 16 authored anchors and 16 layout consumer registrations (18 Bind calls) when in game. New contract checker enforces required roots, restore and forbidden broad behaviors; update durable memory in the same patch.

This checkpoint *does not* mark Main/Override/vehicle or PetActionBar/Frame coverage complete. They remain stock for secure gameplay/edit interactions. Four-domain native source access through a deliberate dock replaces unconditional permanent presentation only if runtime test proves it safe. On failure fail open, record the fault and correct; never claim H.1 done from a static or diagnostic PASS.

Applier verifies exact HEAD and Git blobs, refuses dirty tracked baseline, composes in a local shadow clone, checks `git diff --check` plus every `tools/check_*.py` before tracked writes, then transactionally writes/checks/records manifest. No commits/pushes. WoW deployment required for Lua changes.
