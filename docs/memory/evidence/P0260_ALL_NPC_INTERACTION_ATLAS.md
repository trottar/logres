# P0260 — ALL NPC interactions atlas (pre-modularity scope, NOT feasibility verdict)

Date: 2026-10-18. Baseline: `main` `669ec77`. Companion: `P0260_MODULARITY_SOURCE_AUDIT.md`. Required by D-047: **ALL NPC interactions**, across ordinary, service, specialized and custom/event flows. The following **54 candidate variants** are *coverage families*, not 54 verified Forever 1.60.1 services and not 54 separate Logres UI implementations. The ordinal IDs preserve the inventory agreed during the architecture discussion. Any unlisted script-specific interaction is an extension of the final custom row, not an excuse to ignore it.

## Legend

- **Provisional visual difficulty** 1 simplest to 5 specialized; **action complexity** 1-5 measures expected native transaction/protection burden. These are *pre-modularity hypotheses*, not runtime results or post-modularity rankings.
- **Reuse** names visual families to share: `Narrative` (pages/text), `Decision` (button/cancel), `Options` (selectable list), `Cards` (item/reward list), `Catalog` (scrollable priced entries), `Map`, `Slots` (inventory/pet), `Custom` (domain-specific). Source adapters and mutating actions are separate.
- **Evidence:** `quest-read`/`quest-action` = Logres source implemented with limited runtime evidence; `gossip-probe` = `Quest/InteractionProbe.lua` read-only and P0129 sample; `camera-event` = service open/close events or known named frames in camera only; `unverified` = no service renderer/controller found. None implies live gameplay-action capability.

