---
name: design-craft
description: "Router for the game-design craft skills. Reads the situation, picks the right sequence (core-check, decision-audit, activation-design, resolution-tuning, scenario-forge, exploit-hunt, rules-draft, paper-playtest, remix-levers, world-seed, classic-borrow, unit-costing, model-scope) and keeps the feedback loop between them."
argument-hint: "[what you are stuck on, a path, or 'status']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/design-craft/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Design Craft

Thirteen focused skills for the mechanics side of game design, plus this router. Each one is small on
purpose. The value is in the order you use them and in what you carry from one to the next.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

## Principles the skills share

1. **Design is synthesis, not a cookbook.** Present trade-offs and alternatives. Treat every
   conclusion as a hypothesis until it has been played.
2. **Core loop first.** Turn structure, activation, resolution, victory and scenario engine before
   special rules.
3. **Activation is the tension engine.** Check alpha strikes, downtime and agency during the other
   side's turn.
4. **Balance is managed, not sterilised.** Allow asymmetry, find dominant lines and runaway states,
   and use the scenario to steady play.
5. **The scenario is a rules subsystem.** Terrain, deployment, scoring windows and table geometry
   are levers.
6. **Probability serves clarity.** Use variance on purpose. Flag opaque maths and swingy spikes.
7. **Rules writing is design.** Procedural, unambiguous, consistent, usable under time pressure.

Analysis lenses used across the pack: core loop and agency; tempo and initiative pressure;
decision density against cognitive load; variance and spike risk; snowball and runaway leaders;
dominant strategies and exploits; scenario scaffolding and win paths; physical table usability.

## Phase 1: Locate the situation

Read the argument. `status` lists which craft reports exist under `design/craft/` with dates and
verdicts, and what was last recommended. Otherwise ask in plain text what the user is stuck on, and
what exists (concept, GDD, rules draft, prototype, playtest notes).

Default assumptions when nothing is said, always stated aloud: two players, a play area about
six by four feet or the digital equivalent, ninety minutes, medium complexity, asymmetry allowed,
low to moderate bookkeeping, tactical play with scenario pressure. Change any that do not fit.

## Phase 2: Route

| Situation | First skill | Then |
|---|---|---|
| New idea, unclear what the game is | `/core-check` | `/decision-audit` |
| "Choices feel flat" or "I cannot tell why I lost" | `/decision-audit` | `/resolution-tuning` |
| Turn order, downtime, first-move worries | `/activation-design` | `/exploit-hunt` |
| Dice or card odds feel wrong | `/resolution-tuning` | `/unit-costing` |
| Missions, maps, victory, setup | `/scenario-forge` | `/exploit-hunt` |
| Something is broken but no one knows what | `/exploit-hunt` | `/paper-playtest` |
| Rules are muddy or players argue | `/rules-draft` | `/paper-playtest` |
| Ready to try it at a table | `/paper-playtest` | back to whichever bin the notes fill |
| One problem in an existing game | `/remix-levers` | `/paper-playtest` |
| Setting first, game second | `/world-seed` | `/scenario-forge` |
| Simulation-flavoured game, scale, supply, command, zones | `/model-scope` | `/activation-design` |
| Need a proven mechanism | `/classic-borrow` | `/rules-draft` |
| List-building, points, stats | `/unit-costing` | `/exploit-hunt` |

Output shapes available from the pack, so the user can ask for one by name: a system analysis
report (`/core-check`, `/decision-audit`, `/exploit-hunt`); three-option mechanic designs
(`/activation-design`, `/classic-borrow`); a balance tuning pass (`/exploit-hunt`, `/unit-costing`);
a full rules draft (`/rules-draft`); a rules clarity rewrite (`/rules-draft rewrite`).

## Phase 3: Sequence and thread

Work as a chain, with information flowing both ways:

- **Forward.** Each skill's report lists the questions only the designer can answer and the next
  skill. Carry those into the next call by path.
- **Backward.** A late skill that finds trouble sends it to an early one. A playtest that says the
  decisions are fake goes back to `/decision-audit`, not to the rules text. A rules dispute that
  turns out to be a design hole goes back to `/core-check`.
- **Cross-fertilisation.** Setting facts become scenario objectives, classic mechanisms become remix
  levers, playtest sheets become exploit probes. When you see a result from one skill that is
  useful to another, name it and pass it on.
- **Stop when the loop stops moving.** If two passes of the same skill give the same verdict with
  the same top fix, the fix was cosmetic. Say so.

## Phase 4: Feedback loop notation

Every craft report ends with a short log block, so the pack can improve with use:

```
Loop log
Positive: what worked this pass and should be repeated
Negative: what failed, or what the user rejected, and why
Changed since last pass: the design change, or none
Next skill and the question it must answer:
```

Positive feedback strengthens a habit (a check that caught a real fault stays in the routine).
Negative feedback prunes (a check that only produced noise gets trimmed). If a skill's checks keep
missing real faults, record that in the log and use `/skill-improve` on it.

## Phase 5: Hand off

Name the first skill and the exact input to give it. Ask with `AskUserQuestion`: `[A] Run it now`,
`[B] Save this route to design/craft/route-[name]-[date].md (asks first)`, `[C] Stop`. Write only
after "May I write this to that path?" and a yes. Respect the project style guide, set with
`/prose-style`: this pack writes in plain prose with no em dashes and no arrow glyphs unless the
project guide says otherwise.
