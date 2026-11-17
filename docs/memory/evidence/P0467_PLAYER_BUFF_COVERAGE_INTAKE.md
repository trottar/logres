# P0467 — Player helpful-buff coverage intake (L-051)

Date2026-11-16. User supplied screenshot
codex-clipboard-7fb0b714-1c5d-403b-bbc9-6bda46453394.png; image inspected
individually in the user message, four player helpful icons. User reports a
maximum of4. Screenshot by itself does not establish total active buffs or
which additional spells are missing. This is separate from accepted world
enemy auras (L-028). Do not reopen/rewrite that accepted renderer.

Source verified at main d1b1cdd/P0466, 0.0.335-dev:
- Logres/HUD/PlayerHelpfulAuras.lua: FILTER="HELPFUL|PLAYER", MAX_SCAN=6,
  MAX_ICONS=4. ReadSnapshot only retains up to4 ordinary eligible entries;
  RenderSnapshot clamps to4; OnInitialize creates4 slots.
- tools/check_player_helpful_auras_contract.py explicitly requires all3
  constants. A narrow coherent repair must update that historical coverage
  contract deliberately, preserving secret guards and primitive styling.
- P0196_R1_NATIVE_PET_AURA_EVIDENCE.md already described the original filtered
  four-icon lane; P0196_R2_REGRESSION_EVIDENCE.md left broader helpful coverage
  as a follow-up with on-demand BUFFS fallback.

Diagnosis: confirmed source-imposed capacity and scan/filter restrictions,
not evidence of a four-aura limit in the native engine. Merely raising one
constant is insufficient for complete buff coverage and safe overflow layout.
Next discussion should establish coverage policy (self/other-cast helpful),
wrapping/scrolling/overflow geometry and safe native rendering/fallback for
restricted data. Keep exact approved art, existing useful metadata, labels/
world defaults and native restoration. No polling, protected/secret inspection
or blanket stock suppression to manufacture extra visible icons.

P0467 records/intakes only: no runtime/source change, no redeploy, no fix/PASS
claimed for L-051. Seed the fresh Chat with this issue for discussion before
implementation. Existing runtime acceptance stays intact.
