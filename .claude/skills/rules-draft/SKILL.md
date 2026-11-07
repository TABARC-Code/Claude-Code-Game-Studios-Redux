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
- Use even counts where sets must pair.
- Examples go after the rule they illustrate. Put one wherever a first-time reader is likely to
  get lost. Examples are tests: if the example contradicts the rule, one of them is wrong.
- Teaching: a rulebook is linear text describing a nonlinear web. It works as reference, not as a
  first contact. Pair it with a quick-start or a staged first game.

## Phase 4: Ambiguity pass

Read the text as a neutral stranger, then as a hostile rules lawyer. For each procedure mark:
undefined term; missing timing; two readings; unstated limit; example that disagrees with the
rule; exception that depends on another exception. Record location and the two readings.

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
