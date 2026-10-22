# P0313 — Trainer focus and synthetic empty icon visual correction

Baseline verified main: P0312 `8776eb638706b429350b3d507c2800682681dc50`. Candidate version `0.0.214-dev`. Implements two distinct sidebar sections, **Current trainer** and **Your professions**, through one shared P/live renderer and P0312 profession data adapter. Uses native skill requirement first, independently ordinary native tooltip/greeting only as empty-source fallback. No guessed ownership. Isolated empty fixture icon backplate repair. Full WSL suite and WoW runtime UNVERIFIED until applied/tested. User owns commit/push.

R0 PREWRITE negative result: 3/184 FAIL (checker hard-coded version; two live icon invocation contracts). R1 corrects those failures with no change to accepted visual requirement; WSL PREWRITE/POSTWRITE and WoW UNVERIFIED.
