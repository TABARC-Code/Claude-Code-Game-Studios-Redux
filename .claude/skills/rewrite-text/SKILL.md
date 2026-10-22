---
name: rewrite-text
description: "Rewrites supplied dialogue, barks, item text or any in-game string so it reads as human: removes machine-writing patterns, applies subtext craft, the character's voice profile and the style guide. Keeps limits, placeholders and facts. Shows before and after; writes only on approval."
argument-hint: "<path> [--character <name>] [--max-chars <n>] [--fixed <key,key>] (or paste the text when asked)"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash(bash "*/.claude/skills/rewrite-text/../../hooks/yaml-helper.sh" resolve_config *), Bash(bash .claude/scripts/dash-count.sh*), Bash(bash .claude/scripts/line-check.sh*)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

Resolved above; use as-is. No block: `automation: collaborative`, `docs.density: terse`, and say the
settings were not read.

# Rewrite Text

Takes lines the user already has (a draft, an imported script, machine-written filler, a pass that
sounds flat) and rewrites only what needs it, in the character's voice, to the project's style, inside
the game's limits. It is a rewrite pass, not a writing pass: it invents no lore, no mechanics and no
facts. New content is the `writer` agent's job.

Read `.claude/docs/dialogue-craft.md` before Phase 3 and `references/ai-patterns.md` before Phase 2.
Both are references, not session context.

**What it will not do.** Change what a line tells the player. Change who a character is. Touch a line
marked fixed. Translate. Reword a `{placeholder}`. Make lines longer than the limit to sound nicer.
Pad a rewrite to look busy: a line that is fine is reported as kept.

Ask with the question tool. Without one, list the options numbered and end your turn to wait. A
skipped or dismissed question is not an answer: ask again in plain text.

## Phase 1: Inputs

Build an **input inventory** and print it before doing anything else.

1. **The text.** A path after the skill name: read it. A file over 40 KB: read by section (headings by
   `^#` with Grep, then a ranged read) and work in batches of about 40 lines. No path: ask the user
   to paste the text, and note that pasted text can be shown but not written back to a file it never
   came from. Say what kind of text it is: dialogue, bark, lore entry, item or ability text, UI copy.
   Ask when it is unclear.
2. **Voice.** `--character <name>` or the speaker tags in the text: read each speaker's
   `design/narrative/characters/[name].md`, the **Voice Profile** section only (find the heading,
   read that range). A speaker with no sheet, or a sheet with a blank Voice Profile, is
   **voice NOT ASSESSED for that speaker**: name them. Never rebuild a voice from memory of how the
   character "usually" sounds.
3. **Style.** Read `design/narrative/style-guide.md`. No guide, or a blank setting, is **style NOT
   ASSESSED for that setting**: name it. Never fall back to a default English variant, serial comma
   or dash policy; leave that aspect of the text as found and flag it.
4. **Limits and fixed lines.** The character limit is `--max-chars` or the dialogue box limit in
   `.claude/rules/narrative.md` (120 unless the rule says otherwise); say which. `--fixed` names keys
   or line numbers that must not change; ask whether anything is fixed (recorded voice lines, quoted
   sources, legal text) if the text looks like it has them. Placeholders are the `{name}` and printf
   markers already in the text; string keys and speaker tags are kept as they are.

Print the inventory as a table: input, found or missing, the file it came from, and what a
"missing" costs (for example, "Mira: no sheet, voice NOT ASSESSED"). No later phase may quietly skip
an input that is missing here.

## Phase 2: Diagnose

For each line, tag what is wrong, if anything, using three sources:

- **Machine patterns:** the tags in `references/ai-patterns.md`.
- **Craft:** the failures table and the four read-aloud tests in `.claude/docs/dialogue-craft.md`
  (on the nose, echo, plot lecture, same voice, tidy ending, speech about speech).
- **Constraints:** over the limit, a placeholder oddly placed, a mechanic described beyond what the
  design defines, an idiom that will not localise.

Run the length check once on the original: `bash .claude/scripts/line-check.sh --max <limit> -`
with the lines on standard input. Run `bash .claude/scripts/dash-count.sh -` the same way for the
dash baseline. Read the rows; do not count by eye. If a script cannot run, say which check did not
run and do not report that check as clean.

Present a short diagnosis table (line key, tags) and the counts: lines in, lines with tags, lines
clean. A line with no tag is kept as it is. A pattern on its own is not an offence: tag it only if
the line reads as made by a machine in context.

