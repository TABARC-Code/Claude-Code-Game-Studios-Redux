---
name: activation-design
description: "Designs or critiques turn structure: rounds, phases, initiative and activation models, handovers and downtime. Offers three options with trade-offs, not a single answer. 'Who acts when, and what do the others do?'"
argument-hint: "[path-to-GDD | 'new' to design from scratch]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/activation-design/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Activation Design

Activation is the tension engine of any game with sides taking turns. It decides how long people
wait, how much one player can do before the other answers, and whether the side with more pieces
quietly wins by acting last. Applies to tabletop, tactics and turn-based digital designs alike.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Fed by:** `/core-check` (which action repeats most), `/one-page-design` (feel and length target).
**Feeds:** `/exploit-hunt` (alpha strike and activation advantage), `/paper-playtest`, `/rules-draft`.
**Loop:** playtest downtime and "I could not respond" complaints come back here. Change the
structure, not the symptom.

## Phase 1: Intent

Gather, from documents or by asking in plain text: player count (default two), target session
length, desired feel (strategic planning or constant action), complexity budget, whether the
medium is physical or digital. State any default you assume. Four concerns frame everything:
handover count, downtime, resolution order and complexity.

Vocabulary to hold steady: a session holds rounds, a round holds player turns or phases, those
hold activations. Use these words and nothing else.

## Phase 2: Menu

Present three options that genuinely differ: conservative, volatile, asymmetric. Draw from this
menu, give each its rationale, table behaviour, edge cases and exploit risk.

**Full force** (whole side acts, then passes). Few handovers, strong planning. Risk: an alpha strike
the other side cannot answer, a passive opponent. Mitigate: interrupts on failure, casualties
removed at round end, defensive rolls for the inactive player.

**Partial force** (detachments, or a leader with nearby troops, then the rest). Fewer unanswerable
strikes at low handover cost. Adds a positioning puzzle around the leader.

**Single unit alternating.** Constant action. Risk: more handovers, play drifts to "kill the biggest
threat", and the side with more units sees more before committing key pieces.

**Selection controls for alternating play:** random draw (bag or deck, optionally guaranteeing all
act), push-your-luck (more activations for more risk), programmed orders (hidden stack or dials,
guessing games), unreliable orders (command range, failure penalties), a shared activation pool
(spending early starves later reactions).

**Phase hybrid** (all movement, then all shooting, then all melee, alternating per phase). Moving
first becomes a handicap, striking first an advantage. Removes lone-unit sniping. More handovers.

**Simultaneous hidden choice.** Approximates simultaneity. Needs reveal rules and tie-breaks.

**Reaction windows.** The inactive player spends a resource to interrupt. Keeps them in the game;
specify limits or it swamps the turn.

## Phase 3: Initiative

Coin toss is a decision to examine, not a default. Options: random and fixed; random and shifting
(tie goes to last round's loser); earned (spend resources or cards for earlier action, gated so
everyone can aim for it); bought (costed before the game, hard to price because value is
relative). Ask what an early move is worth in this design and tune against that.

## Phase 4: Checks on the chosen option

Answer each with evidence or `not found`:

1. Can one side remove a piece before it acts? Is that sensible or a spiral?
2. Can the side with more bodies act last on key objectives (activation advantage)? Fixes: the
   smaller side may pass, equal activation counts, unreliable orders for the larger force.
3. What does the inactive player decide during downtime?
4. How many handovers per round, and does the session length survive them?
5. Does the state change per turn feel strategic (big, leaves the opponent passive) or tactical
   (small, urgent)? Is that the intended feel?
6. Does the structure let a player ignore most of the system at any moment (phases) or demand all
   of it at once (free activation)?

## Phase 5: Verdict and report

**SOUND**, **CONCERNS**, **BROKEN** or **NOT ASSESSED**. BROKEN means check 1 or 2 fails with no
mitigation. Report: intent and assumptions, options table, recommended option with reasons and the
runner-up, checks, a one-paragraph turn sequence in rules language, and playtest hypotheses to
test ("moving first is not an advantage at four units a side").

Say plainly where an option rests on a rule of thumb. Claims such as "full-force play has less
real downtime than expected" are asserted by designers, not measured.

## Phase 6: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/activation-[name]-[date].md`, `[B] Draft the turn text
with /rules-draft`, `[C] Stop`. Ask "May I write this to that path?" before writing. Next: run
`/exploit-hunt` on the chosen structure and `/paper-playtest` to see it at the table.
