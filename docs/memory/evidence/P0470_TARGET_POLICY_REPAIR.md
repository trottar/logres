# P0470 — Screen-target decoration policy and selected neutral eligibility

Date 2026-11-17. Verified GitHub/local main P0469
11458a0a4d7322a14f6b71493ed1d74029fe86fd, tree
c613023cca91746d5482b0b1a5e9bb8773979255. User reports friendly NPC PvP/buffs
at the disabled screen-frame position, and yellow enemies missing Logres plates.
L-049 reopened with original P0467 scoped acceptance retained. L-011 PARTIAL
and L-028 OPEN retain all historical failures; no gameplay resolution claimed.

## Supplied evidence

ZIP/standalone diagnostic bytes match SHA256
7673b675ea61244472dbdd89867c1732acad74b0893f9332fdcf54402a4c2030.
Export 2026-11-17T00:04:19-05:00. Source/deployment/latest capture0.0.337-dev
match. Retained ZIP contains12 historical incidents; do not call them all P0469.
Individually inspected the two latest distinct screenshots and incident records:

- Session147 #15316, WoWScrnShot_111726_000405.jpg: selected Melika Isenstrider,
  friendly/nonattackable diagnostics, screen enemy preference=false; floating
  Logres PvP badge at old target screen position. World visible=false,
  requested=true, selected attachments0, eligibility=not-attackable, native
  owner/restore failures0. Status Aura Preview shows target0/false and reason
  preview-target-frame-disabled, so P0469 target-preview gate worked here.
  The six bottom-center harmful icons are explicitly player preview data,
  not proof of six friendly-NPC buffs. User live friendly-buff report remains
  user evidence; source below proves the reachable screen-gate omission.
- Session143 #14907, WoWScrnShot_111626_221205.jpg, older0.0.335-dev: a projectile
  and native Stonetusk Boar plate/level5; selected Logres attachments0, reason
  neutral-not-engaged, ordinary canAttack=true, reaction=neutral. Lifecycle
  combat anchors3; cached State.combat=false. The screenshot does not establish
  damage landed or identify which combat predicate failed. Current P0469
  selected predicate is unchanged from that capture and still requires both
  player and unit ordinary combat=true for neutrals. No current337 yellow
  screenshot is supplied, and no secret/taint failure is inferred from counters.

## Narrow source findings and repair

HUD UpdateTarget hides opted-out name/HP, but its independent root-parented
target PvP badge ignored screen preference and successful world ownership.
Gate only that live badge on screen opt-in/world ownership, preserving any
pending owned secure input's presentation. Player badge, secret-safe observed
flag and explicit synthetic PvP preview remain unchanged. No claim that NPC
PvP source flag itself is wrong; source fact and presentation are separate.

Ordinary StatusAuras targetHelpful and target harmful lanes also ignored
screen opt-out. Scope their local render-active predicate to screen opt-in;
do not clear live source snapshots used by world diagnostics/rendering.
The independently created native screen target harmful container used the
global player+target active switch. Add a per-target cached enabled intent,
computed from screen preference, to its existing OOC enable/disable path.
Combat returns unchanged only when BOTH global and target intent match;
otherwise defer without mutation and reconcile on existing PLAYER_REGEN_ENABLED.
No new hook, event, polling, alpha suppression, payload inspection or control.
Original TargetFrame Auras, target cast and native interaction remain preserved.
Failures remain native fail-open; full target lifecycle stays native-owned.
Report Bug gains only owned target enabled/shown flags in the existing status
snapshot; independent Status Aura Check computes the expected target policy.

Known reaction-neutral + ordinary attackable + ordinary nonfriend selected
nameplates now use the same appearance policy as existing P0459 secondary
plates. This is appearance eligibility, not aggro/threat inference. Combat
booleans are no longer prerequisites for a known neutral; hostile path and
unknown-reaction corroborated combat fallback are unchanged. Friendly,
secret/unavailable attack/friend, unknown role, forbidden/behind-camera and
unsafe native owner paths still refuse/fail open. No new scanning or CVar.
Accepted selected100%, secondary50/50, native aura art/ownership, token reuse,
removal continuity, OFF and restoration code remain unchanged.

## Validation scope

Reviewed P0334 badge, P0345 activation, P0447 neutral/native-owner,
P0457/P0459/P0460 continuity and P0466/P0468/P0469 contracts before edits.
New actual-source fixture covers neutral before combat and with restricted
combat predicates; friendly/secret/attackability/role/forbidden/behind-camera
refusals; hostile regression; badge opt-out/world/pending/preview; native
target enable/OFF/combat-deferred/regen/failure transitions. Existing P0468
fixture explicitly opts into its tested screen frame, then verifies live
positive target snapshots stay available while opted-out roots remain hidden.
Existing selected removal/identity and earlier fixtures also run.
Entire exact candidate and canonical ZIP PREWRITE/POSTWRITE, Lua5.1 syntax,
diff hygiene, source guards, refusal, exact rollback and manifest required.
Static/source tests do not establish gameplay, taint or visual acceptance.

## Client UNVERIFIED

No client execution by assistant. Naturally select a friendly NPC with screen
frame OFF: no floating Logres target PvP/target aura lanes; independent player
buffs/harmful status must remain. Test a selected yellow attackable and red
enemy: same100% world style, secondary50/50 preserved. If naturally available,
check target switch, clear, world OFF and native fallback without contrived
travel. Report Bug captures world eligibility, failures and target-screen flags;
/reload then existing local diagnostic export. Any Lua/taint/restore failure
is FAIL; missing environment is UNVERIFIED. L-049/L-011/L-028 remain open.

Final source review: a target-only combat deferral must retain the global
native-renderer usable result, or StatusAuras could start an ordinary player
fallback alongside an active native player renderer. Return true with explicit
screen-target-combat-deferred and owned targetPending; no native mutation.
Report Bug includes pending/actual cached target intent; OOC clears pending.
Source fixture checks retained native ownership and unchanged mutation count.

Initial candidate333/333 STATIC PASS; no failures observed in that tested
scope. Final pending-ownership correction requires the complete candidate
and canonical PREWRITE/POSTWRITE suite again, plus refusal/rollback/syntax.
