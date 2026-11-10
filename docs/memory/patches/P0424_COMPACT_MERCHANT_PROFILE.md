# P0424 — Compact merchant service profile; preserve full trainer landscape

Source baseline: verified P0423 main
`f283202db47ddee9e9c3c2d7ba2c95e5d6e68d00`.

- Add merchant compact profile (800×625) to the existing shared trainer panel
  configuration; do not resize the seven-row trainer landscape.
- Route MerchantCatalogue's synthetic preview and native-backed live panel to
  that compact geometry. Move only authored merchant washes, dividers, footer,
  pager and preview text bounds as a coherent composition.
- Preserve all merchant native item/button/tooltip/buyback/quantity/repair
  actions and reversible anchor/size mutations, combat deferral and stock fail-open.
- Update the historical P0393 checker narrowly, add P0424 fit/ownership
  contract, and record both the V8 HUD visual acceptance and P0424 runtime
  deferral in durable memory.

Static candidate; no WoW Forever runtime acceptance until user tests.
