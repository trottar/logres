# P0279 — Service mapping index / verification tab

Status: PREPARED, full static/WoW runtime not yet verified. Baseline pushed `41826a9` (P0278 R1).

Adds an indexed data-only mapping from approved Logres native-service visual slots to verified-source Blizzard candidate controls for trainer, merchant, taxi and the further service families. Adds a dedicated paginated **M — UI Mapping** developer-panel tab. Selected entries can be highlighted by a reversible, mouse-inert, addon-owned overlay (parented to the native frame so it closes with it); Hide clears only that overlay. No Blizzard control is hidden, changed or called for transactions. Native row identities and proposed controls without a proven native equivalent remain OPEN/UNMAPPED. Existing preview gallery and H actions unchanged. Records source and visual limitations, with client evidence gates. See `docs/memory/evidence/P0279_SERVICE_MAPPING_INDEX_AND_INSPECTOR.md` and `docs/ui/SERVICE_ELEMENT_MAPPING_INDEX.md`.
