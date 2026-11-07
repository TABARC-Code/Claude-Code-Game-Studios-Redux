---
name: keyword-audit
description: "Audits every keyword on its own and every keyword pair against each other, with the pair list derived from the term register or glossary, to find loops, unkillable pieces, unordered shared triggers and missing rulings before release."
argument-hint: "[path-to-register-or-glossary | 'new <keyword>' to test one addition against the rest]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/keyword-audit/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Keyword Audit

Keywords are where a card or unit game breaks quietly. Each one reads fine alone; the trouble is
the pair nobody tried, two death triggers that together make a piece immortal, or a trigger that
fires on "played" in one place and "resolved" in another. This skill treats the keyword list as a
closed set, tests each member, then tests every pair. The set is derived from the register or
glossary, never chosen by hand: a hand-picked list is silent about the keyword added last week.
It works for card games, skirmish games and any rules set with named abilities.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/term-register` (the keyword set), `/rules-draft`, `/card-forge`, `/faction-forge`,
`/expansion-plan` (keywords a new set adds).
**Feeds:** `/exploit-hunt` (loops and locks to probe deeper), `/rules-draft` (rulings and timing
text), `/term-register` (demotions, family entries), `/paper-playtest` (a named test per risky pair).
**Loop:** every ruling made at the table is a new FAQ line and often a missing pair cell. Bring it
back here. Record the pair count each run so a later run shows whether coverage grew with the list.

Reference: `.claude/docs/craft/keyword-shapes.md`.

## Phase 1: Derive the keyword set

1. Read `design/rules/term-register.md`. Take every entry in category `keyword` whose status is
   locked or under review. If no register, read the glossary or rules file named in the argument
   and take every formatted keyword it defines.
2. Cross-check: Grep the rules and card or unit files for the project's keyword formatting (from
   the register's formatting entry). Any formatted term used in text but missing from the set is
   an **undeclared keyword**. Add it to the set and list it as a finding.
3. If neither register nor glossary exists, stop with **NOT ASSESSED**: there is no set to derive.
   Do not build one from memory of the drafts. Suggest `/term-register build`.
4. State the set size N and the pair count N x (N minus 1) / 2, plus N self-pairs (a keyword
   stacked with itself). This number is the coverage target for Phase 4.

## Phase 2: Per-keyword checks

For each keyword, record:

- **One job.** It does a single thing. Two jobs means two keywords, or card text.
- **Definition length.** A keyword needing a long definition is better as plain card text (rule
  of thumb: more than two sentences).
- **Use count.** Fewer than three cards or units using it: candidate for demotion to plain text
  (a heuristic to test, not a law). Send demotions to `/term-register revise`.
- **Shape.** Bare tag, parameterised, compound phrase or compound-parameterised, per
  `.claude/docs/craft/keyword-shapes.md`. Every use obeys that shape's grammar.
- **Scope.** Exclusive to one faction or group, shared by some, or universal. Exclusive keywords
  protect faction identity and leave room for later sides.
- **Timing class.** Queued (resolves last in, first out), immediate, or replacement (changes an
  event as it happens). Every keyword declares one. Missing class is a finding.
- **Trigger event.** If it triggers, does it say "played" or "resolved"? These are different
  events: a countered card was played but never resolved. Ambiguity here is a finding.
- **Name.** Two or three words, easy to say aloud, drawn from the setting (rule of thumb).

## Phase 3: Shared triggers

Group keywords by trigger event (enters, leaves, dies, attacks, is targeted, turn start). For each
group with two or more members, the rules must say in writing: who orders simultaneous triggers
(active player first is common), whether responses are allowed between them, whether a leave or
death trigger fires before or after the piece is gone, and what happens if a target vanishes
before resolution. Two death triggers on one piece can add up to immortality; test that case
explicitly.

## Phase 4: Pair matrix

Run every pair from Phase 1, including self-pairs. For each pair A and B, four set-ups:

1. A attacks or acts into B.
2. A and B on the same piece.
3. A triggers B (and B triggers A).
4. A counters or cancels B.

Ask each set-up four questions: does it make a piece that cannot be removed; does it loop without
a bound; does it let a losing side win outright from behind; is it assembled early (by about turn
four in a card game; a heuristic to test)? Record each cell as `clean`, `ruling needed`, `risk`
(one yes) or `degenerate` (a loop, an unremovable piece, or two or more yes answers).

For large sets, run every pair at least at set-up 2 and 3, then all four set-ups on pairs sharing
a trigger group or a scope. Any set-up skipped for any pair is not run: count it.

## Phase 5: Counter coverage and rulings

1. For each keyword, name at least one answer in the pool. A keyword with no answer is a finding.
2. A counter that does nothing else becomes a tax on every deck or list. Give it a second use.
3. Every ruling made in testing gets an FAQ line, indexed by keyword, worded the way a player asks.
   List rulings that exist only in someone's memory.

## Phase 6: Verdict

First match wins:

1. **DEGENERATE:** any `degenerate` cell, or a shared-trigger group with no written order.
2. **CONCERNS:** any `risk` cell, an undeclared keyword, a missing timing class, played and
   resolved confused, a keyword with no answer, or a ruling not in the FAQ.
3. **NOT ASSESSED:** no keyword set could be derived, or any pair or set-up was not run. Name the
   pairs not run and give the count (for example: 14 of 66 pairs not run at set-ups 1 and 4).
4. **CLEAN:** every pair and every set-up run, every keyword passed Phase 2, every trigger group
   ordered.

Report: Sources read, Keyword set with N and pair count, Per-keyword table, Trigger groups, Pair
matrix (cells marked), Not run (pairs and set-ups, with count), Rulings to write, Verdict, Top
three fixes. Fix sizes, smallest first: reword, add a condition, raise a cost, add a counter to
the pool, limit copies, cut the keyword. Restrict a loved interaction before deleting it.

## Phase 7: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the report to design/craft/keyword-audit-[name]-[date].md`
- `[B] Walk the worst pair with me now`
- `[C] Stop here`

Write only on [A], after asking "May I write this to that path?". Then suggest `/exploit-hunt`
for degenerate pairs, `/rules-draft` to write rulings and timing text, `/term-register revise`
for demotions and undeclared keywords, and `/paper-playtest` with a named test per risky pair.
After fixes, re-run `/keyword-audit`.
