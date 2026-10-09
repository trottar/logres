# P0175 — Priority aura presentation evidence (2026-10-08)

Status: CANDIDATE / STATIC SOURCE POLICY, IN-CLIENT PENDING.

Authoritative input: user confirmed P0174 R3 “pushed. Works perfectly, I did not see any issues.” GitHub `main` verified `996f6099` / `0.0.90-dev`. Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`: latest `nativeuicheck PASS` folded=5/open=0, `castGate=true/true`, `gateEscapes=0`, gateCounts=4/3/0 on integrated Run All; no recorded native failures. No independent video of every special cast state. Quest tracker user runtime confirmation remains accepted from R2. Negative history: P0174 R1 shadow CURRENT headings missing, R2 combat bars returned; do not silently overwrite historical records.

P0135/D-041 source and P0136 audit prove secret-first `C_Secrets.ShouldUnitAuraIndexBeSecret` + `C_UnitAuras.GetAuraDataByIndex` policy; P0136 had populated player helpful data but no representative populated player harmful/target sample. P0137 helpful icon lane was runtime-proven. P0175 is **additive**: the screen-space target fallback is supported, but accessible world attachment remains unproven, and stock Blizzard aura information remains fully present. The new icon filter order can be previewed with static sample icons; preview is not proof of populated aura source. A duplicate may remain when aura instance identity is secret/unavailable; record duplicateUnknown counter, never inspect identity.

Future evidence required: player harmful/urgent and populated target categories, icon/stack/hover at real scale, target switching, Immersion OFF/ON, no Lua/taint/protected/secret failures. If no natural relevant auras occur, defer that case without manufacturing gameplay. No complete stock aura suppression authorized.

## Post-delivery negative report / P0175 R1

User reported required status controls missing from the in-game developer panel and no visible enemy buff/debuffs. The panel omission is established; target cause remains open. Original target special filters had no generic HELPFUL fallback. Correction and runtime-gated claims: P0175_R1_PANEL_TARGET_AURAS_2026-10-08.md.
