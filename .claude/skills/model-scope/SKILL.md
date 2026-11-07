---
name: model-scope
description: "Fixes what a game models and at what grain: purpose and audience, the scale variables, effect versus detail, chrome versus function, and the optional subsystems (zones of control, supply, command friction, morale). Catches rules that outgrow their purpose."
argument-hint: "[path-to-GDD-or-concept | 'new']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/model-scope/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Model Scope

A simulation-flavoured game has to decide what it is about and what it is willing to ignore. Most
trouble comes from skipping that decision: research piles up with no game in it, one minor rule
quietly sets the pace of the whole game, or an abstraction that suits fifteen minutes is stretched
over six hours. This skill makes the choices explicit, then checks that every rule earns its
weight. It fits wargames, strategy games, management sims and any design with units, space, time
and resources. For pure card or abstract games, use `/core-check`.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/brainstorm`, `/one-page-design`, `/world-seed` (setting facts to model).
**Feeds:** `/activation-design`, `/resolution-tuning`, `/scenario-forge`, `/unit-costing`,
`/exploit-hunt`, `/rules-draft`.
**Loop:** playtests tell you which abstractions broke. Move the failing rule to a different grain
or an optional module, then re-run here. Record which subsystems earned their place and which
were cut, so the next design starts from evidence.

## Phase 1: Where is the game?

Ask first: could this be played now, even roughly? Pictures, research and a pitch are not a
design. If nothing playable exists, say so and move to Phase 2 anyway to name what is missing.
A design sets starting conditions and permitted actions. It does not script a story. Conditional
rewards ("hold the town by turn thirteen and reinforcements arrive") are fine. Scripted outcomes
("the town falls on turn fourteen") remove the player's agency.

## Phase 2: Purpose and audience

Pick the main audience, and note that one rule set can serve several if the motive lives in the
player: a competitor who wants a fair contest; a solitaire player watching events unfold; students
in a short session; professionals who study outcomes over many runs; social players. Each pulls
the rules differently.

Set the dials on separate sliders, not on one realism-against-playability line:
size, complexity (the number of variables a player weighs and the intricacy of the sequence, not
page count), depth, balance (each side wins about half the time between equals, also after
swapping sides), accuracy, and the audience weighting. If history is lopsided and the audience is
competitive, offer scenario variants, victory points that balance the sides, or handicaps rather
than distorting the model.

## Phase 3: Scale variables

Fix four, and write them down: ground covered, force size, map grain (areas or cells), unit grain
(what one piece is). Then answer:

- Which of the four is modelled carefully and which is abstracted?
- Does the table or screen fit the map? Reach limits about five feet across the physical table.
- Does the session length survive the counts? Swapping one command piece for its parts multiplies
  choices, usually forces a finer map, and lengthens play. At the limit every individual and every
  supply item is tracked, which is unplayable.
- Is the size of the game independent of its complexity? Large and simple suits crowds. Small and
  complex suits experts. Do not conflate them.

## Phase 4: Effect against detail

For each major subsystem, choose and record:

- **Design for effect:** a mechanic that gives plausible outcomes without copying the cause. Cheap,
  and it breaks when the time or force scale is changed. Tie each effect abstraction to a stated
  time and force scale and say so in the rules.
- **Design for detail:** a rule for every circumstance. Suits a realism audience in a small scope.
  Costly to learn, rewards rule memorisers, and a single odd rule can end up pacing everything.

Mark each feature as **function** (a rule uses it) or **chrome** (colour, labels, silhouettes).
Chrome is fine and cheap but must carry no rules weight. A counter value no rule reads is chrome.
Terrain types with the same rule effect merge into one class. Draw terrain so every cell is
wholly one thing, and remove ambiguity by redrawing, not by adding hidden conventions.

**Tight or loose.** Place the design on the axis from tight (precise, competitive, few rulings) to loose
(cinematic, umpired, house rules welcome) and say why. Choose an objective viewpoint (model every causal
step) or a subjective one (skip to the moments that matter) and name the steps you skip. Count logical
types: every unit category with its own rule set adds load, and state changes create hidden sub-types.
Merge types that share most rules. Free space can be formalised with zones, templates, base geometry or
fixed measuring rods instead of a grid.

## Phase 5: Subsystem menu

Add an optional subsystem only when the purpose needs it. Give option, use when, cost, risk.

- **Zones of control.** None (a line needs a piece on every cell; opportunity fire makes it
  credible). Full, stop on entry (thin lines hold, very thin lines can be impregnable). Fractional
  or facing-based (fewer units hold a line; harder to explain). Soft (extra cost or a one-cell
  step through; many sub-choices to settle). Weakening it means more units or a narrower map.
  State: does it reach cells holding friends and enemies, can a unit hop between zones of the
  same enemy, do rail and sea moves obey it.
- **Supply.** A traced path to a source, blocked by enemy influence (say whether friendly pieces
  cancel the block); distance from a rail line; an isolation timer or a step loss per turn; a
  single logistics-strain penalty after a long advance. Check end-of-game timers actually fire.
- **Replacements and production.** Pools that accrue, sites that shut when the enemy is adjacent.
  Keep the conditions (isolated, surrounded, threatened) few and clearly different.
- **Command friction.** From light to heavy: none; a pooled allowance across the force; random
  allotments or cards; hidden order chips revealed and resolved by type; regional priorities
  ranked in secret; written orders with delivery delay and acceptance rolls; order sheets with
  triggers. The heavier end needs honest players or a referee. Competitive play prefers range,
  allowances or activation limits.
- **Morale.** Accumulating hits against a quality threshold; a per-unit test after a shock;
  formation-level sliders; a macro support base. Routs need rally rules or they are removals.
- **Hidden information.** Removing a reserve from the table to paper; reverse-side counters;
  zone reporting (exploitable by filling every zone, so report counts or exchange paper maps at
  the end).
- **Forced historical mistakes.** Opponents learn to game them. Prefer victory points for the
  historical goal, a bonus reflecting the side's confidence, or choosing a weaker player for that
  side.
- **Luck.** Represents imperfect knowledge and low-level chaos. Some designs need none.

## Phase 6: Checks

1. **Pace-setter.** Is there a variable that advances at a fixed rate (a supply range, a rail
   repair rule) and so sets the speed of the whole game? Decouple it or make it a decision.
2. **Stretch test.** Run the scenario ten times longer or with ten times the force. Which
   abstraction fails?
3. **Weakest link.** Which rule is only used by the people who memorised it?
4. **Ripple.** For every changed rule, list what else must change (movement allowance, retreat,
   stacking, replacement). Silent ripples are bugs.
5. **Last mover.** Who deploys or acts last, and what does that do?
6. **Simplified subsystem swing.** A subsystem cut to the bone tends to become useless or
   overwhelming. The fix is often fuller rules, not a smaller subsystem.
7. **Rule load against payoff.** Frequent rules are cheap to remember. Rare ones are costly.
8. **Research cap.** Stop research when it stops feeding rules.

## Phase 7: Verdict and report

First match wins: **OVERREACHING** (rules outgrow the stated purpose, or the session cannot finish
in the time available); **DRIFTING** (a pace-setter, a stretch failure or a silent ripple);
**NOT ASSESSED** (not enough written down to run the checks; name what is missing); **SCOPED**
(purpose, scale, effect or detail, and subsystems line up, every check run).

Report: purpose and audience, the four scale values, subsystem table (choice, effect or detail,
function or chrome, cost, risk), check results with evidence, verdict, and three changes ranked.
Say which statements rest on rules of thumb. Some historical claims in design circles are
disputed. Do not import a historical anecdote as a modelling fact without checking it.

## Phase 8: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/model-scope-[name]-[date].md`, `[B] Take the subsystem
choices to /activation-design`, `[C] Stop`. Ask "May I write this to that path?" first. Next:
`/resolution-tuning` for the combat table, `/scenario-forge` for victory and setup,
`/exploit-hunt` once rules exist.
