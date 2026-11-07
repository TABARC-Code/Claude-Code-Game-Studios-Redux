---
name: core-check
description: "Audits a design for one core mechanism, one goal and supporting rules that all earn their place. Finds split cores, bolted-on goals, orphan rules and false-affordance themes. 'Is this design focused?'"
argument-hint: "[path-to-GDD-or-concept | 'pitch' to test a pitch pasted in chat]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/core-check/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Core Check

Asks one question of a design: what is the player actually doing, why, and does every other rule
serve that? Most designs that feel muddy have two or three cores glued together and a goal that
belongs to none of them. This skill finds the seams. It judges structure, not taste.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`. A skipped or dismissed

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.
question is not an answer: re-ask in plain text.

**Fed by:** `/brainstorm`, `/one-page-design`, `/design-system`, `/quick-design`.
**Feeds:** `/decision-audit`, `/exploit-hunt`, `/design-review`, `/scope-check`.
**Loop:** findings change the design, the changed design comes back here. Record each pass in the
report so the next pass can say what moved. A verdict that never changes between passes means
the fixes were cosmetic.

## Phase 1: Gather

1. Read the argument. A path means read that file plus any GDD it links. `pitch` or nothing means
   ask for the pitch in plain text, two to four sentences.
2. If the pitch needs more than four sentences, say so. That alone is a finding: the design is
   probably convoluted, or it is two designs.
3. List what you read. If there is nothing to read, stop with **NOT ASSESSED** and name the missing
   input. Do not invent a core from a title.

## Phase 2: State the core

Fill these in from the document's own words. Where the document is silent, write `not stated`.
Do not fill the gap yourself.

- **Core action:** one verb phrase, a thing the player does in the rules (place, bid, push, route).
  A mood or a slogan is not an action.
- **Core purpose:** why they do it, the main axis they decide along (area control, tempo, risk).
  It must not be the goal restated.
- **Goal:** the single endpoint. Several end triggers are fine if they all express one goal.
- **Full core:** action, purpose and goal in one sentence.

Core test, all five must hold: easy to explain; rooted in a systemic action; one action, not a
summary of many; room for emergent interaction; purpose names the decision axis.

## Phase 3: Map the rules

List every mechanism. For each, assign a rank and a link.

- **Rank:** core, secondary (connects straight to the core), tertiary (connects through a
  secondary), or remote (anything further out; suspect by default).
- **Link:** `deep` (changes what the core decision means), `flat` (an on/off tie), `none`.
- **Jobs:** how many different things it does. One job is tolerable. A pile of one-job rules is
  waste.
- **Weight:** a child heavier than its parent is a warning. A secondary that competes with the core
  for attention is a second core.
- **Edges:** is it double-edged (every change brings a benefit and a cost)? Purely good or purely
  bad state changes tend to be bookkeeping.

## Phase 4: Seam checks

Run each and record the evidence (file and heading) or write `not found`.

1. **Split core.** Separate screens, modes or phases that each feel like a whole game. A
   supporting rule with its own private cluster of sub-rules is probably a rival core.
2. **Phantom core.** A rule added to answer another rule, which together imply a second goal.
   Test: remove both. If the game improves, they were a pair of patches.
3. **Bolted goal.** A win condition that ignores the core's output (a kill meter replacing a
   position-based win while the position rules stay).
4. **Meaningless input.** Player choices that never feed the result.
5. **Orphan rules.** Flat or `none` links that cost more to learn than they return in play.
6. **Content as depth.** Many interchangeable items standing in for interacting systems. Expect
   only a fraction to be viable. Ask what the system is when the content is stripped.
7. **False affordance.** A theme or label that promises behaviour the rules do not have.
8. **Remaining value.** What does this give that a similar game does not? A near-clone is worth
   only its delta.

## Phase 5: Verdict and report

First match wins:

- **SPLIT CORE:** seam check 1 or 2 found a rival core, or two or more goals compete.
- **DRIFTING:** one core is findable but at least two of checks 3 to 7 fail.
- **NOT ASSESSED:** the document does not say enough to run the checks. Name what is missing and which checks did not run.
- **ANCHORED:** a single full core, every mechanism ranked, every check run, none failed or only one minor.

Report sections: Sources read, Full core (or `not stated`), Mechanism table (name, rank, link, jobs,
weight, verdict), Seam checks with evidence, Verdict, Top three fixes in order, Questions only the
designer can answer.

Fix menu to draw from, with trade-offs stated each time: pick one core and delete or shrink the
rival; reconnect a rule so it changes the core decision; merge two rules that do one job; rewrite
the goal as the ultimate expression of the core; thin the theme where it lies.

Contested ground, say so when it applies: the one-core, one-goal pattern is a strong preference,
not a law. Plenty of sprawling designs work. If the user's game is deliberately sprawling, report
the cost of that choice and let them keep it.

## Phase 6: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the report. May I write this to design/craft/core-check-[name]-[date].md?`
- `[B] Walk the top fix with me now`
- `[C] Stop here`

Write only on [A]. Then suggest `/decision-audit` for the choices the core creates, and
`/exploit-hunt` once the rules are stable. After fixes, re-run `/core-check`.
