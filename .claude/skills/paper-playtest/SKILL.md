---
name: paper-playtest
description: "Plans and debriefs cheap tabletop-style playtests of any design: prototype ladder, one question per session, what to watch, how to separate unclear rules from unbalanced design from taste."
argument-hint: "[plan <path> | debrief <notes-path>]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/paper-playtest/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Paper Playtest

The cheapest honest test of a design is paper, a pencil and people who were not in the room when it
was written. This skill plans a session around one question, then reads the aftermath. It suits
board, card and miniature games and works for digital systems that can be played on paper first.
For a built game, use `/playtest-report`.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/rules-draft`, `/exploit-hunt` (what to provoke), `/scenario-forge`.
**Feeds:** `/core-check`, `/decision-audit`, `/balance-check`, `/playtest-report`.
**Loop:** each debrief decides what changes and what the next session's question is. One or two
changes per cycle, logged. A change that tests worse may be an immature good idea, so give it a
second session before dropping it. Be wary of the opposite, which is testers clinging to the
familiar.

## Phase 1: Plan

Read the argument. For `plan`, read the design or rules. Without readable material, stop with
**NOT ASSESSED**.

Fix, in plain text with the user:
1. **One question** for the session ("is the opening too slow?"). Not three.
2. **Prototype rung.** Rung one: sketch and scrap paper, borrowed dice, coins, stones. Rung two:
   printed and cut, consistent card backs, readable stats, a reference card, stock that survives
   shuffling. Rung three, polished parts, only once the rules are stable. Guess numbers at first
   (sketch a track and if it comes to twenty spaces, try twenty). A cheap prototype is easier to
   throw away.
3. **Who.** Alone first, playing every seat, to catch breakage. Then friends. Then strangers who
   will play to the end and say where they hesitated. Include a mix of player counts and extremes,
   because a rule can work at two and fail at four. Aim for several serious testers over time.
4. **Seat the designer** as an observer if possible and tell testers to play to win.
5. **Ladder of tests.** A: verbal teaching with the designer present, still writing down every table and
   sequence that comes up. B: written rules only, designer silent; ask questions instead of correcting
   ("how did you work that out?") or have players narrate each rule as they apply it. C: a fresh group
   for each stage, so nobody leans on a verbal explanation that never reached the text. D: blind test,
   rules only, written questions and answers so there is a record. Test a novel module alone before
   testing it combined. The version you ship must be the version you tested: a fix that changes
   substance triggers another blind round.
6. **Mixed skill.** Include a weaker and a stronger player. Balance among top players can differ
   from balance among merely good ones, and weaker players cannot see the strong lines.
7. **Separate the feedback.** A missing table is a catch. "I would have designed a different game" is
   taste. Be ready to shelve a favourite module that fights the rest of the game.

8. **Content maturity** for large pools: placeholders, a small set per faction, archetype decks, the full
   pool, an extended meta. Fit the question to the stage.
9. **Directed test** for one suspected problem: two set-ups that show it, a fixed number of games, one
   change per batch.
10. **Lenses and blind spots.** Recruit across play styles and read `references/tester-lenses.md`.
    House-rulers' "no problems" is weak evidence of clarity. Returning testers learn the meta, so rotate
    fresh ones in for clarity questions.
11. **Rung zero, optional:** a seat-walk through a few play-style lenses when no testers exist. Label it
    SIMULATED. It is never evidence and cannot lift a verdict above FIXABLE.

## Phase 2: What to watch

Behaviour and mood are primary data. Spoken opinion is second.
- Bored players suggest too few interactive moments. Frustrated players suggest too many, or luck
  at the wrong time.
- Dead turns, elimination waits, slow choosers, anyone with nothing to do.
- Rules disputes. If the text cannot settle it, record a rules bug.
- Lopsided results over repeated plays: same seat wins, same line wins, one location always best.
- First-player advantage and whether a trailing player has a way back.
- A catch-up or circuit-breaker rule: is it hiding an underlying imbalance?
- Whether the opponent never actually interacts.

Give the user a one-page observer sheet: the question, a timer for dead turns, tick boxes for the
flags above, and space to write the exact words of any dispute.

Observer sheet additions:
- **Said and did,** recorded separately, with an interpretation and a confidence. Behaviour wins. Watch
  for the classic contradictions: says it is clear but checks the book every turn; says it is fun but
  avoids it; calls a thing strong but nobody uses it; calls it balanced while every winner takes one route.
- **Social flags:** a dominant player steering others, a quiet player withdrawing, discomfort at betrayal,
  one player doing all the teaching.
- **Metrics:** time to first meaningful choice, teach time against target, worst downtime, score gap at
  the midpoint, kingmaking moments, rules questions tallied by rule, rules that actually fired, and a
  timed lookup task ("find the rule for X").
- **Between games:** who won and why, one unfair moment, one good moment.

## Phase 3: Debrief

For `debrief`, read the notes. Sort every note into one of three bins before proposing anything:

- **Rules unclear:** the text failed. Fix with `/rules-draft`.
- **Design unbalanced:** the system failed. Fix with `/exploit-hunt` or `/resolution-tuning`.
- **Not my taste:** one player's preference. Record, do not act unless it repeats.

Believe testers about problems, be sceptical of their fixes. For each failure ask what about the
rule failed, how it could be made to work, and whether it fails only at some player counts.
Do not cover a slow or bloated game with a bolt-on early end. Fix the cause.

Debrief additions:
- Run the survey before discussion: what was unclear, what was slow, where did you feel clever, would you
  play again and why. Never explain intent before raw feedback.
- Ask what was misunderstood, ignored, repeated or exploited, and where energy dropped.
- Discount known distortions (first-play bias, loss aversion, sunk cost, observer effect, social masking)
  and tag audience fit: target, adjacent or mismatch. Mismatch notes go to the taste bin.
- A fourth bin, **wording:** two players read one rule two ways. Send it to `/rules-draft`, and to
  `/term-register check` if a registered term is involved.
- Rank issues by frequency and severity first, cost of fix second.
- A **do not change** list protects what works. A **needs more testing** list stops thin evidence turning
  into a design change.
- Log every change in `.claude/docs/templates/rule-change-log.md`: expected effect now, observed effect and
  side effects next session. A fix that makes two new problems is reverted.
- Sample floors, as rules of thumb: under about 20 games no matchup claim; under about 50 no balance claim.
  Below the floor, balance is NOT ASSESSED.

## Phase 4: Verdict

**PLAYABLE**, **FIXABLE**, **BROKEN** or **NOT ASSESSED**. BROKEN means the session could not
reach an end or the question could not be answered. Report: the question and whether it was
answered, binned notes with counts, top three changes (at most two to try next), the next session's
question and rung, and a change log line for each change made.

Honest limits: a handful of friendly plays proves very little. Say so in the report when that is
all there is.

## Phase 5: Save and hand off

`AskUserQuestion`: `[A] Save the plan or debrief to design/craft/playtest-[name]-[date].md`,
`[B] Start the next cycle`, `[C] Stop`. Ask "May I write this to that path?" before writing. Then
loop back to `/rules-draft` for clarity bugs or `/exploit-hunt` for balance bugs.
