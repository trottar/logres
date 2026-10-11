#!/usr/bin/env python3
"""P0191 canonical H.2 design-map shape and relationship contract."""
from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / "docs/design/layout/SCREEN_MAP_V4.json"
EXPECTED_IDS = (
    "compass", "quest", "enemy-debuff", "enemy", "enemy-buff", "group",
    "class", "secondary", "main", "player-debuff", "resource",
    "player-buff", "utility",
)


def main() -> int:
    errors=[]
    try:
        rows=json.loads(PATH.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"FAIL H.2 screen map: {exc}")
        return 1
    if not isinstance(rows,list):
        print("FAIL H.2 screen map: expected array")
        return 1
    names=[r.get("id") if isinstance(r,dict) else None for r in rows]
    if names != list(EXPECTED_IDS):
        errors.append("expected exactly 13 ordered, unique canonical IDs")
    ids={}
    for r in rows:
        if not isinstance(r,dict):
            errors.append("row must be object")
            continue
        k=r.get("id")
        if k in ids:
            errors.append(f"duplicate ID: {k}")
        ids[k]=r
        if set(r)!={"id","name","x","y","w","h"}:
            errors.append(f"{k}: unexpected or missing keys")
        if not isinstance(r.get("name"),str) or not r["name"].strip():
            errors.append(f"{k}: empty name")
        for f in ("x","y","w","h"):
            v=r.get(f)
            if type(v) not in (int,float) or not 0<=v<=100:
                errors.append(f"{k}: {f} must be number 0..100")
        if all(type(r.get(f)) in (int,float) for f in ("x","y","w","h")):
            x,y,w,h=(r[f] for f in ("x","y","w","h"))
            if w<=0 or h<=0 or x+w>100.00001 or y+h>100.00001:
                errors.append(f"{k}: rectangle exceeds viewport or has zero extent")
    if not errors:
        def eq(a,b): return abs(a-b)<0.00001
        e,l,r=(ids[k] for k in ("enemy","enemy-debuff","enemy-buff"))
        if not all(eq(i["y"]+i["h"]/2,e["y"]+e["h"]/2) for i in (l,r)):
            errors.append("enemy aura rows must vertically center on target")
        if not eq(e["x"]-l["x"]-l["w"],r["x"]-e["x"]-e["w"]):
            errors.append("enemy aura horizontal gaps must match")
        if not eq(l["w"],r["w"]) or not eq(l["h"],r["h"]):
            errors.append("enemy aura sizes must match")
        if not eq(ids["main"]["y"],ids["secondary"]["y"]):
            errors.append("main and secondary must share top Y")
        pd,pr=ids["player-debuff"],ids["resource"]
        if not(eq(pd["x"],pr["x"]) and eq(pd["w"],pr["w"]) and pd["y"]+pd["h"]<pr["y"]):
            errors.append("player debuffs must align directly above player resource")
        pb,u=ids["player-buff"],ids["utility"]
        if not(eq(pb["x"],u["x"]) and eq(pb["w"],u["w"]) and pb["y"]+pb["h"]<u["y"]):
            errors.append("player buffs must align directly above utility")
        if not ids["enemy"]["x"]>50:
            errors.append("target fallback must remain right of center")
        for ii,a in enumerate(rows):
            for b in rows[ii+1:]:
                if min(a["x"]+a["w"],b["x"]+b["w"])>max(a["x"],b["x"]) + 0.00001 and min(a["y"]+a["h"],b["y"]+b["h"])>max(a["y"],b["y"]) + 0.00001:
                    errors.append(f"design envelope overlap: {a['id']} x {b['id']}")
    print("Logres Phase H.2 design-map contract")
    print("====================================")
    for err in errors: print("ERROR:",err)
    if errors:
        print(f"FAIL: {len(errors)} error(s)")
        return 1
    print("PASS: 13 rectangles, valid geometry, approved alignment constraints")
    return 0

if __name__=="__main__":
    raise SystemExit(main())
