---
name: remix-levers
description: "Fixes one named problem in an existing game or design by applying one modification lever at a time: pace, randomness, information, fairness, theme, social, objective. Produces small rule deltas with knock-ons and patches."
argument-hint: "[game-or-path | problem in plain words]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/remix-levers/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Remix Levers

Most good design changes are small and aimed at one pain point. This skill is a tool for
ideation and repair: name the problem, pick a lever, write the delta, find what it breaks, patch
it. Works on a published game you want to bend, a prototype that has stalled, or a stuck brainstorm.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/brainstorm`, `/paper-playtest` (the problem), `/exploit-hunt` (the finding),
`/classic-borrow` (a mechanism to import).
**Feeds:** `/core-check`, `/rules-draft`, `/prototype`.
**Loop:** the lever you pick is the hypothesis, the playtest is the experiment. Record which lever
fixed which problem and which did not, so the next pick is better informed.

## Phase 1: Diagnose

Name a single problem in the user's words. Common ones: too long, outcome obvious early, luck
punishes some players, skill or knowledge gap, dated content, missing parts, wrong mood. If the
user lists three problems, rank them and take one. State the scale of change:

- **Tweak:** the core is loved, change a rule.
- **New game:** components liked, rules not, so same parts and different play.
- **Mashup:** two component sets that complement each other.

**Before any lever, take the part apart.** Run the revision order: keep what works; cut what is only
clever; redesign any rule needing more than two sentences; cut tracking beyond two numbers per piece;
reword; patch narrowly; protect what makes the game distinct. Then write a card for the part you are
changing: purpose, inputs, outputs, side effects, couplings. The most coupled parts are load-bearing and
need a paper pull test ("remove it, what breaks?") before you touch them. A part whose purpose nobody can
state is marked Unknown and stays.

## Phase 2: Lever library

Pick from the group that matches the problem.

**Pace.** Shortcut the opening (deal starting assets, with a fairness patch). Hard round cap
(fixed laps, richest wins). Easier win condition. Parallel play (everyone acts at once; no
downtime; rewards speed over depth). Shared challenge (others may steal a failed attempt).

**Randomness.** Replace dice with a choice resource (own deck of move cards). Fixed movement.
Visible supply (known draw order gives perfect-information tactics). Add dice to a solved setup
(injects risk).

**Information.** Remove hidden deduction (reveal and retire the clue; less logic, more level
play). Open information with a witness (one holder, yes or no questions). Allow outside
resources for a time-boxed minute.

**Fairness.** Ranked handicap (stronger players start back or clear extra obstacles).
Compensation for a weak start. Rising level-based scoring so late finds matter. Remove a trap piece
that decides games.

**Content and theme.** Reskin by roles (same map, new goals). Reassign categories, or let a player
or opponent pick them. Narrative overlay. Genre swap (same layout, different threat). Reuse the
components as another toy altogether.

**Social economy.** Market overlay (points become currency). Teams. Penalty for a bluff that is
caught. Creative judging, where players argue and vote. [contested] Argument scoring may reward
charisma over merit.

**Objective.** Race instead of accumulation. Pattern puzzle. Pastiche and bluff (write the fake,
vote on the real). Drawing or charades. Hide and find.

**Interaction.** Too nice: tighten scarcity, contest turn order, add public races and visible tempo
fights, fewer but richer action slots. Too nasty: blocking instead of theft, make denial cost something,
cut elimination and snowballing, open a second scoring path when one closes. See `/table-feel`.

**Tone.** Cosy: low stakes, easy recovery, accumulation. Grim: costly failure, scarcity, permanence.
Heroic: big swings, reversals, growth. Absurd: odd combinations, escalating chaos.

**Retheme map.** Keep the mechanics, list each one's expression in the new setting, whether its term
survives, and which mechanics need redesign rather than renaming. If the mechanics move, it is a new game.

## Phase 3: Specify one lever

Write the change as a small rule delta: what to remove, add or replace. One lever per iteration,
so the effect can be isolated. Then:

1. **Knock-ons.** What does this lever break? Removing dice removes catch-up. Visible supply invites
   analysis paralysis. Parallel play kills reading the opponent.
2. **Patch.** Add the compensating lever (handicap, bonus, timer) for each new imbalance. A patch is a
   second lever, so test it separately when you can.
3. **Metadata.** Players, extra components, mood (silly, tactical, creative, chatty, serious),
   duration band (short, medium, long).
4. **Dials.** Expose parameters a group can tune: timer length, number of laps, token count.
5. **Name** the variant for its promise and keep the original rules as the default.

Log **scars**: a change that was reversed, with the check that would have caught it. A scar becomes a
standing rule only if it recurs.

## Phase 4: Verdict

**PROMISING**, **RISKY** (a knock-on is unpatched), **WRONG LEVER** (it cannot fix the stated
problem) or **NOT ASSESSED**. Report: problem, scale, lever, rule delta, knock-ons and patches,
metadata, and the short test: one round, watching for stalls, dominant lines and whether the
weakest player has a path to win.

Several levers lower skill expression. Say who the variant is for. Opinions that an original is
"boring" or "unfair" are the user's, not facts.

## Phase 5: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/remix-[name]-[date].md`, `[B] Try a second lever`,
`[C] Stop`. Ask "May I write this to that path?" first. Then `/paper-playtest` for a short test and
`/core-check` if the change touched the heart of the design.
