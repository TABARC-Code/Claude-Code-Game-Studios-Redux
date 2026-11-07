---
name: story-engine
description: "Checks that play itself produces story: the conceit line and viewpoint fix, minor conceits, embedded against emergent narrative, connected and correlated events, chain reactions, dramatic focus by time share and dissonance between fiction and scoring, with an optional referee mode."
argument-hint: "[path-to-GDD-rules-or-scenario | 'referee' to add the referee pass]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/story-engine/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Story Engine

Some games tell stories because a writer wrote them; others tell stories because the rules make
events lead into each other and players narrate the result afterwards. This skill audits the second
kind: the story that comes out of the rules. It asks whether players know who they are, whether the
systems hand events to one another, whether the part of play that takes the most time is the part
the fiction is about, and whether scoring rewards what the story says matters. It does not write
quests, missions or campaigns; for authored content use `/adventure-forge`.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/core-check` (the core action the story grows from), `/world-seed` (setting facts),
`/scenario-forge` (objectives and events), `/model-scope` (what is modelled and what is skipped).
**Feeds:** `/adventure-forge` (campaign mode), `/scenario-forge`, `/rules-draft`, `/rewrite-text`,
`/paper-playtest`.
**Loop:** after a playtest, ask each tester to retell the game in three sentences. Bring the
retellings back here. A retelling that is only a list of rolls means the chains did not form; a
retelling about a different subject than the conceit means the dramatic focus has drifted.

## Phase 1: Gather

1. Read the argument. A path means read the rules, the scenario or GDD and any document they link.
   Find headings with Grep first and read by section. `referee` adds Phase 7.
2. List every system that produces an event (combat, movement, morale, economy, event decks,
   weather, AI behaviour) and every scoring rule. These two lists drive every later phase.
3. If there are no rules to read, only a pitch or a setting, stop with **NOT ASSESSED**: emergent
   story cannot be judged from intentions. Name what is missing.

## Phase 2: Conceit and viewpoint

- **Conceit line.** Write it from the document's words: "You are [role], doing [what], in [what
  world]." Where the document is silent write `not stated`. The line should give players an entry,
  explain why the conflict happens, support many different stories and invite players to extend it.
  A conceit that fits only one story is a plot, not a conceit.
- **Viewpoint fix.** Players usually see the whole board or screen while the conceit casts them as
  someone inside the world. Say which fix the design uses: a framing device that explains the
  overview (a planner at a map table, a spirit above the field), fog of war or hidden information,
  or an honest acknowledgement that the game is played from above. `none` is a finding when the
  conceit is a person at the front.
- **Minor conceits.** For each abstract roll, track or resource, is there an in-world label that
  makes the result readable ("the line wavers" rather than "morale minus one")? Where a rule's
  in-world logic is not obvious, propose a one-line framing. Labels are chrome: they must not
  change what the rule does.

## Phase 3: Embedded against emergent

Classify every narrative element as **embedded** (written in advance: briefing, setup, scripted
event) or **emergent** (arises from play). Then check the embedded elements:

1. Narrative conditions are set at the start where everyone can see them, not revealed to one side.
2. Mid-game events strike the world or every side, not one unit. An event aimed at one piece reads
   as the designer's hand.
3. Embedded material gives context, never control: no event dictates a result the players were
   playing to decide.
4. Gaps are left on purpose for players to fill.
5. Situations are bold. A last stand is hopelessly outnumbered, not slightly behind (rule of thumb).

## Phase 4: Connected events and chain reactions

Build a link table: for each system, which other system takes its output as input. Then check:

- **Connected events.** At least one output of each major system feeds another. A system whose
  results feed nothing produces isolated incidents, not story.
- **Correlated events.** Independent systems that share a place or a type of result get read as
  cause and effect ("the storm came as the bridge fell"). Note where this happens by accident and
  where it could be arranged.
- **Uncertainty at every step.** If any link is certain, the chain is a script.
- **Expectation match.** Things behave as players expect from the fiction. A frightened unit that
  charges reads as a bug, not a twist.
- **Generic stays generic.** Unnamed soldiers and items invite players to name them. Over-specified
  filler crowds out player stories.
- **Chain reactions.** For each chain of three or more links: possible on any trigger but not
  likely, every step visible as it happens, every step open to a response, and the full result
  spectacular. A hidden chain is an ambush by the rules; a likely chain is routine.

## Phase 5: Dramatic focus

1. Estimate the time share of each activity in a typical session (planning, moving, resolving,
   bookkeeping, negotiating, waiting). Use playtest timings if they exist; otherwise label the
   shares as estimates.
2. The activity with the largest share is the real dramatic focus, whatever the conceit claims.
   If it is bookkeeping or waiting, or it is not the most enjoyable part, that is a finding.
3. **Viewpoint choice.** Does the design model every causal step (objective) or jump to the moments
   that matter (subjective)? Either is valid. Mixed by accident is a finding: say which steps are
   skipped and whether the skip is stated.

## Phase 6: Dissonance between fiction and scoring

For every objective and scoring rule, write what the fiction says the side cares about and what
the points actually reward. A mismatch (the briefing says hold the shrine, the scoring pays more for
abandoning it to raid) is **dissonance**. Also check: does the optimal play look like the conceit
from the outside? Would a spectator describe the winning line in the conceit's own words? Record
each objective as aligned, dissonant or unclear.

## Phase 7: Referee mode (only with `referee`, or if the design has a referee role)

If skipped, list it under `Not run`. Check that the rules give the referee these duties and the
tools to carry them: frame each scene; run third parties; fire timed events; rule on unlisted
actions by the fiction's logic; hold hidden information; keep the pace; aim for dramatic fairness
rather than a rigid balance. Players act on what their character knows, not on what the player can
see. The referee arbitrates the contest and does not turn it into free role-play. Scenario kit
check: hook, divergent motives, hidden information, third parties, hazards, open-ended objectives,
timed events, branching outcomes. If one optimised approach always works, the scenario fails.

## Phase 8: Verdict and report

First match wins:

- **DISSONANT:** at least one primary objective is dissonant in Phase 6, or the dramatic focus in
  Phase 5 contradicts the conceit.
- **MECHANICAL:** Phase 4 found no chain of two or more connected links, or most event systems
  feed nothing.
- **CONCERNS:** no viewpoint fix where one is needed, an embedded check failed, a chain is hidden
  or likely, or the referee kit is missing two or more items.
- **NOT ASSESSED:** no rules to read, or a phase could not run for lack of input. Name each phase.
- **STORIED:** conceit stated, chains present and visible, focus and scoring aligned, every phase
  run (Phase 7 only when in scope).

Report sections: Sources read, Conceit line, Viewpoint fix, Minor conceits proposed, Embedded and
emergent table, System link table, Chains found, Time-share table (estimate or measured), Objective
alignment table, Referee kit (or `Not run`), Verdict, Top three fixes, Questions for the designer.
Time shares and the "bold situation" rule are heuristics to test in play, not measurements.
[contested] Some designers hold that emergent story should never be designed for, only allowed;
report the cost of each fix and let the designer choose how much to steer.

## Phase 9: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the report. May I write this to design/craft/story-engine-[name]-[date].md?`
- `[B] Walk the top fix with me now`
- `[C] Stop here`

Write only on [A]. Then suggest `/scenario-forge` to fix dissonant objectives, `/adventure-forge`
in campaign mode if the stories should carry between games, `/rules-draft` for new framing lines,
and `/paper-playtest` with the three-sentence retelling question.
