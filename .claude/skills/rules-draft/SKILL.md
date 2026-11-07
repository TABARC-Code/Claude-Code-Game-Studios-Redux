---
name: rules-draft
description: "Writes or rewrites rules text so a stranger can run it at the table under time pressure: defined terms, numbered procedures, worked examples, edge cases, tie-breaks. Also cleans up ambiguous rules."
argument-hint: "[draft <system> | rewrite <path> | check <path>]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash(bash "*/.claude/skills/rules-draft/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Rules Draft

Rules writing is system design. A rule nobody can execute is a bug, however clever the idea. This
skill turns a design into procedural text, rewrites muddy rules, or audits a draft without
changing it. It is for rulebooks, tutorials and in-game help alike.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/activation-design`, `/resolution-tuning`, `/scenario-forge`, `/exploit-hunt` (its R5
and R6 findings), `/prose-style` (the project's spelling and dash choices).
**Feeds:** `/paper-playtest` (the text gets tested by strangers), `/rewrite-text` for in-fiction
voice, `/localize`.
**Loop:** every rules dispute at the table is a bug report on this text. Log it, fix the sentence,
check the fix did not move the ambiguity somewhere else.

## Phase 1: Mode

`draft` writes new text from a design document. `rewrite` changes an existing file. `check` reads
and reports, and writes nothing. Nothing given means ask in plain text. Read the project style
guide at `design/narrative/style-guide.md` if there is one and obey it. If it does not exist, say
spelling and punctuation were not assessed and carry on.

**Register first.** Look for `design/rules/term-register.md`, and for a de facto register in rules drafts
and `design/narrative/style-guide.md`. Report found, partial or absent, with the path and the number of
locked terms. If absent, say so and offer `/term-register build` before drafting; record a decline and
carry on. In `check` mode with no register, consistency findings are NOT ASSESSED and go under `Not run`.
If the register has no register-position entry (plain prose against keyword shorthand), `draft` writes the
first passage at the plain end, shows it, and asks how far to push.

**Rewrite mode, pin before you change.** List each existing rule with its purpose. A rule whose purpose
nobody can state is marked Unknown and kept, not deleted. Rewrite in two passes: clarity only, with no
behaviour change, then behaviour changes listed one per line as separate decisions for the user.

## Phase 2: Structure

Use this order, and skip a part only if the game truly has none:

1. Header line: playing time, number of players, age or experience.
2. Components, with counts.
3. Goal, in one or two sentences.
4. Setup, in numbered steps. Include how to choose the starting player.
5. Turn overview, then the turn as a numbered list in strict order.
6. Each action and its limits.
7. Resolution, including a worked example with real numbers.
8. Exceptions and edge cases: what you may not do, when something may be done only at one
   moment, what passing a space means as against stopping on it.
9. End condition, stated separately from the winning condition.
10. Ties, with a predefined tie-break.
11. Optional rules and variants, clearly fenced off from the core.
12. A reference card for any table of costs or abilities.

13. For large card or ability pools, two documents: a learning guide in encounter order and an indexed
    reference. Optionally a five-minute teach script (goal, turn, actions, end) and a one-line expectation
    frame ("this is a blocking game").
14. **Layer order:** core, scenario, force, extended. Outer layers may override inner ones; inner ones
    never depend on outer ones. Whole-book structure and navigation belong to `/rulebook-architecture`.

## Phase 3: Writing rules

- Define a term once, in a glossary or at first use, and never swap in a synonym later. If the
  rule says "unit" in one place and "model" in another, readers assume two things.
- One action per sentence. Imperative mood for procedures ("Roll the dice. Remove one die for each
  modifier.").
- State timing. "Before", "after", "instead of" and "at the start of" each mean something. A rule
  without a trigger will be forgotten, so bind it to a state change or a fixed point in the round.
- Avoid tautologies ("a model can target what it can see"). Say what counts.
- Say what happens when the intended outcome is not legal. Use other pieces as the reference
  point, not the position before the move, unless it is marked.
- Put the catch-all dispute rule in one place and make it deterministic: a default that every table
  will pick the same way beats a coin toss. Use it for cracks, not for patching contradictions.
- Concrete rules give predictable play. Flexible rules need a referee or constant rulings, which
  turns one person into a non-player. Say which you are choosing.
- Keep modifiers few and capped, or supply the reference.
- Keep standard names for standard ideas. Renaming a familiar concept for novelty adds only learning cost.
- Keep rationale out of the rule. A designer's aside ("in practice this means...") is read as part of
  the rule. Put reasons in a separate notes block.
- Say what happens to terrain, units or states that have no effect. Silence is read as an effect.
- Declare which governs when a table and the text disagree (usually the text), and print charts so
  both players can read them upright.
- Where one phrase can be read two ways ("through", "adjacent to", "enter and stop" against "enter
  and leave"), list the cases as numbered clauses.
- Lock ambiguous formulas early. State which factor is counted (printed or adjusted) and for whom.
- Tier the text: an introductory set, the standard set, and an optional box.
- Use even counts where sets must pair.
- Examples go after the rule they illustrate. Put one wherever a first-time reader is likely to
  get lost. Examples are tests: if the example contradicts the rule, one of them is wrong.
- Teaching: a rulebook is linear text describing a nonlinear web. It works as reference, not as a
  first contact. Pair it with a quick-start or a staged first game.

**Precision tests.**
- Any effect with both a range or condition and a duration says `while [condition]` (continuous) or
  `becomes [status] until [end]` (resolved once). If the design does not say which, write
  `[DESIGNER TO DECIDE: continuous or resolved once?]`.
- When one condition governs several effects, number them under it. Put unconditional effects before the
  roll.
- Delete each `must` and reread. Keep it only where it removes a freedom granted elsewhere.
- Hold one agency split for the whole project (a common default: people pick and roll, pieces move and
  attack), victory text included.
- Effect text templates: triggered ("When X, Y"), activated ("Cost: effect"), continuous ("While this is
  in play, Y"), conditional trigger ("When X, if Z, Y"). Owner, controller and "you" are different
  things. "May" only for real choices. Each piece of text should work without seeing any other piece.
- Timing class for every effect: queued, immediate or replacement. Simultaneous triggers have a written
  order for both players; say what happens when a target vanishes.
- Targeting scope: does "choose a player" include yourself? "Whenever" against "once per turn".
- A header naming the situation goes before a dense edge-case clause. At most one fenced, labelled,
  non-normative "Why" line may follow it.

**Terminology.** Lock the five baseline words before drafting (selection verb, permission modal,
play-surface noun, activity name, who wins). Coin a term only for a phrase that recurs about three or more
times. Make a keyword when other rules will cite the mechanic. Keyword shapes and their grammar are in
`.claude/docs/craft/keyword-shapes.md`; the defect catalogue is `.claude/docs/craft/rules-wording-defects.md`.

## Phase 4: Ambiguity pass

Read the text as a neutral stranger, then as a hostile rules lawyer. For each procedure mark:
undefined term; missing timing; two readings; unstated limit; example that disagrees with the
rule; exception that depends on another exception. Record location and the two readings.

Extra marks for the ambiguity table: range plus duration without a marker; unclear condition scope; a
dropped keyword value; a partial or inflected compound keyword; mixed "has" and "is" for one tag; agency
drift; a decorative "must"; a synonym of a locked term; one mechanic worded two ways; flavour text that
seems to change a rule. Every ruling made in testing goes into the FAQ.

Before showing the draft, run the self-check and fix every failure. Return uncertainties, not known
defects. Report a `Register` line (status, path, entries used) and a `Proposed register entries` table;
never lock an entry silently. For live games, errata entries carry version, old text, new text, reason,
date and scope.

## Phase 5: Verdict

**EXECUTABLE**, **CONCERNS**, **AMBIGUOUS** (a core procedure has two readings) or **NOT ASSESSED**.
Report: mode, sections written or read, ambiguity table (location, issue, readings, fix), glossary
list, and a list of questions only the designer can answer. Never resolve a design question by
guessing. Write `[DESIGNER TO DECIDE]` in the text and list it.

## Phase 6: Write

For `draft` and `rewrite`, show the full proposed text or a before and after diff first. Then ask
with `AskUserQuestion`: `[A] Write it`, `[B] Revise first`, `[C] Stop`. On [A] ask "May I write this
to [path]?" and name the path (default `design/rules/[name]-rules.md`). `check` never writes unless
the user asks to save the report. After writing, run `/paper-playtest` with the text and a person
who has not seen the design.
