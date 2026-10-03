# Approved Logres Visual Baseline

Status: **APPROVED REFERENCE ASSETS**  
Accepted: 2026-10-03  
Canonical decision: `../../memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`  
Implementation audit: `../../memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`

These twelve sheets are the durable visual reference baseline for the current
Logres World Ghost / Selective Hybrid E direction. They preserve the approved
component designs that were previously present only in the design conversation.

They are **reference sheets**, not directly deployable WoW texture atlases. Runtime
implementation should derive addon-capable textures, masks, nine-slice pieces,
glyphs, and layout constants from them while preserving the accepted silhouettes,
hierarchy, material language, and interaction-state differences.

## Authority and precedence

1. Product/capability decisions and safety contracts remain authoritative over any
   incidental mockup text.
2. A detailed component sheet is more specific than the overview/moodboard when
   their illustrative details differ.
3. The newest accepted detailed sheet is authoritative for visual calibration of
   its component; D-039 records explicit refinements such as the final compass
   lane system.
4. Example quest names, item names/stats, NPC names, counts, percentages, and
   screenshots are illustrative content, not new game-data requirements.
5. Native WoW spell/item icons shown in a reference sheet are not bundled Logres
   art assets. Production should use client-provided icon textures where allowed.
6. No reference sheet authorizes secret-value inspection, protected mutation,
   Blizzard-surface suppression, or an unproven data source.

## Approved sheets

| File | Approved role | SHA-256 |
| --- | --- | --- |
| `01_world_ghost_hybrid_e_direction.png` | **World Ghost / Selective Hybrid E direction.** Composition-level art direction, material language, typography roles, restrained-vs-ornate split. | `da841222e3d9fe8863b8d4fdf5641e01a61ae936af413e218f741d31867badfc` |
| `02_resource_bar_primitive.png` | **Resource bar primitive.** Approved normal/compact percentage-bar geometry and WoW-native resource-color families. | `0b644dff55976f809396952d7474c22a9cd82709e17950210c3076616c895a44` |
| `03_action_button_primitive.png` | **Action button primitive.** Approved common button frame and visual state layers: default, hover, pressed, checked, activation, cooldown, range/resource/usability. | `c204d9755c3c4298177a5e49be5f9a0042052d9f69d4887b86f83b0b5e7dc7dd` |
| `04_status_aura_icon_primitive.png` | **Status / aura icon primitive.** Approved minimal aura framing, urgent emphasis, stack/duration reserved placement. | `9b2aa564c4b9fd237c302ab3d6ff849e4a88e54a46a3b34f4e7c4017bd71eebd` |
| `05_cast_state_cue_primitive.png` | **Cast-state cue primitive.** Approved player/target cast/channel and interrupted/failed silhouettes; no progress/timing/text. | `deb979ba880256dc8a98e6898289dfe2a2b90ba5b67a5bec3c00a9abd9639e1a` |
| `06_enemy_name_relative_danger.png` | **Enemy name / relative-danger treatment.** Approved subtle name color/weight danger language and reaction-colored percentage bars. | `f21b8e5d961d37abfb2a66afd4ebd555efc3392a00616037cd2a58f58a03b64e` |
| `07_npc_quest_narrative_block.png` | **NPC quest narrative block.** Approved bounded short text, paged long text, objective wrapping, authored narrative treatment. | `8b047e8ee7d436e96a2b64637dceabf121dd6cf9fa943b3156ebb348b8edb85e` |
| `08_npc_quest_interaction_states.png` | **NPC quest interaction states.** Approved offer/progress/completion/reward-choice visual states and player-driven controls. | `023909cd295e6910fcc9bf2d115ddf9dd9f4ff0cda963df41db99a363aa933be` |
| `09_context_message_component.png` | **Context message component.** Approved transient XP, objective-progress, and objective-completion presentation family. | `209610e617345b83eebf9c0aaa5d25d735185a56d8807e6aa8fb23dc282610d2` |
| `10_active_quest_component.png` | **Active Quest component.** Approved one-focus parchment panel, ambient wording, progress bars, inspection counts, completion state. | `5083893ba708f71098a226987e7fa786d1f7756085b41971681f3574fadbef80` |
| `11_health_tunnel_continuous_progression.png` | **Health tunnel continuous progression.** Approved visual calibration sheet for continuous peripheral collapse from healthy to death. | `a9e86d5e4e66604dbe8d8132ec6cee81a3f7d73d8e055185b2f95687809d0886` |
| `12_compass_glyph_and_state_sheet.png` | **Compass glyph and state sheet.** Approved final compass glyph family, lane organization, scale/focus/fade/collision examples. | `8dbd98fa3dd8e15e61a734d6eb08cc34c738fbd77ecb9ca7c8b0e4a48e1dab64` |

## Implementation note

The repository should treat these exact PNGs as historical design evidence. The
runtime addon may use smaller derived production assets; those derived assets should
be reviewed against these sheets rather than replacing the sheets themselves.
