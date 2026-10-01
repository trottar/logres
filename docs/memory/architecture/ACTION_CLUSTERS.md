# Action Cluster Architecture

## Visual model

Logres uses compact square/rectangular button groups rather than treating the primary action interface as one long row.

Logical groups:
- Primary Cluster
- Secondary/Tertiary Clusters
- Utility Clusters

## Presentation intent

- Primary: persistently legible.
- Secondary/Tertiary: nearby and visually related; low opacity or hidden depending on state.
- Utility: normally absent/faded, revealed intentionally.
- Combat: increases relevant visibility.
- PvP flagged: increases caution/secondary visibility before combat.
- Instance: may use more conservative visibility rules.

## Technical constraint

WoW secure action buttons and combat lockdown may constrain what can be reconfigured during combat. The API audit must define what layout/visibility changes are safe.
