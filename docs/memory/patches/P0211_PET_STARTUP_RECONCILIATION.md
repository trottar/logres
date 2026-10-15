# P0211 — Event-driven pet startup readiness handoff

Status: PREPARED / NOT RUNTIME VERIFIED; user reports initial `0.0.120-dev` reload **FAIL** but OFF/ON, observed combat suppression and Edit Mode entry correct. Parent GitHub `main` P0210 `4076d250`. Candidate `0.0.121-dev`.

Reuses existing secure pet-bar constant hide/release policy and readiness gates. `PetActionExecutionProbe:Arm()` and `NativeSurfaceReplacement:PreparePetInteraction()` now notify the trial of established addon-owned readiness once per actual setup, rather than relying solely on ordering of Blizzard/login events. The trial exports diagnostic first-world readiness and first successful arm source. No native presentation inspection, insecure protected mutations or periodic reassertion. Any observed initial armed=true with visible stock UI falsifies this candidate hypothesis and requires a different next investigation. Preserve P0209 failures and future proof gaps; update P0211 evidence after runtime test.
