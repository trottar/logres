# P0325 — Inert schema-3 to five-domain migration proposal

- Baseline: verified main P0324 `bc56185992e79d185063ecfedb1c39da4e8fb58e`, clean tracked tree and exact source blob IDs.
- Output: a standalone Python draft migration tool and a permanent checker, architecture/evidence records, `CURRENT.md`/handoff, and concise roadmap/history entries.
- **No runtime Lua, TOC, camera, saved schema, secure action, NPC parking, native frame, asset or settings UI modifications.** P0325 is **WoW runtime UNVERIFIED**, no WoW redeploy.
- Prewrite exact-candidate whitespace and full **196** static checks; postwrite the same 196, `git diff --check` and manifest. Transactional rollback on any write/check failure. No Git commits or pushes.
- Historical P0321 R0/R1/R2 and P0322 R0 packaging failures remain preserved in prior records.
- Next: bounded read-only merchant/flight native service source study; any actual preference migration or five live toggles separately gated by Forever restoration evidence and D-047 frozen camera.
