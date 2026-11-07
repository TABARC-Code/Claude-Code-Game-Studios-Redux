# Card Balance Lexicon

Read by `/card-forge`, `/faction-forge`, `/expansion-plan` and `/meta-intervention`. Read it by
section heading; it is a reference, not session context. Every number below is a rule of thumb
to test against your own game, not a law.

## 1. Cost baseline and compensation

- **Start linear.** A starting hypothesis: one unit of cost buys about one point of attack and one
  point of toughness, so a cost 3 body is about 3/3. Replace it with the game's own baseline as
  soon as playtests produce one, and say which baseline a report used.
- **Direct damage** costs about half its amount (2 cost for 4 damage), because it cannot be
  blocked and can finish a game.
- **Search** (find a named or typed card) costs more than plain draw, because it removes variance.
- **Short fixed-length matches** loosen the baseline: early efficiency matters more, late value less.
- **Every deviation names its compensation.** A card above baseline must carry at least one of:
  - a **drawback** (lose life, discard, skip a step);
  - a **condition** (only if you control X, only on your turn);
  - a **group lock** (usable only in one faction or deck type);
  - a **copy limit** (one per deck, or tiered by rarity).
  A deviation with no named compensation is a pricing fault. A card far below baseline with no
  upside is a **trap card**.
- **Investment, impact, counterability.** High cost, high impact and hard to counter: broken. High,
  high and easy to counter: the healthy target for big plays. High cost, low impact: a trap. If
  stopping a line costs more than building it, the line is broken.

## 2. Role tags

| Tag | Job | Pool heavy on it tends to |
|---|---|---|
| Threat | Wins if left unanswered | Fast, aggressive play |
| Answer | Removes or neutralises a threat | Stalled, reactive play |
| Pressure | Costs the opponent effort to remove, not lethal alone | Grinding attrition |
| Utility | Draw, resources, setup, search | Slow, combo-friendly play |

A threat to answer ratio beyond about 3:1 in either direction per faction is a signal to inspect.

## 3. Draw taxonomy

Ordered from least to most dangerous to balance (rule of thumb; the order may shift with the
game's resource system):

1. **Pure draw:** draw N.
2. **Search:** find a specific card or type.
3. **Stack then draw:** look at the top cards, order them, draw one. Price it as a search.
4. **Draw up to N:** refill a hand. Grows stronger the more a deck empties its hand.
5. **Draw then discard:** filters, and fuels any graveyard or discard strategy.
6. **Conditional draw:** draw when something happens. Can repeat without limit.
7. **Symmetric draw:** both players draw. Favours whichever deck uses cards better.

Draw is safest as a secondary effect on a card that does something else.

## 4. Purpose questions

Ask of every card. More than two failures makes it a design problem, not a pricing one.

1. Which deck wants it?
2. What decision does it give its owner, and what decision does it give the opponent?
3. Is it so efficient that every deck takes it?
4. Is it strictly worse than another card?
5. Is it exciting to draw?
6. Would it be miserable to face three times in one game?
7. Does it serve a theme?
8. Does it open a new line of play?
9. Does it parse on a cold read?
10. Does it break anything beside the five strongest cards in the pool?

## 5. Combo tests

For any pair or set of cards that work together, ask:

1. Does it come together by turn four?
2. Does it leave the opponent no response window?
3. Does the answer cost more than the combo?
4. Does it use only commons?
5. Does it have only a single narrow counter?

Three or more yes answers: **degenerate**. Remedies, smallest first: raise a piece's rarity, add one
to a cost, add a condition, add a counter to the pool, restrict a piece to one copy. Restrict a
loved combo rather than delete it. A counter that does nothing else becomes a tax on every deck,
so give counters independent uses.

## 6. Rarity tracks complexity, not power

- Higher rarity buys more text, more conditions and more ways to misplay. It does not buy a better
  rate. A common priced as a rare is a fault; a rare at common rate with complex text is correct.
- Tier ladder: commons carry one or two keywords near baseline; top tiers carry unusual rules, one
  copy limits, or effects that can backfire.
- A guideline split for a set: about 40 to 50 per cent common, 30 to 35 uncommon, 15 to 20 rare,
  5 to 8 top tier (rule of thumb).
- Cosmetic treatments (foil, alternate art) never change play. All card backs are identical; a
  different back leaks information.

## 7. Opening-hand odds

**Method.** Drawing without replacement follows the hypergeometric distribution. For a deck of
`N` cards containing `K` copies of a card, the chance that a hand of `n` cards contains exactly
`k` copies is:

`P(X = k) = C(K, k) × C(N − K, n − k) / C(N, n)`

where `C(a, b)` is the number of ways to choose `b` items from `a`. The chance of at least one copy
is `1 − P(X = 0) = 1 − C(N − K, n) / C(N, n)`. To ask about a later turn, add the cards drawn by
then to `n`.

**Worked example** (computed for this document). A 40 card deck with 3 copies of a key card, and a
7 card opening hand.

- `C(40, 7) = 18,643,560` possible hands.
- `C(37, 7) = 10,295,472` hands contain no copy.
- `P(none) = 10,295,472 / 18,643,560 = 0.5522`, so `P(at least one) = 0.4478`, about 45 per cent.
- Exactly one copy: 0.3741. Exactly two: 0.0701. All three: 0.0035.
- By the time 10 cards have been seen (opening 7 plus three draws), at least one copy: 0.5891.

At least one copy in a 40 card deck, computed with the formula above:

| Copies | 5 cards seen | 7 cards seen | 10 cards seen |
|---|---|---|---|
| 1 | 0.125 | 0.175 | 0.250 |
| 2 | 0.237 | 0.323 | 0.442 |
| 3 | 0.338 | 0.448 | 0.589 |
| 4 | 0.427 | 0.552 | 0.700 |

Resource cards in the deck: with 16 resources in 40 cards and a 7 card hand, the chance of two to
four resources is 0.790; of zero or one, 0.134 (screw); of five or more, 0.076 (flood). Recompute
for your own deck size; do not reuse these figures for a different deck.

## 8. Glossary of generic terms

| Term | Meaning |
|---|---|
| Tempo | Spending resources efficiently so the board advantage arrives first |
| Value | Getting more total effect from a card than it cost, often over several turns |
| Card advantage | Having more usable cards than the opponent, from draw or two-for-one trades |
| Two-for-one | One card that removes or replaces two of the opponent's |
| Curve | The spread of a deck's costs, so something can be played each turn |
| Search effect | An effect that finds a chosen card from the deck |
| Replacement draw | A cheap effect that also draws one card, so it does not cost a card |
| Deck-out pressure | Winning by emptying the opponent's deck rather than reducing life |
| Brick | A card that is dead in hand at the moment it is drawn |
| Screw and flood | Too few, or too many, resource cards drawn |
| Deck thinning | Removing weak cards so the strong ones are drawn more often |
| Mulligan | Redrawing an opening hand, usually at some cost |
| Net deck | A list copied from a published source rather than built |
| Alpha strike | Committing everything to one decisive attack |
| Quarterbacking | One player directing everyone's moves in a co-operative game |
| Archetype | A recognisable deck strategy: aggro, control, midrange, combo, exploit, stall |
| Metagame | The mix of decks being played, and the choices it pushes players towards |
| Power creep | Each new set slightly stronger than the last, until old cards stop mattering |
