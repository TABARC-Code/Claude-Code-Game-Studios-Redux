---
name: rulebook-architecture
description: "Audits or plans the whole-book structure of a rulebook: functional layers and their dependencies, the learner and veteran readers, type census, navigation kit, a forensic sentence sample and a cold-read lookup test."
argument-hint: "[path-to-rulebook-or-rules-folder | 'plan' for a book not yet written]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/rulebook-architecture/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Rulebook Architecture

A rulebook can be clear sentence by sentence and still fail at the table, because nobody can find
the rule they need, or because a core rule silently depends on a scenario special, or because the
same rule is restated in three places with three wordings. This skill works above the sentence:
how the book is layered, who reads it and how, how many kinds of thing it defines, and how a
reader navigates it mid-game. Sentence drafting stays with `/rules-draft`; consistent terms stay
with `/term-register`.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/rules-draft` (drafted sections), `/term-register` (glossary and index terms),
`/scenario-forge` (scenario layer), `/faction-forge` (force layer), `/expansion-plan` (extended layer).
**Feeds:** `/rules-draft rewrite` (restructured sections), `/term-register` (index synonyms as
recorded rejects), `/paper-playtest` (the lookup test), `/localize` (a stable section-id scheme).
**Loop:** run the lookup test, restructure, run it again. Record the lookup times each pass; a time
that does not fall means the fix moved text without making it findable.

Reference: `.claude/docs/craft/rules-wording-defects.md` (troublemaker IDs).

## Phase 1: Load and list

1. Read the argument. A path means read the book or every file in the folder; list each with its
   headings (Grep `^#`, then read sections by range). `plan` means ask for the planned contents.
2. Build a section list: id, title, depth, word count, one-line purpose.
3. No text and no plan: stop with **NOT ASSESSED** and name the missing input.

## Phase 2: Layer map

Assign every section to one functional layer: **core** (how any game is played), **scenario**
(set-up, victory, specials for one situation), **force** (rules carried by a side, unit or deck),
**extended** (optional modules, campaigns, supplements).

Dependency runs one way: outer layers may override inner ones; an inner layer never needs an outer
one to work. Draw each reference between sections as an arrow. An inward arrow (core citing a
scenario or force rule) is a defect. Also look at the seams: tight definitions combined with
"anything not forbidden is permitted" breed absurd edge cases where layers meet. List each seam
and the edge case it allows, or `none found`.

## Phase 3: Two readers

The **learner** reads in order and needs encounter sequence: each rule taught before it is used.
The **veteran** jumps in mid-game and needs headings that answer questions. Check both:

- Does any section use a term or procedure taught later? List each forward dependency.
- Can each core heading be read as the answer to a question a player asks at the table?
- For large card or ability pools, is there a learning guide separate from an indexed reference?
- Is there a one-sheet quick reference (turn sequence, key tables)? Players often rate it the most
  used accessory (rule of thumb).

**Repeat list.** Every place a rule is stated twice, with both locations. In the working copy mark
each restatement. One drifted wording makes two rules; send pairs that differ to `/term-register check`.

## Phase 4: Type census

List every kind of thing the book gives its own rule set (unit categories, card types, terrain
classes, token types). State changes (wounded, routed, flipped) create hidden sub-types; count them.
Mark merge candidates: types that share most of their rules. Each separate type adds load.

## Phase 5: Navigation kit

Check each and record present, partial or absent:

1. Contents at two levels; headings no deeper than three levels.
2. A concept index (not a word list), built while writing, with player synonyms: "See" redirects a
   synonym to the term; "See also" points to neighbours.
3. Cross-references by stable section id, never by page alone, and at most one hop: a reference
   never lands on another reference.
4. Defined terms in bold at first use, matching the register's formatting entry.
5. Glossary generated from the register, not maintained beside it.
6. Critical exceptions boxed, so the eye finds them.
7. A short "why" line before important, odd or shortcut rules, sparingly, fenced as non-normative.
   Game-critical rules get the rule of three: flag it, state it briefly, illustrate it.
8. Complex examples written as mini-scenes: a goal, a threat, an open question, with real numbers.

## Phase 6: Forensic sample

Take the three busiest procedures (most cross-references or most table disputes). Label each
sentence: imperative, conditional, definition, example or flavour. Procedures should be mostly
imperative and carry no flavour. Similar procedures should share a step shape so readers can
predict the next step. Then scan the sample for troublemakers (IDs in the defects catalogue): die
and dice wording, semicolons hiding overloaded sentences, designer jargon the author no longer
sees, modifier direction in roll-under systems, working names surviving by inertia, look-alike
stat abbreviations. Tenor: formal reads narrow, informal reads broad; keep tone in examples and
out of procedure. When auditing another author's text, note their habits (favourite hedges,
nesting depth, where ambiguity gets deferred).

## Phase 7: Lookup test plan

Write a cold-read test for `/paper-playtest`: a fresh group, never briefed, given five named rules
to find; time each lookup; ask for the turn order unprompted at the end. Pick the five from the
busiest procedures plus one boxed exception. Thresholds are heuristics to test, for example: a
core rule found in under a minute. If the test has not been run, it is listed under `Not run` and
the verdict cannot be the pass value.

## Phase 8: Verdict

First match wins:

1. **TANGLED:** an inward dependency arrow, or a core rule the lookup test could not find.
2. **CONCERNS:** forward dependencies, drifted restatements, absent navigation items, merge
   candidates left unmerged, or a forensic sample heavy with flavour or troublemakers.
3. **NOT ASSESSED:** no text, any phase not run, or the lookup test not yet run. Name which.
4. **NAVIGABLE:** every phase run, no inward arrows, the lookup test passed, navigation complete.

Report: Sources read, Section list, Layer map with arrows, Seams, Forward dependencies, Repeat list,
Type census, Navigation checklist, Forensic sample table, Lookup test plan and results, Not run,
Verdict, three restructures ranked.

## Phase 9: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the report to design/craft/rulebook-architecture-[name]-[date].md`
- `[B] Send the lookup test plan to /paper-playtest now`
- `[C] Stop here`

Write only on [A], after asking "May I write this to that path?". Next: `/rules-draft rewrite` for
each restructured section, `/term-register check` for drifted restatements, `/paper-playtest` to
run the lookup test. After restructuring, re-run `/rulebook-architecture`.
