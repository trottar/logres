# Logres native-service element mapping index

**Authority:** `Logres/Quest/ServiceElementIndex.lua` is the declarative source consumed by the M developer-panel inspector. This table is a human review aid. The approved landscape trainer screenshot defines design slots; it does **not** prove matching Forever native controls exist.

`SOURCE_CANDIDATE` = evidence from upstream source or Logres native audit, not a successful Forever client probe. `UNMAPPED` = desired Logres slot with no established Blizzard equivalent. M-tab verification highlights a known **unprotected and shown** native element; Hide removes only Logres highlight and never hides a Blizzard control. For dynamic ScrollBox rows, identity is currently deferred.

| ID | Service | Logres role | Intended element | Blizzard candidate | Evidence | State |
|---|---|---|---|---|---|---|
| `trainer.frame` | trainer | `surface` | Panel / border | ClassTrainerFrame | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.title` | trainer | `title` | Trainer title | ClassTrainerNameText | Aurora Classic; client verify | SOURCE_CANDIDATE |
| `trainer.portrait` | trainer | `portrait` | Portrait | ClassTrainerFramePortrait | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.subtitle` | trainer | `subtitle` | Trainer profession | — | design-only | UNMAPPED |
| `trainer.search` | trainer | `search` | Search field | — | design-only | UNMAPPED |
| `trainer.categories` | trainer | `category` | Left category filter | — | design-only | UNMAPPED |
| `trainer.filter` | trainer | `filter` | Native filter | ClassTrainerFrame.FilterDropdown | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.list` | trainer | `list` | Skill list | ClassTrainerFrame.ScrollBox | ElvUI Forever; P0278 runtime | SOURCE_CANDIDATE |
| `trainer.scrollbar` | trainer | `scrollbar` | Skill scrollbar | ClassTrainerFrame.ScrollBar | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.row` | trainer | `row` | Visible skill row | ClassTrainerFrame.ScrollBox.* | ElvUI Forever; row identity TBD | SOURCE_CANDIDATE |
| `trainer.selection` | trainer | `selection` | Selected skill | ClassTrainerFrameSkillStepButton | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.status` | trainer | `status` | Training rank bar | ClassTrainerStatusBar | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.detailIcon` | trainer | `detail.icon` | Selected skill icon | ClassTrainerSkillIcon | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.reagents` | trainer | `reagents` | Reagent display | — | design-only | UNMAPPED |
| `trainer.price` | trainer | `price` | Money / cost | ClassTrainerFrame.money | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.train` | trainer | `action.train` | Train button | ClassTrainerTrainButton | ElvUI Forever | SOURCE_CANDIDATE |
| `trainer.trainAll` | trainer | `action.all` | Train all | — | addon / native source unverified | UNMAPPED |
| `trainer.close` | trainer | `action.close` | Close button | ClassTrainerFrameCloseButton | Blizzard named candidate | SOURCE_CANDIDATE |
| `merchant.frame` | merchant | `surface` | Merchant panel | MerchantFrame | ElvUI | SOURCE_CANDIDATE |
| `merchant.items` | merchant | `item-list` | Merchant item slot | MerchantItem1 | ElvUI | SOURCE_CANDIDATE |
| `merchant.buyback` | merchant | `buyback` | Buyback item | MerchantBuyBackItem | ElvUI | SOURCE_CANDIDATE |
| `merchant.money` | merchant | `money` | Player money | MerchantMoneyInset | ElvUI | SOURCE_CANDIDATE |
| `merchant.tabs` | merchant | `tabs` | Buy / buyback tabs | MerchantFrameTab1 | ElvUI | SOURCE_CANDIDATE |
| `merchant.repair` | merchant | `action.repair` | Repair control | MerchantRepairAllButton | ElvUI | SOURCE_CANDIDATE |
| `merchant.filters` | merchant | `filter` | Stock item filter | MerchantFrame.FilterDropdown | ElvUI modern; client verify | SOURCE_CANDIDATE |
| `flight.frame` | flight | `surface` | Flight map frame | TaxiFrame | ElvUI Classic | SOURCE_CANDIDATE |
| `flight.routes` | flight | `travel.map` | Route map | TaxiRouteMap | ElvUI Classic | SOURCE_CANDIDATE |
| `flight.map` | flight | `travel.mapArt` | Map artwork | TaxiMap | ElvUI Classic | SOURCE_CANDIDATE |
| `flight.close` | flight | `action.close` | Close control | TaxiCloseButton | ElvUI Classic | SOURCE_CANDIDATE |
| `gossip.frame` | gossip | `surface` | NPC conversation | GossipFrame | Logres NativeServiceCapabilities | SOURCE_CANDIDATE |
| `bank.frame` | bank | `surface` | Bank window | BankFrame | Logres NativeServiceCapabilities | SOURCE_CANDIDATE |
| `auction.frame` | auction | `surface` | Auction window | AuctionHouseFrame | Logres NativeServiceCapabilities | SOURCE_CANDIDATE |
| `stable.frame` | stable | `surface` | Pet stable | PetStableFrame | Logres NativeServiceCapabilities | SOURCE_CANDIDATE |
| `tabard.frame` | tabard | `surface` | Guild tabard | TabardFrame | Logres NativeServiceCapabilities | SOURCE_CANDIDATE |

## Forward workflow

1. Source audit (ElvUI Forever preferred for its `ScrollBox`, Aurora Classic when relevant): identify real native globals/fields; capture path and provenance.
2. M tab selects each indexed role and attempts guarded mouse-inert highlighting. Record PASS/DEFERRED in exported diagnostics and screenshots. This does not authorize skinning or native control deletion.
3. Only after runtime verification, implement shared parameterized style primitive + preview fixture + guarded native adapter; keep D-046 parity and D-047 Blizzard interaction ownership.
4. Extend the same catalogue for merchant item/cost/buyback/repair, taxi route/map, and future bank/auction/stable/tabard/gossip services. Unknown UI roles stay UNMAPPED until source+runtime proof.

## Deferred global issue

Logres HUD overlap with Blizzard windows is a global presentation ownership/strata refinement, not a special trainer hack.
