---
name: prose-style
description: "Sets the project's writing style guide: English variant, dash policy and limits, serial comma, quotation marks, numbers, contractions, capitalisation. Writes design/narrative/style-guide.md, or checks existing text against it."
argument-hint: "[set | check <path> [path...]] (default: set)"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash(bash "*/.claude/skills/prose-style/../../hooks/yaml-helper.sh" resolve_config *), Bash(bash .claude/scripts/dash-count.sh*)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

Resolved above; use as-is. No block: `automation: collaborative`, `docs.density: terse`, and say the
settings were not read.

# Prose Style

Decides how the project's source-language text is spelled and punctuated, writes that down once, and
checks text against it. It is the line-level companion to the voice profile: the profile says who is
speaking, the style guide says how the page is set.

It replaces nothing in `/design-system` or `/art-bible`. It writes one file, `design/narrative/style-guide.md`,
from `.claude/docs/templates/writing-style-guide.md`.

**Every setting is the user's choice.** No English variant, dash policy or cap is assumed. A blank
setting is reported as not assessed; it is never read as "anything goes". The one rule that holds in
every `automation` mode, autonomous included: the variant and the dash policy are always asked,
because there is no safe default to log and proceed on. Without a question tool, list the options
numbered and end the turn to wait. A skipped or dismissed question is not an answer: ask again in
plain text.

## Phase 1: Mode and inputs

1. Read the text typed after the skill name. `check` followed by paths runs Phase 5. Anything else,
   or nothing, is `set`.
2. Read `design/narrative/style-guide.md` if it exists. In `set`, an existing guide means **retrofit**:
   show its settings, ask which to change, touch only those. Never overwrite a guide whole.
3. List what exists to be consistent with, so the questions can use it: `design/narrative/` files,
   `design/gdd/game-concept.md` or `design/game-brief.md` (tone and audience lines), and any
   localisation notes. Reading them is optional; say which you read.

## Phase 2: The choices

Ask the settings in four questions, asked together where the tool allows. Each option gets a one-line
description. Put "(Recommended)" on nothing: these are preferences, not a right answer.

1. **English variant.** `en-GB` (British, -ise) / `en-GB-oxford` (British with -ize and -our, as Oxford
   University Press spells) / `en-US` / `Other` (en-CA, en-AU, other: ask for the code). If the project
   has in-world text from a time or place with its own conventions (a western in American English,
   say), ask separately for each **exception**: where it applies, what convention it keeps.
2. **Dashes.** Three policies and a cap.
   - `oxford`: unspaced em dash for a parenthesis or break in thought, closed-up em dash for
     interrupted speech. Described from secondary sources about Oxford University Press house
     style; **not checked against the current New Hart's Rules**. Say so in the question.
   - `british-spaced-en`: spaced en dash, the norm at most other UK publishers.
   - `none`: no dashes in prose; commas, colons, brackets, a new sentence.

   Then the **cap**: most dashes per 100 words, for narrative, for rules and technical text, and for
   dialogue lines. Offer the template defaults (1, 1.5, 1) and let the user type their own. State
   plainly that the published styles set no cap: the defaults are an editing rule of thumb and the
   user's call. Interrupted speech: dash or ellipsis.
3. **Commas, quotes, contractions.** Serial comma (`yes` / `no`); quotation marks (`single` /
   `double`; nested quotes use the other); contractions (`yes` / `by_register`, which leaves it to each
   voice profile / `no`).
4. **Numbers, capitalisation, register.**
   - Spell numbers out up to nine, ninety-nine or one hundred; numerals above. Game values (stats,
     damage, prices, timers) stay numerals in UI and rules unless the user says otherwise. Large
     numbers: ask for the form.
   - Job titles: capitalised before a name ("Captain Hale") or lower case.
   - Terms the game always capitalises or spells a set way: collect them into the Terms table.
   - Optional narrator register preset: `chronicler` (measured, observant, restrained),
     `pulp cadence` (faster, harder, short bursts), `broadcast dread` (calm surface, pressure
     underneath, plain words), `grim guide` (dry, exact, little ornament), or `custom` (one
     sentence). Skip it if the user has no narrator.

## Phase 3: Draft and approve

Fill the template from the answers. Leave any setting the user did not answer blank and list those at
the top of the draft under "Not set". Show the whole guide, then ask: "May I write this to
`design/narrative/style-guide.md`?" `Yes, write it` / `Revise a setting first`. A "go on" is not a
yes to the write. On a revision change the named setting, show it before and after, and ask again.
Create `design/narrative/` if needed.

## Phase 4: Hand-offs

After the write, say which tools now read the guide: `/rewrite-text`, the `writer` and
`narrative-director` agents (through `.claude/rules/narrative.md`), and `/prose-style check`.
If the project ships in more than one language, say that translations follow their own locale's
guide and the localisation lead should see the Terms table.

End with the line `Verdict: **COMPLETE** — style guide written (N settings set, M left blank).`

## Phase 5: Check mode (`check <path> [path...]`)

Reads text and reports; edits nothing.

1. Read the guide. **No guide, or a blank dash policy:** the dash checks are `NOT ASSESSED`
   (name which input is missing) and the verdict cannot be better than `NOT ASSESSED`. Offer
   `/prose-style set`.
2. Run `bash .claude/scripts/dash-count.sh --lines <paths>`. Read the `file` and `dash` rows as given;
   do not recount by eye. A `not_read` row is a file that was not checked: list it by name.
3. Pick the text type for each file for the cap: dialogue files (`design/narrative/dialogue/`) use
   `dialogue_lines`; design docs that state rules use `rules_and_technical`; everything else
   `narrative`. Say which was used for each file; ask when it is unclear.
4. Compare, by the policy:
   - `oxford`: unspaced em dashes are in form. Spaced em, mixed, spaced en (not ranges), spaced
     hyphens and double hyphens are deviations.
   - `british-spaced-en`: spaced en dashes are in form. Em dashes and unspaced or mixed en dashes
     are deviations.
   - `none`: every dash is a deviation. Ranges (`en_range`) are never counted.
   - Density: `per100` above the cap for that text type is a deviation. Note the word count is of
     whitespace tokens, so a text full of closed-up dashes reads slightly dense.
5. The other settings (spelling, serial comma, quotation marks, numbers, contractions, capitalised
   terms) are **read, not counted**. Report each as `OBSERVED` with up to three examples, or
   `NOT ASSESSED` when the setting is blank or the text is too short to show it. Label this part
   "by reading" so it is not mistaken for a count.
6. Report: the dash table (file, words, per100, cap, form deviations), the by-reading list, and any
   file not read. Verdict words: `DEVIATIONS FOUND` when any deviation exists; otherwise
   `NOT ASSESSED` when any rule could not be assessed; otherwise `CONFORMS`. A known deviation
   outranks an unknown; an unknown outranks a pass.

End with `Verdict: **[CONFORMS | DEVIATIONS FOUND | NOT ASSESSED]**` and one line saying what it rests
on. Offer `/rewrite-text <path>` for fixes. Never fix in this mode.

## Recommended Next Steps

- `/rewrite-text [path]`: rewrite lines to the style guide, the voice profile and the dialogue craft
- `/prose-style check [path]`: re-check after edits
- The `narrative-director` agent: record the register in the voice profiles
- `/localize`: when the guide changes the Terms table, string tables may need a refresh

<!-- skill-links:start -->
## Links

Generated by `.claude/scripts/skill-links.sh --write`. Change the skill's text, not this block.

Links to: `/art-bible`, `/design-system`, `/localize`, `/rewrite-text`
Linked from: `/rewrite-text`
<!-- skill-links:end -->
