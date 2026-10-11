#!/usr/bin/env python3
"""P0193: preserve raw read-only H2 geometry evidence without implying placement PASS."""
from pathlib import Path
import json
import math
import re

ROOT = Path(__file__).resolve().parents[1]
J = ROOT / "docs/memory/evidence/P0193_H2_GEOMETRY_RUNTIME_2026-10-11.json"
V4 = ROOT / "docs/design/layout/SCREEN_MAP_V4.json"
errors=[]
try:
    audit=json.loads(J.read_text(encoding="utf-8"))
    design=json.loads(V4.read_text(encoding="utf-8"))
    if audit.get("result")!="READ_ONLY_GEOMETRY_MEASURED": errors.append("unexpected classification")
    if not isinstance(audit.get("addon_version"), str) or re.fullmatch(r"[0-9]+(?:\.[0-9]+){2}-dev", audit["addon_version"]) is None or audit.get("load_count")!=242: errors.append("observed baseline mismatch")
    if audit.get("counts")!={"total":13,"measured":13,"missing":0,"deferred":0}: errors.append("incomplete measurement")
    rows=audit.get("rows",[])
    if len(rows)!=13 or len(design)!=13: errors.append("expected 13 rows")
    else:
        for a,d in zip(rows,design):
            if a.get("id")!=d["id"]: errors.append("row order/id mismatch")
            for k in ("x","y","w","h"):
                v=a.get("actual",{}).get(k)
                if type(v) not in (int,float) or not math.isfinite(v) or v<0 or v>100: errors.append(f"invalid measured {a.get('id')} {k}")
                p=a.get("planned",{}).get(k)
                if p!=d[k]: errors.append(f"planned {a.get('id')} {k} differs from v4")
            if not errors and (a["actual"]["x"]+a["actual"]["w"]>100.1 or a["actual"]["y"]+a["actual"]["h"]>100.1): errors.append(f"measured outside viewport {a['id']}")
except (OSError, ValueError, TypeError, KeyError) as exc:
    errors.append(str(exc))
print("Logres P0193 H2 geometry evidence contract")
for err in errors: print("ERROR:", err)
print(f"{'FAIL' if errors else 'PASS'}: {len(errors)} errors")
raise SystemExit(1 if errors else 0)
