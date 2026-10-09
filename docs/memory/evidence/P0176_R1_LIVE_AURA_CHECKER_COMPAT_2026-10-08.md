# P0176 R1 — Original prewrite failure and bounded corrective test (2026-10-08)

## Observed negative result

User's original P0176 apply used ZIP SHA `f63086a955ce7d074830c3d21f7b3e0af85c70c6adf92126ca3fcf498c5e9269` and reached the shadow checker suite. `check_status_aura_disabled_contract.py` emitted `ERROR: cannot isolate disabled snapshot in StatusAuras:Refresh`; the applier reported FAIL and produced no P0176 manifest. The user's `git status --short` listed untracked local files, with no tracked modifications. The earlier passing checkers do not mean that candidate was valid.

## Targeted diagnosis and R1 change

P0175 R3's disabled-source contract recognizes an `elseif active ... else ... end` block immediately followed by `self.last[unit] = snapshot`. Original P0176 placed a diagnostic call before `else`, so the contract intentionally failed. R1 leaves that snapshot block unchanged and calls the recorder after `self.last[unit] = snapshot` only while `active and not self.preview`. The existing R3 contract is not changed, and the P0176 contract asserts both order and guard.

## Evidence boundaries

R1's candidate source/checker tests are static; WoW runtime testing is pending. The full suite is run by the applier before tracked writes. No harmful live aura sample, visual completeness, loot tracker flash fix, or native UI expansion is claimed. Blizzard aura fallback and the original R2 Run All crash evidence remain preserved.
