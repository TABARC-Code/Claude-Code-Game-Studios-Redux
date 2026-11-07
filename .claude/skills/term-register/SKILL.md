---
name: term-register
description: "Finds, builds, checks and revises a project's controlled register of rules terms, keywords and wording patterns so every rules document and supplement uses one wording per mechanic."
argument-hint: "[build | check <path> | lookup <term> | revise <term> | status]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/term-register/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Term Register

Rules drift one sentence at a time. A mechanic gets a second wording in a supplement, a keyword
loses its number in a cross-reference, an editor trims a clause that was load-bearing elsewhere,
and players infer two mechanics where the designer meant one. Memory does not catch this. A
register does: one file that holds every locked word, keyword and wording pattern, read before
any rule is drafted and checked against every rule at final edit. This skill finds that file (or
the informal one hiding in the drafts), builds it, checks text against it and revises it under a
fixed procedure. It does not write rules; `/rules-draft` does, against this register.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/activation-design` (agency split, phase names), `/resolution-tuning` (roll words,
threshold comparisons), `/scenario-forge` (objective and zone terms), `/classic-borrow` (standard
names), `/unit-costing` (keyword families), `/prose-style` (formatting such as italics),
`/paper-playtest` (wording disputes), `/keyword-audit`, `/card-forge`.
**Feeds:** `/rules-draft` (its active standard), `/keyword-audit` (the keyword list it derives
pairs from), `/exploit-hunt` R5 and R6, `/rulebook-architecture` (glossary and index), `/localize`
(rules glossary as a derived view), `/patch-notes` and `/changelog` (renames and deprecations).
**Loop:** every table dispute is a register check. Before rewriting a disputed sentence, search
for a second wording of the same mechanic. Record each run's entry counts in the report so the
next run can say what moved.

Template: `.claude/docs/templates/term-register.md`. References: `.claude/docs/craft/keyword-shapes.md`,
`.claude/docs/craft/rules-wording-defects.md`.

## Phase 1: Mode and scan

1. Read the argument. No argument means `status`.
2. If a register was already loaded this session, do not rescan. Answer `lookup` straight from it.
3. Otherwise scan, in this order, and list every file read: `design/rules/term-register.md`; other
   files in `design/rules/`; `design/gdd/`; `design/narrative/style-guide.md`; any `/localize`
   glossary; text pasted in chat.
4. A register can hide under another name: a table with term-like columns, a house-style section
   in a draft, or keywords used consistently but never declared. A missing file called "glossary"
   proves nothing. Grep the drafts for capitalised or formatted recurring terms before concluding.

## Phase 2: Classify the state

Exactly one, with evidence (path and heading):

- **Found:** a register file exists. Report path, locked-entry count and register position.
- **Partial:** something register-like exists. Name what is there and which fields or minimum
  entries are missing. Ask whether to formalise it now or proceed with the gap recorded. Never fill
  a gap with an invented convention.
- **Absent:** say so plainly and recommend `build` before any drafting. The author may decline:
  record the decline in the report so you do not nag, and raise it again only when a real
  consistency defect turns up.

If project files contradict the loaded register (a stale register), report it. Do not patch around it.

## Phase 3: Register position (build, or when missing)

Rules text sits somewhere between plain prose (readable cold, longer) and dense keyword shorthand
(compact, opaque to newcomers). Both work; the position must be chosen and recorded.

1. If the user states a position, lock it and skip the samples.
2. Otherwise draft one short passage of an existing rule at the plain end. Show it. Ask how far to
   push towards shorthand.
3. "More shorthand": ask which mechanics deserve keywords first. Recurring and interacting ones
   usually come first (rule of thumb).
4. "Somewhere between": draft a second sample at that point and ask again. Never lock on an
   unresolved answer.
5. Later changes to the position go through Phase 8 with a reason, not rule by rule.

## Phase 4: Baseline lexicon (build)

Ask one question per decision, even where the genre has a usual answer: the selection verb (pick,
select or choose); the permission modal (can or may); the play-surface noun; the name of the
activity (a game, a battle, a round); victory attribution (the player wins or the side wins).
These five plus the register position are the six-entry minimum. Record rejected alternatives
beside each lexicon entry, so a later synonym can be flagged as a known reject.

## Phase 5: Mine and classify

1. Extract candidates from the drafts: phrases recurring about three or more times (a coinage
   threshold to test, not a law); implicit keywords; synonym clusters for one concept; mixed
   "has X" and "is X"; effects with a range and a duration but no marker.
2. Classify each with a category from the template: lexicon, keyword, game term, mechanic pattern,
   project setting.
3. Keywords get a shape from `.claude/docs/craft/keyword-shapes.md`, a formatting convention, slot
   ranges (shapes 2 and 4) and closed category lists (shape 4). Name every keyword family as its
   own pattern entry; a family never exists by name resemblance.
4. Separate a mechanic-type keyword (the hook other rules cite) from the status it produces (a game
   term). Merged, a later rule cannot exclude the type cleanly.
5. Agency (who acts: player, side or piece) and continuous against resolved-once conventions are
   mechanic-pattern entries.
6. Everything mined is **proposed**. Nothing is adopted silently. First use of an adopted entry
   locks it at once; locking is not provisional.

## Phase 6: Crosscheck (advisory)

For each new term, look up the concept in `/classic-borrow` standard names and common genre usage.
Note convergence (a recognised name exists; diverge knowingly), collision (the word means
something strongly different elsewhere) or shape corroboration (the concept usually carries a
value). One line each. Record the choice and do not reopen it. No match is not a defect. If the
crosscheck was not run, list it under `Not run`.

## Phase 7: Check (check mode)

Read the named file against the register, line by line. Report each hit with line, entry and
defect ID from `.claude/docs/craft/rules-wording-defects.md`: synonym of a locked term (or a known
reject), wrong formatting, dropped slot value, partial or inflected compound keyword, mixed has and
is, a mechanic worded differently from its pattern entry, and an unregistered recurring term. With
no register, precision checks still run on internal logic; consistency is `NOT ASSESSED` and named.

## Phase 8: Revise (revise mode)

Five steps, in order: set the entry to under review; state the drafting problem (a real one, not a
preference); list every use, across every document; confirm with the author; update every use in
one pass and relock. Add a change-history line (date, term, change, reason). Deprecated entries
stay in the register for older supplements.

## Phase 9: Verdict

First match wins:

1. **DRIFT FOUND:** check mode found text contradicting a locked entry.
2. **NO REGISTER:** none exists and the author declined to build one (recorded).
3. **REGISTER PARTIAL:** a register exists with named gaps: below the six-entry minimum, a keyword
   with no shape or formatting, or an entry left under review.
4. **NOT ASSESSED:** part of the scope did not run (unreadable files, crosscheck skipped, check
   mode with no register). Name which.
5. **REGISTER READY:** six-entry minimum met, every keyword has shape and formatting, no entry
   under review, every phase for the mode run.

Report: Sources read, State (found, partial, absent), Entry counts by category and status, Proposed
entries table (term, category, shape, first used), Drift table (check mode), Not run, Verdict.

## Phase 10: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the report to design/craft/term-register-[name]-[date].md`
- `[B] Write the register itself to design/rules/term-register.md, using the template`
- `[C] Stop here`

Before either write, ask "May I write this to that path?" and show the entries that change. Never
lock a proposed entry the author has not approved. Any glossary or keyword list elsewhere is a view
of the register: if the two disagree, the register wins and the view is regenerated. Next: `/rules-draft`
to write against it, `/keyword-audit` once keywords exist, `/rulebook-architecture` for the index.
