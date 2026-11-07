---
name: expansion-plan
description: "Plans an expansion, set or content drop for a card or collectible game: set philosophy and jobs, coverage and cycles, new card type checklist, power creep benchmarking, ethics, distribution and free-path test, pack and starter rules, format portfolio, rotation and reprint policy."
argument-hint: "[path-to-set-plan-or-GDD | 'new']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/expansion-plan/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Expansion Plan

An expansion has to add depth without making the old pool worthless, and a pool has to reach
players without making the free player a second-class citizen. Both drift quietly: each new set is
a little stronger than the last, each product a little more expensive to keep up with. This skill
plans a set against stated jobs, benchmarks it against the existing pool, and checks how cards are
distributed, which formats exist and how the pool ages. Pricing figures from the notes behind it
are rules of thumb to test, not industry facts.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`. A skipped or dismissed
question is not an answer: re-ask in plain text.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/card-forge`, `/faction-forge`, `/team-live-ops`, `/meta-intervention`.
**Feeds:** `/keyword-audit`, `/card-forge`, `/paper-playtest`, `/balance-check`, `/patch-notes`.
**Loop:** after release, the meta answers whether the set did its jobs. Feed that back through
`/meta-intervention`, then into the next set's philosophy. Record each set's jobs and whether it
met them.

## Phase 1: Load

1. Read the argument plus the current card list, glossary and any prior set plans. `new` means ask
   in plain text for the set's working name and what it is for.
2. Find the **benchmark**: the existing pool's cost baseline (from `/card-forge` or
   `/unit-costing`). None: Phase 5 is **NOT ASSESSED**.
3. Physical, digital or both: the answer decides whether Phases 7 and 9 have secondary-market
   questions. List what you read.

## Phase 2: Philosophy and jobs

1. **Set philosophy:** one line that a card must serve to be in the set. Use it as a filter: list
   any planned card it would reject.
2. **Jobs.** Five jobs a set can do: revenue, meta disruption, story, new mechanics, balance
   correction. Pick about three (rule of thumb). Five jobs means none is done well; one means the
   set is a patch.
3. **One new mechanic per set** at most, so problems can be traced to their source.

## Phase 3: Coverage and cycles

Minimum set, check each: new archetypes (name them); every rarity tier; every faction; a neutral
bridge card or two; glossary updates for every new term. Cycles: one card per faction in the same
slot at equal power, two or three cycles a set (rule of thumb). Draft or sealed formats need a
playable archetype from commons and uncommons alone. Mostly new cards, few reprints, unless the set
is a deliberate reprint product.

## Phase 4: New card type checklist

Only if the set adds a card type. More than one new type in a set is a finding. The new type needs
all of: its own zone, phase legality, how it is removed, a deck limit, a test against every
existing keyword (hand to `/keyword-audit`), a glossary entry, and a visual frame distinct from
existing types. Missing items are listed.

## Phase 5: Anti-creep benchmarking

1. Price every new card against the benchmark, as in `/card-forge` Phase 3. Report the average
   deviation for the set and for each prior set if data exists.
2. **Creep signal:** the new set's mean rate above baseline, or a new card strictly better than an
   old card in the same slot. Report both counts.
3. Prefer giving old strategies **consistency** (better draws, smoother curves) over replacing
   their best cards with stronger ones.
4. Long-running lines: set a per-category ceiling at the outset (most stat points for a given cost,
   most cards drawn for a given cost) and test each set against it. Supplement inflation is many
   small steps, each defensible, that sum to a new game.

## Phase 6: Ethics

Check each, yes or no:
- No card is designed weak on purpose so a later set can sell the fix.
- Promotional, preorder and event cards are cosmetic in effect, or functional reprints of cards
  available elsewhere.
- No unique gameplay effect lives only in a limited or time-bound product.
- The release cadence is announced, and the plan keeps it.

## Phase 7: Distribution and free path

1. **Model:** random packs, fixed-content releases, digital crafting, or a hybrid (fixed starters
   plus random packs is common). State the trade each makes between frustration, entry cost and
   revenue ceiling.
2. **Free-path test:** a player who pays nothing can build a deck that holds its own in casual play
   without punitive grind. Describe the route and an estimated time; no route is a finding.
3. Red flags: power only purchasable, no earn route, hidden odds, gameplay cards that expire.

## Phase 8: Packs and starters

- **Packs:** a rarity floor per pack; at least one card anyone is glad to open; published odds for
  every tier in every product; on digital packs, an account-bound bad-luck counter that survives a
  crash.
- **Starters:** beat casual decks, teach with no special cases, can be improved, introduce one or
  two factions well, ship with a turn reference.

## Phase 9: Formats, rotation and reprints

1. **Format portfolio:** which exist of rotating competitive, eternal with a ban list, open or
   casual, limited (draft, sealed), multiplayer with its own balance pass. Side decks (about 10 to
   15 cards between games, rule of thumb) make narrow counters legitimate.
2. **Rotation:** published before the first set and not changed mid-cycle; a set stays legal for at
   least two full seasons (rule of thumb). Legality shown on every card in a digital builder.
3. **Reprints (physical):** a published reprint policy; functional reprints as a pressure valve when
   a staple prices out competitors. Keep scarcity for cosmetics.

## Phase 10: Verdict and report

First match wins:

- **CREEPING:** the creep signal fired, a category ceiling is broken, or an ethics check failed.
- **CONCERNS:** fewer or more jobs than the set can carry, more than one new mechanic or type,
  coverage gaps, a failed free-path test, missing pack or starter rules, or no rotation policy.
- **NOT ASSESSED:** no benchmark, no card list to price, or any phase not run. Name each.
- **COHERENT:** every phase run, every check passed.

Report sections: Sources read, Philosophy and jobs, Coverage grid, New type checklist, Benchmark
table, Ethics checks, Distribution and free path, Packs and starters, Formats and rotation,
Verdict, Top three fixes, `Not run`.

## Phase 11: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/expansion-plan-[name]-[date].md`, `[B] Price the
set's outliers with /card-forge now`, `[C] Stop`. Ask "May I write this to that path?" first and
write only on [A]. Next: `/keyword-audit` for the new mechanic, `/paper-playtest` with the new
archetypes, `/balance-check` for economy odds, `/patch-notes` for the announcement.
