#!/usr/bin/env python3
from pathlib import Path
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {
    "01_world_ghost_hybrid_e_direction.png": "da841222e3d9fe8863b8d4fdf5641e01a61ae936af413e218f741d31867badfc",
    "02_resource_bar_primitive.png": "0b644dff55976f809396952d7474c22a9cd82709e17950210c3076616c895a44",
    "03_action_button_primitive.png": "c204d9755c3c4298177a5e49be5f9a0042052d9f69d4887b86f83b0b5e7dc7dd",
    "04_status_aura_icon_primitive.png": "9b2aa564c4b9fd237c302ab3d6ff849e4a88e54a46a3b34f4e7c4017bd71eebd",
    "05_cast_state_cue_primitive.png": "deb979ba880256dc8a98e6898289dfe2a2b90ba5b67a5bec3c00a9abd9639e1a",
    "06_enemy_name_relative_danger.png": "f21b8e5d961d37abfb2a66afd4ebd555efc3392a00616037cd2a58f58a03b64e",
    "07_npc_quest_narrative_block.png": "8b047e8ee7d436e96a2b64637dceabf121dd6cf9fa943b3156ebb348b8edb85e",
    "08_npc_quest_interaction_states.png": "023909cd295e6910fcc9bf2d115ddf9dd9f4ff0cda963df41db99a363aa933be",
    "09_context_message_component.png": "209610e617345b83eebf9c0aaa5d25d735185a56d8807e6aa8fb23dc282610d2",
    "10_active_quest_component.png": "5083893ba708f71098a226987e7fa786d1f7756085b41971681f3574fadbef80",
    "11_health_tunnel_continuous_progression.png": "a9e86d5e4e66604dbe8d8132ec6cee81a3f7d73d8e055185b2f95687809d0886",
    "12_compass_glyph_and_state_sheet.png": "8dbd98fa3dd8e15e61a734d6eb08cc34c738fbd77ecb9ca7c8b0e4a48e1dab64",
}

errors = []
asset_dir = ROOT / "docs/design/approved"
for name, expected in EXPECTED.items():
    path = asset_dir / name
    if not path.is_file():
        errors.append(f"missing approved asset: {path.relative_to(ROOT)}")
        continue
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        errors.append(
            f"hash mismatch: {path.relative_to(ROOT)} expected={expected} actual={actual}"
        )

required = [
    ROOT / "docs/design/approved/README.md",
    ROOT / "docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md",
    ROOT / "docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md",
]
for path in required:
    if not path.is_file():
        errors.append(f"missing canonical visual record: {path.relative_to(ROOT)}")

if errors:
    print("Logres approved visual baseline")
    print("===============================")
    for error in errors:
        print(f"FAIL: {error}")
    print(f"FAIL: {len(errors)} error(s)")
    sys.exit(1)

print("Logres approved visual baseline")
print("===============================")
print(f"PASS: {len(EXPECTED)} approved assets + canonical records")
