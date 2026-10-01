# Logres API Audit Probe

Temporary diagnostic addon for Project Logres Phase 0 / I-001.

It is **not** product code.

## Safety / scope

The probe:
- sends no chat messages;
- performs no protected actions;
- changes no camera CVars;
- does not reveal or persist secret values;
- stores only non-secret scalars, booleans, API availability, call success/failure, and whether returned values were secret.

Failures are intentional evidence.

## Install

From WSL, locate the Forever AddOns directory. For a default Blizzard install, start with:

```bash
find "/mnt/c/Program Files (x86)/World of Warcraft" \
  -maxdepth 5 -type d -path '*/Interface/AddOns' -print
```

Choose the directory belonging to the Forever client, then copy:

```bash
cd ~/Projects/logres
ADDONS="/mnt/c/.../Interface/AddOns"

rm -rf "$ADDONS/LogresAPIAudit"
cp -a tools/probes/LogresAPIAudit "$ADDONS/LogresAPIAudit"
```

Do not copy this README's parent `probes` directory; the installed addon folder should be exactly `LogresAPIAudit`.

## In game

After login/reload:

```text
/lapi status
/lapi snapshot
```

The addon also records selected state transitions automatically.

Useful first-pass scenarios:
1. open world, out of combat;
2. target an ordinary enemy, then `/lapi snapshot`;
3. target an elite enemy if convenient, then snapshot;
4. enter combat;
5. cast and/or channel a spell;
6. observe a target cast if convenient;
7. become PvP flagged when safe/convenient;
8. enter an instance when convenient.

Do not force a risky scenario merely to fill the matrix. Missing scenarios remain UNKNOWN.

## SavedVariables

The TOC declares global `SavedVariables: LogresAPIAuditDB`.

After `/reload` or logout, locate the file from WSL:

```bash
find "/mnt/c/Program Files (x86)/World of Warcraft" \
  -type f -path '*/WTF/Account/*/SavedVariables/LogresAPIAudit.lua' -print
```

Copy the current file somewhere convenient and provide it for the next evidence pass.

The database intentionally does not record character names, realm names, target names, account identifiers, chat text, or secret values.
