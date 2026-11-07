---
name: adventure-forge
description: "Designs or critiques authored content (quests, story missions, dungeons, investigations) and, in campaign mode, linked play: dramatic question, beats or fronts, revelation routes, fail forward, pressure, cast, campaign arc and progression guard rails."
argument-hint: "[path-to-content | 'new' | 'campaign <path-or-new>']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/adventure-forge/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Adventure Forge

Authored content fails in a few recurring ways: it only works if the players choose as the writer
hoped, it hides the one clue that matters behind one roll, its world waits politely for the
players, or, across a campaign, the leader pulls away and nothing carries between sessions. This
skill builds or audits the dramatic and information shape of a quest, mission, dungeon,
investigation or campaign. It judges structure, not prose. Mechanical builds (deployment, terrain,
victory points) go to `/scenario-forge`; story that grows from the rules alone goes to
`/story-engine`.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/world-seed` (hooks and factions), `/story-engine`, `/brainstorm`, `/one-page-design`,
`/team-narrative` drafts, `/scenario-forge` (missions to give a story).
**Feeds:** `/scenario-forge`, `/paper-playtest`, `/team-level`, `/team-narrative`, `/exploit-hunt`
(sequence breaks), `/resolution-tuning` and `/unit-costing` (any number this skill will not set).
**Loop:** after play, ask testers which conclusions they reached and how. A required revelation
nobody reached, or reached by one route only, comes back to Phase 4. Record each pass.

**Two standing rules.** Player characters stay free: give them pressure (a situation that pokes a
loyalty, a debt or a fear), never an expected response. Never invent numbers (difficulties, damage,
rewards) for a system the user has not named; write `[number: set in /resolution-tuning]` instead.

## Phase 1: Gate

1. Read the argument. A path means read it and linked documents by section (Grep headings first).
   `new` means build. `campaign` adds Phases 8 and 9; without it they are out of scope and the
   report says so.
2. **Protagonist owner.** Does the designer own the lead (fixed hero, solo, branching gamebook) or
   do players own their characters? If players, arc tools apply only to NPCs, factions and the
   antagonist.
3. **Structure type.** Linear; site-based (beats mapped to depth or location, not time); open (no
   fixed length). A linear beat sheet laid over an open world is a misdiagnosis, so say which.
4. **Brief.** Length, tone in two words, facts to honour, rules system if any. Each missing item is
   written as a stated assumption. In critique mode with nothing readable, stop: **NOT ASSESSED**.

## Phase 2: Spine

- **Dramatic question:** one sentence, answered by the end. Two questions means two adventures.
- **Want and need** for each authored character (the lead if designer-owned; otherwise the
  antagonist and key NPCs): the conscious goal and the truth they have not recognised. Ending
  shapes: both met; need met at the cost of the want; want won while the need is refused.
- Generate options in threes, each labelled by tone and fit. Plot the ending first, then its
  opposite, and check the opening points at both.

## Phase 3: Shape

- **Linear or site.** Place six ordinal beats: hook, threshold, the turn from reacting to acting, a
  collapse aimed at the character's own fear, the crisis choice, a changed equilibrium. In play
  beats are recognised, not scheduled. Proportional placement is a rule of thumb and fits only
  fixed-length text or a fixed-length session.
- **Open.** Each threat is a front with three to five escalating moves it makes if nobody acts,
  each visible in the world, each ticked by world time or events. Use
  `.claude/docs/templates/front-and-clock.md`. Test: remove the players. The world must still move.
  An open-world hook is the visible sign of a front advancing.

## Phase 4: Information

List every conclusion the players must reach to finish. For each, give three independent routes
(a document, a witness, a scene detail) and record them in `.claude/docs/templates/revelation-web.md`.
Nothing required sits behind one character's goodwill, one roll or one room. Each node points to
two or more others: a web, not a chain. Checks gate bonus information only. Every twist has two
earlier plants, named with their location.

## Phase 5: Pressure and choice

1. **Hook clock.** Every hook has a deadline, a worsening condition or a rival.
2. **Stakes ladder.** Personal, community, setting. Weightless stakes usually lack the personal rung.
3. **Pressure rule.** Never two scenes running without a stakes decision, a revelation that changes
   the meaning of earlier events, or a worsening threat.
4. **Fail forward.** For every check and fight, failure gives progress at a cost, a new problem, or
   information. "Nothing happens, try again" is a stall. Total defeat is fair only when the stakes
   were visible beforehand.
5. **Scene test** on a sample of at least three scenes: an upset, complications that escalate
   (mixing action turns and revelation turns), a crisis between two bad options or two
   incompatible goods, an act, a changed state that seeds the next scene. No crisis means a corridor.
6. **Choice nodes:** both options viable, risks readable in advance, consequence proportional
   rather than punitive. Paths differ in cost, information or position.
7. **Set-pieces:** a terrain feature that changes how things resolve, an escalation mid-scene, one
   vivid sentence of description.

## Phase 6: Cast

- **Antagonist:** a fear that produces the goal, a method that produces the obstacles, a presence
  felt before the confrontation, one moment of sympathy, a moral direction, and in open play a front.
- **NPC one-liner:** fear, want, need, method, moral position, shadow, plus a verbal tell. An NPC
  that cannot fill it is a function, which is fine if it is meant to be one.
- Fear and stress profiles are for authored NPCs only, never assigned to player characters.

## Phase 7: Anti-pattern sweep

Run every row of `references/critique-checklist.md`: same encounter whichever path, gatekeeper clue,
exposition dump, one-enemy climax with no phases or choice, unordered fetch list, victory that
resets the status quo, attrition-only fights (each encounter must reveal, escalate, cost or
characterise), and a beat that needs one particular player choice. Record evidence or `not found`.

## Phase 8: Campaign arc (campaign mode)

1. **Type:** branching story; territorial; ladder (forces grow between games); event chain into a
   final battle. State length and whether the end state is fixed.
2. **Arc, climax first.** Write the climax, then plant seeds backwards: introduction with a
   recoverable setback, escalation, midpoint reversal, crisis with permanent stakes, a climax that
   answers session one's question, an aftermath that seeds the next arc.
3. **Scene types per session:** two or more of action, investigation, decision, reversal, climax,
   aftermath. Plan small releases before each peak; constant maximum tension numbs.
4. **Between games:** a reaction (what changed and how it lands), a dilemma between two costly
   options, and a decision that sets the next goal. A good option against a bad one is a test, not
   a dilemma.

## Phase 9: Progression guard rails (campaign mode)

Check each and give evidence: progression steady, not exponential; stacked bonuses capped; soft
resets at phase changes; injuries that matter but never cripple a force; rewards that widen options
more than raw power; gear that can be lost. **Furthest behind:** walk the player three games behind
through to a credible route to victory; if you cannot, that is a finding. **Supplement inflation:**
each new unit or reward drifts stronger over time; set per-category cost ceilings at the outset.
Thresholds such as "three games behind" are rules of thumb to test.

## Phase 10: Verdict and report

First match wins:

- **RAILROADED:** a beat needs a specific player choice or response, or the paths converge to the
  same encounter.
- **BRITTLE:** a required revelation has fewer than three routes, or a failure stalls play.
- **STATIC:** an open world does not advance without the players, or a hook has no clock.
- **RUNAWAY** (campaign): no credible route back for the player furthest behind, or uncapped
  stacking or exponential progression.
- **DISPOSABLE** (campaign): nothing carries between games that changes the next decision.
- **NOT ASSESSED:** no readable material, or a phase in scope could not run. Name each.
- **SOUND:** every phase in scope run, no failure verdict met.

Report: Sources read, Gate results, Spine, Shape (beats or fronts), Revelation web summary, Pressure
table, Cast lines, Anti-pattern table, campaign phases or `Out of scope`, Verdict. Issues are tiered
fatal, significant, polish: at most two fatal, each with location and fix. Name at least one
strength. Invent no problems to fill a tier.

## Phase 11: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the report. May I write this to design/craft/adventure-forge-[name]-[date].md?`
- `[B] Fill the front-and-clock or revelation-web sheet with me now`
- `[C] Stop here`

Write only on [A]. Then suggest `/scenario-forge` for the mechanical build, `/paper-playtest` with
the question "which conclusions did you reach, and how?", and `/exploit-hunt` for sequence breaks.
