# HUD Architecture

## Intent

The HUD exposes the minimum information necessary for awareness while preserving uncertainty and world focus.

Planned subdomains:
- player health vignette;
- resource percentage;
- cast confirmation;
- target presentation;
- party/allies;
- pets.

## Hard design constraints

- no conventional player health bar by default;
- no numeric enemy level by default;
- no explicit elite warning by default;
- no cast progress bar by default;
- percentage-oriented health/power presentation where shown;
- state-aware visibility.

Implementation remains blocked on the Forever API audit.