## Phase 3: Rewrite

Smallest change that fixes the tags.

- Keep the meaning and every fact the player may need: names, numbers, directions, prices, clues.
  List a line's facts to yourself before rewriting it and check each is still there.
- Keep line order, speaker tags, condition notes, keys, and every placeholder exactly: same names,
  same count, same braces.
- Apply the voice profile: speech pattern, vocabulary level, tics, what the character dodges, what
  pressure does to their sentences. Without a profile, fix only machine patterns and craft failures
  that do not need character knowledge, and mark the output **voice not applied**.
- Apply the style settings that are set. Dash policy and cap come from the guide. Settings that are
  blank stay as found, flagged.
- Keep the variety: lines of different lengths and shapes, one evasion or interruption where the
  scene wants it, not a pattern laid over every line. Do not smooth everything to one rhythm.
- A line that needs new information, a new joke or a new fact to be good: leave it, and list it for
  the `writer` agent. A line that contradicts canon you cannot check: leave it, flag it to
  `narrative-director`.
- Never rewrite a fixed line. Never add a line.

## Phase 4: Verify

Put each rewritten line beside its original as `before<TAB>after`, one pair per line, and run
`bash .claude/scripts/line-check.sh --pair --max <limit> -`. Then run
`bash .claude/scripts/dash-count.sh -` on the rewritten lines.

Read the rows and report, without rounding in your favour:

- **Placeholders:** `placeholder_mismatches` must be 0. A mismatch is a defect of this rewrite: fix
  the line and run it again.
- **Length:** `over_max` must be 0 for rewritten lines. A line that was already over and is kept,
  or cannot be both inside the limit and complete, is listed by key for the user to decide.
- **Dashes:** `per100` against the style guide's cap for this text type, and the forms against the
  policy. Blank policy: dash checks NOT ASSESSED.
- **Facts:** for each rewritten line, confirm its fact list from Phase 3. A line you are not sure
  about is marked `CHECK` and shown with the fact in doubt.

If a script could not run, that check is NOT ASSESSED, named. The verdict cannot call it clean.

## Phase 5: Present

Show a table: key or line, before, after, what changed and why (one clause). Kept lines are listed
by key with "kept". Then the status block:

```
Lines: [n] in, [n] rewritten, [n] kept, [n] fixed (untouched)
Placeholders: [n] checked, [n] mismatches
Length: limit [n] ([source]); [n] over
Dashes: [x.xx] per 100 words against cap [n] ([text type]); forms [ok | deviations: ...]
Voice: [applied for ... | NOT ASSESSED for ...]
Style: [applied: ... | NOT ASSESSED: ...]
For the writer agent: [lines that need new content, or none]
For narrative-director: [canon questions, or none]
```

## Phase 6: Write

Ask where the result goes, as its own question:

- `Write a proposal file`: `production/narrative/rewrites/[slug]-rewrite.md`, containing the table
  and the status block. Nothing existing is changed. A new file under `production/`.
- `Edit the source in place`: only for a path input. List the file and the keys changed first.
- `Show only`: nothing is written.

Write only on an explicit yes to "May I write this to [path]?" Agreeing to the wording of a line is not
a yes to the write. An in-place edit changes each line with `Edit`, one at a time, and re-reads the
file afterwards to confirm only the listed lines moved.

End with one verdict line:

- `Verdict: **COMPLETE** — [n] lines rewritten, checks clean.`
- `Verdict: **COMPLETE** — voice NOT ASSESSED ([speakers])`, `style NOT ASSESSED ([settings])`, or
  both joined, when Phase 1 listed anything missing. A missing input is never folded into plain
  COMPLETE.
- `Verdict: **BLOCKED** — [reason]` when there is nothing to rewrite, the file cannot be read, a
  placeholder mismatch is unresolved, or the user asked for a limit the text cannot meet.
- `Verdict: **NOT ASSESSED** — checks did not run ([which])` when the length or placeholder check
  could not run at all.

## Recommended Next Steps

- `/prose-style check [path]`: re-measure the rewritten text against the style guide
- The `writer` agent: lines listed under "For the writer agent"
- The `narrative-director` agent: canon questions and missing voice profiles
- `/localize`: when keys, placeholders or the Terms table changed

<!-- skill-links:start -->
## Links

Generated by `.claude/scripts/skill-links.sh --write`. Change the skill's text, not this block.

Links to: `/localize`, `/prose-style`
Linked from: `/prose-style`
<!-- skill-links:end -->
