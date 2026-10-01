# Current Handoff

Authoritative state: `../CURRENT.md`.

P0058 is verified pushed at `eba9998`.

D.5 source/design review is complete.

D-028 is canonical.

Selected current matrix:
- action replacement follows immersion preference;
- Player replacement follows immersion preference;
- Target replacement follows immersion preference;
- Quiet Mode = immersion ON + world context;
- Party suppression = false;
- ActionContext presentation precedence =
  combat > PvP > instance > world.

No instanceType-specific branch in the first pass.

Current runtime behavior already matches this matrix.

Next patch should add integrated Context Policy Check diagnostics rather than
inventing new suppression behavior.

P0059 is documentation/source-design only; no WoW redeploy required.

User performs all commits/pushes.
