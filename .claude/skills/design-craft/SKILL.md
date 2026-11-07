---
name: design-craft
description: "Router for the game-design craft skills. Reads the situation, picks the right sequence (core-check, decision-audit, activation-design, resolution-tuning, scenario-forge, exploit-hunt, rules-draft, paper-playtest, remix-levers, world-seed, classic-borrow, unit-costing, model-scope, term-register, keyword-audit, rulebook-architecture, card-forge, faction-forge, expansion-plan, meta-intervention, tempo-curve, table-feel, mechanic-forge, story-engine, adventure-forge), settles conflicting advice and keeps the feedback loop between them."
argument-hint: "[what you are stuck on, a path, or 'status']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/design-craft/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Design Craft

Twenty-five focused skills for the mechanics side of game design, plus this router. Each one is small on
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
7. **Rules writing is design.** Procedural, unambiguous, consistent, usable under time pressure,
   and consistent across documents: enforced by a register, not by memory.

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

That default suits a skirmish game. For anything else, take a short intake of at most eight questions:
a one-sentence hook; audience (children, family, hobby, party, solo); player range; duration;
interaction mode (competitive, co-operative, team, semi-co-operative); one to three verbs (plan,
negotiate, draft, fight, build, puzzle, bluff, explore, optimise); how much randomness; hard
constraints. Infer what is not said and mark the inference low confidence: hook words such as survive,
together or solve suggest co-operative play; betray or traitor suggest semi-co-operative; otherwise
competitive. Derive two to four success measures from audience, duration and interaction.

**Hard gate.** Before any detail work, four things must exist, however rough: a turn or round structure,
a primary verb set, a win, end or co-operative loss condition, and a minimal component model. If any is
missing, route to `/core-check` first and say why. Genre-specific checks live in
`.claude/docs/craft/genre-checklists.md`; read the matching block.

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
| Terms drift, keywords multiply, supplements disagree | `/term-register` | `/rules-draft` |
| Keywords or special rules combine badly | `/keyword-audit` | `/exploit-hunt` |
| Players cannot find rules, the book is a tangle | `/rulebook-architecture` | `/rules-draft` |
| A card or small cluster needs designing or checking | `/card-forge` | `/keyword-audit` |
| Factions or sides feel the same | `/faction-forge` | `/unit-costing` |
| Planning an expansion, formats, rotation | `/expansion-plan` | `/card-forge` |
| A live strategy dominates, a piece is mandatory or dead | `/meta-intervention` | `/patch-notes` |
| Decided in round one, or grinds, or the middle sags | `/tempo-curve` | `/scenario-forge` |
| Fine but flat, cold or nasty at a multiplayer table | `/table-feel` | `/remix-levers` |
| Need a mechanism that does not exist yet | `/mechanic-forge` | `/classic-borrow` |
| No story comes out of play | `/story-engine` | `/scenario-forge` |
| Quest, mission story, investigation, campaign, flat villain | `/adventure-forge` | `/scenario-forge` |

For a complaint in the player's own words ("the first turn decides it", "nobody attacks", "my
faction feels like theirs"), look it up in `.claude/docs/craft/symptom-index.md`, which maps symptoms
to a skill and a phase.

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

**When advice collides.** Two recommendations collide when they touch the same subsystem (core loop,
economy, information, interaction, endgame, components, rules load) and push opposite ways. Settle it by
a fixed order of lenses, higher wins: the designer's intent (a written veto); friction (downtime, teach
time, compounding load); balance (a dominant line, a runaway, scoring that collapses under optimal play);
loop integrity; component economy; randomness; interaction and tone; market fit (advisory, never a veto).
Final tie-break: whichever option is cheaper to test next session. Log what was accepted, what was
rejected and why, and turn anything unresolved into a playtest hypothesis. Never compute a score to
decide it.

**Re-check triggers.** Run the whole chain again when a component type is added or the piece count grows
by about a quarter; a phase, action type or exception is added; the amount of randomness moves; scoring or
end conditions change; the interaction structure changes; or downtime rises.

**Escalate or shelve.** Escalate when the core loop changed in two consecutive iterations, a balance
failure survives two tests, more than half the testers report friction, or components grow by about a
third with no gain in the loop. After about three iterations with an unstable core, an unclear identity
or unresolved structural faults, recommend shelving or a return to `/brainstorm`. Keep each iteration to
one or two structural additions and at most three fixes between tests, and keep every build playable and
versioned. All of these thresholds are rules of thumb.

## Phase 4: Feedback loop notation

Every craft report ends with a short log block, so the pack can improve with use:

```
Loop log
Positive: what worked this pass and should be repeated
Negative: what failed, or what the user rejected, and why
Changed since last pass: the design change, or none
Re-check triggered by: which trigger above, or none
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
