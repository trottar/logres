# P0332 — target aura fallback canonical-source repair

- Baseline P0331 pushed `dce2355cd960dab457f933982ca39d45c0610c98`, source version 0.0.225-dev.
- Scope: `Logres/HUD/StatusAuras.lua` canonical target HARMFUL source, bounded 16 candidate positions/5 displayed, ordinary player-origin ordering; migrate P0175 static checker; Bootstrap/TOC version 0.0.226-dev. Native/secure renderer and Blizzard fallback untouched.
- Documentation: current/handoff, L-028 issue register, active/Phase H/patch index/status/roadmap, evidence. Preserve P0330 and P0331 runtime UNVERIFIED, P0321 gossip and L-019 license gates, camera frozen D-047, five D-048 systems not live.
- Static: 203 checkers PREWRITE shadow + POSTWRITE and manifest; user WSL outcome UNVERIFIED until supplied. Corrective source finding is not client acceptance. No deployment while beta closed; runtime L-028 acceptance after November 4.
- Next after push verification: bounded L-021/L-024 pet hotkey and active-frame presentation corrections, then other Phase H issues; P0321 first at client reopening.
