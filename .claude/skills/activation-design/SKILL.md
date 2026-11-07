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

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

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

**Further structures.**
- *Dual-use initiative dice:* each side rolls a pool; unmatched dice buy priority, matched sets fuel
  abilities. A weak ability round is a strong priority round, which is the tension.
- *Command plus chance:* a command value sets how many units may act, a roll adds or removes a few.
- *Action chains:* declare micro-actions, roll for speed, successes execute in order.
- *Alternating attacker and defender:* the defender declares blocks after seeing the attack, which keeps
  the inactive side deciding.
- *Round-based play:* passing ends your part of the round, rounds are scored separately (best of three,
  say), and some resources carry over, so baiting the opponent into overspending becomes a tactic.

**Pacing currency** (what limits what you do each turn): a pool that grows each turn (predictable,
shallow); resource pieces in the deck (flood and screw variance); a cap on plays per turn (cost stops
working as a lever, so a building budget replaces it); sacrifice to act. Check **cap collapse**: once
income is at maximum, does the game become "play the biggest thing"? Add sinks, upkeep or a lower cap.
A second currency earns its place only if the two run dry at different times. Never change the currency
system to fix one deck or faction.

Scale default, a rule of thumb: single-piece alternation up to about twenty pieces a side, detachments
or phases up to about sixty, whole-side turns with reactions beyond a hundred.

## Phase 3: Initiative

Coin toss is a decision to examine, not a default. Options: random and fixed; random and shifting
(tie goes to last round's loser); earned (spend resources or cards for earlier action, gated so
everyone can aim for it); bought (costed before the game, hard to price because value is
relative). Ask what an early move is worth in this design and tune against that.

**First-player remedies:** compensation for the second player, no attack on turn one, one fewer draw,
types barred on the first turn, simultaneous phases. Working hypothesis to test: the first player wins
no more than about 55 per cent between equals.

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

7. Every phase is named, with the types of action legal in it and whether responses are allowed.
   Simultaneous triggers have a stated order for both sides.
8. **Activation padding:** cheap filler pieces bought only to pass time while the real threats wait. Check
   cost of a second activation, decay of excess activations, a cap of two consecutive activations, or a
   surge for the outnumbered side.
9. **Multiplayer:** turn order has stakes, downtime at the maximum player count is tolerable, role
   selection or simultaneous phases keep idle players engaged, and first-seat advantage is checked per
   player count.

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