| # | NPC interaction / variant | Visual | Action | Reuse | Current evidence |
| --- | --- | ---: | ---: | --- | --- |
| 01 | NPC greetings, lore and flavor text | 1 | 1 | Narrative | gossip-probe |
| 02 | Long/multi-page NPC dialogue | 1 | 1 | Narrative | quest-read |
| 03 | Goodbye, cancel, back, close | 1 | 2 | Decision | quest-read; general fallback unverified |
| 04 | Generic multi-choice/branching gossip | 1 | 3 | Narrative, Options | gossip-probe |
| 05 | Directions, hints, service explanations | 1 | 2 | Narrative | gossip-probe; generic unverified |
| 06 | Unavailable/locked option/requisite text | 1 | 2 | Options, Decision | gossip-probe |
| 07 | Available/active/completed/repeatable quest list | 1 | 3 | Options | gossip-probe |
| 08 | Quest offer narrative/objective | 1 | 2 | Narrative, Decision | quest-read/action |
| 09 | In-progress/incomplete quest narrative | 1 | 2 | Narrative | quest-read; Continue unverified |
| 10 | Completion narrative | 1 | 2 | Narrative | quest-read |
| 11 | Quest Accept/Decline | 2 | 2 | Decision | quest-action, scoped runtime |
| 12 | Quest progress Continue to reward step | 2 | 3 | Decision | action unavailable in Logres |
| 13 | No-choice final Complete/claim | 2 | 3 | Decision, Cards | gated native-handler route; live claim unverified |
| 14 | Guaranteed reward item/money/XP display | 2 | 2 | Cards | reward-model/view; scoped visual |
| 15 | Innkeeper bind/confirmation | 2 | 3 | Narrative, Decision | compass service marker; live adapter unverified |
| 16 | Spirit healer resurrection/cost/penalties | 2 | 3 | Narrative, Decision | unverified |
| 17 | Trainer reset talents/unlearn confirmation | 2 | 4 | Decision, Catalog | trainer camera-event only |
| 18 | Legacy talent/dual-spec options | 2 | 4 | Decision, Catalog | trainer camera-event only |
| 19 | NPC teleport/portal/travel confirmation | 2 | 3 | Decision, Map | unverified |
| 20 | Battlemaster initial PvP selection | 2 | 4 | Options, Decision | unverified |
| 21 | Experience gain on/off or similar paid toggles | 2 | 3 | Decision | unverified |
| 22 | Transmog enable/disable opt-in | 2 | 3 | Decision | transmog camera-event; exact option unverified |
| 23 | Quest turn-in requiring cost or items | 2 | 4 | Cards, Decision | completion cost gate blocks unsupported |
| 24 | NPC spells/buffs/healing/one-action services | 2 | 3 | Decision | unverified |
| 25 | Merchant item browse and purchase | 3 | 3 | Catalog, Cards | merchant camera-event only |
| 26 | Sell bag items at merchant | 3 | 4 | Catalog, Slots | merchant camera-event only |
| 27 | Merchant buyback | 3 | 3 | Catalog, Cards | merchant camera-event only |
| 28 | Repairs: individual/every equipped | 3 | 3 | Decision, Slots | repair POI, merchant events; transactional unverified |
| 29 | Limited stock, reputation, alternate-currency vendors | 3 | 4 | Catalog, Cards | unverified |
| 30 | Class spell training | 3 | 3 | Catalog | trainer camera-event only |
| 31 | Profession/weapon/riding and specialist training | 3 | 3 | Catalog | trainer camera-event only |
| 32 | Hunter pet training / pet unlearning | 3 | 4 | Catalog, Decision | unverified |
| 33 | Selectable quest rewards and final claim | 3 | 5 | Cards, Options | sample choice cards; live choice still stock |
| 34 | PvP/honor/reputation quartermaster | 3 | 4 | Catalog, Cards | unverified |
| 35 | Repeatable material turn-in/exchange/supply order | 3 | 4 | Cards, Decision | quest/gossip analog only |
| 36 | Guild registrar / charter and signatures | 3 | 4 | Catalog, Decision | guild camera-event only |
| 37 | Guild tabard visual/cost customization | 3 | 4 | Custom, Decision | tabard camera-event only |
| 38 | Rewards Shop/special reward catalog | 3 | 4 | Catalog, Cards | Forever category potential; unverified source |
| 39 | Profession specialization / unlearning | 3 | 4 | Catalog, Decision | unverified |
| 40 | Flight master routes/destinations/fare | 4 | 4 | Map, Options | service POI, FlightMapFrame excluded from camera frame predicate |
| 41 | Stable master pet store/retrieve/swap | 4 | 4 | Slots, Cards | stable camera-event only |
| 42 | Personal bank deposit/withdraw/tab purchases | 4 | 5 | Slots, Catalog | bank camera-event only |
| 43 | Guild bank tabs/permissions/transactions | 4 | 5 | Slots, Catalog | unverified |
| 44 | Appearance/transmog equipment preview | 4 | 5 | Custom, Slots | transmog camera-event only |
| 45 | Battlemaster group queues/eligibility/status | 4 | 5 | Options, Custom | unverified |
| 46 | NPC character customization/appearance | 4 | 5 | Custom | unverified |
| 47 | Special crafting/work-order interfaces (where supported) | 4 | 5 | Catalog, Slots | shipment event in camera; service not confirmed |
| 48 | Multi-stage scripted NPC interaction with item requirements | 4 | 4 | Narrative, Decision, Cards | custom unverified |
| 49 | Auction house search/bid/buyout/sell/cancel | 5 | 5 | Catalog, Slots, Custom | auction camera-event only |
| 50 | Item upgrades/transformations via NPC | 5 | 5 | Cards, Custom | unverified |
| 51 | Cinematic/scripted multi-stage decisions | 5 | 5 | Narrative, Custom | unverified |
| 52 | Dungeon/group finder NPC interactions, if present | 5 | 5 | Options, Custom | unverified |
| 53 | Void storage/black market/specialized banking, if present | 5 | 5 | Slots, Catalog | unverified |
| 54 | Other server-specific/event NPC services and scripts | 5 | 5 | Custom, registry extension | intentionally open-ended/unverified |

## Companion interaction conditions — each service needs variants

Available vs unavailable; ineligible/reputation/level/quest status; single vs multiple choices; confirmed vs cancelled; insufficient currency or inventory; user selection; full/empty lists and overflow; in/out of combat; native protected/secret/unknown values; active vs closing NPC session; transition between two services from one NPC; NPC distance/world transition; DynamicCam running vs Logres camera controlling; unsupported Forever APIs; lost/reopened native window; multi-actor party permissions where relevant. These are not independently verified client behaviors.

## Reassessment method AFTER working modular extractions

For every row reassess: (1) percentage of visually reused *tested* components, (2) proven data availability on Forever, (3) safe action ownership, (4) camera/immersion benefit, (5) regression and maintenance burden, (6) safe native-backed alternative. Choose native presentation, hybrid, full Logres, or defer. Do not convert these provisional numbers to release promises. **Bank/auction remain deferred pending real capability + user-benefit review**, not silently excluded.
