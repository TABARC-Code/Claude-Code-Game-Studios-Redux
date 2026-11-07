---
name: decision-audit
description: "Classifies the player's choices as solutions, guesses or decisions, then audits randomness placement, feedback quality, labour and memorisation load. 'Are the choices real?'"
argument-hint: "[path-to-GDD | system-name]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/decision-audit/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Decision Audit

A game lives or dies on whether the player is choosing something worth choosing. This skill takes
the moments of play one at a time and asks what kind of choice each one is, how the result comes
back, and whether the player can learn from it.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/core-check` (the core says which choices matter), `/design-system`, `/balance-check`.
**Feeds:** `/resolution-tuning`, `/exploit-hunt`, `/playtest-report`, `/design-review`.
**Loop:** playtest notes go back in here. If testers report "I did not know why I lost", the
feedback phase is where the fault will be.

## Phase 1: Pick the moments

Read the argument. List the five to ten most frequent or most important choices the player makes in
the design. Frequency matters more than drama. If nothing can be read, stop with **NOT ASSESSED**.

## Phase 2: Classify each choice

- **Solution:** the player holds almost everything needed. The odds of each option can be worked
  out. Fine for a tutorial, deadly if it is most of the game.
- **Guess:** almost no information. Any pick is as good as any other.
- **Decision:** in between. Resolved by heuristics, reading the opponent and judgement.
- **Not a choice:** reflex, execution, memory recall, labour. Count these separately.

Quick test: can the player calculate the odds of each option? Always yes means solved. Never means
guessing. Record which, with the evidence.

Also note depth: how many strategically distinct viable states are there, not how many raw states.
Mirror images add nothing. Too large a space can feel futile, so aim for enough rather than most.

## Phase 3: Randomness placement

For every random element:

- **Input randomness** shows before the player chooses (a drawn hand, a revealed map). It gives
  puzzle feel and lets both sides feel clever. Check it does not hand one player an easier setup.
- **Output randomness** resolves after the choice (the roll). It gives risk and surprise. Check
  the proportion: if a weaker player could not plausibly beat a stronger one five times in a row
  even once, luck may be too thin; if the weaker one wins half the time, luck is too thick.
- **Timing gap.** Input randomness that arrives early enough to plan around behaves like skill.
  Late, it behaves like output.
- Nearly everything "kind of works" with heavy luck, which is why designers get fooled. Ask what
  a player can learn from a loss.

## Phase 4: Feedback

Check the four loops: instant (after input), response (after the other side answers), strategic
(after a multi-move plan plays out) and final (win or loss). Everything else takes its meaning from
the final one. Questions:

- After a loss can the player say what they should have done differently?
- Is there a gap between a good decision and its payoff long enough to hide the connection?
- Does failure move the game forward, or does a failed test give nothing?

## Phase 5: Load

- **Labour:** no-thought time cost. Cut traversal and busywork that interrupts good play.
- **Execution:** can I perform it, as opposed to should I. Failed inputs corrupt feedback.
- **Memorisation:** a deterministic game gets solved openings unless something varies. Keep what the
  player must remember small and loose.
- **Option overload:** more than one or two truly hard choices a round freezes beginners. Fewer, and
  the resource is pointless.

## Phase 6: Verdict

First match wins:

- **DEGENERATE:** most choices are solutions or guesses, or one option dominates every time.
- **CONCERNS:** real decisions exist but randomness placement, feedback or load fails a check.
- **NOT ASSESSED:** not enough to judge. Name what is missing and which phases did not run.
- **SOUND:** most frequent choices are decisions, loss is explainable, load is proportionate, all phases run.

Report: moment table (choice, type, evidence), randomness table, feedback findings, load findings,
verdict, three fixes ranked with the cost of each.

Fix menu: add hidden information or interacting variables to a solved choice; move randomness from
output to input; shorten the gap between choice and result; replace labour with a decision; let the
player choose among random results (roll two, keep one) instead of removing the luck.

Flag as contested: minimising luck, labour and execution suits abstract strategy. Other genres use
them on purpose. Ask the user what the game is for before calling a thing a defect.

## Phase 7: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/decision-audit-[name]-[date].md (asks first)`,
`[B] Work the top fix now`, `[C] Stop`. Write only on [A], after asking
"May I write this to that path?". Then suggest `/resolution-tuning` for dice or card problems and
`/exploit-hunt` for dominant lines. Re-run after changes.
