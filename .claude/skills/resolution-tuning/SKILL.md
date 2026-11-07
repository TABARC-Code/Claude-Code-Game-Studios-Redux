---
name: resolution-tuning
description: "Chooses and tunes resolution mechanics (dice, cards, pools, tables) for the intended odds and feel, then checks modifiers, rerolls, criticals and the resource economy around them."
argument-hint: "[path-to-GDD | system-name | 'odds' to start from target probabilities]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/resolution-tuning/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Resolution Tuning

Equal averages feel different. Twenty small chances and one big roll can have the same expected
damage and play nothing alike. This skill designs the feel first and the mean second, and it works
for any random or semi-random resolver, digital or physical.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/decision-audit` (where randomness sits), `/balance-check` (numbers in data).
**Feeds:** `/unit-costing`, `/exploit-hunt`, `/rules-draft`.
**Loop:** simulated or playtest results return here. If outcomes cluster too tight, loosen; if
players cannot read odds, simplify.

## Phase 1: Target feel

Ask, or read from the GDD, for each test type: who rolls (a lone hero or a mass), how predictable
it should be, whether failure should do something, and what the player should be able to read at a
glance. State target odds first if known (for example 30, 50 and 90 per cent) and slot the
mechanic in afterwards.

## Phase 2: Mechanic menu

Give each candidate with when to use it, cost and risk.

- **Target number, one die.** Granularity of one step per face. Simple, few difficulty steps.
- **Pool, count successes.** Bigger pools are steadier. Pools smooth when the number of dice is at
  least the number of faces, and very stable at multiples of that. Threshold pools suit one big
  action. By-degree pools suit counting wounds on groups. Add one differently coloured spike die to
  put swing back into a pool that has become too stable.
- **Highest plus bonus.** Take the top die, add for extra successes. Good for individuals, flattens
  quickly as dice are added.
- **Sum of dice.** Bell curve. A flat modifier is worth most near the middle of the curve, so
  strong units are naturally hard to improve. Awkward with many simultaneous attackers.
- **Nested stages** (hit, then wound, then save). Two or three stages steady the output without a
  large pool, and a stage can make a unit feel elite. Saves cost nothing mathematically but give
  the defender a roll.
- **Lookup table.** Exact odds and rich results. Slow. Reserve for rare, complex events.
- **Cards.** Multi-effect single flips, deck memory for pacing, hands as chosen luck. Avoid when
  odds must be easy to compute or private information would be unequal.
- **Custom symbol dice.** Smooth lookups but they refuse simple modifiers. Decide early.

Die choice: six-sided is stable and intuitive but offers few difficulty steps; percentile reads as
odds; larger or oddly shaped dice raise the entry barrier. Rolling low being good clashes with
intuition and is usually avoided. [contested]

## Phase 3: Secondary rules

- **Rerolls:** specify whether you can reroll dice you did not roll. Losing a die per reroll keeps
  them costly. Letting a player revert to the original keeps the decision space wide.
- **Modifiers:** apply them to one side only, cap them (about plus or minus three) or let natural
  extremes override, and supply a reference once there are more than a couple.
- **Criticals and fumbles:** automatic results at the extremes are simple but erase large
  modifiers. Alternative: extremes flip the result and add a side effect (success with a cost,
  failure with a perk). Keep side effects uniform.
- **Opposed tests:** compute a target from both stats (widens the useful stat range) or compare
  two rolls (a plain dice-off is a coin toss that can tie).
- **Fail forward:** a failed test that does nothing is a dead moment. Give it a consequence.

**Ratio tables.** If combat compares totals as a ratio, say which way it rounds (rounding toward the
defender is conventional and only relabels columns). Put a floor and a ceiling on the ratio. Keep each
column monotone, so a die modifier or column shift behaves, and say what happens beyond the die range.
Where identical results fill many columns, shifts mean nothing. For exchange results, say which factors
count for each side (printed or adjusted). Tabulate each column's distribution before trusting it.
Work out the odds at which an attack is safe, how many attack factors one stack can bring, and cap
them so only part of a defensive line can be made unbreakable.

## Phase 4: Checks

1. Compute the actual probability of each outcome by hand and show the working. If you cannot, say
   so; do not estimate and call it a result.
2. Compare the feel against Phase 1: variance, longest dry spell, chance of a total whiff.
3. Check extremes: the best stat against the worst, the largest pool against the smallest.
4. Check bookkeeping: how many dice per model, how many lookups, how many modifiers to recall?
5. Check the economy around it: any resource spent on odds (rerolls, boosts) must have a price
   that matters, and surplus must not pile up unspent.

## Phase 5: Verdict and report

**FIT**, **CONCERNS**, **MISFIT** or **NOT ASSESSED**. MISFIT: the mechanic cannot deliver the
Phase 1 feel at any tuning. Report: target feel, chosen mechanic and two alternatives, probability
table with the arithmetic, the checks, and the dials to tune with a first guess for each.
Mark every figure as computed, assumed or rule of thumb.

## Phase 6: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/resolution-[name]-[date].md`, `[B] Price units against
this resolver with /unit-costing`, `[C] Stop`. Ask "May I write this to that path?" first. Next:
`/exploit-hunt` for stacking and modifier abuse, `/rules-draft` to write the procedure.
