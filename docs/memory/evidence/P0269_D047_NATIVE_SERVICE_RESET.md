# P0269 — D-047 native-service ownership correction

Date: 2026-10-19. Baseline: verified pushed P0268 `53fe8aece2a03c9792bde336ad324226ca8acf23`.

## Trigger and failure

User tested P0268 merchant/trainer/flight/unavailable previews successfully and initially requested quantities, filters, repairs and Sell Junk. Assistant proposed **custom** versions of those controls. User correctly objected: existing accepted D-047 requires retaining Blizzard's merchant/trainer/service transaction UI with selective Logres visual/position integration, **not** rebuilding it. This is an assistant architectural/process FAILURE despite P0268's scoped successful preview testing. The user's explicit correction outranks the assistant's speculative enhancement plan. The `0.0.166-dev` diagnostic export reports Quest Dialogue, Offer Controls and Run All PASS for performed checks, and no native service transaction proof.

## Coherent P0269 correction

- Retire four synthetic catalogue P actions, service catalogue model/TOC load, and preview quote-confirmation routing. Keep P0268 evidence/patch record; it demonstrated component reuse, NOT native service ownership.
- Preserve approved P0265-27 generic narrative, branching, Back, Goodbye, reward previews, accepted header insets, stock restoration, and frozen camera.
- Install one read-only `NativeServicePolicy` enumerating merchant/buy-sell-buyback/quantity, repairs, native item-selling (one-click Sell Junk shortcut unverified), trainer/filters, flight, bank and auction as **Blizzard-owned**. It reads only normalized Logres state, does not identify active service or touch native frames, and cannot change inventory, gold, training, travel or protected controls.
- Add H-tab `Native NPC Services Check` as a nonmutating scope guard, not a simulated merchant or proof that native visual styling is implemented.
- Source audits identify Blizzard frame names only as candidates; frame existence, load conditions, geometry, native protected and secret restrictions, styling and positioning APIs **remain UNVERIFIED**. Do not implement `SetPoint`/style mutations until client-specific capability evidence and a reversible, combat-safe, fail-open design are established. Generic player interaction state is not service identity.

## Test gates and limits

Exact P0268 pushed commit and byte-for-byte source before changes; synthetic gallery removal, source safety, TOC/checker parity; entire repository `tools/check_*.py` suite against prewrite shadow and postwrite; `git diff --check`, guarded rollback/manifest. In WoW validate P — page 2 no synthetic catalogues; P generic Branching/Reward unchanged; H `Native NPC Services Check` reports Blizzard ownership / source-only status; H quest controls and 0 Run All. No real purchases, sales, repairs, training, flight or quest 237. Native service styling/positioning and full session bridging remain OPEN / UNVERIFIED.

## Status

P0268 remains PUSHED / SCOPED SYNTHETIC PREVIEW PASS; P0269 PREPARED / CLIENT UNVERIFIED. D-047 implementation divergence closed only for **retirement of speculative custom services**, not for complete native visual integration. Do not claim native styling or placement is finished.

## R0 applier failure, preserved as negative evidence (2026-10-19)

User ran P0269 R0 at the verified P0268 baseline `53fe8ae`. The prewrite
shadow suite FAILED at 1/136, because the old `tools/check_p0268_service_catalog_contract.py`
still attempted to read the deleted `Logres/Quest/ServiceCatalogModel.lua`.
The R0 ZIP **already contained** a replacement archival P0268 checker, but
`prepare()` read that file in `SOURCE` from the committed baseline and
overlaid only the `ADD` payload dictionary. The historical checker was not
in `ADD`, so its replacement was silently omitted. This was an assistant
artifact-construction defect, not a user's repository problem. The applier
failed before any tracked writes; R0 is CLOSED / superseded by R1.

R1 explicitly replaces `data['tools/check_p0268_service_catalog_contract.py']`
from the shipped payload *before* candidate shadow generation, asserts its
expected archival signature, and retains the same postwrite suite/rollback
gates. The full WSL checker suite and WoW runtime remain PENDING until run.
