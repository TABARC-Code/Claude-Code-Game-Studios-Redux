# Skill Test Spec: /rewrite-text

## Skill Summary

`/rewrite-text` rewrites supplied in-game text (dialogue, barks, lore, item text, UI copy) to read as
human: it removes machine-writing patterns (`references/ai-patterns.md`), applies the craft in
`.claude/docs/dialogue-craft.md`, the speaker's Voice Profile and the style guide, and keeps the
character limit, `{placeholders}` and every fact. Phase 1 prints an input inventory naming anything
missing. Lengths and placeholders are checked with `.claude/scripts/line-check.sh`, dashes with
`.claude/scripts/dash-count.sh`. It shows before and after, then asks where to write. A missing voice
profile or style setting is reported as NOT ASSESSED in the verdict, never folded into COMPLETE.

---

## Static Assertions (Structural)

- [ ] Frontmatter has `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] 2+ phase headings found
- [ ] Contains `COMPLETE`, `BLOCKED` and `NOT ASSESSED`
- [ ] `allowed-tools` includes Write/Edit and "May I write" language is present
- [ ] `allowed-tools` has no bare `Bash`; the shell grants are the config helper, `dash-count.sh` and `line-check.sh`
- [ ] References `.claude/docs/dialogue-craft.md` and `references/ai-patterns.md`
- [ ] Next-step handoff section present at end

---

## Director Gate Checks

N/A. Canon questions are listed for the narrative-director; no gate is spawned.

---

## Fixture Defaults

Every case's `project.yaml` sets `modes.rigor: minimal` and `modes.automation: collaborative`,
with no `project.local.yaml`, unless its own Fixture says otherwise.

---

## Test Cases

### Case 1: Happy Path — full inputs

**Fixture**: `design/narrative/dialogue/market.md` with 6 lines for Mira, one with `{player_name}`;
`design/narrative/characters/mira.md` with a filled Voice Profile; a complete style guide.

**Input**: `/rewrite-text design/narrative/dialogue/market.md --character mira`

**Expected behavior**: inventory shows all inputs found; diagnosis tags lines; rewrite keeps facts and
placeholders; `line-check.sh --pair` reports 0 mismatches and 0 over limit; before/after table and
status block shown; write question asked; Verdict COMPLETE.

**Assertions**:
- [ ] Placeholder sets identical before and after
- [ ] No rewritten line is over the limit
- [ ] Lines with no tag are reported as kept
- [ ] No file written before the write question is answered yes

### Case 2: No voice profile — NOT ASSESSED

**Fixture**: dialogue for "Tobin"; no `tobin.md`.

**Input**: `/rewrite-text design/narrative/dialogue/market.md`

**Expected behavior**: inventory lists "Tobin: no sheet, voice NOT ASSESSED"; only machine patterns and
craft failures not needing character knowledge are fixed; output marked "voice not applied".

**Assertions**:
- [ ] Verdict reads `COMPLETE — voice NOT ASSESSED (Tobin)`
- [ ] No voice is invented from memory

### Case 3: No style guide — no default variant

**Fixture**: no `design/narrative/style-guide.md`; the text has "colour" and "color" mixed.

**Input**: `/rewrite-text <path>`

**Expected behavior**: style NOT ASSESSED; spelling and dashes left as found and flagged; no variant chosen.

**Assertions**:
- [ ] Spelling is not normalised to any variant
- [ ] Verdict names style NOT ASSESSED and which settings

### Case 4: Placeholder mismatch is fixed, not shipped

**Fixture**: a rewrite drafts "Hello, friend" for "Hello, {player_name}".

**Expected behavior**: `line-check.sh --pair` shows `same=no`; the line is corrected and re-run; verdict
is not COMPLETE while a mismatch stands.

**Assertions**:
- [ ] `placeholder_mismatches` is 0 in the final report
- [ ] An unresolved mismatch yields BLOCKED

### Case 5: Fixed line untouched

**Fixture**: `--fixed mira_03`; that line is flat and machine-like.

**Expected behavior**: the line is reported as fixed (untouched), not rewritten.

**Assertions**:
- [ ] The fixed line is identical in the output
- [ ] It appears in the "fixed" count

### Case 6: Helper cannot run

**Fixture**: `line-check.sh` is missing.

**Expected behavior**: length and placeholder checks are NOT ASSESSED, named; verdict NOT ASSESSED; they
are not reported clean.

**Assertions**:
- [ ] Verdict is `NOT ASSESSED — checks did not run`
- [ ] The missing check is named

### Case 7: New content needed

**Fixture**: a line that is flat because the scene gives the speaker nothing to want.

**Expected behavior**: the line is left, and listed under "For the writer agent"; no new fact or joke is added.

**Assertions**:
- [ ] No invented lore, price or mechanic appears in any rewritten line
- [ ] The line is listed for the writer agent

---

## Protocol Compliance

- [ ] Asks "May I write" before writing; in-place edits list the keys first
- [ ] Never changes a fact, key, speaker tag or placeholder
- [ ] A missing input is named in the verdict, not folded into COMPLETE
- [ ] Reads limits and dash counts from the scripts' rows, not by eye
- [ ] Ends with a Verdict line

---

## Coverage Notes

- Whether a rewrite sounds better is judgement; the spec pins the checks around it.
- Pasted text cannot be written back to a file; Case coverage for that path is manual.
- No automated runner; review manually or via `/skill-test`.
