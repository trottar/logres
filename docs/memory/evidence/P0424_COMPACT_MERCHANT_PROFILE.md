# P0424 — Compact Merchant shell within shared NPC presentation

Date: 2026-11-09. Verified exact GitHub main baseline:
`f283202db47ddee9e9c3c2d7ba2c95e5d6e68d00` (P0423).

## Observed and approved

The user explicitly accepts the V8 HUD visual layout as perfect. In the next
screenshot the live merchant Brog Hamfist displays functional native vendor
stock inside a large Logres parchment panel. The user observes excessive
empty perimeter and footer space and approves a narrower, shorter window,
while retaining shared stylistic consistency across NPC services.

This is a cosmetic/layout request, not evidence that merchant transactions,
trainer purchase, or Blizzard fallbacks are broken. It does not re-open V8
HUD geometry or L-008 pet control ownership.

## Targeted source finding

P0393 uses `PanelConfigs.trainer.preview` (896×712) for **both** the merchant
shell and the trainer preview. The trainer landscape itself uses a seven-row
list, detail panel, cost fields and training controls extending to ~Y673 of
712; blindly shrinking the shared trainer width/height would truncate content.
Merchant stock, meanwhile, has two native columns of six nominal rows, its
own tab/pager anchors and a shared PanelSurface backing.

## Chosen scoped change

P0424 adds a merchant-specific 800×625 geometry profile within the same shared
`TrainerPanelConfig.lua` module. `MerchantCatalogue.lua` uses it for both
synthetic preview and gated live native frame. Its list/sidebars, footer,
pager, preview text row widths and gold dividers are coordinated. The trainer's
896×712 preview and landscape geometry are deliberately retained. The same
reversible native frame anchor/size snapshots, out-of-combat gate, protected/
secret rejection, three-phase review/reconcile and failure-to-stock policy
remain. No native purchase, quantity, repair or close handlers are replaced.

Original P0393/P0394/P0395/P0396 evidence and previous native-placement
refusals remain historical authority. This is not a new generic reskin engine
or evidence of transaction success. No polling, blanket hide, secret probing
or Blizzard child reparenting is added.

## Verification gate

The new P0424 contract statically checks the two profiles, list/preview/footer
bounds, native script ownership/restoration and repo continuity. Historical
P0393 checker now accepts a service-specific merchant profile while retaining
its original native-control, privilege and rollback assertions. The full
checker suite and exact-baseline apply must pass before the user commits.

WoW Forever runtime is **UNVERIFIED**. Next checks: merchant list with paging,
buyback, quantity dialog open/cancel, close/reopen, immersion restoration and
trainer layout not truncated. Treat any partial inability to test as a
DEFERRED environment case, not PASS.

## Author-time negative results (retained)

1. Initial candidate-wide checker attempt reached **291/292**: the historical
   P0422 continuity checker refused because an overly concise CURRENT.md
   replacement omitted the P0422 marker. No user checkout was changed. The
   P0422 misplacement/correction reference was restored in CURRENT.md, and the
   complete 292-check suite subsequently passed. This was a repository-memory
   continuity failure, not a merchant Lua/runtime failure.
2. The first packaging draft contained a Python quoting error in the applier's
   dirty-checkout refusal string. The author-side `py_compile` gate caught the
   syntax error **before handoff**. The applier source was fixed, recompiled,
   and the ZIP was rebuilt with a new checksum. No invalid ZIP was supplied to
   the user. No in-game behavior was tested by either of these checks.
