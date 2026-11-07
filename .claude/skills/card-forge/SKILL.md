---
name: card-forge
description: "Designs or audits single cards and small clusters against a cost baseline, role tags, purpose questions, draw and random checks, rarity fit and combo tests, with a run mode for deck-builder and roguelike card pools."
argument-hint: "[path-to-card-list-or-GDD | 'new' | 'run' for a deck-builder or roguelike pool]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/card-forge/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Card Forge

A card is a small rule with a price on it. Most bad cards fail in one of three ways: the price
does not match the effect, the card has no deck that wants it, or it does something harmless alone
and something ruinous beside two friends. This skill prices each card against a stated baseline,
asks what it is for, and tests it beside the strongest cards in the pool. It works on one card, a
cluster of up to about twenty, or (in `run` mode) the offer pool of a deck-builder run.
Vocabulary, the cost baseline and the opening-hand method live in
`.claude/docs/craft/card-balance-lexicon.md`. Read the sections you need from it by heading.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`. A skipped or dismissed
question is not an answer: re-ask in plain text.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/unit-costing` (the cost baseline), `/faction-forge` (identity and weakness),
`/resolution-tuning` (draw and variance), `/world-seed` (theme).
**Feeds:** `/keyword-audit`, `/exploit-hunt`, `/expansion-plan`, `/paper-playtest`, `/balance-check`.
**Loop:** a card that comes back REWORK returns here with its change log. Keep the pricing table
between passes; a card whose price moves every pass has no settled job.

## Phase 1: Inputs

1. Read the argument. A path means read that file plus the glossary and any faction document it
   links. `new` means ask in plain text for the card's intended job and faction. `run` means
   read the run structure as well (energy per turn, deck start, offer rules, enemy list).
2. Find the **cost baseline**: the document's own rule for what a unit of cost buys. None stated
   means pricing (Phase 3) is **NOT ASSESSED**. Offer the lexicon's linear starting baseline as a
   hypothesis the user can adopt, and say the pricing that follows rests on that choice.
3. Find the **pool's five strongest cards**: the document's own list, or ask. Without them the
   cluster test (Phase 7) is **NOT ASSESSED**.
4. List what you read. Nothing to read: stop with **NOT ASSESSED** and name the missing input.

## Phase 2: Role tag

Tag each card: **threat** (wins if unanswered), **answer** (removes or neutralises a threat),
**pressure** (costs the opponent effort to remove, not lethal alone) or **utility** (draw,
resources, setup). One primary tag, an optional secondary. Count per faction. A threat to answer
ratio beyond about 3:1 is a signal to inspect (rule of thumb): threat-heavy pools drift to fast
aggressive play, answer-heavy pools stall. Report the ratio, not a verdict on it.

## Phase 3: Price against the baseline

For each card, a row: cost, stats, effect, baseline value, deviation, named compensation.

- Every deviation above baseline names its **compensation**: a drawback, a condition, a group or
  faction lock, or a copy limit. A deviation with no named compensation is a finding.
- A card well below baseline with no upside is a **trap card**: it teaches new players to lose.
- Price direct damage at roughly half its amount and search as dearer than draw (lexicon, rules of
  thumb). Short fixed-length matches loosen the baseline; say which the game is.
- Investment, impact, counterability: high cost, high impact and hard to counter is broken; high,
  high and easy to counter is the healthy target for big plays.

## Phase 4: Purpose questions

Ask the ten purpose questions from the lexicon of each card (which deck wants it, what decision it
gives each player, auto-include, strictly worse, exciting to draw, miserable three times, theme,
new line of play, parses cold, breaks beside the top five). Record yes, no or `not known`.
More than two failures makes it a **design** problem, not a pricing one (rule of thumb). Do not
fix a design problem with a number.

## Phase 5: Draw, random and denial checks

1. **Draw:** place each draw effect in the lexicon's danger ordering. Draw is safest as a
   secondary effect on a card that does something else.
2. **Random:** the worst result must still help its owner. The best result must not win outright
   or beat a fixed card at the same cost.
3. **Denial:** it may slow the opponent. A card that removes their next turn or locks them out of
   resources is a finding.
4. **Hard counter:** a card that only answers one strategy becomes a tax on every deck. Give it an
   independent use.

## Phase 6: Rarity, copies and wording

- **Rarity tracks complexity, not power.** Higher rarity buys more text, more conditions, more
  ways to misplay; it does not buy a better rate. A common above baseline is a finding.
- Copy limit stated and tiered by rarity if the game tiers it.
- **Cold read:** the text executes without seeing any other card. Owner, controller and "you" are
  used consistently; "may" appears only for a real choice; a keyword is defined before use.
- Flavour text never changes a rule. If it seems to, the rules text is ambiguous.

## Phase 7: Cluster test

Pair each card with each of the five strongest cards, then with the best two-card pair. Apply the
five combo tests from the lexicon (assembles by turn four, no response window, answer dearer than
the combo, commons only, a single narrow counter). Three or more yes answers: **degenerate**.
Remedies, smallest first: raise a piece's rarity, add one to a cost, add a condition, add a
counter to the pool, restrict a piece to one copy. Restrict a loved combo rather than delete it.
Pairs not run are named and counted in the report.

## Phase 8: Run mode (deck-builder and roguelike pools)

Run only with `run`, otherwise list it under `Not run` as out of scope.

1. **Resource model:** fixed energy per turn makes every energy gain a major effect; price it so.
2. **Bounds:** build the **worst plausible deck** (weak picks, no removals) and the **best
   plausible deck** (a strong synergy found early). The worst must still clear the first act; the
   best must not end fights before the enemy acts. Unbounded loops are findings.
3. **Offer variance and pick agency:** offer size, rerolls, skip option, removal and thinning
   access. Early picks should reward flexibility, later picks commitment. Thinning is a skill to
   reward, and in-run power growth is expected, not creep.
4. **Enemy doctrine:** no blanket immunity to a strategy (use resistance or a condition), intent
   shown before the player commits except in deliberate uncertainty events, damage that tracks
   expected player power without spikes, higher difficulties that demand execution without
   closing an archetype.

## Phase 9: Verdict and report

First match wins:

- **BROKEN:** a degenerate cluster, an unbounded run loop, a random best case that wins outright,
  or a lockout.
- **REWORK:** any card with an uncompensated deviation, a trap card, more than two purpose
  failures, a common priced as a rare, or a failed cold read.
- **NOT ASSESSED:** no cost baseline, no top-five list, or any phase in scope not run. Name each.
- **READY:** every phase in scope run, every card priced with compensation named, no failures.

Report sections: Sources read, Baseline used, Pricing table, Role counts, Purpose grid, Checks,
Cluster pairs run and not run, Run bounds (if `run`), Verdict, Top three fixes, `Not run`.

## Phase 10: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/card-forge-[name]-[date].md`, `[B] Rework the top
card with me now`, `[C] Stop`. Ask "May I write this to that path?" first and write only on [A].
Next: `/keyword-audit` for any keyword the cards lean on, `/exploit-hunt` once the pool is stable,
`/paper-playtest` with the degenerate pairs as named tests, `/expansion-plan` when the cards are
a set.
