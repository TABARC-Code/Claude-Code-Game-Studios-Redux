---
name: unit-costing
description: "Designs unit stats and a points or cost system for list-building games: stat types, expected-value pricing, overshoot correction, force limits, synergies and faction identity."
argument-hint: "[path-to-unit-data | system-name]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/unit-costing/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Unit Costing

Costs are not additive. A stat's value sits on a curve, depends on the opposing stat in the field,
changes with synergy, and depends on who picks the unit. Perfect balance is also undesirable: if
every option is equal, choice is meaningless, and a weak option rewards clever play. This skill
prices units from expected value, then sets up the playtest loop that corrects the price.
It works for tabletop army lists, digital squad builders and deck points.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Fed by:** `/resolution-tuning` (the odds), `/activation-design`, `/core-check`.
**Feeds:** `/exploit-hunt`, `/balance-check`, `/paper-playtest`.
**Loop:** playtest results overshoot-correct the price, and the corrected prices feed back to
`/balance-check`. Record each price move with the evidence.

## Phase 1: Inputs

Read the unit data and the resolution rules. Without both, stop with **NOT ASSESSED** and name
the missing file. Never price from vibes. State the unit of cost and the size of a typical force.

## Phase 2: Stat types

Know what each stat type costs the player to read.
- **Physical quantity** (movement distance). **Intangible quantity** (wounds, actions, ammo).
- **Target number.** Clear at a glance; lower-is-better confuses.
- **Indirect** (a formula or table). Flexible, but heavy to read.
- **Modifier.** Higher is better, no tables.
- **Dice type** (die size). No tables but odd dice; poor for masses. A maximum that wins outright
  gives low dice an underdog chance.
- **Comparative** (ordering only), and **cost**.

## Phase 3: Pricing procedure

1. Fix an arbitrary base cost for an average unit. Use a figure like 10 for small groups and 100
   for squads, doubling every cost if you need granularity.
2. Compute expected damage against the average unit over a typical game. Show the arithmetic.
   Example in generic terms: a ranged unit with a 50 per cent hit chance and four chances in range,
   killing about two average units over the game, costs about double the average. Treat this as a
   starting guess, since it ignores synergy and range play.
3. Adjust for durability, speed, reach, special rules and how often the unit gets to act.
4. Playtest. If the test suggests ninety rather than a hundred, test at eighty. Overshooting
   narrows the range faster, makes the unit chosen more, and shows whether it is fun when strong.
5. Collect many opinions: average tester ratings as a multiplier, or have testers build two fair
   opposing forces at a fixed total without knowing which side they get.

## Phase 4: Force building

- List-building uses solo time and deepens engagement but can swamp newcomers. Offer presets or
  menus for starters. Building at the table after objectives are revealed is tighter but costs
  more in collection size.
- Force organisation: minimum and maximum counts by type, share caps (no more than a third in one
  role), slots, themed forces with bonuses. Prefer motivations that arise from play to imposed
  limits.
- Synergy: fair abilities that combine into a bonus reward list skill. Make the combination
  discoverable (named cross-references, discounts for pairs). Do not bury it.
- Factions steer new players into a playstyle. Limit availability so a strong combination does not
  dominate everywhere, with faction rules that match the fiction.
- Evolving meta: after a loss players either counter or copy. Show one or two counters to every
  obvious strategy in testing so players believe answers exist. For copying, make the core engine
  fun in a mirror match and make maximised lists fragile (over-commitment loses to rock, paper,
  scissors dynamics).
- Weak is fine. Forgettable (a duplicate role) is not.

## Phase 5: Checks

1. Any unit that is strictly better than another at equal or lower cost.
2. Any role with only one viable unit.
3. Any combination that stacks the same bonus (hand to `/exploit-hunt`).
4. Cost curve smoothness: do small stat changes cause large cost jumps?
5. Price against the player type that picks it. Does a melee-minded player have a reason to take
   ranged support?
6. Stats that never matter, and values nobody can read at a glance.

## Phase 6: Verdict

**PRICED** (checks pass, prices have a working shown), **CONCERNS**, **BROKEN** (a strictly dominant
unit or a stat that decides everything) or **NOT ASSESSED**. Report: inputs, stat table with type,
pricing working per unit, checks, and the first playtest list with overshoot targets. Mark every
price as a starting guess.

## Phase 7: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/unit-costing-[name]-[date].md`, `[B] Hunt exploits in
these prices`, `[C] Stop`. Ask "May I write this to that path?" first. Then `/exploit-hunt` and
`/balance-check`.
